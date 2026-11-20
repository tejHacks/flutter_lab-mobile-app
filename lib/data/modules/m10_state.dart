import 'package:flutter/material.dart';

import '../../models/lesson.dart';
import '../dsl.dart';

final stateManagement = LearningModule(
  id: 'state',
  title: 'State Management',
  description: 'Share data between widgets: lifting state, InheritedWidget, ChangeNotifier, Provider, Riverpod and Bloc.',
  level: Level.intermediate,
  icon: Icons.sync_alt_rounded,
  color: const Color(0xFF6D4C41),
  lessons: [
    Lesson(
      id: 'state.what',
      title: 'What is State?',
      summary: 'Ephemeral (local) state vs app (shared) state.',
      minutes: 6,
      sections: [
        p('**State** is any data that can change and affects what\'s on screen. "State management" is simply: **where do I keep that data, and how do widgets that need it get it and update it?**'),
        h('Two kinds of state'),
        bullets([
          '**Ephemeral (local) state** — only one widget cares: the current tab, an animation, whether a password is visible. → Use `StatefulWidget` + `setState`.',
          '**App (shared) state** — many screens care: the logged-in user, the shopping cart, settings, downloaded data. → Use one of the patterns in this module.',
        ]),
        analogy('Local state is a note in your pocket. App state is a whiteboard in the office — everyone can read it, and when someone updates it, everyone sees the change.'),
        tip('Don\'t over-engineer. Many screens only need `setState`. Reach for shared state when you find yourself passing the same data down through 3+ widgets.'),
      ],
      quiz: [
        q('Which is ephemeral (local) state?', ['Logged-in user', 'Shopping cart', 'Selected tab in one screen', 'App settings'], 2,
            'Only one widget cares about the selected tab.'),
      ],
    ),
    Lesson(
      id: 'state.lifting',
      title: 'Lifting State Up',
      summary: 'Share state by moving it to a common parent.',
      minutes: 8,
      sections: [
        p('If two sibling widgets need the same data, move the data **up** to their closest common parent. The parent passes the **value** down and a **callback** to change it.'),
        code(r'''
class _ParentState extends State<Parent> {
  int _likes = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      LikeCounter(likes: _likes),                                // reads
      LikeButton(onLike: () => setState(() => _likes++)),        // writes
    ]);
  }
}

class LikeButton extends StatelessWidget {
  const LikeButton({super.key, required this.onLike});
  final VoidCallback onLike;   // a function with no args

  @override
  Widget build(BuildContext context) =>
      IconButton(onPressed: onLike, icon: const Icon(Icons.thumb_up));
}
'''),
        demo('lifting', caption: 'Two children, one shared state'),
        p('**Data flows down, events flow up.** This is the foundation of every state management approach.'),
        warn('If you pass the same value through many layers of widgets that don\'t use it ("prop drilling"), it\'s time for InheritedWidget / Provider.'),
      ],
      quiz: [
        q('How does a child change state that lives in its parent?', ['It edits the parent\'s field directly', 'The parent passes a callback the child calls', 'Using GlobalKey always', 'It can\'t'], 1,
            'Callbacks let events flow up.'),
      ],
    ),
    Lesson(
      id: 'state.inherited',
      title: 'InheritedWidget',
      summary: 'How Theme.of(context) works under the hood.',
      minutes: 9,
      sections: [
        p('`InheritedWidget` makes data available to **every widget below it** without passing it through constructors. `Theme.of(context)`, `MediaQuery.of(context)` and `Navigator.of(context)` all use it.'),
        code(r'''
class UserScope extends InheritedWidget {
  const UserScope({super.key, required this.userName, required super.child});
  final String userName;

  static UserScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<UserScope>()!;

  @override
  bool updateShouldNotify(UserScope old) => userName != old.userName;
}

// Provide it near the top
UserScope(userName: 'Ada', child: MaterialApp(...))

// Read it anywhere below
Text('Hi ${UserScope.of(context).userName}')
'''),
        p('Widgets that call `dependOnInheritedWidgetOfExactType` are **subscribed**: when the value changes, they rebuild automatically.'),
        note('You rarely write InheritedWidgets yourself — packages like Provider wrap them in a friendlier API. But knowing this explains how all of them work.'),
      ],
      quiz: [
        q('Which built-in uses InheritedWidget?', ['Text', 'Theme.of(context)', 'Container', 'print'], 1, 'Theme is an inherited widget.'),
      ],
    ),
    Lesson(
      id: 'state.notifier',
      title: 'ChangeNotifier & ValueNotifier',
      summary: 'Observable objects built into Flutter.',
      minutes: 11,
      sections: [
        h('ValueNotifier — one observable value'),
        code(r'''
final counter = ValueNotifier<int>(0);

ValueListenableBuilder<int>(
  valueListenable: counter,
  builder: (context, value, child) => Text('Count: $value'),
)

counter.value++; // listeners rebuild automatically — no setState!
'''),
        demo('value_notifier'),
        h('ChangeNotifier — a class with logic'),
        code(r'''
class CartModel extends ChangeNotifier {
  final List<String> _items = [];
  List<String> get items => List.unmodifiable(_items);
  int get count => _items.length;

  void add(String item) {
    _items.add(item);
    notifyListeners(); // tell everyone listening to rebuild
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

final cart = CartModel();

ListenableBuilder(
  listenable: cart,
  builder: (context, child) => Badge(
    label: Text('${cart.count}'),
    child: const Icon(Icons.shopping_cart),
  ),
)
'''),
        demo('cart', caption: 'A shared shopping cart'),
        note('FlutterLab\'s own progress tracking is a `ChangeNotifier` (AppState) shared through an `InheritedNotifier` — check `lib/state/app_state.dart` in this project!'),
        tip('Keep business logic (adding, removing, saving) in the notifier class, not in widgets. Widgets should only display and call methods.'),
      ],
      quiz: [
        q('What does notifyListeners() do?', ['Saves to disk', 'Tells listening widgets to rebuild', 'Shows a notification', 'Disposes the object'], 1,
            'It triggers listeners such as ListenableBuilder.'),
        q('Which widget rebuilds when a ValueNotifier changes?', ['ValueListenableBuilder', 'FutureBuilder', 'StreamBuilder', 'LayoutBuilder'], 0,
            'ValueListenableBuilder listens to a ValueListenable.'),
      ],
    ),
    Lesson(
      id: 'state.packages',
      title: 'Provider, Riverpod & Bloc',
      summary: 'The popular state management packages compared.',
      minutes: 12,
      sections: [
        p('For larger apps, the community uses packages. They all build on the ideas you just learned. Here\'s the same counter in each:'),
        h('Provider — simple and official-recommended starter'),
        sh('flutter pub add provider'),
        code(r'''
// Provide
ChangeNotifierProvider(
  create: (_) => CartModel(),
  child: const MyApp(),
)

// Read & listen (rebuilds on change)
final cart = context.watch<CartModel>();
Text('${cart.count}')

// Call a method (no rebuild)
context.read<CartModel>().add('Apple');
'''),
        h('Riverpod — Provider\'s modern successor'),
        sh('flutter pub add flutter_riverpod'),
        code(r'''
final counterProvider = NotifierProvider<Counter, int>(Counter.new);

class Counter extends Notifier<int> {
  @override
  int build() => 0;
  void increment() => state++;
}

void main() => runApp(const ProviderScope(child: MyApp()));

class CounterText extends ConsumerWidget {
  const CounterText({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return TextButton(
      onPressed: () => ref.read(counterProvider.notifier).increment(),
      child: Text('$count'),
    );
  }
}
'''),
        h('Bloc / Cubit — strict, event-driven, great for big teams'),
        sh('flutter pub add flutter_bloc'),
        code(r'''
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);
  void increment() => emit(state + 1);
}

BlocProvider(create: (_) => CounterCubit(), child: const MyApp())

BlocBuilder<CounterCubit, int>(
  builder: (context, count) => Text('$count'),
)
context.read<CounterCubit>().increment();
'''),
        h('Which should I learn?'),
        bullets([
          '**Learning / small apps**: `setState` + `ChangeNotifier` (+ `provider`).',
          '**Most new apps**: **Riverpod** — testable, safe, no BuildContext needed.',
          '**Large teams, strict architecture**: **Bloc**.',
          'All are fine! The concepts (state, notify, rebuild) transfer between them.',
        ]),
      ],
      quiz: [
        q('In Provider, which call listens and rebuilds on changes?', ['context.read', 'context.watch', 'context.listen', 'Provider.get'], 1,
            'watch subscribes; read does not.'),
        q('In a Cubit, how do you publish a new state?', ['setState', 'notifyListeners', 'emit', 'yield'], 2, 'Cubits call emit(newState).'),
      ],
    ),
  ],
);
