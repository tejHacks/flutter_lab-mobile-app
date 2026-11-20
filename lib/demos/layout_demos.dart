import 'package:flutter/material.dart';

import 'controls.dart';

// ---------------------------------------------------------------- constraints
class ConstraintsDemo extends StatelessWidget {
  const ConstraintsDemo({super.key});

  Widget _case(BuildContext context, String title, String code, Widget child) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 4),
          Container(
            height: 70,
            width: double.infinity,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: child,
          ),
          CodeHint(code),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final box = Container(width: 100, color: Colors.orange, alignment: Alignment.center, child: const Text('width: 100'));
    return Column(children: [
      _case(context, '1. Tight parent: child is FORCED to fill', 'SizedBox.expand(child: Container(width: 100))',
          SizedBox.expand(child: box)),
      _case(context, '2. Center loosens constraints: width respected', 'Center(child: Container(width: 100))',
          Center(child: box)),
      _case(context, '3. Align also loosens', 'Align(alignment: Alignment.centerRight, ...)',
          Align(alignment: Alignment.centerRight, child: box)),
    ]);
  }
}

// ---------------------------------------------------------------- container
class ContainerDemo extends StatefulWidget {
  const ContainerDemo({super.key});
  @override
  State<ContainerDemo> createState() => _ContainerDemoState();
}

class _ContainerDemoState extends State<ContainerDemo> {
  double _padding = 16, _margin = 8, _radius = 12, _border = 0;
  bool _shadow = true;
  Color _color = demoColors[4];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        height: 140,
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.all(_margin),
          padding: EdgeInsets.all(_padding),
          decoration: BoxDecoration(
            color: _color,
            borderRadius: BorderRadius.circular(_radius),
            border: _border > 0 ? Border.all(color: Colors.white, width: _border) : null,
            boxShadow: _shadow
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 14, offset: const Offset(0, 6))]
                : null,
          ),
          child: const Text('Hello', style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ),
      LabeledSlider(label: 'padding', value: _padding, min: 0, max: 40, onChanged: (v) => setState(() => _padding = v)),
      LabeledSlider(label: 'margin', value: _margin, min: 0, max: 30, onChanged: (v) => setState(() => _margin = v)),
      LabeledSlider(label: 'radius', value: _radius, min: 0, max: 50, onChanged: (v) => setState(() => _radius = v)),
      LabeledSlider(label: 'border', value: _border, min: 0, max: 6, onChanged: (v) => setState(() => _border = v)),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('boxShadow'),
        value: _shadow,
        onChanged: (v) => setState(() => _shadow = v),
      ),
      ChoiceRow<Color>(
          label: 'color',
          values: demoColors,
          selected: _color,
          nameOf: (_) => '●',
          onSelected: (c) => setState(() => _color = c)),
      CodeHint('Container(\n'
          '  margin: EdgeInsets.all(${_margin.round()}),\n'
          '  padding: EdgeInsets.all(${_padding.round()}),\n'
          '  decoration: BoxDecoration(\n'
          '    borderRadius: BorderRadius.circular(${_radius.round()}),${_border > 0 ? '\n    border: Border.all(width: ${_border.round()}),' : ''}${_shadow ? '\n    boxShadow: [BoxShadow(...)],' : ''}\n'
          '  ),\n)'),
    ]);
  }
}

// ---------------------------------------------------------------- rowcol
class RowColDemo extends StatefulWidget {
  const RowColDemo({super.key});
  @override
  State<RowColDemo> createState() => _RowColDemoState();
}

class _RowColDemoState extends State<RowColDemo> {
  bool _isRow = true;
  MainAxisAlignment _main = MainAxisAlignment.start;
  CrossAxisAlignment _cross = CrossAxisAlignment.center;
  MainAxisSize _size = MainAxisSize.max;

