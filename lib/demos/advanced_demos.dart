import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'controls.dart';

// ---------------------------------------------------------------- future_builder
class FutureBuilderDemo extends StatefulWidget {
  const FutureBuilderDemo({super.key});
  @override
  State<FutureBuilderDemo> createState() => _FutureBuilderDemoState();
}

class _FutureBuilderDemoState extends State<FutureBuilderDemo> {
  Future<List<String>>? _future;

  Future<List<String>> _fakeFetch(bool fail) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (fail) throw Exception('No internet connection');
    return ['Ada Lovelace', 'Alan Turing', 'Grace Hopper'];
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        Expanded(
          child: FilledButton(
              onPressed: () => setState(() => _future = _fakeFetch(false)), child: const Text('Load ✅')),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
              onPressed: () => setState(() => _future = _fakeFetch(true)), child: const Text('Load ❌')),
        ),
      ]),
      const SizedBox(height: 10),
      SizedBox(
        height: 150,
        child: FutureBuilder<List<String>>(
          future: _future,
          builder: (context, snapshot) {
            final state = snapshot.connectionState;
            Widget body;
            if (state == ConnectionState.none) {
              body = const Center(child: Text('Press a button to start the Future'));
            } else if (state == ConnectionState.waiting) {
              body = const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              body = Center(
                child: Text('⚠️ ${snapshot.error}', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              );
            } else {
              body = ListView(children: [
                for (final n in snapshot.data!) ListTile(dense: true, leading: const Icon(Icons.person), title: Text(n)),
              ]);
            }
            return Column(children: [
              CodeHint('snapshot.connectionState = ${state.name}'
                  '${snapshot.hasError ? '\nsnapshot.hasError = true' : ''}'
                  '${snapshot.hasData ? '\nsnapshot.hasData = true' : ''}'),
              Expanded(child: body),
            ]);
          },
        ),
      ),
    ]);
  }
}

// ---------------------------------------------------------------- stream_builder
class StreamBuilderDemo extends StatefulWidget {
  const StreamBuilderDemo({super.key});
  @override
  State<StreamBuilderDemo> createState() => _StreamBuilderDemoState();
}

class _StreamBuilderDemoState extends State<StreamBuilderDemo> {
  Stream<double>? _stream;
  final _rand = Random();

  Stream<double> _prices() async* {
    var price = 100.0;
    while (true) {
      await Future.delayed(const Duration(milliseconds: 700));
      price += (_rand.nextDouble() - 0.5) * 6;
      yield price;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      StreamBuilder<double>(
        stream: _stream,
        builder: (context, snapshot) {
          final text = _stream == null
              ? 'Stream not started'
              : !snapshot.hasData
                  ? 'Waiting for first value...'
                  : '\$${snapshot.data!.toStringAsFixed(2)}';
          return Container(
            height: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.show_chart),
              const SizedBox(width: 8),
              Flexible(child: Text('FLTR: $text', style: Theme.of(context).textTheme.titleLarge)),
            ]),
          );
        },
      ),
      const SizedBox(height: 8),
      FilledButton.tonal(
        onPressed: () => setState(() => _stream = _stream == null ? _prices() : null),
        child: Text(_stream == null ? 'Start stream' : 'Stop stream'),
      ),
    ]);
  }
}

// ================================================================ ANIMATIONS

// ---------------------------------------------------------------- implicit
class ImplicitDemo extends StatefulWidget {
  const ImplicitDemo({super.key});
  @override
  State<ImplicitDemo> createState() => _ImplicitDemoState();
}

