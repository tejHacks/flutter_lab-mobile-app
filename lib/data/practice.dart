/// Coding challenges for the Practice tab, plus glossary and CLI cheat sheet.
class Challenge {
  const Challenge({
    required this.id,
    required this.title,
    required this.level,
    required this.task,
    required this.hints,
    required this.solution,
  });
  final String id;
  final String title;
  final String level;
  final String task;
  final List<String> hints;
  final String solution;
}

const challenges = <Challenge>[
  Challenge(
    id: 'c.fizzbuzz',
    title: 'FizzBuzz',
    level: 'Dart · Easy',
    task: 'Print the numbers 1 to 15. For multiples of 3 print "Fizz", for multiples of 5 print "Buzz", and for multiples of both print "FizzBuzz".',
    hints: ['Use a `for` loop from 1 to 15.', 'Check `i % 15 == 0` first.', 'The `%` operator gives the remainder.'],
    solution: r'''
void main() {
  for (var i = 1; i <= 15; i++) {
    if (i % 15 == 0) {
      print('FizzBuzz');
    } else if (i % 3 == 0) {
      print('Fizz');
    } else if (i % 5 == 0) {
      print('Buzz');
    } else {
      print(i);
    }
  }
}''',
  ),
  Challenge(
    id: 'c.average',
    title: 'Average & Max',
    level: 'Dart · Easy',
    task: 'Given `final scores = [72, 95, 88, 61, 79];` write a function that returns the average and another that returns the highest score.',
    hints: ['`reduce((a, b) => a + b)` sums a list.', 'Divide by `scores.length`.', '`reduce((a, b) => a > b ? a : b)` finds the max.'],
    solution: r'''
double average(List<int> xs) => xs.reduce((a, b) => a + b) / xs.length;
int highest(List<int> xs) => xs.reduce((a, b) => a > b ? a : b);

void main() {
  final scores = [72, 95, 88, 61, 79];
  print(average(scores)); // 79.0
  print(highest(scores)); // 95
}''',
  ),
  Challenge(
    id: 'c.bank',
    title: 'Bank Account Class',
    level: 'Dart · Medium',
    task: 'Create a `BankAccount` class with an owner name, a private `_balance`, `deposit` and `withdraw` methods, and a `balance` getter. `withdraw` should throw an exception if there isn\'t enough money.',
    hints: ['Fields starting with `_` are private.', 'Use `double get balance => _balance;`', '`throw Exception(\'Insufficient funds\')`'],
    solution: r'''
class BankAccount {
  BankAccount(this.owner);
  final String owner;
  double _balance = 0;

  double get balance => _balance;

  void deposit(double amount) {
    if (amount <= 0) throw ArgumentError('Amount must be positive');
    _balance += amount;
  }

  void withdraw(double amount) {
    if (amount > _balance) throw Exception('Insufficient funds');
    _balance -= amount;
  }
}

void main() {
  final acc = BankAccount('Ada')..deposit(100);
  acc.withdraw(30);
  print(acc.balance); // 70.0
  try {
    acc.withdraw(500);
  } catch (e) {
    print(e);
  }
}''',
  ),
  Challenge(
    id: 'c.profile',
    title: 'Profile Card',
    level: 'Flutter · Easy',
    task: 'Build a centred Card with a CircleAvatar, a name in bold, a job title in grey, and a row of three icon buttons (email, phone, share).',
    hints: ['Card > Padding > Column(mainAxisSize: MainAxisSize.min)', 'Use `SizedBox(height: 8)` for gaps.', 'Row(mainAxisAlignment: MainAxisAlignment.center, children: [IconButton...])'],
    solution: r'''
class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(radius: 40, child: Text('AL', style: TextStyle(fontSize: 24))),
              const SizedBox(height: 12),
              const Text('Ada Lovelace',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Text('Flutter Developer', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.email)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.phone)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}''',
  ),
  Challenge(
    id: 'c.like',
    title: 'Like Button',
    level: 'Flutter · Easy',
    task: 'Make a StatefulWidget that shows a heart icon and a like count. Tapping toggles liked/unliked: the heart fills red and the count goes up by one, or back down.',
    hints: ['Keep `bool _liked` and `int _count` in State.', 'Change both inside `setState`.', 'Icons.favorite vs Icons.favorite_border'],
    solution: r'''
class LikeButton extends StatefulWidget {
  const LikeButton({super.key});
  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _liked = false;
  int _count = 41;

  void _toggle() {
    setState(() {
      _liked = !_liked;
      _count += _liked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: _toggle,
          icon: Icon(
            _liked ? Icons.favorite : Icons.favorite_border,
            color: _liked ? Colors.red : null,
          ),
        ),
        Text('$_count'),
      ],
    );
  }
}''',
  ),
  Challenge(
    id: 'c.tip',
    title: 'Tip Calculator',
    level: 'Flutter · Medium',
    task: 'Build a screen with a TextField for the bill amount, a Slider for tip % (0–30), and Text showing the tip and the total. Update live as the user types or drags.',
    hints: ['Use `double.tryParse(text) ?? 0`.', 'Store `_bill` and `_tipPercent` in State.', 'Call setState in TextField.onChanged and Slider.onChanged.'],
    solution: r'''
class TipCalculator extends StatefulWidget {
  const TipCalculator({super.key});
  @override
  State<TipCalculator> createState() => _TipCalculatorState();
}

class _TipCalculatorState extends State<TipCalculator> {
  double _bill = 0;
  double _tip = 15;

  @override
  Widget build(BuildContext context) {
    final tipAmount = _bill * _tip / 100;
    return Scaffold(
      appBar: AppBar(title: const Text('Tip Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Bill', prefixText: '\$ '),
              onChanged: (t) => setState(() => _bill = double.tryParse(t) ?? 0),
            ),
            const SizedBox(height: 16),
            Text('Tip: ${_tip.round()}%'),
            Slider(
              value: _tip,
              max: 30,
              divisions: 30,
              onChanged: (v) => setState(() => _tip = v),
            ),
            Text('Tip: \$${tipAmount.toStringAsFixed(2)}'),
            Text('Total: \$${(_bill + tipAmount).toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}''',
  ),
  Challenge(
    id: 'c.contacts',
    title: 'Contacts List → Details',
    level: 'Flutter · Medium',
    task: 'Show a ListView.builder of contacts (name + phone). Tapping one pushes a details page that receives the contact through its constructor.',
    hints: ['Create a `Contact` class with name and phone.', 'Use `Navigator.of(context).push(MaterialPageRoute(...))`.', 'The details page takes `required this.contact`.'],
    solution: r'''
class Contact {
  const Contact(this.name, this.phone);
  final String name, phone;
}

const contacts = [
  Contact('Ada', '555-0101'),
  Contact('Alan', '555-0102'),
  Contact('Grace', '555-0103'),
];

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, i) {
          final c = contacts[i];
          return ListTile(
            leading: CircleAvatar(child: Text(c.name[0])),
            title: Text(c.name),
            subtitle: Text(c.phone),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ContactDetails(contact: c)),
            ),
          );
        },
      ),
    );
  }
}

class ContactDetails extends StatelessWidget {
  const ContactDetails({super.key, required this.contact});
  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(contact.name)),
      body: Center(child: Text('📞 ${contact.phone}', style: const TextStyle(fontSize: 24))),
    );
  }
}''',
  ),
  Challenge(
    id: 'c.users',
    title: 'Fetch Users from an API',
    level: 'Flutter · Hard',
    task: 'Using the `http` package, fetch https://jsonplaceholder.typicode.com/users, parse it into `User` objects (id, name, email) and show them with a FutureBuilder — with loading and error states.',
    hints: ['Create the Future in initState.', '`jsonDecode(response.body) as List`', 'Write `User.fromJson` as a factory constructor.'],
    solution: r'''
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class User {
  const User({required this.id, required this.name, required this.email});
  final int id;
  final String name, email;

  factory User.fromJson(Map<String, dynamic> j) =>
      User(id: j['id'] as int, name: j['name'] as String, email: j['email'] as String);
}

Future<List<User>> fetchUsers() async {
  final res = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
  if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');
  return (jsonDecode(res.body) as List)
      .map((j) => User.fromJson(j as Map<String, dynamic>))
      .toList();
}

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});
  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late Future<List<User>> _future = fetchUsers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: FutureBuilder<List<User>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: TextButton(
                onPressed: () => setState(() => _future = fetchUsers()),
                child: Text('Error: ${snap.error}\nTap to retry'),
              ),
            );
          }
          final users = snap.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (_, i) => ListTile(
              title: Text(users[i].name),
              subtitle: Text(users[i].email),
            ),
          );
        },
      ),
    );
  }
}''',
  ),
  Challenge(
    id: 'c.theme',
    title: 'Dark Mode Toggle',
    level: 'Flutter · Hard',
    task: 'Make an app with light and dark themes and a Switch on the home page that toggles between them. Use a ValueNotifier<ThemeMode> at the top of the app.',
    hints: ['`final themeMode = ValueNotifier(ThemeMode.light);` as a top-level variable.', 'Wrap MaterialApp in ValueListenableBuilder.', 'Set `themeMode:` on MaterialApp.'],
    solution: r'''
final themeMode = ValueNotifier(ThemeMode.light);

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (context, mode, _) => MaterialApp(
        theme: ThemeData(colorSchemeSeed: Colors.indigo),
        darkTheme: ThemeData(colorSchemeSeed: Colors.indigo, brightness: Brightness.dark),
        themeMode: mode,
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = themeMode.value == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Theme toggle')),
      body: Center(
        child: SwitchListTile(
          title: const Text('Dark mode'),
          value: isDark,
          onChanged: (v) => themeMode.value = v ? ThemeMode.dark : ThemeMode.light,
        ),
      ),
    );
  }
}''',
  ),
];

