import 'package:flutter/material.dart';

import '../../models/lesson.dart';
import '../dsl.dart';

final fundamentals = LearningModule(
  id: 'basics',
  title: 'Flutter Fundamentals',
  description: 'Widgets, the widget tree, Stateless vs Stateful, setState, BuildContext and keys.',
  level: Level.beginner,
  icon: Icons.widgets_rounded,
  color: const Color(0xFF1E88E5),
  lessons: [
    Lesson(
      id: 'basics.widgets',
      title: 'Everything is a Widget',
      summary: 'Widgets, the widget tree, parents and children.',
      minutes: 8,
      sections: [
        p('A **widget** is a description of part of your UI. Text, buttons, padding, rows, whole pages — all widgets. You build screens by **nesting** widgets inside each other.'),
        code(r'''
Scaffold(
  appBar: AppBar(title: const Text('Profile')),
  body: Column(
    children: [
      const Icon(Icons.person, size: 64),
      const Text('Ada Lovelace'),
      ElevatedButton(
        onPressed: () {},
        child: const Text('Follow'),
      ),
    ],
  ),
)
''', caption: 'Widgets inside widgets'),
        demo('widget_tree', caption: 'The widget tree of the code above'),
        bullets([
          'A widget with one slot uses `child:`. One with many uses `children: [ ... ]`.',
          'The outer widget is the **parent**; the inner ones are **children**. Together they form the **widget tree**.',
          'Widgets are **immutable** (they can\'t change). To change the screen, Flutter builds new widgets — this is cheap and fast.',
        ]),
        analogy('Widgets are like LEGO instructions, not the LEGO itself. Flutter reads the instructions and builds what you see. When something changes, you hand it new instructions and Flutter updates only the bricks that differ.'),
        h('Two big families'),
        bullets([
          '**Material** widgets (`package:flutter/material.dart`) — Google\'s design system: `ElevatedButton`, `AppBar`, `Card`…',
          '**Cupertino** widgets (`package:flutter/cupertino.dart`) — iOS style: `CupertinoButton`, `CupertinoNavigationBar`…',
        ]),
        tip('Put commas after every closing `)` in a widget tree (trailing commas). Then press **Format Document** (Shift+Alt+F / Shift+Option+F) and Flutter indents everything beautifully.'),
      ],
      quiz: [
        q('Which property holds multiple widgets?', ['child', 'children', 'widgets', 'items'], 1,
            'Row, Column, Stack, ListView etc. take children: [...].'),
        q('Are widgets mutable?', ['Yes', 'No — they\'re immutable descriptions', 'Only buttons', 'Only in release mode'], 1,
            'You rebuild new widgets rather than changing old ones.'),
      ],
    ),
    Lesson(
      id: 'basics.app',
      title: 'MaterialApp & Scaffold',
      summary: 'The skeleton every screen is built on.',
      minutes: 7,
      sections: [
        code(r'''
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false, // hide DEBUG ribbon
      theme: ThemeData(colorSchemeSeed: Colors.teal),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Hi!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
'''),
        bullets([
          '`MaterialApp` — wraps the whole app: theme, navigation, localization. Usually used **once**, at the top.',
          '`Scaffold` — one per **screen**. Provides slots: `appBar`, `body`, `floatingActionButton`, `drawer`, `bottomNavigationBar`, `bottomSheet`.',
          '`SafeArea` — keeps content away from notches and the status bar (Scaffold\'s body under an AppBar is already safe at the top).',
        ]),
        demo('scaffold', caption: 'A mini Scaffold with all its slots'),
        tip('For an iOS-looking app use `CupertinoApp` and `CupertinoPageScaffold` — but most apps use Material and still look great on iPhone.'),
      ],
      quiz: [
        q('How many Scaffolds per screen, typically?', ['None', 'One', 'One per widget', 'Exactly two'], 1, 'Each page usually has its own Scaffold.'),
        q('Which Scaffold slot holds the main content?', ['appBar', 'body', 'drawer', 'child'], 1, 'The body is the main content area.'),
      ],
    ),
    Lesson(
      id: 'basics.stateless',
      title: 'StatelessWidget',
      summary: 'Widgets that only depend on their inputs.',
      minutes: 7,
      sections: [
        p('A **StatelessWidget** never changes by itself. It just shows what it\'s given (its **properties**). Give it different inputs → it looks different.'),
        code(r'''
class Greeting extends StatelessWidget {
  const Greeting({super.key, required this.name, this.color = Colors.blue});

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Hello, $name!',
      style: TextStyle(fontSize: 24, color: color),
    );
  }
}

// Using it:
const Greeting(name: 'Ada')
const Greeting(name: 'Linus', color: Colors.red)
'''),
        bullets([
          '`extends StatelessWidget` — inherit the widget behaviour.',
          '`final` fields — widget inputs are always final.',
          '`const` constructor — allows Flutter to reuse it without rebuilding (faster).',
          '`build()` — returns the widget tree. Flutter calls it whenever needed.',
          '`super.key` — forwards an optional key to the parent class (see the Keys lesson).',
        ]),
        demo('stateless', caption: 'Change the inputs → the same widget looks different'),
        tip('Making your own widgets is the #1 way to keep code clean. If a `build` method gets longer than ~60 lines, extract parts into smaller widgets.'),
      ],
      quiz: [
        q('When does a StatelessWidget change what it shows?', ['On its own, with setState', 'Only when its parent rebuilds it with new inputs', 'Never', 'Every frame'], 1,
            'Stateless widgets depend only on constructor inputs.'),
      ],
    ),
    Lesson(
      id: 'basics.stateful',
      title: 'StatefulWidget & setState',
      summary: 'Widgets that remember and change over time.',
      minutes: 10,
      sections: [
        p('**State** is data that can change while the app runs: a counter, whether a checkbox is ticked, text typed by the user. A **StatefulWidget** keeps this data in a separate **State** object that survives rebuilds.'),
        code(r'''
class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _count = 0; // the state

  void _increment() {
    setState(() {
      _count++; // change the data INSIDE setState
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('You tapped $_count times'),
        ElevatedButton(onPressed: _increment, child: const Text('Tap me')),
      ],
    );
  }
}
'''),
        demo('counter'),
        h('What does setState do?'),
        steps([
          'You change a variable inside `setState(() { ... })`.',
          'Flutter marks this widget as "dirty" (needs rebuilding).',
          'On the next frame Flutter calls `build()` again with the new value.',
          'Flutter compares old and new widgets and updates only what changed on screen.',
        ]),
        warn('Changing a variable **without** `setState` updates the data but **not the screen**. This is the most common beginner bug!'),
        demo('setstate_bug', caption: 'See the bug: with vs without setState'),
        h('Stateless or Stateful?'),
        bullets([
          'Does it hold data that changes while visible (and nobody else needs it)? → **Stateful**.',
          'Otherwise → **Stateless**. Start stateless; switch when needed.',
        ]),
        tip('VS Code shortcut: type `stful` or `stless` and press Enter to generate the whole class.'),
      ],
      quiz: [
        q('Why are there two classes in a StatefulWidget?', [
          'Dart requires it',
          'The widget is immutable; the State object keeps mutable data across rebuilds',
          'For speed only',
          'One for iOS, one for Android'], 1, 'Widgets are rebuilt often; State persists.'),
        q('What happens if you change a field without setState?', ['Screen updates', 'App crashes', 'Data changes but the UI doesn\'t update', 'Hot reload runs'], 2,
            'setState tells Flutter to rebuild.'),
      ],
    ),
    Lesson(
      id: 'basics.lifecycle',
      title: 'Widget Lifecycle',
      summary: 'initState, didUpdateWidget, dispose and friends.',
      minutes: 9,
      sections: [
        p('A State object goes through a **lifecycle**. Flutter calls special methods at each stage so you can set things up and clean them up.'),
        code(r'''
class _ClockState extends State<Clock> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState(); // always first
    // Runs ONCE when the widget is inserted. Start timers, controllers,
    // listeners, load data here.
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void didUpdateWidget(Clock oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The parent rebuilt us with new properties. Compare & react.
  }

  @override
  void dispose() {
    // Runs ONCE when removed. Clean up to avoid memory leaks!
    _timer.cancel();
    super.dispose(); // always last
  }

  @override
  Widget build(BuildContext context) => Text('$_now');
}
'''),
        steps([
          '`createState()` — Flutter creates the State object.',
          '`initState()` — one-time setup.',
          '`didChangeDependencies()` — an inherited widget it uses (like Theme) changed.',
          '`build()` — called many times.',
          '`didUpdateWidget()` — parent passed new properties.',
          '`dispose()` — permanent removal: cancel timers, dispose controllers.',
        ]),
        demo('lifecycle', caption: 'Watch the lifecycle log as you add/remove/update the child'),
        warn('Never call `setState` after `dispose`. If an async task finishes later, check `if (!mounted) return;` first.'),
      ],
      quiz: [
        q('Where should you start a timer or create a controller?', ['build()', 'initState()', 'dispose()', 'main()'], 1,
            'initState runs once at the beginning.'),
        q('Where should you cancel timers and dispose controllers?', ['initState()', 'build()', 'dispose()', 'setState()'], 2,
            'dispose cleans up resources.'),
      ],
    ),
    Lesson(
      id: 'basics.context',
      title: 'BuildContext',
      summary: 'A widget\'s location in the tree, and how .of(context) works.',
      minutes: 7,
      sections: [
        p('Every `build` method receives a **BuildContext**. It tells a widget **where it is** in the tree. You use it to look **up** the tree and find things provided by ancestors.'),
        code(r'''
@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);              // nearest Theme
  final size = MediaQuery.sizeOf(context);      // screen size
  final nav = Navigator.of(context);            // to change pages
  final messenger = ScaffoldMessenger.of(context); // snackbars

  return Text(
    'Width: ${size.width.toStringAsFixed(0)}',
    style: theme.textTheme.headlineSmall,
  );
}
'''),
        analogy('BuildContext is your home address. "Find the nearest hospital" (`Theme.of(context)`) gives different answers depending on where you live in the tree.'),
        warn('A common error: calling `Scaffold.of(context)` with the context of the widget that **creates** the Scaffold. That context is *above* the Scaffold, so it can\'t find it. Fix: wrap the child in a `Builder` or extract a new widget.'),
        code(r'''
Scaffold(
  body: Builder(
    // This new context is BELOW the Scaffold ✅
    builder: (innerContext) => ElevatedButton(
      onPressed: () => Scaffold.of(innerContext).openDrawer(),
      child: const Text('Open drawer'),
    ),
  ),
)
'''),
        demo('context', caption: 'Values read via context'),
      ],
      quiz: [
        q('What does Theme.of(context) do?', ['Creates a theme', 'Finds the nearest Theme above this widget', 'Changes the theme', 'Deletes the theme'], 1,
            '.of(context) looks up the tree.'),
      ],
    ),
    Lesson(
      id: 'basics.const_keys',
      title: 'const & Keys',
      summary: 'Performance with const; keeping state with keys.',
      minutes: 9,
      sections: [
        h('const widgets'),
        p('Marking a widget `const` tells Flutter: "this will never change". Flutter creates it once and **skips rebuilding** it. It\'s free performance.'),
        code(r'''
// ✅ Good: these never change
const Text('Title')
const SizedBox(height: 16)
const Icon(Icons.star)

// Can't be const: depends on a runtime value
Text('Hello $name')
'''),
        tip('The linter shows a blue squiggle "Prefer const…" — accept the quick fix (Cmd/Ctrl + .) to add const.'),
        h('Keys'),
        p('When widgets of the **same type** move around in a list (reordering, deleting), Flutter may get confused about which State belongs to which item. A **Key** gives each widget a stable identity.'),
        code(r'''
ListView(
  children: [
    for (final todo in todos)
      TodoTile(key: ValueKey(todo.id), todo: todo),
  ],
)
'''),
        demo('keys', caption: 'Swap the boxes — watch the colours (state) with and without keys'),
        bullets([
          '`ValueKey(id)` — based on a unique value. Most common.',
          '`ObjectKey(obj)` — based on object identity.',
          '`UniqueKey()` — new every time (forces a fresh State).',
          '`GlobalKey` — access a widget\'s state from anywhere (e.g. `Form` validation). Use sparingly.',
        ]),
        note('You only need keys when stateful widgets of the same type are added, removed or reordered in a collection.'),
      ],
      quiz: [
        q('Why use const constructors?', ['Required by Dart', 'Flutter can reuse them and skip rebuilds', 'To make them private', 'For dark mode'], 1,
            'const widgets are canonicalized and not rebuilt.'),
        q('When do you need Keys?', ['Always', 'When reordering/removing stateful widgets of the same type', 'For Text widgets', 'Never'], 1,
            'Keys preserve state identity across list changes.'),
      ],
    ),
  ],
);
