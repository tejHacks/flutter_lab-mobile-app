import 'package:flutter/material.dart';

import '../../models/lesson.dart';
import '../dsl.dart';

final navigation = LearningModule(
  id: 'nav',
  title: 'Navigation & Structure',
  description: 'Move between screens, pass data, tabs, drawers, dialogs, bottom sheets and snackbars.',
  level: Level.intermediate,
  icon: Icons.alt_route_rounded,
  color: const Color(0xFF3949AB),
  lessons: [
    Lesson(
      id: 'nav.push',
      title: 'Navigator: push & pop',
      summary: 'Go to a new screen and come back.',
      minutes: 8,
      sections: [
        p('Flutter keeps screens (called **routes**) in a **stack**. `push` puts a new screen on top; `pop` removes it, revealing the one below.'),
        analogy('A stack of plates: you can only add to or take from the top. The back button takes the top plate off.'),
        code(r'''
// Go to DetailsPage
Navigator.of(context).push(
  MaterialPageRoute(builder: (context) => const DetailsPage()),
);

// Go back (the AppBar back arrow does this automatically)
Navigator.of(context).pop();

// Replace the current screen (e.g. after login, no going back)
Navigator.of(context).pushReplacement(
  MaterialPageRoute(builder: (_) => const HomePage()),
);

// Clear everything and go to a screen (e.g. logout)
Navigator.of(context).pushAndRemoveUntil(
  MaterialPageRoute(builder: (_) => const LoginPage()),
  (route) => false,
);
'''),
        demo('nav_push', caption: 'Push a real page'),
        tip('Use `CupertinoPageRoute` for iOS-style slide transitions with swipe-back gesture.'),
      ],
      quiz: [
        q('What does Navigator.pop() do?', ['Opens a new page', 'Removes the top page, going back', 'Closes the app', 'Reloads'], 1,
            'pop removes the current route.'),
        q('After login, which prevents going back to the login page?', ['push', 'pushReplacement', 'pop', 'maybePop'], 1,
            'pushReplacement swaps the current route.'),
      ],
    ),
    Lesson(
      id: 'nav.data',
      title: 'Passing & Returning Data',
      summary: 'Send data to a screen and get a result back.',
      minutes: 8,
      sections: [
        h('Sending data: constructor parameters'),
        code(r'''
class ProductPage extends StatelessWidget {
  const ProductPage({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: Text(product.name)));
}

Navigator.of(context).push(
  MaterialPageRoute(builder: (_) => ProductPage(product: myProduct)),
);
'''),
        h('Returning a result: await push + pop(value)'),
        code(r'''
// Screen A: wait for the result
final color = await Navigator.of(context).push<String>(
  MaterialPageRoute(builder: (_) => const ColorPickerPage()),
);
if (color != null) print('User picked $color');

// Screen B: return a value
Navigator.of(context).pop('blue');
'''),
        demo('nav_result', caption: 'Pick a colour on another screen'),
        note('`push` returns a **Future** that completes when the pushed page pops. The result is `null` if the user pressed back.'),
      ],
      quiz: [
        q('How do you return a value from a page?', ['return value', 'Navigator.pop(context, value)', 'setState', 'Navigator.push(value)'], 1,
            'pop accepts an optional result.'),
      ],
    ),
    Lesson(
      id: 'nav.routes',
      title: 'Named Routes & go_router',
      summary: 'Organising navigation in bigger apps.',
      minutes: 8,
      sections: [
        h('Named routes (built in)'),
        code(r'''
MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => const HomePage(),
    '/settings': (context) => const SettingsPage(),
  },
)

Navigator.of(context).pushNamed('/settings');
'''),
        h('go_router (recommended for real apps)'),
        p('`go_router` is the official package for URL-based navigation, deep links (opening the app from a link) and web support.'),
        sh('flutter pub add go_router'),
        code(r'''
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) =>
          ProductPage(id: state.pathParameters['id']!),
    ),
  ],
);

MaterialApp.router(routerConfig: router);

// Navigate
context.go('/product/42');   // replace the stack with this location
context.push('/product/42'); // push on top
context.pop();
'''),
        tip('Start with `Navigator.push` while learning. Move to go_router when you need deep links, web URLs or many screens.'),
      ],
      quiz: [
        q('Why use go_router?', ['It\'s required', 'URL-based routing, deep links and web support', 'Faster animations', 'Smaller APK'], 1,
            'go_router handles URLs and deep linking well.'),
      ],
    ),
    Lesson(
      id: 'nav.appbar',
      title: 'AppBar & Drawer',
      summary: 'Top bars, actions and side menus.',
      minutes: 7,
      sections: [
        code(r'''
Scaffold(
  appBar: AppBar(
    title: const Text('Inbox'),
    actions: [
      IconButton(icon: const Icon(Icons.search), onPressed: () {}),
      IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
    ],
  ),
  drawer: Drawer(
    child: ListView(
      children: [
        const DrawerHeader(child: Text('Menu')),
        ListTile(
          leading: const Icon(Icons.inbox),
          title: const Text('Inbox'),
          onTap: () => Navigator.pop(context), // close drawer
        ),
      ],
    ),
  ),
  body: ...,
)
'''),
        demo('drawer', caption: 'Tap the ☰ menu icon'),
        note('When a Scaffold has a `drawer`, the AppBar shows a ☰ menu button automatically. A drawer is a route too — `Navigator.pop` closes it.'),
      ],
      quiz: [
        q('Where do AppBar icon buttons go?', ['leading', 'actions', 'title', 'bottom'], 1, 'actions are shown on the right.'),
      ],
    ),
    Lesson(
      id: 'nav.tabs',
      title: 'Bottom Navigation & Tabs',
      summary: 'NavigationBar and TabBar for multi-section apps.',
      minutes: 9,
      sections: [
        h('NavigationBar (bottom)'),
        code(r'''
class _ShellState extends State<Shell> {
  int _index = 0;
  static const _pages = [HomePage(), SearchPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages), // keeps each tab's state
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
'''),
        demo('navbar', caption: 'Bottom navigation'),
        note('FlutterLab itself uses exactly this pattern for its Learn / Widgets / Practice / Me tabs!'),
        h('TabBar (top)'),
        code(r'''
DefaultTabController(
  length: 3,
  child: Scaffold(
    appBar: AppBar(
      title: const Text('Shop'),
      bottom: const TabBar(tabs: [
        Tab(text: 'New'),
        Tab(text: 'Popular'),
        Tab(text: 'Sale'),
      ]),
    ),
    body: const TabBarView(children: [NewTab(), PopularTab(), SaleTab()]),
  ),
)
'''),
        demo('tabs', caption: 'Tap or swipe the tabs'),
      ],
      quiz: [
        q('Which widget keeps the state of all tabs alive?', ['Stack', 'IndexedStack', 'PageView', 'Column'], 1,
            'IndexedStack keeps all children built but shows one.'),
        q('TabBar and TabBarView need what to sync?', ['GlobalKey', 'A TabController (e.g. DefaultTabController)', 'setState', 'Navigator'], 1,
            'DefaultTabController links them.'),
      ],
    ),
    Lesson(
      id: 'nav.dialogs',
      title: 'Dialogs, Bottom Sheets & SnackBars',
      summary: 'Popups and messages.',
      minutes: 9,
      sections: [
        demo('dialogs', caption: 'Try each one'),
        code(r'''
// Alert dialog (returns a value when closed)
final ok = await showDialog<bool>(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Delete photo?'),
    content: const Text('This cannot be undone.'),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
      FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
    ],
  ),
);

// Bottom sheet
showModalBottomSheet(
  context: context,
  showDragHandle: true,
  builder: (context) => const SizedBox(height: 200, child: Center(child: Text('Hi!'))),
);

// SnackBar — a short message at the bottom
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: const Text('Message archived'),
    action: SnackBarAction(label: 'UNDO', onPressed: () {}),
  ),
);
'''),
        tip('Dialogs and sheets are routes, so `Navigator.pop(context, value)` closes them and returns a value.'),
      ],
      quiz: [
        q('How do you show a short message at the bottom?', ['showDialog', 'ScaffoldMessenger.of(context).showSnackBar', 'print', 'Toast()'], 1,
            'SnackBars go through ScaffoldMessenger.'),
      ],
    ),
  ],
);
