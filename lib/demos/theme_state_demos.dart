import 'package:flutter/material.dart';

import 'controls.dart';

// ---------------------------------------------------------------- theme_seed
class ThemeSeedDemo extends StatefulWidget {
  const ThemeSeedDemo({super.key});
  @override
  State<ThemeSeedDemo> createState() => _ThemeSeedDemoState();
}

class _ThemeSeedDemoState extends State<ThemeSeedDemo> {
  static const _seeds = [
    Colors.teal,
    Colors.indigo,
    Colors.pink,
    Colors.orange,
    Colors.green,
    Colors.brown,
  ];
  Color _seed = Colors.teal;
  bool _dark = false;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seed,
        brightness: _dark ? Brightness.dark : Brightness.light,
      ),
    );
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Wrap(
                runSpacing: 8,
                children: [
                  for (final s in _seeds)
                    GestureDetector(
                      onTap: () => setState(() => _seed = s),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: s,
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 3,
                            color: s == _seed
                                ? Theme.of(context).colorScheme.onSurface
                                : Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => setState(() => _dark = !_dark),
              icon: Icon(_dark ? Icons.dark_mode : Icons.light_mode),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Theme(
          data: theme,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final (name, bg, fg) in [
                      ('primary', cs.primary, cs.onPrimary),
                      (
                        'primaryContainer',
                        cs.primaryContainer,
                        cs.onPrimaryContainer,
                      ),
                      ('secondary', cs.secondary, cs.onSecondary),
                      (
                        'secondaryContainer',
                        cs.secondaryContainer,
                        cs.onSecondaryContainer,
                      ),
                      ('tertiary', cs.tertiary, cs.onTertiary),
                      (
                        'surfaceContainer',
                        cs.surfaceContainerHighest,
                        cs.onSurface,
                      ),
                      ('error', cs.error, cs.onError),
                    ])
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          name,
                          style: TextStyle(color: fg, fontSize: 11.5),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    FilledButton(onPressed: () {}, child: const Text('Filled')),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Outlined'),
                    ),
                    Switch(value: true, onChanged: (_) {}),
                  ],
                ),
                const Card(
                  child: ListTile(
                    leading: Icon(Icons.palette),
                    title: Text('Card in this theme'),
                  ),
                ),
              ],
            ),
          ),
        ),
        CodeHint(
          'ColorScheme.fromSeed(seedColor: ..., brightness: Brightness.${_dark ? 'dark' : 'light'})',
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------- dark_mode
class DarkModeDemo extends StatelessWidget {
  const DarkModeDemo({super.key});

  Widget _preview(Brightness b) {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: b,
      ),
    );
    return Theme(
      data: theme,
      child: Builder(
        builder: (context) {
          final cs = Theme.of(context).colorScheme;
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  b == Brightness.light ? 'Light' : 'Dark',
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'primaryContainer',
                    style: TextStyle(
                      color: cs.onPrimaryContainer,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                FilledButton(onPressed: () {}, child: const Text('Button')),
                Text(
                  'Same code, two themes',
                  style: TextStyle(color: cs.onSurfaceVariant, fontSize: 11.5),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _preview(Brightness.light)),
        const SizedBox(width: 8),
        Expanded(child: _preview(Brightness.dark)),
      ],
    );
  }
}

// ---------------------------------------------------------------- decoration
class DecorationDemo extends StatefulWidget {
  const DecorationDemo({super.key});
  @override
  State<DecorationDemo> createState() => _DecorationDemoState();
}

class _DecorationDemoState extends State<DecorationDemo> {
  double _radius = 24, _blur = 20, _border = 0;
  String _gradient = 'linear';
  bool _circle = false;

  Gradient? get _g => switch (_gradient) {
    'linear' => const LinearGradient(
      colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'radial' => const RadialGradient(
      colors: [Color(0xFFFFD452), Color(0xFFFF5E62)],
    ),
    'sweep' => const SweepGradient(
      colors: [
        Colors.red,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.red,
      ],
    ),
    _ => null,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 170,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: _circle ? 130 : 220,
              height: 130,
              decoration: BoxDecoration(
                color: _g == null ? Colors.teal : null,
                gradient: _g,
                shape: _circle ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: _circle ? null : BorderRadius.circular(_radius),
                border: _border > 0
                    ? Border.all(color: Colors.white, width: _border)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: _blur,
                    offset: Offset(0, _blur / 2),
                  ),
                ],
              ),
            ),
          ),
        ),
        ChoiceRow<String>(
          label: 'gradient',
          values: const ['none', 'linear', 'radial', 'sweep'],
          selected: _gradient,
          onSelected: (v) => setState(() => _gradient = v),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('shape: BoxShape.circle'),
          value: _circle,
          onChanged: (v) => setState(() => _circle = v),
        ),
        if (!_circle)
          LabeledSlider(
            label: 'radius',
            value: _radius,
            min: 0,
            max: 65,
            onChanged: (v) => setState(() => _radius = v),
          ),
        LabeledSlider(
          label: 'shadow blur',
          value: _blur,
          min: 0,
          max: 40,
          onChanged: (v) => setState(() => _blur = v),
        ),
        LabeledSlider(
          label: 'border',
          value: _border,
          min: 0,
          max: 8,
          onChanged: (v) => setState(() => _border = v),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------- responsive
class ResponsiveDemo extends StatefulWidget {
  const ResponsiveDemo({super.key});
  @override
  State<ResponsiveDemo> createState() => _ResponsiveDemoState();
}

class _ResponsiveDemoState extends State<ResponsiveDemo> {
  double _fraction = 1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, outer) {
        final width = outer.maxWidth * _fraction;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width,
              height: 170,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: LayoutBuilder(
                builder: (context, c) {
                  final wide = c.maxWidth > 260;
                  final list = ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      for (var i = 1; i <= 4; i++)
                        ListTile(
                          dense: true,
                          title: Text('Email $i'),
                          selected: i == 1,
                        ),
                    ],
                  );
                  final detail = Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    alignment: Alignment.center,
                    child: const Text('Email 1 details'),
                  );
                  return wide
                      ? Row(
                          children: [
                            SizedBox(width: c.maxWidth * 0.4, child: list),
                            Expanded(child: detail),
                          ],
                        )
                      : list;
                },
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'maxWidth: ${(width - 4).round()} → ${(width - 4) > 260 ? 'two-pane layout' : 'one column'}',
            ),
            Slider(
              value: _fraction,
              min: 0.4,
              max: 1,
              onChanged: (v) => setState(() => _fraction = v),
            ),
          ],
        );
      },
    );
  }
}

