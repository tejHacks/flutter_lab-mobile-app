import 'dart:math';

import 'package:flutter/material.dart';

import 'controls.dart';

// ---------------------------------------------------------------- hot_reload
class HotReloadDemo extends StatefulWidget {
  const HotReloadDemo({super.key});
  @override
  State<HotReloadDemo> createState() => _HotReloadDemoState();
}

class _HotReloadDemoState extends State<HotReloadDemo> {
  int _count = 0;
  int _codeVersion = 0;
  String _message = 'Tap + a few times, then try reload vs restart.';

  @override
  Widget build(BuildContext context) {
    final color = demoColors[_codeVersion % demoColors.length];
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text('Count: $_count',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
              ),
              IconButton.filled(
                onPressed: () => setState(() => _count++),
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: FilledButton.tonalIcon(
                onPressed: () => setState(() {
                  _codeVersion++;
                  _message = '⚡ Hot reload: the colour (code) changed, count kept at $_count.';
                }),
                icon: const Icon(Icons.bolt),
                label: const Text('Hot reload'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => setState(() {
                  _codeVersion++;
                  _count = 0;
                  _message = '🔄 Hot restart: code changed AND state reset to 0.';
                }),
                icon: const Icon(Icons.restart_alt),
                label: const Text('Hot restart'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(_message, textAlign: TextAlign.center),
      ],
    );
  }
}

// ---------------------------------------------------------------- widget_tree
class WidgetTreeDemo extends StatefulWidget {
  const WidgetTreeDemo({super.key});
  @override
  State<WidgetTreeDemo> createState() => _WidgetTreeDemoState();
}

class _WidgetTreeDemoState extends State<WidgetTreeDemo> {
  static const _nodes = [
    (0, 'Scaffold', 'The page skeleton.'),
    (1, 'AppBar', 'The top bar (Scaffold.appBar).'),
    (2, 'Text "Profile"', 'The AppBar title.'),
    (1, 'Column', 'Scaffold.body — stacks children vertically.'),
    (2, 'Icon', 'First child of the Column.'),
    (2, 'Text "Ada Lovelace"', 'Second child of the Column.'),
    (2, 'ElevatedButton', 'Third child. Has onPressed and a child.'),
    (3, 'Text "Follow"', 'The button\'s label (its child).'),
  ];
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < _nodes.length; i++)
          Padding(
            padding: EdgeInsets.only(left: _nodes[i].$1 * 22.0, bottom: 4),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => setState(() => _selected = i),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: i == _selected ? scheme.primaryContainer : scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(children: [
                  if (_nodes[i].$1 > 0)
                    Icon(Icons.subdirectory_arrow_right, size: 16, color: scheme.outline),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(_nodes[i].$2,
                        style: const TextStyle(fontFamily: 'monospace', fontFamilyFallback: ['Menlo'])),
                  ),
                ]),
              ),
            ),
          ),
        const SizedBox(height: 6),
        Text('👉 ${_nodes[_selected].$3}', style: TextStyle(color: scheme.primary)),
      ],
    );
  }
}

// ---------------------------------------------------------------- scaffold
class ScaffoldDemo extends StatelessWidget {
  const ScaffoldDemo({super.key});

  Widget _tag(String s) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)),
        child: Text(s, style: const TextStyle(color: Colors.white, fontSize: 11)),
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 380,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Scaffold(
          appBar: AppBar(title: Row(children: [const Flexible(child: Text('Home ')), _tag('appBar')])),
          drawer: const Drawer(child: Center(child: Text('drawer'))),
          body: Center(child: _tag('body')),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            tooltip: 'floatingActionButton',
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: NavigationBar(
            height: 64,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: 'bottomNavigationBar'),
              NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- stateless
class Greeting extends StatelessWidget {
  const Greeting({super.key, required this.name, this.color = Colors.blue});
  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) =>
      Text('Hello, $name!', style: TextStyle(fontSize: 24, color: color, fontWeight: FontWeight.w700));
}

