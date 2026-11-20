// Generated from android/app/google-services.json and
// ios/Runner/GoogleService-Info.plist (Firebase project: flutterlab-d3329).
// These values identify the app to Firebase; they are not secrets — access is
// protected by Firebase Auth + Firestore security rules.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) throw UnsupportedError('Firebase is not configured for web.');
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => android,
      TargetPlatform.iOS => ios,
      _ => throw UnsupportedError('Firebase is not configured for $defaultTargetPlatform.'),
    };
  }

  static const android = FirebaseOptions(
    apiKey: 'AIzaSyC_2lBfrS0KrowQW8oyMnKmxB1jGv_4FIA',
    appId: '1:14910245108:android:0986af9e66b91495da36a1',
    messagingSenderId: '14910245108',
    projectId: 'flutterlab-d3329',
    storageBucket: 'flutterlab-d3329.firebasestorage.app',
  );

  static const ios = FirebaseOptions(
    apiKey: 'AIzaSyA24oPkKKK7tzfS0EvmJLaa5awB3Wh8i1k',
    appId: '1:14910245108:ios:55f476e2b9f36ee0da36a1',
    messagingSenderId: '14910245108',
    projectId: 'flutterlab-d3329',
    storageBucket: 'flutterlab-d3329.firebasestorage.app',
    iosClientId: '14910245108-0rs5184cvj0i42la8t0apukmsdgdr5ij.apps.googleusercontent.com',
    iosBundleId: 'com.olateju.flutterLab',
  );

  /// OAuth "web" client — Android's Google Sign-In needs it to issue ID tokens
  /// that Firebase accepts.
  static const googleServerClientId = '14910245108-t3s9a9087dg4k18vqls26ms7rr7t8g90.apps.googleusercontent.com';
}
