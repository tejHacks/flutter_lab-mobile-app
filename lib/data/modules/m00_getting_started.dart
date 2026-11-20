import 'package:flutter/material.dart';

import '../../models/lesson.dart';
import '../dsl.dart';

final gettingStarted = LearningModule(
  id: 'start',
  title: 'Getting Started',
  description: 'What Flutter is, how to install it, and how to run your first app on iOS and Android.',
  level: Level.beginner,
  icon: Icons.rocket_launch_rounded,
  color: const Color(0xFF0B6BCB),
  lessons: [
    Lesson(
      id: 'start.welcome',
      title: 'Welcome to FlutterLab',
      summary: 'How this app works and how to learn effectively.',
      minutes: 3,
      sections: [
        p('Welcome! FlutterLab takes you from **zero** to building and shipping real Flutter apps. You do not need any previous programming experience — every idea is explained from scratch.'),
        h('How lessons work'),
        bullets([
          '**Read** short explanations. Words in `this style` are code.',
          '**Run** Dart examples: code boxes with a green **Run** button execute real Dart code right inside the app and show you the output.',
          '**Play** with live demos: blue-framed boxes are real Flutter widgets. Tap, drag, and change their settings to see what happens.',
          '**Check yourself** with a short quiz at the end of each lesson.',
          '**Practice** in the Practice tab with quizzes and coding challenges.',
        ]),
        h('Your learning path'),
        steps([
          '**Getting Started** — install Flutter and run an app.',
          '**Dart** — the programming language Flutter uses.',
          '**Flutter Fundamentals** — widgets, the core idea of Flutter.',
          '**Layout, Widgets, Input, Lists, Navigation, Theming** — build real screens.',
          '**State, Data, Networking, Animations** — make apps dynamic.',
          '**Advanced + Capstone** — testing, performance, release, and a full project.',
        ]),
        tip('Learning to code is like learning an instrument: **practice beats reading**. After each lesson, open your editor and type the examples yourself. Don\'t copy-paste — typing builds memory.'),
        note('You can follow the path in order (recommended) or jump anywhere. Bookmark lessons with the bookmark icon to find them again in the **Me** tab.'),
      ],
      quiz: [
        q('What does a green "Run" button on a code box do?',
            ['Opens a website', 'Runs the Dart code and shows its output', 'Copies the code', 'Nothing'],
            1, 'Runnable examples execute real Dart code inside FlutterLab and show what it prints.'),
      ],
    ),
    Lesson(
      id: 'start.what',
      title: 'What is Flutter?',
      summary: 'One codebase, many platforms — and how Flutter draws your UI.',
      minutes: 6,
      sections: [
        p('**Flutter** is a free, open-source toolkit made by Google for building apps. You write your code **once**, and it runs on **iOS, Android, web, Windows, macOS and Linux**.'),
        p('Flutter apps are written in a programming language called **Dart** (also by Google). Don\'t worry — you will learn Dart in this app before diving deep into Flutter.'),
        h('How does Flutter work?'),
        p('Most frameworks use the phone\'s built-in buttons and text boxes. Flutter is different: it **draws every pixel itself** using its own rendering engine (called **Impeller**). That\'s why a Flutter app looks the same on every device and runs smoothly at 60–120 frames per second.'),
        analogy('Imagine painting a picture. Other frameworks ask the phone to "place a button here". Flutter brings its own canvas and paints the button itself. You get full control over every pixel.'),
        h('Everything is a widget'),
        p('In Flutter you build your user interface (UI) out of **widgets**. A widget is a description of a piece of UI: a piece of text, a button, some padding, a whole screen. You combine small widgets into bigger ones, like LEGO bricks.'),
        code(r'''
Center(
  child: Text('Hello, Flutter!'),
)
''', caption: 'A Text widget inside a Center widget'),
        h('Why developers love Flutter'),
        bullets([
          '**Hot Reload** — change code and see the result in under a second, without losing your place in the app.',
          '**One codebase** — iOS and Android (and more) from the same code.',
          '**Beautiful by default** — Material Design (Android style) and Cupertino (iOS style) widgets included.',
          '**Fast** — compiled to native machine code.',
          '**Huge ecosystem** — thousands of free packages on pub.dev.',
        ]),
        note('Big apps built with Flutter include Google Pay, BMW, Alibaba\'s Xianyu, Nubank and many more.'),
      ],
      quiz: [
        q('Which language do you write Flutter apps in?', ['JavaScript', 'Kotlin', 'Dart', 'Swift'], 2,
            'Flutter uses Dart, a language created by Google.'),
        q('What is the basic building block of a Flutter UI?', ['Activity', 'Widget', 'View controller', 'Component'], 1,
            'In Flutter, everything you see is built from widgets.'),
        q('How does Flutter display UI?', [
          'It uses each platform\'s native buttons',
          'It draws every pixel with its own rendering engine',
          'It opens a web page',
          'It uses screenshots',
        ], 1, 'Flutter renders the UI itself, which is why it looks identical on every platform.'),
      ],
    ),
    Lesson(
      id: 'start.install',
      title: 'Install Flutter (macOS)',
      summary: 'Download the SDK, set up your PATH, and run flutter doctor.',
      minutes: 10,
      sections: [
        p('To build Flutter apps you need the **Flutter SDK** (Software Development Kit) — a folder of tools, including Dart. Here\'s how to install it on a Mac. (Windows/Linux steps are similar; see docs.flutter.dev.)'),
        h('Option A — VS Code (easiest)'),
        steps([
          'Install **Visual Studio Code** from code.visualstudio.com.',
          'Open VS Code → Extensions → install the **Flutter** extension (it installs Dart too).',
          'Press **Cmd+Shift+P**, type `Flutter: New Project`. VS Code offers to **download the SDK** for you. Pick a folder like `~/develop`.',
          'When asked, click **Add SDK to PATH**.',
        ]),
        h('Option B — manual install'),
        sh(r'''
# 1. Make a folder and download Flutter with git
mkdir -p ~/develop && cd ~/develop
git clone https://github.com/flutter/flutter.git -b stable

# 2. Add Flutter to your PATH (zsh is the default Mac shell)
echo 'export PATH="$HOME/develop/flutter/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# 3. Check it works
flutter --version
''', caption: 'Terminal'),
        note('**PATH** is a list of folders where your terminal looks for programs. Adding Flutter\'s `bin` folder lets you type `flutter` from anywhere.'),
        h('Meet flutter doctor'),
        p('`flutter doctor` checks your computer and tells you what\'s missing. Run it any time something seems broken.'),
        sh(r'''
flutter doctor

# Example output:
# [✓] Flutter (Channel stable, 3.x)
# [✗] Android toolchain - Android SDK not found
# [!] Xcode - CocoaPods not installed
# [✓] VS Code
''', caption: 'Terminal'),
        p('A ✓ means good, ! means a warning, ✗ means something is missing. The next lesson fixes the iOS and Android items.'),
        tip('Run `flutter doctor -v` (verbose) for detailed hints on how to fix each problem.'),
      ],
      quiz: [
        q('Which command checks your Flutter setup for problems?',
            ['flutter check', 'flutter doctor', 'flutter fix', 'dart test'], 1,
            '`flutter doctor` diagnoses your installation.'),
        q('Why add Flutter to your PATH?', [
          'To make apps faster',
          'So the terminal can find the `flutter` command from any folder',
          'To enable dark mode',
          'It is required by Apple',
        ], 1, 'PATH tells the shell which folders contain runnable programs.'),
      ],
    ),
    Lesson(
      id: 'start.platforms',
      title: 'Set up iOS & Android',
      summary: 'Xcode, CocoaPods, Android Studio, simulators and emulators.',
      minutes: 12,
      sections: [
        p('To run apps on iPhone you need **Xcode** (Mac only). To run on Android you need **Android Studio** (any computer). You can set up one or both.'),
        h('iOS setup (Mac only)'),
        steps([
          'Install **Xcode** from the Mac App Store (it\'s big — be patient).',
          'Open Xcode once and accept the license; let it install components.',
          'Install an iOS simulator: Xcode → Settings → Components (or Platforms) → iOS.',
          'Install **CocoaPods** (manages iOS plugins).',
        ]),
        sh(r'''
# Point the command-line tools at Xcode and accept the license
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
sudo xcodebuild -license accept

# CocoaPods (via Homebrew — install it from brew.sh if needed)
brew install cocoapods

# Open the iOS Simulator
open -a Simulator
''', caption: 'Terminal'),
        h('Android setup'),
        steps([
          'Install **Android Studio** from developer.android.com/studio.',
          'Open it → **More Actions → SDK Manager**. Under **SDK Tools**, tick **Android SDK Command-line Tools** and click Apply.',
          'Go to **More Actions → Virtual Device Manager → Create device**. Pick a phone (e.g. Pixel), download a system image, Finish. This is your **emulator**.',
          'Accept the Android licenses (below).',
        ]),
        sh(r'''
flutter doctor --android-licenses   # press y to accept each

# List and start emulators from the terminal
flutter emulators
flutter emulators --launch <emulator_id>
''', caption: 'Terminal'),
        h('Using a real phone'),
        bullets([
          '**Android**: Settings → About phone → tap **Build number** 7 times to unlock Developer options. Then enable **USB debugging** and plug in the phone.',
          '**iPhone**: plug in, tap **Trust**, enable **Developer Mode** (Settings → Privacy & Security). In Xcode open `ios/Runner.xcworkspace`, select the Runner target → Signing & Capabilities → choose your **Team** (a free Apple ID works).',
        ]),
        tip('Run `flutter doctor` again. When iOS and Android show ✓, you\'re ready to build!'),
        warn('Simulators/emulators are great for learning, but always test on a real device before releasing — performance, camera and notifications behave differently.'),
      ],
      quiz: [
        q('What do you need to build iOS apps?',
            ['Android Studio only', 'A Mac with Xcode', 'A Windows PC', 'Nothing extra'], 1,
            'Apple requires Xcode, which only runs on macOS.'),
        q('What is an Android emulator?', [
          'A virtual Android phone running on your computer',
          'A cable', 'A Flutter widget', 'A type of APK'], 0,
            'Emulators simulate a device so you can test without a physical phone.'),
      ],
    ),
    Lesson(
      id: 'start.project',
      title: 'Your First Project',
      summary: 'Create an app and understand every folder in it.',
      minutes: 10,
      sections: [
        sh(r'''
flutter create my_first_app
cd my_first_app
flutter run
''', caption: 'Create and run a new app'),
        p('`flutter create` generates a complete starter app (a counter). Here\'s what the folders mean:'),
        bullets([
          '`lib/` — **your Dart code**. You\'ll spend 95% of your time here. `lib/main.dart` is where the app starts.',
          '`pubspec.yaml` — the app\'s settings: name, version, **dependencies** (packages) and **assets** (images, fonts).',
          '`android/` and `ios/` — native projects for each platform. You rarely touch these (app name, icons, permissions).',
          '`test/` — automated tests.',
          '`web/`, `macos/`, `windows/`, `linux/` — other platforms.',
          '`build/` — generated output. Never edit it.',
        ]),
        h('The smallest Flutter app'),
        code(r'''
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello, world!'),
        ),
      ),
    );
  }
}
''', caption: 'lib/main.dart'),
        bullets([
          '`import` brings in Flutter\'s Material widgets.',
          '`main()` is where every Dart program starts.',
          '`runApp()` takes a widget and makes it the root of the screen.',
          '`MaterialApp` sets up the app (theme, navigation). `Scaffold` is a basic page layout. `Center` centres its child. `Text` shows text.',
        ]),
        h('pubspec.yaml'),
        code(r'''
name: my_first_app
version: 1.0.0+1

environment:
  sdk: ^3.5.0

dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0        # a package from pub.dev

flutter:
  uses-material-design: true
  assets:
    - assets/images/
''', caption: 'pubspec.yaml'),
        warn('YAML is **indentation-sensitive**. Use 2 spaces, never tabs. A wrong indent is the #1 cause of pubspec errors.'),
      ],
      quiz: [
        q('Where does your app\'s Dart code live?', ['android/', 'build/', 'lib/', 'test/'], 2,
            'All your Dart source goes in lib/, starting at lib/main.dart.'),
        q('What does runApp() do?', [
          'Installs packages',
          'Makes the given widget the root of the app',
          'Builds an APK',
          'Starts the emulator'], 1, 'runApp attaches your root widget to the screen.'),
        q('Where do you add packages (dependencies)?', ['main.dart', 'pubspec.yaml', 'Info.plist', 'build.gradle'], 1,
            'Dependencies are declared in pubspec.yaml.'),
      ],
    ),
    Lesson(
      id: 'start.run',
      title: 'Run Apps & Hot Reload',
      summary: 'Run on simulators and phones, hot reload, and basic debugging.',
      minutes: 8,
      sections: [
        sh(r'''
flutter devices             # list connected phones/simulators
flutter run                 # run on the only/selected device
flutter run -d iphone       # pick a device by name or id
flutter run -d emulator-5554
flutter run --release       # fast, optimized build
''', caption: 'Running'),
        p('In VS Code, pick a device in the bottom-right status bar and press **F5**. In Android Studio, pick a device in the toolbar and press the green ▶.'),
        h('Hot Reload vs Hot Restart'),
        bullets([
          '**Hot Reload** (`r` in terminal, or save the file): injects your code changes in under a second and **keeps the app state** (e.g. the counter value).',
          '**Hot Restart** (`R`): restarts the app from scratch, **resets state**. Needed when you change `main()`, global variables or `initState`.',
          '**Full restart** (stop + run): needed after adding packages or native changes.',
        ]),
        demo('hot_reload', caption: 'Simulate: state survives hot reload'),
        h('Debug, profile and release modes'),
        bullets([
          '**Debug** — hot reload, assertions, debugger. Slower. Shows a DEBUG banner.',
          '**Profile** — near-release performance with profiling tools.',
          '**Release** — fully optimized, no debugging. What users get.',
        ]),
        h('Debugging basics'),
        code(r'''
print('Button pressed!');        // simple log
debugPrint('Value: $value');     // safer for long output

// In VS Code: click left of a line number to add a
// breakpoint (red dot). The app pauses there and you can
// inspect variables.
''', caption: 'Logging'),
        tip('Flutter DevTools (open from VS Code or the link printed by flutter run) has a **Widget Inspector** — tap any widget on the screen to see its code location and size.'),
        warn('If hot reload doesn\'t show your change, try hot restart (`R`). If you added a package, stop the app and run again.'),
      ],
      quiz: [
        q('Which keeps your app\'s current state?', ['Hot reload', 'Hot restart', 'Full rebuild', 'Uninstall'], 0,
            'Hot reload swaps code in while preserving state.'),
        q('Which mode do users get from the app store?', ['Debug', 'Profile', 'Release', 'Test'], 2,
            'Release mode is fully optimized.'),
      ],
    ),
  ],
);
