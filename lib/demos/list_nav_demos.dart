import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'controls.dart';

// ---------------------------------------------------------------- listview_builder
class ListViewBuilderDemo extends StatefulWidget {
  const ListViewBuilderDemo({super.key});
  @override
  State<ListViewBuilderDemo> createState() => _ListViewBuilderDemoState();
}

class _ListViewBuilderDemoState extends State<ListViewBuilderDemo> {
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 260,
        child: ListView.separated(
          controller: _scroll,
          itemCount: 10000,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) => ListTile(
            dense: true,
            leading: CircleAvatar(radius: 16, child: Text('${index + 1}', style: const TextStyle(fontSize: 11))),
            title: Text('Item #$index'),
            subtitle: const Text('Built only when visible'),
          ),
        ),
      ),
      Wrap(alignment: WrapAlignment.center, children: [
        TextButton.icon(
          onPressed: () => _scroll.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeOut),
          icon: const Icon(Icons.vertical_align_top),
          label: const Text('Top'),
        ),
        TextButton.icon(
          onPressed: () => _scroll.jumpTo(_scroll.position.maxScrollExtent),
          icon: const Icon(Icons.vertical_align_bottom),
          label: const Text('Jump to #9999'),
        ),
      ]),
    ]);
  }
}

// ---------------------------------------------------------------- gridview
class GridViewDemo extends StatefulWidget {
  const GridViewDemo({super.key});
  @override
  State<GridViewDemo> createState() => _GridViewDemoState();
}

class _GridViewDemoState extends State<GridViewDemo> {
  double _cols = 3;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 250,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _cols.round(),
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
          ),
          itemCount: 60,
          itemBuilder: (context, i) => Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: demoColors[i % demoColors.length].withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('$i', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
      LabeledSlider(
          label: 'columns', value: _cols, min: 1, max: 6, divisions: 5, onChanged: (v) => setState(() => _cols = v)),
    ]);
  }
}

// ---------------------------------------------------------------- slivers
class SliversDemo extends StatelessWidget {
  const SliversDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CustomScrollView(slivers: [
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Gallery'),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF00B4DB), Color(0xFF0083B0)]),
                ),
                child: const Icon(Icons.photo_library, size: 60, color: Colors.white54),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(6),
            sliver: SliverGrid.count(
              crossAxisCount: 3,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              children: [
                for (var i = 0; i < 9; i++)
                  Container(color: demoColors[i % demoColors.length], child: const Icon(Icons.image, color: Colors.white)),
              ],
            ),
          ),
          SliverList.builder(
            itemCount: 15,
            itemBuilder: (context, i) => ListTile(dense: true, title: Text('SliverList row $i')),
          ),
          const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.all(16), child: Center(child: Text('The end 👋')))),
        ]),
      ),
    );
  }
}

// ---------------------------------------------------------------- pageview
class PageViewDemo extends StatefulWidget {
  const PageViewDemo({super.key});
  @override
  State<PageViewDemo> createState() => _PageViewDemoState();
}

class _PageViewDemoState extends State<PageViewDemo> {
  final _controller = PageController();
  int _page = 0;
  static const _pages = [
    (Icons.school, 'Learn', 'Short lessons from basics to advanced.', Color(0xFF1E88E5)),
    (Icons.touch_app, 'Play', 'Interactive demos for every widget.', Color(0xFF8E24AA)),
    (Icons.rocket_launch, 'Build', 'Ship your own apps to iOS and Android.', Color(0xFF43A047)),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 200,
        child: PageView(
          controller: _controller,
          onPageChanged: (i) => setState(() => _page = i),
          children: [
            for (final (icon, title, text, color) in _pages)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(icon, size: 56, color: Colors.white),
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
                  ),
                ]),
              ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        for (var i = 0; i < _pages.length; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.all(3),
            width: i == _page ? 22 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == _page ? Theme.of(context).colorScheme.primary : Colors.grey,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ]),
      TextButton(
        onPressed: () => _page == _pages.length - 1
            ? _controller.animateToPage(0, duration: const Duration(milliseconds: 400), curve: Curves.easeOut)
            : _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut),
        child: Text(_page == _pages.length - 1 ? 'Start over' : 'Next →'),
      ),
    ]);
  }
}