  @override
  Widget build(BuildContext context) {
    final children = [
      DemoBox('1', color: demoColors[0], width: 44, height: 44),
      DemoBox('2', color: demoColors[1], width: 60, height: 70),
      DemoBox('3', color: demoColors[2], width: 36, height: 30),
    ];
    final flex = _isRow
        ? Row(mainAxisAlignment: _main, crossAxisAlignment: _cross, mainAxisSize: _size, children: children)
        : Column(mainAxisAlignment: _main, crossAxisAlignment: _cross, mainAxisSize: _size, children: children);
    final name = _isRow ? 'Row' : 'Column';
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
        height: 220,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                // Show the actual size of the Row/Column itself
                color: Colors.amber.withValues(alpha: 0.2),
                child: flex,
              ),
            ),
          ),
          Positioned(
            right: 6,
            bottom: 4,
            child: Text(_isRow ? 'main axis →' : 'main axis ↓',
                style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 12)),
          ),
        ]),
      ),
      const Text('Yellow area = the size of the Row/Column itself', style: TextStyle(fontSize: 12)),
      ChoiceRow<bool>(
          label: 'widget',
          values: const [true, false],
          selected: _isRow,
          nameOf: (v) => v ? 'Row' : 'Column',
          onSelected: (v) => setState(() => _isRow = v)),
      ChoiceRow<MainAxisAlignment>(
          label: 'mainAxisAlignment',
          values: MainAxisAlignment.values,
          selected: _main,
          onSelected: (v) => setState(() => _main = v)),
      ChoiceRow<CrossAxisAlignment>(
          label: 'crossAxisAlignment',
          values: const [
            CrossAxisAlignment.start,
            CrossAxisAlignment.center,
            CrossAxisAlignment.end,
            CrossAxisAlignment.stretch,
          ],
          selected: _cross,
          onSelected: (v) => setState(() => _cross = v)),
      ChoiceRow<MainAxisSize>(
          label: 'mainAxisSize',
          values: MainAxisSize.values,
          selected: _size,
          onSelected: (v) => setState(() => _size = v)),
      CodeHint('$name(\n  mainAxisAlignment: MainAxisAlignment.${_main.name},\n'
          '  crossAxisAlignment: CrossAxisAlignment.${_cross.name},\n'
          '  mainAxisSize: MainAxisSize.${_size.name},\n  children: [...],\n)'),
    ]);
  }
}

// ---------------------------------------------------------------- expanded
class ExpandedDemo extends StatefulWidget {
  const ExpandedDemo({super.key});
  @override
  State<ExpandedDemo> createState() => _ExpandedDemoState();
}

class _ExpandedDemoState extends State<ExpandedDemo> {
  final _flex = [1.0, 2.0, 1.0];
  bool _spacer = false;

  @override
  Widget build(BuildContext context) {
    final total = _flex.reduce((a, b) => a + b) + (_spacer ? 1 : 0);
    return Column(children: [
      Row(children: [
        for (var i = 0; i < 3; i++)
          Expanded(
            flex: _flex[i].round(),
            child: Container(
              height: 64,
              margin: const EdgeInsets.all(2),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: demoColors[i], borderRadius: BorderRadius.circular(8)),
              child: Text('flex ${_flex[i].round()}\n${(_flex[i] / total * 100).round()}%',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        if (_spacer) const Spacer(),
        DemoBox('40px', color: Colors.grey, width: 44, height: 64),
      ]),
      for (var i = 0; i < 3; i++)
        LabeledSlider(
          label: 'box ${i + 1} flex',
          value: _flex[i],
          min: 1,
          max: 5,
          divisions: 4,
          onChanged: (v) => setState(() => _flex[i] = v),
        ),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('Add a Spacer() (flex 1)'),
        value: _spacer,
        onChanged: (v) => setState(() => _spacer = v),
      ),
      const Text('The grey box has a fixed width. Expanded children share what\'s left.'),
    ]);
  }
}

// ---------------------------------------------------------------- stack
class StackDemo extends StatefulWidget {
  const StackDemo({super.key});
  @override
  State<StackDemo> createState() => _StackDemoState();
}

class _StackDemoState extends State<StackDemo> {
  double _top = 10, _left = 180;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 160,
        width: 260,
        child: Stack(clipBehavior: Clip.none, children: [
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF355C7D), Color(0xFF6C5B7B)]),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const Positioned(
            left: 16,
            bottom: 14,
            child: Text('Bottom layer (first child)', style: TextStyle(color: Colors.white)),
          ),
          Positioned(
            top: _top,
            left: _left,
            child: const CircleAvatar(
              backgroundColor: Colors.red,
              child: Text('3', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ]),
      ),
      LabeledSlider(label: 'top', value: _top, min: -20, max: 130, onChanged: (v) => setState(() => _top = v)),
      LabeledSlider(label: 'left', value: _left, min: -20, max: 230, onChanged: (v) => setState(() => _left = v)),
      CodeHint('Positioned(top: ${_top.round()}, left: ${_left.round()}, child: CircleAvatar(...))'),
    ]);
  }
}