class _ImplicitDemoState extends State<ImplicitDemo> {
  bool _big = false;
  bool _visible = true;
  bool _right = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 210,
        child: Center(
          child: GestureDetector(
            onTap: () => setState(() => _big = !_big),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutBack,
              width: _big ? 200 : 100,
              height: _big ? 200 : 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _big ? Colors.orange : Colors.blue,
                borderRadius: BorderRadius.circular(_big ? 100 : 12),
              ),
              child: const Text('Tap me', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
      const Divider(),
      Row(children: [
        Expanded(
          child: AnimatedOpacity(
            opacity: _visible ? 1 : 0,
            duration: const Duration(milliseconds: 400),
            child: const Text('AnimatedOpacity 👻'),
          ),
        ),
        TextButton(onPressed: () => setState(() => _visible = !_visible), child: const Text('Fade')),
      ]),
      Row(children: [
        Expanded(
          child: AnimatedAlign(
            alignment: _right ? Alignment.centerRight : Alignment.centerLeft,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            child: const Icon(Icons.directions_run, size: 32),
          ),
        ),
        TextButton(onPressed: () => setState(() => _right = !_right), child: const Text('Move')),
      ]),
    ]);
  }
}

// ---------------------------------------------------------------- curves
class CurvesDemo extends StatefulWidget {
  const CurvesDemo({super.key});
  @override
  State<CurvesDemo> createState() => _CurvesDemoState();
}

class _CurvesDemoState extends State<CurvesDemo> {
  static const _curves = {
    'linear': Curves.linear,
    'easeInOut': Curves.easeInOut,
    'easeOutBack': Curves.easeOutBack,
    'bounceOut': Curves.bounceOut,
    'elasticOut': Curves.elasticOut,
    'fastOutSlowIn': Curves.fastOutSlowIn,
  };
  bool _end = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      for (final e in _curves.entries)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(children: [
            SizedBox(width: 104, child: Text(e.key, style: const TextStyle(fontSize: 12.5))),
            Expanded(
              child: Container(
                height: 26,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 1200),
                  curve: e.value,
                  alignment: _end ? Alignment.centerRight : Alignment.centerLeft,
                  child: const CircleAvatar(radius: 13, child: Icon(Icons.circle, size: 10)),
                ),
              ),
            ),
          ]),
        ),
      const SizedBox(height: 6),
      FilledButton.icon(
        onPressed: () => setState(() => _end = !_end),
        icon: const Icon(Icons.play_arrow),
        label: const Text('Play'),
      ),
    ]);
  }
}

// ---------------------------------------------------------------- explicit
class ExplicitDemo extends StatefulWidget {
  const ExplicitDemo({super.key});
  @override
  State<ExplicitDemo> createState() => _ExplicitDemoState();
}

class _ExplicitDemoState extends State<ExplicitDemo> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 2));
  late final Animation<double> _scale =
      Tween(begin: 0.6, end: 1.2).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 140,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          RotationTransition(turns: _controller, child: const FlutterLogo(size: 70)),
          ScaleTransition(scale: _scale, child: const Icon(Icons.favorite, color: Colors.red, size: 70)),
        ]),
      ),
      AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => Column(children: [
          LinearProgressIndicator(value: _controller.value),
          const SizedBox(height: 4),
          Text('controller.value = ${_controller.value.toStringAsFixed(2)}  (${_controller.status.name})',
              style: const TextStyle(fontSize: 12.5)),
        ]),
      ),
      const SizedBox(height: 6),
      Wrap(spacing: 6, runSpacing: 6, alignment: WrapAlignment.center, children: [
        OutlinedButton(onPressed: () => _controller.forward(), child: const Text('forward()')),
        OutlinedButton(onPressed: () => _controller.reverse(), child: const Text('reverse()')),
        OutlinedButton(onPressed: () => _controller.repeat(), child: const Text('repeat()')),
        OutlinedButton(onPressed: () => _controller.repeat(reverse: true), child: const Text('repeat(reverse)')),
        OutlinedButton(onPressed: () => _controller.stop(), child: const Text('stop()')),
        OutlinedButton(onPressed: () => _controller.reset(), child: const Text('reset()')),
      ]),
    ]);
  }
}