class StatelessDemo extends StatefulWidget {
  const StatelessDemo({super.key});
  @override
  State<StatelessDemo> createState() => _StatelessDemoState();
}

class _StatelessDemoState extends State<StatelessDemo> {
  String _name = 'Ada';
  Color _color = demoColors.first;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Greeting(name: _name, color: _color)),
        ChoiceRow<String>(
          label: 'name:',
          values: const ['Ada', 'Linus', 'Grace', 'You'],
          selected: _name,
          onSelected: (v) => setState(() => _name = v),
        ),
        ChoiceRow<Color>(
          label: 'color:',
          values: demoColors,
          selected: _color,
          nameOf: (c) => '●',
          onSelected: (v) => setState(() => _color = v),
        ),
        CodeHint("Greeting(name: '$_name', color: ...)"),
      ],
    );
  }
}

// ---------------------------------------------------------------- counter
class CounterDemo extends StatefulWidget {
  const CounterDemo({super.key});
  @override
  State<CounterDemo> createState() => _CounterDemoState();
}

class _CounterDemoState extends State<CounterDemo> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('You tapped $_count times', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () => setState(() => _count++), child: const Text('Tap me')),
            const SizedBox(width: 8),
            TextButton(onPressed: () => setState(() => _count = 0), child: const Text('Reset')),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------- setstate_bug
class SetStateBugDemo extends StatefulWidget {
  const SetStateBugDemo({super.key});
  @override
  State<SetStateBugDemo> createState() => _SetStateBugDemoState();
}

class _SetStateBugDemoState extends State<SetStateBugDemo> {
  int _without = 0;
  int _with = 0;

