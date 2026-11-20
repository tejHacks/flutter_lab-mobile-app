import 'package:flutter/material.dart';

import '../../models/lesson.dart';
import '../dsl.dart';

final advanced = LearningModule(
  id: 'adv',
  title: 'Advanced Flutter',
  description: 'Custom painting, packages, native code, testing, performance, architecture and publishing.',
  level: Level.advanced,
  icon: Icons.workspace_premium_rounded,
  color: const Color(0xFFD2414B),
  lessons: [
    Lesson(
      id: 'adv.paint',
      title: 'CustomPaint & Canvas',
      summary: 'Draw anything: charts, shapes, signatures.',
      minutes: 10,
      sections: [
        p('When no widget does what you need, draw it yourself with `CustomPaint` and a `CustomPainter`.'),
        code(r'''
class RingPainter extends CustomPainter {
  RingPainter(this.progress);
  final double progress; // 0.0 – 1.0

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 10;
    final bg = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final fg = Paint()
      ..color = Colors.teal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bg);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.1416 / 2,                // start at the top
      2 * 3.1416 * progress,      // sweep angle
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(RingPainter old) => old.progress != progress;
}

CustomPaint(size: const Size(160, 160), painter: RingPainter(0.65))
'''),
        demo('custom_paint', caption: 'Painted with a Canvas'),
        bullets([
          'Canvas methods: `drawLine`, `drawRect`, `drawRRect`, `drawCircle`, `drawArc`, `drawPath`, `drawImage`, text via `TextPainter`.',
          '`Paint` sets colour, stroke width, fill vs stroke, gradients (`shader`).',
          '`Path` builds complex shapes with `moveTo`, `lineTo`, `quadraticBezierTo`, `arcTo`.',
          '`shouldRepaint` — return true only when the drawing changes (performance).',
        ]),
      ],
      quiz: [
        q('Which method do you override to draw?', ['build', 'paint', 'draw', 'render'], 1, 'CustomPainter.paint(Canvas, Size).'),
      ],
    ),
    Lesson(
      id: 'adv.packages',
      title: 'Packages & pub.dev',
      summary: 'Find, add and evaluate packages.',
      minutes: 7,
      sections: [
        p('**pub.dev** hosts tens of thousands of Dart & Flutter packages. Don\'t reinvent the wheel!'),
        sh(r'''
flutter pub add http           # add latest version to pubspec.yaml
flutter pub add dev:mocktail   # dev-only dependency
flutter pub remove http
flutter pub get                # download dependencies
flutter pub outdated           # check for updates
flutter pub upgrade
''', caption: 'Terminal'),
        h('Choosing a good package'),
        bullets([
          'Look at **likes**, **pub points** (quality score, max 160) and **downloads**.',
          'Prefer the **Flutter Favorite** badge and **verified publishers**.',
          'Check the last update date and open GitHub issues.',
          'Check the **platforms** it supports (Android, iOS, Web…).',
        ]),
        h('Must-know packages'),
        bullets([
          '`http` / `dio` — networking',
          '`provider` / `flutter_riverpod` / `flutter_bloc` — state',
          '`go_router` — navigation',
          '`shared_preferences`, `sqflite`, `hive` — storage',
          '`cached_network_image` — image caching',
          '`url_launcher` — open links, email, phone',
          '`image_picker` — camera & gallery',
          '`firebase_core` & friends — auth, database, push notifications',
          '`intl` — dates, numbers, translations',
          '`freezed` / `json_serializable` — code generation',
        ]),
        h('Version constraints'),
        p('`http: ^1.2.0` means "1.2.0 or any newer version below 2.0.0". The caret `^` allows compatible updates only.'),
      ],
      quiz: [
        q('What does ^1.2.0 allow?', ['Exactly 1.2.0', '>=1.2.0 and <2.0.0', 'Any version', '<1.2.0'], 1, 'Caret allows non-breaking updates.'),
      ],
    ),
    Lesson(
      id: 'adv.platform',
      title: 'Platform Channels & Native Code',
      summary: 'Talk to Swift/Kotlin when you need native features.',
      minutes: 10,
      sections: [
        p('Most native features (camera, GPS, Bluetooth) already have packages. When they don\'t, use a **MethodChannel** to call your own Kotlin (Android) or Swift (iOS) code.'),
        code(r'''
import 'package:flutter/services.dart';

const _channel = MethodChannel('com.example.app/battery');

Future<int> getBatteryLevel() async {
  final level = await _channel.invokeMethod<int>('getBatteryLevel');
  return level ?? -1;
}
''', caption: 'Dart side'),
        code(r'''
// ios/Runner/AppDelegate.swift (inside application didFinishLaunching)
let controller = window?.rootViewController as! FlutterViewController
let channel = FlutterMethodChannel(name: "com.example.app/battery",
                                   binaryMessenger: controller.binaryMessenger)
channel.setMethodCallHandler { call, result in
  if call.method == "getBatteryLevel" {
    UIDevice.current.isBatteryMonitoringEnabled = true
    result(Int(UIDevice.current.batteryLevel * 100))
  } else {
    result(FlutterMethodNotImplemented)
  }
}
''', caption: 'Swift side (iOS)'),
        code(r'''
// android/app/src/main/kotlin/.../MainActivity.kt
class MainActivity : FlutterActivity() {
  override fun configureFlutterEngine(engine: FlutterEngine) {
    super.configureFlutterEngine(engine)
    MethodChannel(engine.dartExecutor.binaryMessenger, "com.example.app/battery")
      .setMethodCallHandler { call, result ->
        if (call.method == "getBatteryLevel") {
          val bm = getSystemService(BATTERY_SERVICE) as BatteryManager
          result.success(bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY))
        } else result.notImplemented()
      }
  }
}
''', caption: 'Kotlin side (Android)'),
        bullets([
          '`MethodChannel` — call a method, get one result.',
          '`EventChannel` — receive a stream of events from native code (sensors).',
          '**Pigeon** package — generates type-safe channel code for you.',
          '**FFI** (`dart:ffi`) — call C libraries directly.',
        ]),
        h('Permissions'),
        p('Native features need permission entries: iOS in `ios/Runner/Info.plist` (e.g. `NSCameraUsageDescription`), Android in `AndroidManifest.xml`. The `permission_handler` package asks the user at runtime.'),
      ],
      quiz: [
        q('Which channel type sends a stream of events from native code?', ['MethodChannel', 'EventChannel', 'BasicMessageChannel', 'StreamChannel'], 1,
            'EventChannel is for continuous events.'),
      ],
    ),
    Lesson(
      id: 'adv.testing',
      title: 'Testing',
      summary: 'Unit, widget and integration tests.',
      minutes: 12,
      sections: [
        p('Tests are code that checks your code. They catch bugs before users do and let you change code with confidence.'),
        h('Unit test — test a function or class'),
        code(r'''
// test/cart_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/cart.dart';

void main() {
  group('CartModel', () {
    test('starts empty', () {
      expect(CartModel().count, 0);
    });

    test('add increases count', () {
      final cart = CartModel()..add('Apple');
      expect(cart.count, 1);
      expect(cart.items, contains('Apple'));
    });
  });
}
'''),
        h('Widget test — test UI without a device'),
        code(r'''
testWidgets('counter increments', (tester) async {
  await tester.pumpWidget(const MaterialApp(home: CounterPage()));

  expect(find.text('0'), findsOneWidget);

  await tester.tap(find.byIcon(Icons.add));
  await tester.pump(); // rebuild after the tap

  expect(find.text('1'), findsOneWidget);
});
'''),
        h('Integration test — the full app on a real device'),
        p('Uses the `integration_test` package: drives the real app on a simulator/phone, tapping through whole flows like sign-up.'),
        sh(r'''
flutter test                                  # unit + widget tests
flutter test test/cart_test.dart              # one file
flutter test integration_test                 # integration tests (on a device)
flutter test --coverage                       # coverage report
''', caption: 'Terminal'),
        tip('Mock network calls in tests with `mocktail` so tests are fast and don\'t need internet.'),
      ],
      quiz: [
        q('Which test type runs UI without a device?', ['Unit test', 'Widget test', 'Integration test', 'Manual test'], 1,
            'Widget tests run in a simulated environment.'),
        q('After tester.tap(), what rebuilds the UI?', ['tester.pump()', 'setState()', 'tester.build()', 'Nothing needed'], 0,
            'pump() advances a frame.'),
      ],
    ),
    Lesson(
      id: 'adv.performance',
      title: 'Performance & DevTools',
      summary: 'Keep your app at a smooth 60–120 fps.',
      minutes: 9,
      sections: [
        h('Top performance habits'),
        bullets([
          'Use `const` constructors wherever possible.',
          'Use `ListView.builder` / `GridView.builder` for long lists.',
          'Split big widgets into smaller ones so `setState` rebuilds less.',
          'Never do heavy work (parsing big JSON, image processing) in `build()`.',
          'Move CPU-heavy work off the UI thread with `compute()` or `Isolate.run()`.',
          'Size images: `Image.network(url, cacheWidth: 300)` avoids decoding huge images.',
          'Avoid `Opacity` and `ClipPath` in animations where possible; prefer `FadeTransition`.',
          'Wrap complex, frequently-repainting parts in `RepaintBoundary`.',
        ]),
        code(r'''
// Heavy work on a background isolate
final result = await Isolate.run(() => parseHugeJson(rawText));
'''),
        h('Flutter DevTools'),
        bullets([
          '**Widget Inspector** — explore the widget tree, see layout and sizes.',
          '**Performance** — find slow frames ("jank").',
          '**CPU Profiler** — what code is taking time.',
          '**Memory** — find leaks (forgotten dispose!).',
          '**Network** — inspect HTTP requests.',
        ]),
        warn('Always measure performance in **profile mode** (`flutter run --profile`) on a **real device**. Debug mode is intentionally slow.'),
      ],
      quiz: [
        q('Which mode should you profile performance in?', ['Debug', 'Profile', 'Release', 'Test'], 1, 'Profile mode is close to release with tooling.'),
      ],
    ),
    Lesson(
      id: 'adv.architecture',
      title: 'App Architecture',
      summary: 'Organise code so apps stay maintainable as they grow.',
      minutes: 10,
      sections: [
        p('A small app can live in a few files. A real app needs **structure**. Flutter\'s official guide recommends separating code into **layers**:'),
        bullets([
          '**UI layer** — widgets (views) + view models / controllers that hold UI state.',
          '**Data layer** — **repositories** (the single source of truth for a kind of data) and **services** (talk to APIs, databases, platform).',
          '(Optional) **Domain layer** — use cases / business rules for complex apps.',
        ]),
        code(r'''
lib/
  main.dart
  app.dart                 # MaterialApp, theme, router
  core/                    # shared utils, constants, theme
  data/
    services/api_client.dart
    repositories/post_repository.dart
    models/post.dart
  features/
    posts/
      posts_screen.dart
      posts_view_model.dart
      widgets/post_card.dart
    settings/
      ...
''', caption: 'Feature-first folder structure'),
        code(r'''
class PostRepository {
  PostRepository(this._api);
  final ApiClient _api;
  List<Post>? _cache;

  Future<List<Post>> getPosts({bool refresh = false}) async {
    if (_cache != null && !refresh) return _cache!;
    return _cache = await _api.fetchPosts();
  }
}

class PostsViewModel extends ChangeNotifier {
  PostsViewModel(this._repo);
  final PostRepository _repo;

  bool loading = false;
  List<Post> posts = [];
  String? error;

  Future<void> load() async {
    loading = true;
    notifyListeners();
    try {
      posts = await _repo.getPosts();
      error = null;
    } catch (e) {
      error = 'Could not load posts';
    }
    loading = false;
    notifyListeners();
  }
}
'''),
        tip('Widgets should never call `http` directly. UI → ViewModel → Repository → Service. Each piece can then be tested and replaced independently.'),
      ],
      quiz: [
        q('Which layer should talk to the HTTP API?', ['Widgets', 'Services in the data layer', 'main.dart', 'Theme'], 1,
            'Services wrap external APIs; repositories use them.'),
      ],
    ),
    Lesson(
      id: 'adv.firebase',
      title: 'Firebase: Sign-in & Cloud Sync',
      summary: 'Google sign-in and syncing data across devices — how FlutterLab does it.',
      minutes: 14,
      sections: [
        p('Phones can\'t talk to each other directly. To share data between your iPhone and an Android phone you need a **backend** in the cloud. **Firebase** is Google\'s backend-as-a-service: authentication, a database, file storage, push notifications and more — with official Flutter packages and a generous free plan.'),
        analogy('Firebase is a locker at the train station. Any of your devices can open *your* locker with your key (your Google account). Put progress in from one phone, take it out on another.'),
        h('The pieces'),
        bullets([
          '`firebase_core` — connects the app to your Firebase project.',
          '`firebase_auth` — who is the user? Gives each person a stable **user ID (uid)**.',
          '`google_sign_in` — the native "Continue with Google" sheet on iOS and Android.',
          '`cloud_firestore` — a NoSQL database of **collections** and **documents** (like folders of JSON files) with live updates and offline support.',
        ]),
        h('Setup checklist'),
        steps([
          'Create a project at **console.firebase.google.com**.',
          'Enable **Authentication → Google** and create a **Firestore** database.',
          'Register your iOS app (bundle id) and Android app (package name + **SHA-1** signing fingerprint).',
          'Download `GoogleService-Info.plist` (iOS) and `google-services.json` (Android) into the project — or run `flutterfire configure`, which does it for you and generates `lib/firebase_options.dart`.',
          '`flutter pub add firebase_core firebase_auth cloud_firestore google_sign_in`',
        ]),
        sh(r'''
# Get the SHA-1 Android needs for Google sign-in
keytool -list -v -alias androiddebugkey \
  -keystore ~/.android/debug.keystore -storepass android
''', caption: 'Terminal'),
        h('1. Start Firebase'),
        code(r'''
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
'''),
        h('2. Sign in with Google'),
        code(r'''
await GoogleSignIn.instance.initialize();

Future<void> signIn() async {
  final account = await GoogleSignIn.instance.authenticate(); // native sheet
  final idToken = account.authentication.idToken;
  final credential = GoogleAuthProvider.credential(idToken: idToken);
  await FirebaseAuth.instance.signInWithCredential(credential);
}

// React to sign-in / sign-out anywhere
FirebaseAuth.instance.authStateChanges().listen((User? user) {
  print(user == null ? 'Signed out' : 'Hello ${user.displayName} (${user.uid})');
});
'''),
        note('Google proves who you are and hands the app an **ID token**. Firebase checks that token and signs you in to *your project*, giving you a `uid`. That `uid` is the same on every device you sign in on.'),
        h('3. Save and listen with Firestore'),
        code(r'''
final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);

// Write small changes (operations), not the whole object
await doc.set({
  'completed': FieldValue.arrayUnion(['dart.null']),
  'quizAnswered': FieldValue.increment(1),
}, SetOptions(merge: true));

// Live updates — fires when ANY device changes the document
doc.snapshots().listen((snap) {
  final data = snap.data();
  print('Completed: ${data?['completed']}');
});
'''),
        h('Why operations instead of "save everything"?'),
        p('Imagine you finish lesson A on your iPhone while offline, and lesson B on Android. If each phone uploaded its **whole** progress, the last upload would erase the other\'s lesson. With `arrayUnion(\'A\')` and `arrayUnion(\'B\')`, Firestore **combines** them: both lessons end up completed. `FieldValue.increment(1)` does the same for counters.'),
        h('Offline-first'),
        bullets([
          'The phone (shared_preferences) stays the main copy, so the app works with no internet and no account.',
          'Firestore keeps a local cache and **queues writes while offline**, uploading automatically when the connection returns.',
          'On first sign-in, FlutterLab **merges** this phone\'s progress into the cloud, so nothing is lost.',
        ]),
        h('4. Security rules — never skip this!'),
        p('Your app talks to the database directly, so **rules** decide who may read or write what. Without them, anyone could read everyone\'s data.'),
        code(r'''
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
''', caption: 'firestore.rules'),
        warn('"Test mode" rules (`allow read, write: if true`) are fine for 5 minutes of experimenting — never for a real app.'),
        tip('Read FlutterLab\'s real implementation: `lib/sync/sync_service.dart` (sign-in, merge, live sync) and `lib/state/app_state.dart` (the `SyncSink` interface).'),
      ],
      quiz: [
        q('What gives each user the same identity on every device?', ['The phone model', 'Their Firebase user ID (uid)', 'shared_preferences', 'The app version'], 1,
            'Firebase Auth assigns a stable uid per account.'),
        q('Two offline phones each complete a different lesson. Which write keeps both?', [
          'doc.set(wholeProgress)',
          "FieldValue.arrayUnion([lessonId])",
          'Deleting the document first',
          'Writing to shared_preferences only'], 1, 'arrayUnion merges values instead of overwriting.'),
        q('What stops other users reading your data?', ['Hiding the API key', 'Firestore security rules', 'Using HTTPS', 'Nothing'], 1,
            'Rules check request.auth.uid against the document.'),
      ],
    ),
    Lesson(
      id: 'adv.release',
      title: 'Build & Release (iOS & Android)',
      summary: 'Icons, app name, signing, and publishing to the stores.',
      minutes: 14,
      sections: [
        h('Before releasing'),
        steps([
          'Set the app **name**: Android `android:label` in `AndroidManifest.xml`; iOS `CFBundleDisplayName` in `Info.plist`.',
          'Set a unique **bundle id / applicationId** (e.g. `com.yourname.myapp`).',
          'Create **app icons** — the `flutter_launcher_icons` package generates all sizes from one image.',
          'Bump the **version** in pubspec.yaml: `version: 1.0.1+2` (name + build number).',
          'Test in release mode on real devices: `flutter run --release`.',
        ]),
        h('Android → Google Play'),
        sh(r'''
# 1. Create an upload keystore (once, keep it SAFE!)
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA \
  -keysize 2048 -validity 10000 -alias upload

# 2. Reference it in android/key.properties and android/app/build.gradle.kts
#    (see docs.flutter.dev/deployment/android)

# 3. Build an App Bundle for the Play Store
flutter build appbundle
# -> build/app/outputs/bundle/release/app-release.aab

# Or an APK to share directly
flutter build apk --release
''', caption: 'Android'),
        p('Upload the `.aab` in the **Google Play Console** (one-time \$25 developer fee), fill in the store listing, and roll out.'),
        h('iOS → App Store'),
        sh(r'''
# Requires a paid Apple Developer account ($99/year)
flutter build ipa
# -> build/ios/ipa/*.ipa

# Upload with the Transporter app or:
open build/ios/archive/Runner.xcarchive   # Xcode Organizer -> Distribute
''', caption: 'iOS'),
        steps([
          'Create the app in **App Store Connect** with the same bundle id.',
          'In Xcode (`ios/Runner.xcworkspace`) set your Team and signing.',
          'Upload the build, test it with **TestFlight**, then submit for review.',
        ]),
        warn('Lose your Android upload keystore and you can\'t update your app easily. Back it up somewhere safe and never commit it to git.'),
        tip('Automate builds with Codemagic, GitHub Actions or fastlane once you release regularly.'),
      ],
      quiz: [
        q('Which file format does Google Play prefer?', ['.apk', '.aab (App Bundle)', '.ipa', '.zip'], 1, 'Play requires App Bundles for new apps.'),
        q('In version: 1.2.0+5, what is 5?', ['Major version', 'Build number', 'Patch version', 'Minimum SDK'], 1,
            'The number after + is the build number.'),
      ],
    ),
  ],
);

