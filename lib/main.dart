import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'state/app_state.dart';
import 'sync/sync_service.dart';
import 'ui/home_shell.dart';
import 'ui/theme.dart';

Future<void> main() async {
  // Needed before using plugins (shared_preferences, Firebase) ahead of runApp.
  WidgetsFlutterBinding.ensureInitialized();
  final state = await AppState.load();

  // Cloud sync is optional: if Firebase isn't configured or fails to start,
  // the app still works fully offline.
  SyncService? sync;
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    sync = SyncService(state);
    await sync.start();
  } catch (e) {
    debugPrint('Cloud sync disabled: $e');
    sync = null;
  }

  Widget app = const FlutterLabApp();
  if (sync != null) app = SyncScope(sync: sync, child: app);
  runApp(AppScope(state: state, child: app));
}

class FlutterLabApp extends StatelessWidget {
  const FlutterLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return MaterialApp(
      title: 'FlutterLab',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: state.themeMode,
      home: const HomeShell(),
    );
  }
}