// ---------------------------------------------------------------- hero
class HeroDemo extends StatelessWidget {
  const HeroDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      for (var i = 0; i < 3; i++)
        GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => _HeroDetail(index: i))),
          child: Hero(
            tag: 'flutterlab-hero-$i',
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(color: demoColors[i], borderRadius: BorderRadius.circular(16)),
              child: Icon([Icons.landscape, Icons.pets, Icons.local_florist][i], color: Colors.white, size: 40),
            ),
          ),
        ),
    ]);
  }
}

class _HeroDetail extends StatelessWidget {
  const _HeroDetail({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hero detail')),
      body: Column(children: [
        Hero(
          tag: 'flutterlab-hero-$index',
          child: Container(
            height: 280,
            width: double.infinity,
            color: demoColors[index],
            child: Icon([Icons.landscape, Icons.pets, Icons.local_florist][index], color: Colors.white, size: 120),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(24),
          child: Text('The tile flew here from the previous screen. Go back to watch it fly home.',
              textAlign: TextAlign.center),
        ),
      ]),
    );
  }
}

// ---------------------------------------------------------------- switcher
class SwitcherDemo extends StatefulWidget {
  const SwitcherDemo({super.key});
  @override
  State<SwitcherDemo> createState() => _SwitcherDemoState();
}

class _SwitcherDemoState extends State<SwitcherDemo> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      IconButton.outlined(onPressed: () => setState(() => _count--), icon: const Icon(Icons.remove)),
      SizedBox(
        width: 110,
        height: 80,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
            child: Text('$_count', key: ValueKey(_count), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
      IconButton.filled(onPressed: () => setState(() => _count++), icon: const Icon(Icons.add)),
    ]);
  }
}

// ---------------------------------------------------------------- animated_list
class AnimatedListDemo extends StatefulWidget {
  const AnimatedListDemo({super.key});
  @override
  State<AnimatedListDemo> createState() => _AnimatedListDemoState();
}

class _AnimatedListDemoState extends State<AnimatedListDemo> {
  final _key = GlobalKey<AnimatedListState>();
  final _items = <int>[1, 2, 3];
  int _next = 4;

  Widget _tile(int n, Animation<double> animation) => SizeTransition(
        sizeFactor: animation,
        child: FadeTransition(
          opacity: animation,
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 3),
            child: ListTile(
              dense: true,
              leading: CircleAvatar(radius: 14, backgroundColor: demoColors[n % demoColors.length]),
              title: Text('Item $n'),
            ),
          ),
        ),
      );

  void _insert() {
    _items.insert(0, _next);
    _key.currentState!.insertItem(0, duration: const Duration(milliseconds: 350));
    _next++;
  }

  void _remove() {
    if (_items.isEmpty) return;
    final removed = _items.removeAt(0);
    _key.currentState!.removeItem(0, (context, a) => _tile(removed, a), duration: const Duration(milliseconds: 350));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 230,
        child: AnimatedList(
          key: _key,
          initialItemCount: _items.length,
          itemBuilder: (context, i, a) => _tile(_items[i], a),
        ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        FilledButton.icon(onPressed: _insert, icon: const Icon(Icons.add), label: const Text('Insert')),
        const SizedBox(width: 8),
        OutlinedButton.icon(onPressed: _remove, icon: const Icon(Icons.remove), label: const Text('Remove')),
      ]),
    ]);
  }
}

// ================================================================ ADVANCED

// ---------------------------------------------------------------- custom_paint
class CustomPaintDemo extends StatefulWidget {
  const CustomPaintDemo({super.key});
  @override
  State<CustomPaintDemo> createState() => _CustomPaintDemoState();
}