final capstone = LearningModule(
  id: 'capstone',
  title: 'Capstone: Build a Todo App',
  description: 'Put everything together step by step, then plan your next steps.',
  level: Level.advanced,
  icon: Icons.emoji_events_rounded,
  color: const Color(0xFF00897B),
  lessons: [
    Lesson(
      id: 'capstone.todo',
      title: 'Build a Todo App',
      summary: 'Models, state, lists, input, dismiss and persistence.',
      minutes: 25,
      sections: [
        p('Time to combine what you\'ve learned! Here\'s the finished app you\'ll build — try it:'),
        demo('todo_app', caption: 'The finished Todo app'),
        h('Step 1 — The model'),
        code(r'''
class Todo {
  Todo({required this.title, this.done = false})
      : id = DateTime.now().microsecondsSinceEpoch.toString();
  final String id;
  final String title;
  bool done;
}
''', caption: 'lib/todo.dart'),
        h('Step 2 — State with a ChangeNotifier'),
        code(r'''
class TodoList extends ChangeNotifier {
  final List<Todo> _todos = [];
  List<Todo> get todos => List.unmodifiable(_todos);
  int get remaining => _todos.where((t) => !t.done).length;

  void add(String title) {
    if (title.trim().isEmpty) return;
    _todos.insert(0, Todo(title: title.trim()));
    notifyListeners();
  }

  void toggle(Todo todo) {
    todo.done = !todo.done;
    notifyListeners();
  }

  void remove(Todo todo) {
    _todos.remove(todo);
    notifyListeners();
  }
}
''', caption: 'lib/todo_list.dart'),
        h('Step 3 — The screen'),
        code(r'''
class TodoPage extends StatefulWidget {
  const TodoPage({super.key});
  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _list = TodoList();
  final _input = TextEditingController();

  @override
  void dispose() {
    _input.dispose();
    _list.dispose();
    super.dispose();
  }

  void _submit() {
    _list.add(_input.text);
    _input.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Todos')),
      body: ListenableBuilder(
        listenable: _list,
        builder: (context, _) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller: _input,
                    decoration: const InputDecoration(hintText: 'What needs doing?'),
                    onSubmitted: (_) => _submit(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(onPressed: _submit, icon: const Icon(Icons.add)),
              ]),
            ),
            Text('${_list.remaining} left'),
            Expanded(
              child: ListView.builder(
                itemCount: _list.todos.length,
                itemBuilder: (context, i) {
                  final todo = _list.todos[i];
                  return Dismissible(
                    key: ValueKey(todo.id),
                    onDismissed: (_) => _list.remove(todo),
                    background: Container(color: Colors.red),
                    child: CheckboxListTile(
                      value: todo.done,
                      onChanged: (_) => _list.toggle(todo),
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          decoration: todo.done ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
''', caption: 'lib/todo_page.dart'),
        h('Step 4 — Make it yours'),
        steps([
          '**Persist** todos with shared_preferences: add `toJson`/`fromJson` to `Todo`, save the list as a JSON string in `notifyListeners` time.',
          'Add **filters** (All / Active / Done) with a `SegmentedButton`.',
          'Add **due dates** with `showDatePicker`.',
          'Add an **edit** screen using `Navigator.push` and return the new title with `pop`.',
          'Animate additions with `AnimatedList`.',
          'Write **unit tests** for `TodoList` and a **widget test** for adding a todo.',
        ]),
        tip('Build it from scratch in a new project (`flutter create todo_app`) without copying. Getting stuck and figuring it out is where the real learning happens.'),
      ],
      quiz: [
        q('Which widget rebuilds the todo list when TodoList calls notifyListeners?', ['FutureBuilder', 'ListenableBuilder', 'LayoutBuilder', 'Builder'], 1,
            'ListenableBuilder listens to any Listenable, including ChangeNotifier.'),
      ],
    ),
    Lesson(
      id: 'capstone.next',
      title: 'What\'s Next?',
      summary: 'Project ideas and resources to keep growing.',
      minutes: 5,
      sections: [
        p('🎉 If you\'ve made it here — congratulations! You now know the core of Flutter. The fastest way to grow from here is to **build real projects**.'),
        h('Project ideas (easy → hard)'),
        steps([
          '**Tip calculator** — TextField, Slider, math.',
          '**BMI / unit converter** — forms, validation.',
          '**Quiz app** — state, navigation, results screen.',
          '**Weather app** — HTTP + JSON from a free API (open-meteo.com needs no key).',
          '**Notes app** — CRUD, local database (sqflite/hive), search.',
          '**Expense tracker** — charts (fl_chart), categories, persistence.',
          '**Chat app** — Firebase Auth + Firestore streams.',
          '**E-commerce clone** — go_router, Riverpod, cart, checkout flow.',
        ]),
        h('Resources'),
        bullets([
          '**docs.flutter.dev** — official docs, codelabs and cookbook.',
          '**dart.dev** — the Dart language tour.',
          '**dartpad.dev** — run Flutter in your browser.',
          '**Flutter YouTube channel** — "Widget of the Week" videos.',
          '**pub.dev** — packages.',
          '**Flutter community** on Discord and Reddit (r/FlutterDev).',
        ]),
        tip('Revisit lessons you found hard — understanding grows each time. And come back to the Practice tab to keep your knowledge fresh!'),
      ],
    ),
  ],
);
