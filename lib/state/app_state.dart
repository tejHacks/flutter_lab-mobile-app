import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Receives every progress change so it can be mirrored to the cloud.
/// Implemented by SyncService; AppState itself knows nothing about Firebase.
abstract class SyncSink {
  void lessonCompleted(String id, bool done);
  void bookmarkChanged(String id, bool on);
  void challengeChanged(String id, bool solved);
  void quizAnswered(bool correct);
  void lessonOpened(String id);
  void streakChanged(int streak, String lastActive);
  void progressReset();
}

/// All user progress lives here. It's a ChangeNotifier exposed to the whole
/// app through [AppScope] (an InheritedNotifier) — the exact pattern taught in
/// the "State Management" module.
class AppState extends ChangeNotifier {
  AppState._(this._prefs) {
    _completed.addAll(_prefs.getStringList('completed') ?? const []);
    _bookmarks.addAll(_prefs.getStringList('bookmarks') ?? const []);
    _solvedChallenges.addAll(_prefs.getStringList('challenges') ?? const []);
    _lastLessonId = _prefs.getString('lastLesson');
    _themeMode = ThemeMode.values[_prefs.getInt('themeMode') ?? 0];
    _streak = _prefs.getInt('streak') ?? 0;
    _lastActive = _prefs.getString('lastActive');
    _quizCorrect = _prefs.getInt('quizCorrect') ?? 0;
    _quizAnswered = _prefs.getInt('quizAnswered') ?? 0;
    _codeFontScale = _prefs.getDouble('codeFontScale') ?? 1.0;
    _touchStreak();
  }

  static Future<AppState> load() async =>
      AppState._(await SharedPreferences.getInstance());

  final SharedPreferences _prefs;
  final Set<String> _completed = {};
  final Set<String> _bookmarks = {};
  final Set<String> _solvedChallenges = {};
  String? _lastLessonId;
  ThemeMode _themeMode = ThemeMode.system;
  int _streak = 0;
  String? _lastActive;
  int _quizCorrect = 0;
  int _quizAnswered = 0;
  double _codeFontScale = 1.0;
  SyncSink? _sync;

  /// Start/stop mirroring changes to the cloud (null = signed out).
  void attachSync(SyncSink? sink) => _sync = sink;

  Set<String> get completed => _completed;
  Set<String> get bookmarks => _bookmarks;
  Set<String> get solvedChallenges => _solvedChallenges;
  String? get lastLessonId => _lastLessonId;
  ThemeMode get themeMode => _themeMode;
  int get streak => _streak;
  int get quizCorrect => _quizCorrect;
  int get quizAnswered => _quizAnswered;
  double get codeFontScale => _codeFontScale;

  bool isCompleted(String lessonId) => _completed.contains(lessonId);
  bool isBookmarked(String lessonId) => _bookmarks.contains(lessonId);

  void setCompleted(String lessonId, bool done) {
    done ? _completed.add(lessonId) : _completed.remove(lessonId);
    _prefs.setStringList('completed', _completed.toList());
    _sync?.lessonCompleted(lessonId, done);
    notifyListeners();
  }

  void toggleBookmark(String lessonId) {
    final on = !_bookmarks.remove(lessonId);
    if (on) _bookmarks.add(lessonId);
    _prefs.setStringList('bookmarks', _bookmarks.toList());
    _sync?.bookmarkChanged(lessonId, on);
    notifyListeners();
  }

  void toggleChallenge(String id) {
    final solved = !_solvedChallenges.remove(id);
    if (solved) _solvedChallenges.add(id);
    _prefs.setStringList('challenges', _solvedChallenges.toList());
    _sync?.challengeChanged(id, solved);
    notifyListeners();
  }

  void openLesson(String lessonId) {
    _lastLessonId = lessonId;
    _prefs.setString('lastLesson', lessonId);
    _sync?.lessonOpened(lessonId);
    _touchStreak();
    notifyListeners();
  }

