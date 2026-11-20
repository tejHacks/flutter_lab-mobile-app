import 'package:flutter/material.dart';

import '../../models/lesson.dart';
import '../dsl.dart';

final layout = LearningModule(
  id: 'layout',
  title: 'Layout',
  description: 'Position anything: constraints, Container, Row, Column, Expanded, Stack and more.',
  level: Level.beginner,
  icon: Icons.dashboard_rounded,
  color: const Color(0xFFF4511E),
  lessons: [
    Lesson(
      id: 'layout.constraints',
      title: 'The Golden Rule of Layout',
      summary: 'Constraints go down. Sizes go up. Parent sets position.',
      minutes: 8,
      sections: [
        p('Every layout in Flutter follows one rule. Learn it and 90% of layout confusion disappears:'),
        CalloutSection(CalloutKind.note,
            '**Constraints go down. Sizes go up. Parent sets position.**'),
        steps([
          'A parent tells its child: "you can be between **min** and **max** width/height" (the **constraints**).',
          'The child picks its own **size** within those limits and reports it back up.',
          'The parent decides **where** to place the child.',
        ]),
        analogy('A parent says: "You may spend between \$0 and \$100." The child decides to spend \$40 and reports back. The parent then decides which shelf to put the purchase on. The child can never spend \$200 — it must respect the limit.'),
        h('Tight vs loose constraints'),
        bullets([
          '**Tight**: min == max. The child has no choice. The screen gives the root widget tight constraints — that\'s why a `Container(width: 100)` at the root fills the whole screen anyway!',
          '**Loose**: min is 0. The child can be smaller. `Center` loosens constraints, so `Center(child: Container(width: 100))` really is 100 wide.',
        ]),
        demo('constraints', caption: 'Same Container, different parents'),
        tip('When something has the "wrong" size, ask: **what constraints did its parent give it?** Wrap with `LayoutBuilder` or use the DevTools Layout Explorer to see them.'),
      ],
      quiz: [
        q('Who decides a widget\'s position?', ['The widget itself', 'Its parent', 'The theme', 'MaterialApp'], 1,
            'Parents position their children.'),
        q('Why does Container(width: 100) fill the screen when it\'s the root?', [
          'Bug in Flutter',
          'The screen gives tight constraints, which override the requested width',
          'Width is in percent',
          'Containers ignore width'], 1, 'Tight constraints force the size.'),
      ],
    ),
    Lesson(
      id: 'layout.container',
      title: 'Container, Padding & SizedBox',
      summary: 'Boxes, spacing, colours and borders.',
      minutes: 9,
      sections: [
        p('`Container` is a Swiss-army-knife box: size, padding, margin, colour, border, rounded corners, shadow.'),
        code(r'''
Container(
  width: 200,
  height: 120,
  margin: const EdgeInsets.all(16),        // space OUTSIDE
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // INSIDE
  alignment: Alignment.center,
  decoration: BoxDecoration(
    color: Colors.indigo,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.white, width: 2),
    boxShadow: const [BoxShadow(blurRadius: 12, color: Colors.black26)],
  ),
  child: const Text('Hello', style: TextStyle(color: Colors.white)),
)
'''),
        demo('container', caption: 'Container playground'),
        h('EdgeInsets cheatsheet'),
        bullets([
          '`EdgeInsets.all(16)` — same on all sides.',
          '`EdgeInsets.symmetric(horizontal: 16, vertical: 8)`',
          '`EdgeInsets.only(left: 8, top: 4)`',
          '`EdgeInsets.fromLTRB(8, 4, 8, 0)`',
        ]),
        h('Lighter alternatives'),
        code(r'''
const Padding(
  padding: EdgeInsets.all(16),
  child: Text('Just padding'),
)

const SizedBox(height: 24)            // a gap in a Column
const SizedBox(width: 100, height: 50, child: Text('Fixed size'))
const SizedBox.expand()               // as big as allowed
'''),
        warn('`color:` and `decoration:` can\'t both be set on a Container. Put the colour **inside** the BoxDecoration.'),
        tip('Use `SizedBox` for spacing and `Padding` for padding. They\'re lighter than Container and can be `const`.'),
      ],
      quiz: [
        q('Margin vs padding?', ['Same thing', 'Margin is outside the box, padding is inside', 'Padding is outside', 'Margin only for text'], 1,
            'Margin = outside spacing, padding = inside spacing.'),
        q('Best widget for a 16px vertical gap in a Column?', ['Container(height: 16)', 'SizedBox(height: 16)', 'Padding()', 'Spacer()'], 1,
            'SizedBox is the lightweight, const-able choice.'),
      ],
    ),
    Lesson(
      id: 'layout.rowcol',
      title: 'Row & Column',
      summary: 'Lay children horizontally or vertically; main and cross axis.',
      minutes: 12,
      sections: [
        p('`Row` places children **left→right**. `Column` places them **top→bottom**. These are the most-used layout widgets in Flutter.'),
        code(r'''
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: const [
    Icon(Icons.star),
    Text('4.8'),
    Text('(1,024 reviews)'),
  ],
)
'''),
        h('Main axis vs cross axis'),
        bullets([
          '**Main axis** = the direction children are laid out. Row: horizontal. Column: vertical.',
          '**Cross axis** = the perpendicular direction.',
          '`mainAxisAlignment`: start, end, center, spaceBetween, spaceAround, spaceEvenly.',
          '`crossAxisAlignment`: start, end, center, stretch, baseline.',
          '`mainAxisSize`: `max` (take all space, default) or `min` (shrink to fit children).',
          '`spacing`: a gap between every child, e.g. `spacing: 12`.',
        ]),
        demo('rowcol', caption: 'Row/Column playground — change the settings'),
        tip('Can\'t remember? **Main** axis = the way the widget\'s name points. A Row is a row of seats (horizontal); a Column is a pillar (vertical).'),
      ],
      quiz: [
        q('What is the main axis of a Column?', ['Horizontal', 'Vertical', 'Diagonal', 'Depends on screen'], 1, 'Columns lay out vertically.'),
        q('How do you centre children horizontally in a Row?', [
          'crossAxisAlignment: center', 'mainAxisAlignment: MainAxisAlignment.center', 'alignment: center', 'Center()'], 1,
            'Horizontal is the Row\'s main axis.'),
        q('Which spreads children with equal gaps, none at the edges?', ['spaceAround', 'spaceEvenly', 'spaceBetween', 'center'], 2,
            'spaceBetween puts gaps only between children.'),
      ],
    ),
    Lesson(
      id: 'layout.expanded',
      title: 'Expanded, Flexible & Spacer',
      summary: 'Share the remaining space between children.',
      minutes: 8,
      sections: [
        p('Inside a Row or Column, wrap a child in `Expanded` to make it **fill the remaining space**. With several Expanded children, `flex` sets their share.'),
        code(r'''
Row(
  children: [
    Expanded(flex: 2, child: Container(color: Colors.red, height: 50)),
    Expanded(flex: 1, child: Container(color: Colors.green, height: 50)),
    const Spacer(),  // empty Expanded
    Container(width: 40, height: 50, color: Colors.blue), // fixed
  ],
)
'''),
        demo('expanded', caption: 'Change the flex values'),
        bullets([
          '`Expanded` — child **must** fill its share.',
          '`Flexible` — child **may** use up to its share but can be smaller (`fit: FlexFit.loose`).',
          '`Spacer` — empty space that takes a share; great for pushing things apart.',
        ]),
        warn('`Expanded` only works as a **direct child** of Row, Column or Flex. Anywhere else you get "Incorrect use of ParentDataWidget".'),
        tip('Long text inside a Row overflowing? Wrap the Text in `Expanded` so it wraps to the next line instead.'),
      ],
      quiz: [
        q('Two Expanded children with flex 1 and 3 share space how?', ['50/50', '25%/75%', '1px/3px', '33%/66%'], 1,
            'Space is divided in proportion to flex.'),
        q('Where can Expanded be used?', ['Anywhere', 'Directly inside Row/Column/Flex', 'Inside Container', 'Inside Text'], 1,
            'Expanded needs a Flex parent.'),
      ],
    ),
    Lesson(
      id: 'layout.stack',
      title: 'Stack & Positioned',
      summary: 'Layer widgets on top of each other.',
      minutes: 8,
      sections: [
        p('`Stack` places children **on top of each other** — the first child at the bottom. Use it for badges, text over images, floating buttons.'),
        code(r'''
Stack(
  clipBehavior: Clip.none,
  children: [
    Container(width: 200, height: 120, color: Colors.blueGrey), // bottom
    const Positioned(
      top: 8,
      right: 8,
      child: Icon(Icons.favorite, color: Colors.red),
    ),
    const Positioned(
      left: 0, right: 0, bottom: 0,
      child: Text('Caption', textAlign: TextAlign.center),
    ),
  ],
)
'''),
        demo('stack', caption: 'Move the badge with the sliders'),
        bullets([
          '`Positioned(top:, left:, right:, bottom:, width:, height:)` — exact placement inside the Stack.',
          '`Positioned.fill()` — cover the whole Stack.',
          '`alignment:` on Stack — where non-positioned children go (default top-left).',
          '`Align` inside a Stack — position by alignment instead of pixels.',
        ]),
      ],
      quiz: [
        q('In a Stack, which child is drawn on top?', ['The first', 'The last', 'The biggest', 'Random'], 1,
            'Children are painted in order; the last is on top.'),
      ],
    ),
    Lesson(
      id: 'layout.align',
      title: 'Center, Align, AspectRatio & FittedBox',
      summary: 'Fine positioning and sizing helpers.',
      minutes: 7,
      sections: [
        code(r'''
const Center(child: Text('Middle'))

const Align(
  alignment: Alignment.bottomRight,   // or Alignment(0.5, -1)
  child: Text('Corner'),
)

AspectRatio(
  aspectRatio: 16 / 9,                // width / height
  child: Container(color: Colors.black),
)

const FittedBox(                       // shrinks child to fit
  child: Text('Very very long headline'),
)

FractionallySizedBox(
  widthFactor: 0.5,                    // 50% of parent width
  child: Container(height: 20, color: Colors.amber),
)
'''),
        demo('align', caption: 'Drag around the Alignment(x, y) grid'),
        note('`Alignment(x, y)` uses a coordinate system from **-1 to 1**: (-1,-1) is top-left, (0,0) centre, (1,1) bottom-right.'),
      ],
      quiz: [
        q('Alignment(0, 0) is…', ['Top-left', 'Center', 'Bottom-right', 'Invalid'], 1, '(0,0) is the centre.'),
        q('Which widget keeps a 16:9 shape?', ['FittedBox', 'AspectRatio', 'SizedBox', 'Center'], 1, 'AspectRatio enforces width/height ratio.'),
      ],
    ),
    Lesson(
      id: 'layout.wrap',
      title: 'Wrap',
      summary: 'Like a Row that flows onto new lines.',
      minutes: 5,
      sections: [
        p('A Row overflows when children don\'t fit. `Wrap` moves them to the next line instead — perfect for tags and chips.'),
        code(r'''
Wrap(
  spacing: 8,      // gap between items
  runSpacing: 8,   // gap between lines
  children: [
    for (final tag in ['Dart', 'Flutter', 'iOS', 'Android', 'Web'])
      Chip(label: Text(tag)),
  ],
)
'''),
        demo('wrap', caption: 'Add chips — watch them wrap'),
      ],
      quiz: [
        q('What does Wrap do when children don\'t fit?', ['Overflow error', 'Moves them onto a new line', 'Shrinks them', 'Hides them'], 1,
            'Wrap flows children onto new runs.'),
      ],
    ),
    Lesson(
      id: 'layout.overflow',
      title: 'Fixing Overflow Errors',
      summary: 'The yellow-and-black stripes, and how to fix them.',
      minutes: 7,
      sections: [
        p('Seen yellow and black stripes with "A RenderFlex overflowed by 42 pixels"? It means children asked for more space than the Row/Column has. Every Flutter developer meets this — here\'s how to fix it.'),
        demo('overflow', caption: 'Break it, then fix it'),
        h('Common fixes'),
        bullets([
          'Text too long in a Row → wrap the Text in `Expanded` (or `Flexible`), optionally with `overflow: TextOverflow.ellipsis`.',
          'Column too tall (e.g. keyboard opened) → wrap the content in `SingleChildScrollView`.',
          'Many chips/buttons in a Row → use `Wrap` instead.',
          'Image too big → give it a size, or use `BoxFit.cover` inside a sized box.',
        ]),
        h('"Vertical viewport was given unbounded height"'),
        p('This appears when you put a `ListView` inside a `Column`. The ListView wants infinite height; the Column offers infinite height → conflict. Fix: wrap the ListView in `Expanded`.'),
        code(r'''
Column(
  children: [
    const Text('Header'),
    Expanded(            // ✅ gives the ListView a bounded height
      child: ListView(children: items),
    ),
  ],
)
'''),
      ],
      quiz: [
        q('A long Text in a Row overflows. Best fix?', ['Make font smaller', 'Wrap it in Expanded', 'Use Stack', 'Ignore it'], 1,
            'Expanded constrains the text width so it wraps or ellipsizes.'),
        q('ListView inside Column throws unbounded height. Fix?', ['Wrap ListView in Expanded', 'Use Row', 'Add const', 'Use Container'], 0,
            'Expanded gives the list a finite height.'),
      ],
    ),
  ],
);