// ---------------------------------------------------------------- align
class AlignDemo extends StatefulWidget {
  const AlignDemo({super.key});
  @override
  State<AlignDemo> createState() => _AlignDemoState();
}

class _AlignDemoState extends State<AlignDemo> {
  double _x = 0, _y = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 170,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(children: [
          // tap-able 3x3 grid of named alignments
          for (final ax in [-1.0, 0.0, 1.0])
            for (final ay in [-1.0, 0.0, 1.0])
              Align(
                alignment: Alignment(ax, ay),
                child: GestureDetector(
                  onTap: () => setState(() {
                    _x = ax;
                    _y = ay;
                  }),
                  child: Container(
                    width: 28,
                    height: 28,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.outline),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            alignment: Alignment(_x, _y),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: DemoBox('★', color: Colors.deepOrange, width: 28, height: 28),
            ),
          ),
        ]),
      ),
      LabeledSlider(label: 'x', value: _x, min: -1, max: 1, decimals: 1, onChanged: (v) => setState(() => _x = v)),
      LabeledSlider(label: 'y', value: _y, min: -1, max: 1, decimals: 1, onChanged: (v) => setState(() => _y = v)),
      CodeHint('Align(alignment: Alignment(${_x.toStringAsFixed(1)}, ${_y.toStringAsFixed(1)}))'),
    ]);
  }
}

// ---------------------------------------------------------------- wrap
class WrapDemo extends StatefulWidget {
  const WrapDemo({super.key});
  @override
  State<WrapDemo> createState() => _WrapDemoState();
}

class _WrapDemoState extends State<WrapDemo> {
  static const _pool = ['Dart', 'Flutter', 'iOS', 'Android', 'Web', 'Firebase', 'Riverpod', 'Bloc',
    'Animations', 'Widgets', 'Testing', 'Layouts'];
  int _n = 5;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Wrap(spacing: 8, runSpacing: 8, children: [
        for (final t in _pool.take(_n)) Chip(label: Text(t)),
      ]),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        IconButton.outlined(
            onPressed: _n > 1 ? () => setState(() => _n--) : null, icon: const Icon(Icons.remove)),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('$_n chips')),
        IconButton.filled(
            onPressed: _n < _pool.length ? () => setState(() => _n++) : null, icon: const Icon(Icons.add)),
      ]),
    ]);
  }
}

// ---------------------------------------------------------------- overflow
class OverflowDemo extends StatefulWidget {
  const OverflowDemo({super.key});
  @override
  State<OverflowDemo> createState() => _OverflowDemoState();
}

class _OverflowDemoState extends State<OverflowDemo> {
  bool _fixed = false;
  bool _ellipsis = false;

  @override
  Widget build(BuildContext context) {
    const longText = 'This is a very long title that definitely will not fit on a single line of a phone';
    final text = Text(
      longText,
      maxLines: _ellipsis ? 1 : null,
      overflow: _ellipsis ? TextOverflow.ellipsis : null,
      softWrap: true,
    );
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRect(
          child: Row(children: [
            const Icon(Icons.article),
            const SizedBox(width: 8),
            if (_fixed) Expanded(child: text) else text,
          ]),
        ),
      ),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('Wrap Text in Expanded'),
        value: _fixed,
        onChanged: (v) => setState(() => _fixed = v),
      ),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('maxLines: 1 + ellipsis'),
        value: _ellipsis,
        onChanged: (v) => setState(() => _ellipsis = v),
      ),
      Text(_fixed
          ? '✅ Fixed: Expanded limits the Text to the remaining width, so it can wrap.'
          : '❌ Overflow: the Row gives Text unlimited width, so it runs off the edge (in debug mode you\'ll see yellow/black stripes).'),
    ]);
  }
}