  void recordQuizAnswer(bool correct) {
    _quizAnswered++;
    if (correct) _quizCorrect++;
    _prefs.setInt('quizAnswered', _quizAnswered);
    _prefs.setInt('quizCorrect', _quizCorrect);
    _sync?.quizAnswered(correct);
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _prefs.setInt('themeMode', mode.index);
    notifyListeners();
  }

  void setCodeFontScale(double scale) {
    _codeFontScale = scale;
    _prefs.setDouble('codeFontScale', scale);
    notifyListeners();
  }

  Future<void> resetProgress() async {
    _completed.clear();
    _bookmarks.clear();
    _solvedChallenges.clear();
    _lastLessonId = null;
    _quizAnswered = 0;
    _quizCorrect = 0;
    _streak = 0;
    _lastActive = null;
    for (final k in [
      'completed', 'bookmarks', 'challenges', 'lastLesson',
      'quizAnswered', 'quizCorrect', 'streak', 'lastActive',
    ]) {
      await _prefs.remove(k);
    }
    _touchStreak();
    _sync?.progressReset();
    notifyListeners();
  }

  /// Daily learning streak: +1 if you were here yesterday, reset if you missed a day.
  void _touchStreak() {
    final today = _dateKey(DateTime.now());
    if (_lastActive == today) return;
    final yesterday = _dateKey(DateTime.now().subtract(const Duration(days: 1)));
    _streak = _lastActive == yesterday ? _streak + 1 : 1;
    _lastActive = today;
    _prefs.setInt('streak', _streak);
    _prefs.setString('lastActive', today);
    _sync?.streakChanged(_streak, today);
  }

  /// yyyy-mm-dd, so dates compare correctly as strings.
  static String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  // ------------------------------------------------------------------ sync

  /// The progress that is synced (theme and font size stay per-device).
  Map<String, Object?> toSyncMap() => {
        'completed': _completed.toList(),
        'bookmarks': _bookmarks.toList(),
        'challenges': _solvedChallenges.toList(),
        'quizAnswered': _quizAnswered,
        'quizCorrect': _quizCorrect,
        'streak': _streak,
        'lastActive': _lastActive,
        'lastLesson': _lastLessonId,
      };

  /// Applies the cloud copy (which already includes this device's own
  /// pending changes). Saves locally but does NOT echo back to the cloud.
  void applyRemote(Map<String, dynamic> data) {
    List<String> list(String k) => [for (final v in (data[k] as List? ?? const [])) '$v'];
    _completed
      ..clear()
      ..addAll(list('completed'));
    _bookmarks
      ..clear()
      ..addAll(list('bookmarks'));
    _solvedChallenges
      ..clear()
      ..addAll(list('challenges'));
    _quizAnswered = (data['quizAnswered'] as num?)?.toInt() ?? _quizAnswered;
    _quizCorrect = (data['quizCorrect'] as num?)?.toInt() ?? _quizCorrect;
    final remoteDay = data['lastActive'] as String?;
    if (remoteDay != null && remoteDay.compareTo(_lastActive ?? '') >= 0) {
      _streak = (data['streak'] as num?)?.toInt() ?? _streak;
      _lastActive = remoteDay;
    }
    _lastLessonId = data['lastLesson'] as String? ?? _lastLessonId;

    _prefs.setStringList('completed', _completed.toList());
    _prefs.setStringList('bookmarks', _bookmarks.toList());
    _prefs.setStringList('challenges', _solvedChallenges.toList());
    _prefs.setInt('quizAnswered', _quizAnswered);
    _prefs.setInt('quizCorrect', _quizCorrect);
    _prefs.setInt('streak', _streak);
    if (_lastActive != null) _prefs.setString('lastActive', _lastActive!);
    if (_lastLessonId != null) _prefs.setString('lastLesson', _lastLessonId!);
    notifyListeners();
  }
}

/// Makes [AppState] available anywhere below it: `AppScope.of(context)`.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;

  /// Read without subscribing to rebuilds (use inside callbacks).
  static AppState read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