// ---------------------------------------------------------------- refresh
class RefreshDemo extends StatefulWidget {
  const RefreshDemo({super.key});
  @override
  State<RefreshDemo> createState() => _RefreshDemoState();
}

class _RefreshDemoState extends State<RefreshDemo> {
  final _items = <String>['Message 3', 'Message 2', 'Message 1'];
  int _n = 3;

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _items.insert(0, 'Message ${++_n} (new!)'));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('⬇ Pull down to refresh', textAlign: TextAlign.center),
            ),
            for (final i in _items) ListTile(dense: true, leading: const Icon(Icons.mail_outline), title: Text(i)),
          ],
        ),
      ),
    );
  }
}

// ================================================================ NAVIGATION

// ---------------------------------------------------------------- nav_push
class NavPushDemo extends StatelessWidget {
  const NavPushDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      FilledButton.icon(
        icon: const Icon(Icons.open_in_new),
        label: const Text('Navigator.push(DetailsPage)'),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const _DetailsPage()),
        ),
      ),
      const SizedBox(height: 8),
      OutlinedButton.icon(
        icon: const Icon(Icons.phone_iphone),
        label: const Text('Push with CupertinoPageRoute'),
        onPressed: () => Navigator.of(context).push(
          CupertinoPageRoute(builder: (_) => const _DetailsPage(ios: true)),
        ),
      ),
    ]);
  }
}

class _DetailsPage extends StatelessWidget {
  const _DetailsPage({this.ios = false});
  final bool ios;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details Page')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.layers, size: 72),
            const SizedBox(height: 12),
            Text(
              'This page was pushed on top of the lesson.\n'
              '${ios ? 'Swipe from the left edge to go back (iOS style), ' : ''}'
              'Tap the back arrow, or the button below.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Navigator.pop()')),
          ]),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- nav_result
class NavResultDemo extends StatefulWidget {
  const NavResultDemo({super.key});
  @override
  State<NavResultDemo> createState() => _NavResultDemoState();
}

class _NavResultDemoState extends State<NavResultDemo> {
  Color? _picked;
  String _note = 'No colour yet';

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 60,
        decoration: BoxDecoration(
          color: _picked ?? Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(_note),
      ),
      const SizedBox(height: 8),
      FilledButton(
        onPressed: () async {
          final color = await Navigator.of(context).push<Color>(
            MaterialPageRoute(builder: (_) => const _ColorPickerPage()),
          );
          setState(() {
            if (color != null) _picked = color;
            _note = color == null ? 'Returned null (pressed back)' : 'Got a colour back!';
          });
        },
        child: const Text('Pick a colour →'),
      ),
    ]);
  }
}