// ================================================================ STATE

// ---------------------------------------------------------------- lifting
class LiftingDemo extends StatefulWidget {
  const LiftingDemo({super.key});
  @override
  State<LiftingDemo> createState() => _LiftingDemoState();
}

class _LiftingDemoState extends State<LiftingDemo> {
  int _likes = 0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: cs.primary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Parent — owns _likes = $_likes',
            style: TextStyle(color: cs.primary, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _LikeCounter(likes: _likes)),
              const SizedBox(width: 8),
              Expanded(
                child: _LikeButton(onLike: () => setState(() => _likes++)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            '↓ value flows down   ·   ↑ event flows up',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _LikeCounter extends StatelessWidget {
  const _LikeCounter({required this.likes});
  final int likes;
  @override
  Widget build(BuildContext context) => Container(
    height: 80,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text('LikeCounter\n❤️ $likes', textAlign: TextAlign.center),
  );
}

class _LikeButton extends StatelessWidget {
  const _LikeButton({required this.onLike});
  final VoidCallback onLike;
  @override
  Widget build(BuildContext context) => Container(
    height: 80,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('LikeButton'),
        IconButton.filled(onPressed: onLike, icon: const Icon(Icons.thumb_up)),
      ],
    ),
  );
}

// ---------------------------------------------------------------- value_notifier
class ValueNotifierDemo extends StatefulWidget {
  const ValueNotifierDemo({super.key});
  @override
  State<ValueNotifierDemo> createState() => _ValueNotifierDemoState();
}

class _ValueNotifierDemoState extends State<ValueNotifierDemo> {
  final _counter = ValueNotifier<int>(0);
  int _parentBuilds = 0;

  @override
  void dispose() {
    _counter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _parentBuilds++;
    return Column(
      children: [
        ValueListenableBuilder<int>(
          valueListenable: _counter,
          builder: (context, value, _) => Text(
            'Count: $value',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () => _counter.value++,
              child: const Text('counter.value++'),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () => _counter.value = 0,
              child: const Text('Reset'),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Parent build() ran $_parentBuilds time(s) — only the Text rebuilds!',
          style: const TextStyle(fontSize: 12.5),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------- cart
class CartModel extends ChangeNotifier {
  final List<String> _items = [];
  List<String> get items => List.unmodifiable(_items);
  int get count => _items.length;

  void add(String item) {
    _items.add(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

class CartDemo extends StatefulWidget {
  const CartDemo({super.key});
  @override
  State<CartDemo> createState() => _CartDemoState();
}

class _CartDemoState extends State<CartDemo> {
  final _cart = CartModel();
  static const _products = [
    ('🍎', 'Apple'),
    ('🍌', 'Banana'),
    ('🥑', 'Avocado'),
    ('🍍', 'Pineapple'),
  ];

  @override
  void dispose() {
    _cart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Text(
              'Shop',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            // Widget 1 listening to the cart
            ListenableBuilder(
              listenable: _cart,
              builder: (context, _) => Badge(
                label: Text('${_cart.count}'),
                isLabelVisible: _cart.count > 0,
                child: const Icon(Icons.shopping_cart, size: 28),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        for (final (emoji, name) in _products)
          ListTile(
            dense: true,
            leading: Text(emoji, style: const TextStyle(fontSize: 22)),
            title: Text(name),
            trailing: IconButton.filledTonal(
              onPressed: () => _cart.add(name),
              icon: const Icon(Icons.add),
            ),
          ),
        // Widget 2 listening to the same cart
        ListenableBuilder(
          listenable: _cart,
          builder: (context, _) => Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _cart.count == 0
                        ? 'Cart is empty'
                        : 'In cart: ${_cart.items.join(', ')}',
                  ),
                ),
                if (_cart.count > 0)
                  TextButton(
                    onPressed: _cart.clear,
                    child: const Text('Clear'),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