const glossary = <(String, String)>[
  ('Widget', 'An immutable description of part of the UI. Everything on screen is built from widgets.'),
  ('Widget tree', 'The hierarchy of widgets nested inside each other, from MaterialApp down to each Text.'),
  ('StatelessWidget', 'A widget that depends only on its constructor inputs.'),
  ('StatefulWidget', 'A widget with a separate State object holding data that can change.'),
  ('State', 'Data that can change over time and affects what is shown.'),
  ('setState', 'Tells Flutter that state changed so the widget rebuilds.'),
  ('build()', 'The method that returns a widget\'s UI. Called whenever the widget needs to update.'),
  ('BuildContext', 'A handle to a widget\'s location in the tree, used to look up Theme, Navigator, etc.'),
  ('Hot reload', 'Injects code changes into the running app while keeping state.'),
  ('Hot restart', 'Restarts the app with new code, resetting state.'),
  ('Constraints', 'The min/max width and height a parent gives to a child.'),
  ('Main axis', 'The direction a Row (horizontal) or Column (vertical) lays out children.'),
  ('Cross axis', 'The direction perpendicular to the main axis.'),
  ('Flex', 'The share of free space an Expanded/Flexible child gets.'),
  ('Material Design', 'Google\'s design system; Flutter\'s Material widgets implement it.'),
  ('Cupertino', 'Flutter\'s iOS-style widget set.'),
  ('Scaffold', 'A page layout with slots for app bar, body, FAB, drawer and bottom bar.'),
  ('Route', 'A screen managed by the Navigator.'),
  ('Navigator', 'Manages a stack of routes: push to go forward, pop to go back.'),
  ('Key', 'An identifier that helps Flutter match widgets to their State when lists change.'),
  ('const', 'A compile-time constant. const widgets are created once and reused.'),
  ('final', 'A variable that can be assigned only once.'),
  ('Null safety', 'Dart\'s guarantee that non-nullable variables can never hold null.'),
  ('Future', 'A value that will be available later (async).'),
  ('Stream', 'A sequence of async values over time.'),
  ('async / await', 'Syntax for writing asynchronous code that reads like synchronous code.'),
  ('Isolate', 'Dart\'s unit of concurrency — separate memory, used for heavy work off the UI thread.'),
  ('Package', 'Reusable code published on pub.dev and added via pubspec.yaml.'),
  ('pubspec.yaml', 'Project config: name, version, dependencies, assets, fonts.'),
  ('Asset', 'A file bundled with the app: images, fonts, JSON.'),
  ('InheritedWidget', 'A widget that shares data with all its descendants efficiently.'),
  ('ChangeNotifier', 'A class that can notify listeners when it changes.'),
  ('Provider / Riverpod / Bloc', 'Popular state management packages.'),
  ('Sliver', 'A scrollable piece of a CustomScrollView.'),
  ('Tween', 'Defines a range (begin → end) to animate between.'),
  ('Curve', 'An easing function that shapes an animation\'s speed over time.'),
  ('AnimationController', 'Produces animation values 0.0 → 1.0 and controls playback.'),
  ('Ticker / vsync', 'A per-frame callback that drives animations in sync with the screen.'),
  ('Platform channel', 'A bridge to call native Kotlin/Swift code from Dart.'),
  ('Jank', 'Visible stutter caused by frames taking too long to render.'),
  ('DevTools', 'Flutter\'s debugging and profiling suite.'),
  ('APK / AAB', 'Android app package / Android App Bundle (for Google Play).'),
  ('IPA', 'iOS app archive uploaded to the App Store.'),
  ('Bundle ID', 'Unique app identifier, e.g. com.yourname.app.'),
];

const cliCheatSheet = <(String, String)>[
  ('flutter doctor', 'Check your setup'),
  ('flutter create my_app', 'New project'),
  ('flutter devices', 'List connected devices'),
  ('flutter emulators --launch <id>', 'Start an emulator'),
  ('open -a Simulator', 'Open the iOS Simulator (macOS)'),
  ('flutter run', 'Run in debug mode'),
  ('flutter run -d <device>', 'Run on a specific device'),
  ('flutter run --release', 'Run optimized build'),
  ('r / R / q', 'Hot reload / hot restart / quit (while running)'),
  ('flutter pub add <pkg>', 'Add a package'),
  ('flutter pub get', 'Download dependencies'),
  ('flutter pub upgrade', 'Upgrade dependencies'),
  ('flutter clean', 'Delete build files (fixes odd errors)'),
  ('flutter analyze', 'Find code problems'),
  ('dart format .', 'Format all code'),
  ('dart fix --apply', 'Auto-fix lint issues'),
  ('flutter test', 'Run tests'),
  ('flutter build apk', 'Build an Android APK'),
  ('flutter build appbundle', 'Build an Android App Bundle'),
  ('flutter build ipa', 'Build for the App Store'),
  ('flutter upgrade', 'Update Flutter itself'),
];