  Widget _panel(String title, int value, VoidCallback onTap, Color color) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: [
            Text(title, textAlign: TextAlign.center, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            Text('$value', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
            FilledButton(
              onPressed: onTap,
              style: FilledButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
              child: const Text('+1'),
            ),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          _panel('WITHOUT setState', _without, () => _without++, Colors.red),
          const SizedBox(width: 10),
          _panel('WITH setState', _with, () => setState(() => _with++), Colors.green),
        ]),
        const SizedBox(height: 8),
        const Text(
          'Tap the red +1 a few times: nothing changes. Then tap the green one — the red value suddenly '
          'jumps! The data was changing all along, but the screen only updates on a rebuild.',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------- lifecycle
class LifecycleDemo extends StatefulWidget {
  const LifecycleDemo({super.key});
  @override
  State<LifecycleDemo> createState() => _LifecycleDemoState();
}

class _LifecycleDemoState extends State<LifecycleDemo> {
  final _log = <String>[];
  final _version = ValueNotifier(0);
  bool _scheduled = false;
  bool _show = true;
  int _prop = 1;

  void _add(String entry) {
    _log.add(entry);
    if (_log.length > 30) _log.removeAt(0);
    if (_scheduled) return;
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      if (mounted) _version.value++; // the demo itself may be gone by now
    });
  }

  @override
  void dispose() {
    _version.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(spacing: 8, runSpacing: 8, children: [
          FilledButton.tonal(
            onPressed: () => setState(() => _show = !_show),
            child: Text(_show ? 'Remove child' : 'Add child'),
          ),
          OutlinedButton(
            onPressed: _show ? () => setState(() => _prop++) : null,
            child: const Text('Pass new property'),
          ),
          TextButton(
            onPressed: () {
              _log.clear();
              _version.value++;
            },
            child: const Text('Clear log'),
          ),
        ]),
        const SizedBox(height: 8),
        SizedBox(
          height: 60,
          child: Center(child: _show ? _LifecycleChild(value: _prop, log: _add) : const Text('(no child)')),
        ),
        ValueListenableBuilder(
          valueListenable: _version,
          builder: (context, _, _) => Container(
            height: 150,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1117),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView(
              reverse: true,
              children: [
                for (final l in _log.reversed)
                  Text(l,
                      style: const TextStyle(
                          color: Color(0xFFA5E075),
                          fontFamily: 'monospace',
                          fontFamilyFallback: ['Menlo'],
                          fontSize: 12.5)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LifecycleChild extends StatefulWidget {
  const _LifecycleChild({required this.value, required this.log});
  final int value;
  final void Function(String) log;
  @override
  State<_LifecycleChild> createState() => _LifecycleChildState();
}

class _LifecycleChildState extends State<_LifecycleChild> {
  @override
  void initState() {
    super.initState();
    widget.log('initState()');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.log('didChangeDependencies()');
  }

  @override
  void didUpdateWidget(covariant _LifecycleChild oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.log('didUpdateWidget(old: ${oldWidget.value}, new: ${widget.value})');
  }

  @override
  void dispose() {
    widget.log('dispose()');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.log('build()');
    return Chip(label: Text('Child widget — value: ${widget.value}'));
  }
}

// ---------------------------------------------------------------- context
class ContextDemo extends StatelessWidget {
  const ContextDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final rows = [
      ('Theme.of(context).brightness', theme.brightness.name),
      ('Theme.of(context).colorScheme.primary', '■'),
      ('MediaQuery.sizeOf(context)', '${size.width.round()} × ${size.height.round()}'),
      ('MediaQuery.textScalerOf(context)', MediaQuery.textScalerOf(context).scale(1).toStringAsFixed(2)),
      ('Theme.of(context).platform', theme.platform.name),
      ('MediaQuery.paddingOf(context).top', MediaQuery.paddingOf(context).top.toStringAsFixed(0)),
    ];
    return Column(children: [
      for (final (k, v) in rows)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(children: [
            Expanded(
              child: Text(k,
                  style: const TextStyle(fontFamily: 'monospace', fontFamilyFallback: ['Menlo'], fontSize: 12.5)),
            ),
            Text(v,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: v == '■' ? theme.colorScheme.primary : null,
                    fontSize: v == '■' ? 22 : null)),
          ]),
        ),
      const Text('Rotate the device or change text size in Settings — these update.',
          style: TextStyle(fontSize: 12.5)),
    ]);
  }
}

// ---------------------------------------------------------------- keys
class KeysDemo extends StatefulWidget {
  const KeysDemo({super.key});
  @override
  State<KeysDemo> createState() => _KeysDemoState();
}

class _KeysDemoState extends State<KeysDemo> {
  List<String> _labels = ['A', 'B'];
  bool _useKeys = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (final l in _labels) _ColorTile(key: _useKeys ? ValueKey(l) : null, label: l),
        ],
      ),
      const SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        FilledButton.icon(
          onPressed: () => setState(() => _labels = _labels.reversed.toList()),
          icon: const Icon(Icons.swap_horiz),
          label: const Text('Swap'),
        ),
        const SizedBox(width: 12),
        const Text('Use keys'),
        Switch(value: _useKeys, onChanged: (v) => setState(() => _useKeys = v)),
      ]),
      Text(
        _useKeys
            ? '✅ With ValueKey: each colour (state) travels with its letter.'
            : '❌ No keys: letters swap but colours stay put — the State got matched by position!',
        textAlign: TextAlign.center,
      ),
    ]);
  }
}

class _ColorTile extends StatefulWidget {
  const _ColorTile({super.key, required this.label});
  final String label;
  @override
  State<_ColorTile> createState() => _ColorTileState();
}

class _ColorTileState extends State<_ColorTile> {
  // Each State picks a colour once — this is the "state" we want to keep.
  late final Color _color = widget.label == 'A' ? demoColors[0] : demoColors[1 + Random().nextInt(4)];

  @override
  Widget build(BuildContext context) => DemoBox(widget.label, color: _color, width: 90, height: 90);
}
