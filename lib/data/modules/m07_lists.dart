import 'package:flutter/material.dart';

import '../../models/lesson.dart';
import '../dsl.dart';

final lists = LearningModule(
  id: 'lists',
  title: 'Lists & Scrolling',
  description: 'ListView, builders, grids, slivers, page views and pull-to-refresh.',
  level: Level.beginner,
  icon: Icons.view_list_rounded,
  color: const Color(0xFF43A047),
  lessons: [
    Lesson(
      id: 'lists.listview',
      title: 'ListView Basics',
      summary: 'Scrollable lists of widgets.',
      minutes: 7,
      sections: [
        p('When content is taller than the screen, it must **scroll**. `ListView` is a scrollable Column.'),
        code(r'''
ListView(
  padding: const EdgeInsets.all(16),
  children: const [
    ListTile(title: Text('Inbox')),
    ListTile(title: Text('Starred')),
    ListTile(title: Text('Sent')),
  ],
)

// Just need a scrollable page (e.g. a form)?
SingleChildScrollView(
  child: Column(children: [ /* ... */ ]),
)

// Horizontal list
SizedBox(
  height: 100,
  child: ListView(
    scrollDirection: Axis.horizontal,
    children: [ /* ... */ ],
  ),
)
'''),
        warn('A plain `ListView(children: [...])` builds **all** children immediately. Fine for ~20 items; for long or unknown lengths use `ListView.builder` (next lesson).'),
      ],
      quiz: [
        q('Which widget makes a single tall Column scrollable?', ['Scrollable', 'SingleChildScrollView', 'Expanded', 'Flexible'], 1,
            'SingleChildScrollView scrolls one child.'),
      ],
    ),
    Lesson(
      id: 'lists.builder',
      title: 'ListView.builder & separated',
      summary: 'Efficient lists with thousands of items.',
      minutes: 9,
      sections: [
        p('`ListView.builder` creates items **lazily** — only the ones visible on screen (plus a few). A list of 10,000 items is as fast as a list of 10.'),
        code(r'''
final items = List.generate(10000, (i) => 'Item #$i');

ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(
      leading: CircleAvatar(child: Text('${index + 1}')),
      title: Text(items[index]),
    );
  },
)

// With dividers between items:
ListView.separated(
  itemCount: items.length,
  separatorBuilder: (context, index) => const Divider(height: 1),
  itemBuilder: (context, index) => ListTile(title: Text(items[index])),
)
'''),
        demo('listview_builder', caption: '10,000 items, built lazily'),
        analogy('`ListView.builder` is like a restaurant cooking food only when it\'s ordered, instead of cooking all 10,000 dishes when it opens.'),
        tip('`itemBuilder` receives an `index`. Use it to get your data: `items[index]`.'),
      ],
      quiz: [
        q('Why use ListView.builder for long lists?', ['Prettier', 'It only builds visible items (lazy)', 'Required by iOS', 'Adds dividers'], 1,
            'Lazy building keeps memory and CPU low.'),
      ],
    ),
    Lesson(
      id: 'lists.grid',
      title: 'GridView',
      summary: 'Two-dimensional scrolling grids.',
      minutes: 7,
      sections: [
        code(r'''
GridView.builder(
  padding: const EdgeInsets.all(12),
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,      // 3 columns
    mainAxisSpacing: 8,
    crossAxisSpacing: 8,
    childAspectRatio: 1,    // square tiles
  ),
  itemCount: 30,
  itemBuilder: (context, i) => Container(color: Colors.teal, child: Text('$i')),
)

// Responsive: as many columns as fit, each max 160px wide
GridView.extent(
  maxCrossAxisExtent: 160,
  children: [ /* ... */ ],
)
'''),
        demo('gridview', caption: 'Change the column count'),
      ],
      quiz: [
        q('What sets the number of columns in GridView.builder?', ['columns:', 'crossAxisCount in the gridDelegate', 'itemCount', 'mainAxisSpacing'], 1,
            'SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: n).'),
      ],
    ),
    Lesson(
      id: 'lists.slivers',
      title: 'Slivers & CustomScrollView',
      summary: 'Collapsing app bars and mixed scrolling content.',
      minutes: 10,
      sections: [
        p('A **sliver** is a piece of a scrollable area. `CustomScrollView` combines slivers so a collapsing header, a grid and a list all scroll **together** as one.'),
        code(r'''
CustomScrollView(
  slivers: [
    const SliverAppBar(
      expandedHeight: 180,
      pinned: true,            // stays visible when collapsed
      flexibleSpace: FlexibleSpaceBar(title: Text('Gallery')),
    ),
    SliverGrid.count(
      crossAxisCount: 3,
      children: [ /* tiles */ ],
    ),
    SliverList.builder(
      itemCount: 20,
      itemBuilder: (context, i) => ListTile(title: Text('Row $i')),
    ),
    const SliverToBoxAdapter(       // any normal widget
      child: Padding(padding: EdgeInsets.all(16), child: Text('The end')),
    ),
  ],
)
'''),
        demo('slivers', caption: 'Scroll inside the box — the header collapses'),
        tip('Rule of thumb: inside `slivers: [...]` everything must be a Sliver. Wrap normal widgets in `SliverToBoxAdapter`.'),
      ],
      quiz: [
        q('How do you put a normal widget inside a CustomScrollView?', ['Directly', 'SliverToBoxAdapter', 'Expanded', 'Container'], 1,
            'SliverToBoxAdapter wraps a box widget as a sliver.'),
      ],
    ),
    Lesson(
      id: 'lists.pageview',
      title: 'PageView, Pull-to-Refresh & ScrollController',
      summary: 'Swipeable pages, refreshing and controlling scroll position.',
      minutes: 9,
      sections: [
        h('PageView — swipe between pages'),
        code(r'''
final _controller = PageController();

PageView(
  controller: _controller,
  onPageChanged: (i) => setState(() => _page = i),
  children: const [OnboardingOne(), OnboardingTwo(), OnboardingThree()],
)

// Go to the next page from a button:
_controller.nextPage(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeOut,
);
'''),
        demo('pageview', caption: 'Swipe like an onboarding screen'),
        h('Pull to refresh'),
        code(r'''
RefreshIndicator(
  onRefresh: () async {
    await loadNewData(); // must return a Future
  },
  child: ListView(children: [ /* ... */ ]),
)
'''),
        demo('refresh', caption: 'Pull down on the list'),
        h('ScrollController'),
        code(r'''
final _scroll = ScrollController();

ListView.builder(controller: _scroll, ...)

// Scroll to top
_scroll.animateTo(0,
    duration: const Duration(milliseconds: 400), curve: Curves.easeOut);

// React to scrolling (e.g. load more at the bottom)
_scroll.addListener(() {
  if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 200) {
    loadMore();
  }
});
'''),
      ],
      quiz: [
        q('What must onRefresh return?', ['void', 'A Future', 'A widget', 'bool'], 1,
            'The spinner stays until the Future completes.'),
      ],
    ),
  ],
);
