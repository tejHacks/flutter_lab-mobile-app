import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../firebase_options.dart';
import '../state/app_state.dart';

/// Google sign-in + two-way progress sync through Cloud Firestore.
///
/// Design (offline-first):
///  * The phone (shared_preferences) stays the primary copy. The app works
///    the same signed out or offline.
///  * Each change is sent as a small *operation* (arrayUnion / arrayRemove /
///    increment), so changes from several devices — even made offline — merge
///    instead of overwriting each other. Firestore queues writes while offline.
///  * A live listener on `users/{uid}` brings changes from other devices in.
class SyncService extends ChangeNotifier implements SyncSink {
  SyncService(this._state);

  final AppState _state;
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  StreamSubscription<User?>? _authSub;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _docSub;

  bool googleAvailable = false;
  bool busy = false;
  DateTime? lastSynced;
  bool hasPendingWrites = false;
  String? error;

  User? get user => _auth.currentUser;
  bool get signedIn => user != null;

  DocumentReference<Map<String, dynamic>> _doc(String uid) => _db.collection('users').doc(uid);

  Future<void> start() async {
    try {
      // iOS identifies itself with its own OAuth client; Android needs the
      // project's "web" client so the ID token is accepted by Firebase.
      final isIOS = defaultTargetPlatform == TargetPlatform.iOS;
      await GoogleSignIn.instance.initialize(
        clientId: isIOS ? DefaultFirebaseOptions.ios.iosClientId : null,
        serverClientId: isIOS ? null : DefaultFirebaseOptions.googleServerClientId,
      );
      googleAvailable = GoogleSignIn.instance.supportsAuthenticate();
    } catch (e) {
      debugPrint('Google Sign-In unavailable: $e');
    }
    _authSub = _auth.authStateChanges().listen(_onUserChanged);
  }

  // ------------------------------------------------------------------ auth

  /// Returns null on success (or if the user cancelled), otherwise an error message.
  Future<String?> signInWithGoogle() async {
    if (!googleAvailable) return 'Google Sign-In is not configured on this device yet.';
    busy = true;
    error = null;
    notifyListeners();
    try {
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) throw Exception('Google did not return an ID token.');
      await _auth.signInWithCredential(GoogleAuthProvider.credential(idToken: idToken));
      return null;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      return error = 'Google sign-in failed (${e.code.name}). ${e.description ?? ''}'.trim();
    } on FirebaseAuthException catch (e) {
      return error = e.message ?? 'Sign-in failed (${e.code}).';
    } catch (e) {
      return error = 'Sign-in failed: $e';
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _docSub?.cancel();
    _docSub = null;
    _state.attachSync(null);
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
    await _auth.signOut();
  }

  Future<void> _onUserChanged(User? u) async {
    await _docSub?.cancel();
    _docSub = null;
    if (u == null) {
      _state.attachSync(null);
      lastSynced = null;
      notifyListeners();
      return;
    }
    busy = true;
    notifyListeners();
    try {
      await _initialMerge(u);
      error = null;
    } catch (e) {
      error = 'Could not merge your progress yet: $e';
    }
    _state.attachSync(this);
    _docSub = _doc(u.uid).snapshots(includeMetadataChanges: true).listen(
      (snap) {
        hasPendingWrites = snap.metadata.hasPendingWrites;
        final data = snap.data();
        if (data != null) _state.applyRemote(data);
        if (!snap.metadata.isFromCache && !hasPendingWrites) lastSynced = DateTime.now();
        notifyListeners();
      },
      onError: (Object e) {
        error = 'Sync error: $e';
        notifyListeners();
      },
    );
    busy = false;
    notifyListeners();
  }

  /// First sign-in on a device: combine this phone's progress with the cloud copy.
  Future<void> _initialMerge(User u) async {
    final ref = _doc(u.uid);
    final local = _state.toSyncMap();
    Map<String, dynamic> merged(Map<String, dynamic> remote) {
      int bigger(String k) => max((local[k] as int?) ?? 0, (remote[k] as num?)?.toInt() ?? 0);
      final localDay = local['lastActive'] as String? ?? '';
      final remoteDay = remote['lastActive'] as String? ?? '';
      final streak = remoteDay.compareTo(localDay) > 0
          ? (remote['streak'] as num?)?.toInt() ?? 0
          : remoteDay == localDay
              ? bigger('streak')
              : (local['streak'] as int?) ?? 0;
      return {
        'completed': FieldValue.arrayUnion(local['completed'] as List),
        'bookmarks': FieldValue.arrayUnion(local['bookmarks'] as List),
        'challenges': FieldValue.arrayUnion(local['challenges'] as List),
        'quizAnswered': bigger('quizAnswered'),
        'quizCorrect': bigger('quizCorrect'),
        'streak': streak,
        'lastActive': remoteDay.compareTo(localDay) > 0 ? remoteDay : localDay,
        'lastLesson': local['lastLesson'] ?? remote['lastLesson'],
        'displayName': u.displayName,
        'email': u.email,
        'updatedAt': FieldValue.serverTimestamp(),
      };
    }

    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      tx.set(ref, merged(snap.data() ?? {}), SetOptions(merge: true));
    });
  }

  // ------------------------------------------------------------------ SyncSink

  void _push(Map<String, dynamic> data) {
    final u = user;
    if (u == null) return;
    // Not awaited: Firestore applies it locally at once and uploads when online.
    _doc(u.uid).set({...data, 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true)).catchError((Object e) {
      error = 'Sync error: $e';
      notifyListeners();
    });
  }

  FieldValue _toggle(String id, bool on) => on ? FieldValue.arrayUnion([id]) : FieldValue.arrayRemove([id]);

  @override
  void lessonCompleted(String id, bool done) => _push({'completed': _toggle(id, done)});

  @override
  void bookmarkChanged(String id, bool on) => _push({'bookmarks': _toggle(id, on)});

  @override
  void challengeChanged(String id, bool solved) => _push({'challenges': _toggle(id, solved)});

  @override
  void quizAnswered(bool correct) => _push({
        'quizAnswered': FieldValue.increment(1),
        if (correct) 'quizCorrect': FieldValue.increment(1),
      });

  @override
  void lessonOpened(String id) => _push({'lastLesson': id});

  @override
  void streakChanged(int streak, String lastActive) => _push({'streak': streak, 'lastActive': lastActive});

  @override
  void progressReset() {
    final u = user;
    if (u == null) return;
    _doc(u.uid).set({
      'completed': <String>[],
      'bookmarks': <String>[],
      'challenges': <String>[],
      'quizAnswered': 0,
      'quizCorrect': 0,
      'streak': 1,
      'lastActive': _state.toSyncMap()['lastActive'],
      'lastLesson': null,
      'displayName': u.displayName,
      'email': u.email,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _docSub?.cancel();
    super.dispose();
  }
}

/// Makes the (optional) [SyncService] available to the UI.
class SyncScope extends InheritedNotifier<SyncService> {
  const SyncScope({super.key, required SyncService sync, required super.child}) : super(notifier: sync);

  /// Null when Firebase isn't configured (e.g. tests, or before setup).
  static SyncService? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SyncScope>()?.notifier;
}