class _CustomPaintDemoState extends State<CustomPaintDemo> {
  double _progress = 0.65;
  double _wave = 3;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        SizedBox(
          width: 140,
          height: 140,
          child: CustomPaint(
            painter: RingPainter(_progress, cs.primary, cs.surfaceContainerHighest),
            child: Center(
              child: Text('${(_progress * 100).round()}%', style: Theme.of(context).textTheme.headlineSmall),
            ),
          ),
        ),
        SizedBox(width: 140, height: 140, child: CustomPaint(painter: WavePainter(_wave, cs.tertiary))),
      ]),
      LabeledSlider(
          label: 'progress', value: _progress, min: 0, max: 1, decimals: 2, onChanged: (v) => setState(() => _progress = v)),
      LabeledSlider(label: 'waves', value: _wave, min: 1, max: 8, decimals: 1, onChanged: (v) => setState(() => _wave = v)),
    ]);
  }
}

class RingPainter extends CustomPainter {
  RingPainter(this.progress, this.color, this.track);
  final double progress;
  final Color color, track;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 10;
    final bg = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final fg = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bg);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, 2 * pi * progress, false, fg);
  }

  @override
  bool shouldRepaint(RingPainter old) => old.progress != progress || old.color != color;
}

class WavePainter extends CustomPainter {
  WavePainter(this.waves, this.color);
  final double waves;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..moveTo(0, size.height / 2);
    for (double x = 0; x <= size.width; x++) {
      path.lineTo(x, size.height / 2 + sin(x / size.width * waves * 2 * pi) * size.height * 0.3);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(WavePainter old) => old.waves != waves || old.color != color;
}

// ---------------------------------------------------------------- todo_app (capstone)
class Todo {
  Todo({required this.title}) : id = DateTime.now().microsecondsSinceEpoch.toString();
  final String id;
  final String title;
  bool done = false;
}

class TodoList extends ChangeNotifier {
  final List<Todo> _todos = [Todo(title: 'Finish the Layout module'), Todo(title: 'Build a Todo app')];
  List<Todo> get todos => List.unmodifiable(_todos);
  int get remaining => _todos.where((t) => !t.done).length;

  void add(String title) {
    if (title.trim().isEmpty) return;
    _todos.insert(0, Todo(title: title.trim()));
    notifyListeners();
  }

  void toggle(Todo todo) {
    todo.done = !todo.done;
    notifyListeners();
  }

  void remove(Todo todo) {
    _todos.remove(todo);
    notifyListeners();
  }
}

class TodoAppDemo extends StatefulWidget {
  const TodoAppDemo({super.key});
  @override
  State<TodoAppDemo> createState() => _TodoAppDemoState();
}

class _TodoAppDemoState extends State<TodoAppDemo> {
  final _list = TodoList();
  final _input = TextEditingController();

  @override
  void dispose() {
    _input.dispose();
    _list.dispose();
    super.dispose();
  }

  void _submit() {
    _list.add(_input.text);
    _input.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 430,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Scaffold(
          appBar: AppBar(title: const Text('My Todos'), automaticallyImplyLeading: false),
          body: ListenableBuilder(
            listenable: _list,
            builder: (context, _) => Column(children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      decoration: const InputDecoration(hintText: 'What needs doing?', isDense: true),
                      onSubmitted: (_) => _submit(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(onPressed: _submit, icon: const Icon(Icons.add)),
                ]),
              ),
              Text('${_list.remaining} left · swipe to delete', style: const TextStyle(fontSize: 12.5)),
              Expanded(
                child: _list.todos.isEmpty
                    ? const Center(child: Text('Nothing to do 🎉'))
                    : ListView.builder(
                        itemCount: _list.todos.length,
                        itemBuilder: (context, i) {
                          final todo = _list.todos[i];
                          return Dismissible(
                            key: ValueKey(todo.id),
                            onDismissed: (_) => _list.remove(todo),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 16),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: CheckboxListTile(
                              value: todo.done,
                              onChanged: (_) => _list.toggle(todo),
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(
                                todo.title,
                                style: TextStyle(
                                  decoration: todo.done ? TextDecoration.lineThrough : null,
                                  color: todo.done ? Colors.grey : null,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