class _ColorPickerPage extends StatelessWidget {
  const _ColorPickerPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose a colour')),
      body: GridView.count(
        crossAxisCount: 3,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: [
          for (final c in demoColors)
            InkWell(
              onTap: () => Navigator.of(context).pop(c),
              borderRadius: BorderRadius.circular(16),
              child: Ink(decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(16))),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- drawer
class DrawerDemo extends StatefulWidget {
  const DrawerDemo({super.key});
  @override
  State<DrawerDemo> createState() => _DrawerDemoState();
}

class _DrawerDemoState extends State<DrawerDemo> {
  String _page = 'Inbox';

  @override
  Widget build(BuildContext context) {
    final pages = {'Inbox': Icons.inbox, 'Starred': Icons.star, 'Sent': Icons.send, 'Trash': Icons.delete};
    return SizedBox(
      height: 320,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Scaffold(
          appBar: AppBar(
            title: Text(_page),
            actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
          ),
          drawer: Builder(builder: (context) {
            return Drawer(
              width: 220,
              child: ListView(padding: EdgeInsets.zero, children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer),
                  child: const Align(alignment: Alignment.bottomLeft, child: Text('Mail', style: TextStyle(fontSize: 22))),
                ),
                for (final e in pages.entries)
                  ListTile(
                    leading: Icon(e.value),
                    title: Text(e.key),
                    selected: e.key == _page,
                    onTap: () {
                      setState(() => _page = e.key);
                      Navigator.pop(context);
                    },
                  ),
              ]),
            );
          }),
          body: Center(child: Icon(pages[_page], size: 64, color: Colors.grey)),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- navbar
class NavBarDemo extends StatefulWidget {
  const NavBarDemo({super.key});
  @override
  State<NavBarDemo> createState() => _NavBarDemoState();
}

class _NavBarDemoState extends State<NavBarDemo> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Scaffold(
          body: IndexedStack(index: _index, children: const [
            _TabCounter(label: 'Home', icon: Icons.home),
            _TabCounter(label: 'Search', icon: Icons.search),
            _TabCounter(label: 'Profile', icon: Icons.person),
          ]),
          bottomNavigationBar: NavigationBar(
            height: 64,
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
              NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabCounter extends StatefulWidget {
  const _TabCounter({required this.label, required this.icon});
  final String label;
  final IconData icon;
  @override
  State<_TabCounter> createState() => _TabCounterState();
}

class _TabCounterState extends State<_TabCounter> {
  int _taps = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(widget.icon, size: 48),
        Text('${widget.label} — taps: $_taps'),
        TextButton(onPressed: () => setState(() => _taps++), child: const Text('Tap')),
        const Text('Switch tabs: IndexedStack keeps the count!', style: TextStyle(fontSize: 12)),
      ]),
    );
  }
}

// ---------------------------------------------------------------- tabs
class TabsDemo extends StatelessWidget {
  const TabsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SizedBox(
        height: 220,
        child: Column(children: [
          const TabBar(tabs: [
            Tab(icon: Icon(Icons.fiber_new), text: 'New'),
            Tab(icon: Icon(Icons.local_fire_department), text: 'Popular'),
            Tab(icon: Icon(Icons.sell), text: 'Sale'),
          ]),
          Expanded(
            child: TabBarView(children: [
              for (final (t, c) in [('New arrivals', demoColors[0]), ('Trending now', demoColors[3]), ('50% off', demoColors[1])])
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: c.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                  alignment: Alignment.center,
                  child: Text(t, style: TextStyle(fontSize: 20, color: c, fontWeight: FontWeight.bold)),
                ),
            ]),
          ),
        ]),
      ),
    );
  }
}

// ---------------------------------------------------------------- dialogs
class DialogsDemo extends StatefulWidget {
  const DialogsDemo({super.key});
  @override
  State<DialogsDemo> createState() => _DialogsDemoState();
}

class _DialogsDemoState extends State<DialogsDemo> {
  String _result = 'Results appear here';

  Future<void> _alert() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.delete_outline),
        title: const Text('Delete photo?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    setState(() => _result = 'AlertDialog returned: $ok');
  }

  Future<void> _sheet() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          for (final (icon, label) in [(Icons.share, 'Share'), (Icons.link, 'Copy link'), (Icons.edit, 'Edit')])
            ListTile(leading: Icon(icon), title: Text(label), onTap: () => Navigator.pop(context, label)),
        ]),
      ),
    );
    setState(() => _result = 'Bottom sheet returned: $choice');
  }

  Future<void> _simple() async {
    final lang = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Pick a language'),
        children: [
          for (final l in ['Dart', 'Kotlin', 'Swift'])
            SimpleDialogOption(onPressed: () => Navigator.pop(context, l), child: Text(l)),
        ],
      ),
    );
    setState(() => _result = 'SimpleDialog returned: $lang');
  }

  Future<void> _cupertino() async {
    final ok = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Allow notifications?'),
        content: const Text('iOS-style alert'),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.pop(context, false), child: const Text('Don\'t allow')),
          CupertinoDialogAction(isDefaultAction: true, onPressed: () => Navigator.pop(context, true), child: const Text('Allow')),
        ],
      ),
    );
    setState(() => _result = 'CupertinoAlertDialog returned: $ok');
  }

  void _snack() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: const Text('Message archived'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(label: 'UNDO', onPressed: () => setState(() => _result = 'SnackBar UNDO tapped')),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center, children: [
        FilledButton.tonal(onPressed: _alert, child: const Text('AlertDialog')),
        FilledButton.tonal(onPressed: _sheet, child: const Text('Bottom sheet')),
        FilledButton.tonal(onPressed: _simple, child: const Text('SimpleDialog')),
        FilledButton.tonal(onPressed: _cupertino, child: const Text('Cupertino alert')),
        FilledButton.tonal(onPressed: _snack, child: const Text('SnackBar')),
      ]),
      const SizedBox(height: 10),
      CodeHint(_result),
    ]);
  }
}
