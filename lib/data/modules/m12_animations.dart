import 'package:flutter/material.dart';

import '../../models/lesson.dart';
import '../dsl.dart';

final animations = LearningModule(
  id: 'anim',
  title: 'Animations',
  description: 'Implicit animations, AnimationController, Hero transitions and animated lists.',
  level: Level.intermediate,
  icon: Icons.animation_rounded,
  color: const Color(0xFFFFA000),
  lessons: [
    Lesson(
      id: 'anim.implicit',
      title: 'Implicit Animations',
      summary: 'Change a value — Flutter animates it for you.',
      minutes: 9,
      sections: [
        p('The easiest animations: use an `Animated…` version of a widget. When its properties change (via setState), it **smoothly animates** from the old value to the new one.'),
        code(r'''
AnimatedContainer(
  duration: const Duration(milliseconds: 400),
  curve: Curves.easeInOut,
  width: _big ? 200 : 100,
  height: _big ? 200 : 100,
  decoration: BoxDecoration(
    color: _big ? Colors.orange : Colors.blue,
    borderRadius: BorderRadius.circular(_big ? 40 : 8),
  ),
)

// Toggle it:
setState(() => _big = !_big);
'''),
        demo('implicit', caption: 'Tap to animate'),
        h('The Animated family'),
        bullets([
          '`AnimatedContainer` — size, colour, padding, radius…',
          '`AnimatedOpacity` — fade in/out.',
          '`AnimatedAlign`, `AnimatedPositioned`, `AnimatedPadding`',
          '`AnimatedScale`, `AnimatedRotation`, `AnimatedSlide`',
          '`AnimatedDefaultTextStyle`, `AnimatedCrossFade`',
          '`TweenAnimationBuilder` — animate any value you like.',
        ]),
        h('Curves'),
        demo('curves', caption: 'Compare curves'),
      ],
      quiz: [
        q('How do you trigger an implicit animation?', ['Call controller.forward()', 'Change its property with setState', 'Use a Timer', 'Hot reload'], 1,
            'Implicit animations run when properties change.'),
      ],
    ),
    Lesson(
      id: 'anim.explicit',
      title: 'AnimationController (Explicit)',
      summary: 'Full control: loop, reverse, pause and chain animations.',
      minutes: 12,
      sections: [
        code(r'''
class _SpinnerState extends State<Spinner>
    with SingleTickerProviderStateMixin {  // provides the "ticker" (frame clock)
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // loop forever
  }

  @override
  void dispose() {
    _controller.dispose(); // always!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,  // 0.0 → 1.0 = one full turn
      child: const FlutterLogo(size: 80),
    );
  }
}
'''),
        demo('explicit', caption: 'Control the animation'),
        bullets([
          'An `AnimationController` produces values from **0.0 to 1.0** over a duration.',
          'Methods: `forward()`, `reverse()`, `repeat()`, `stop()`, `reset()`.',
          '`Tween(begin: 50, end: 200).animate(controller)` maps 0→1 to any range.',
          '`CurvedAnimation(parent: controller, curve: Curves.bounceOut)` adds easing.',
          'Ready-made transitions: `FadeTransition`, `ScaleTransition`, `SlideTransition`, `RotationTransition`.',
          '`AnimatedBuilder` — build anything from the animation value.',
        ]),
        tip('Rule: use **implicit** animations when a value just changes from A to B. Use **explicit** when you need looping, reversing, or precise control.'),
      ],
      quiz: [
        q('What does an AnimationController produce by default?', ['0 to 100', '0.0 to 1.0', 'Colours', 'Widgets'], 1, 'It animates from lowerBound 0.0 to upperBound 1.0.'),
        q('Which mixin provides vsync for one controller?', ['TickerMixin', 'SingleTickerProviderStateMixin', 'AnimationMixin', 'StateMixin'], 1,
            'SingleTickerProviderStateMixin supplies a Ticker.'),
      ],
    ),
    Lesson(
      id: 'anim.hero',
      title: 'Hero & Page Transitions',
      summary: 'Fly a widget from one screen to the next.',
      minutes: 7,
      sections: [
        code(r'''
// Screen A
Hero(
  tag: 'avatar-42',       // same tag on both screens
  child: CircleAvatar(backgroundImage: NetworkImage(url)),
)

// Screen B
Hero(
  tag: 'avatar-42',
  child: Image.network(url),
)
'''),
        demo('hero', caption: 'Tap a tile'),
        h('Custom page transitions'),
        code(r'''
Navigator.of(context).push(PageRouteBuilder(
  transitionDuration: const Duration(milliseconds: 500),
  pageBuilder: (_, _, _) => const DetailsPage(),
  transitionsBuilder: (_, animation, _, child) =>
      FadeTransition(opacity: animation, child: child),
));
'''),
      ],
      quiz: [
        q('What links two Hero widgets?', ['Same key', 'Same tag', 'Same child', 'Same size'], 1, 'Heroes with the same tag animate between routes.'),
      ],
    ),
    Lesson(
      id: 'anim.switcher',
      title: 'AnimatedSwitcher & AnimatedList',
      summary: 'Animate widgets being replaced, added or removed.',
      minutes: 8,
      sections: [
        code(r'''
AnimatedSwitcher(
  duration: const Duration(milliseconds: 300),
  transitionBuilder: (child, animation) =>
      ScaleTransition(scale: animation, child: child),
  child: Text(
    '$_count',
    key: ValueKey(_count), // a new key = a new widget to animate in
    style: const TextStyle(fontSize: 48),
  ),
)
'''),
        demo('switcher', caption: 'Tap + and −'),
        h('AnimatedList'),
        code(r'''
final _listKey = GlobalKey<AnimatedListState>();

AnimatedList(
  key: _listKey,
  initialItemCount: _items.length,
  itemBuilder: (context, index, animation) => SizeTransition(
    sizeFactor: animation,
    child: ListTile(title: Text(_items[index])),
  ),
)

// Insert with animation
_items.insert(0, 'New');
_listKey.currentState!.insertItem(0);
'''),
        demo('animated_list'),
        tip('Explore Rive and Lottie packages for designer-made animations (animated icons, illustrations).'),
      ],
      quiz: [
        q('Why does AnimatedSwitcher need a key on its child?', ['For styling', 'To know the child changed and animate', 'Performance only', 'It doesn\'t'], 1,
            'Same type + no key looks like the same widget, so no animation.'),
      ],
    ),
  ],
);
