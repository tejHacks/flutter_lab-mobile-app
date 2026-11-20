import 'package:flutter/material.dart';

import '../../models/lesson.dart';
import '../dsl.dart';

final dartAdvanced = LearningModule(
  id: 'dartplus',
  title: 'Dart: Next Level',
  description: 'Async code, streams, errors, generics, extensions, records and patterns.',
  level: Level.intermediate,
  icon: Icons.bolt_rounded,
  color: const Color(0xFF5E35B1),
  lessons: [
    Lesson(
      id: 'dartplus.async',
      title: 'Futures, async & await',
      summary: 'Do slow work (network, files) without freezing the app.',
      minutes: 12,
      sections: [
        p('Some tasks take time: downloading data, reading a file, waiting for a timer. If the app just waited, the screen would **freeze**. Instead Dart uses a **Future** — a promise that a value will arrive later.'),
        analogy('Ordering food at a restaurant: you get a receipt (the **Future**) immediately and keep chatting. When the food is ready (the Future **completes**), you eat it. You don\'t stand frozen at the counter.'),
        code(r'''
Future<String> fetchUsername() async {
  await Future.delayed(const Duration(seconds: 1)); // pretend network
  return 'flutter_fan';
}

Future<void> main() async {
  print('Fetching...');
  final name = await fetchUsername(); // wait here, without blocking the UI
  print('Got: $name');
  print('Done');
}
''', run: 'd.async1'),
        bullets([
          '`Future<String>` — a String that will be available later.',
          '`async` — marks a function that uses `await`. It always returns a Future.',
          '`await` — pause **this function** until the Future completes. Other code (like animations) keeps running.',
        ]),
        h('Order of execution'),
        code(r'''
Future<void> main() async {
  print('1. Start');
  final f = Future.delayed(const Duration(milliseconds: 500), () => '3. Future done');
  print('2. Not waiting yet...');
  print(await f);
}
''', run: 'd.async2'),
        h('Running things in parallel'),
        code(r'''
Future<int> slowDouble(int x) async {
  await Future.delayed(const Duration(milliseconds: 400));
  return x * 2;
}

Future<void> main() async {
  final watch = Stopwatch()..start();
  final results = await Future.wait([slowDouble(1), slowDouble(2), slowDouble(3)]);
  print(results);
  print('Took about ${(watch.elapsedMilliseconds / 100).round() * 100} ms, not 1200!');
}
''', run: 'd.async3'),
        warn('Forgetting `await` is a classic bug: you get a `Future<String>` instead of a `String`, and printing it shows "Instance of Future<String>".'),
      ],
      quiz: [
        q('What is a Future?', ['A value available now', 'A value (or error) that will be available later', 'A loop', 'A widget'], 1,
            'Futures represent asynchronous results.'),
        q('What must a function be marked with to use await?', ['sync', 'async', 'future', 'late'], 1, 'await only works inside async functions.'),
      ],
    ),
    Lesson(
      id: 'dartplus.streams',
      title: 'Streams',
      summary: 'A sequence of async values over time.',
      minutes: 9,
      sections: [
        p('A Future gives you **one** value later. A **Stream** gives you **many** values over time: chat messages, GPS locations, a timer ticking, download progress.'),
        analogy('A Future is a letter in the mail. A Stream is a YouTube subscription: new videos keep arriving until the channel closes.'),
        code(r'''
Stream<int> countdown(int from) async* {
  for (var i = from; i >= 0; i--) {
    await Future.delayed(const Duration(milliseconds: 300));
    yield i; // emit a value
  }
}

Future<void> main() async {
  await for (final n in countdown(3)) {
    print(n == 0 ? 'Liftoff! 🚀' : '$n...');
  }
}
''', run: 'd.stream1'),
        bullets([
          '`async*` makes a function that returns a Stream.',
          '`yield` sends the next value.',
          '`await for` processes each value as it arrives.',
        ]),
        h('Transforming and listening'),
        code(r'''
Future<void> main() async {
  final stream = Stream.fromIterable([1, 2, 3, 4, 5]);
  final evensSquared = stream.where((n) => n.isEven).map((n) => n * n);
  await evensSquared.forEach(print);

  // listen() returns a subscription you can cancel
  final ticks = Stream.periodic(const Duration(milliseconds: 200), (i) => i).take(3);
  await ticks.listen((t) => print('tick $t')).asFuture();
}
''', run: 'd.stream2'),
        tip('In Flutter, `StreamBuilder` rebuilds a widget every time a stream emits — perfect for live data like Firebase.'),
      ],
      quiz: [
        q('Which keyword emits a value from an async* function?', ['return', 'emit', 'yield', 'await'], 2, 'yield sends values to the stream.'),
        q('Future vs Stream?', ['Same thing', 'Future = one value later, Stream = many values over time', 'Stream is synchronous', 'Future is faster'], 1,
            'Streams deliver a sequence of async events.'),
      ],
    ),
    Lesson(
      id: 'dartplus.errors',
      title: 'Errors & Exceptions',
      summary: 'try, catch, finally, throw and custom exceptions.',
      minutes: 8,
      sections: [
        p('When something goes wrong (bad input, no internet), Dart **throws an exception**. If nobody catches it, the program crashes. Use `try/catch` to handle it gracefully.'),
        code(r'''
class InsufficientFunds implements Exception {
  final double needed;
  InsufficientFunds(this.needed);
  @override
  String toString() => 'Need $needed more';
}

void withdraw(double balance, double amount) {
  if (amount > balance) throw InsufficientFunds(amount - balance);
  print('Withdrew $amount');
}

void main() {
  try {
    int.parse('abc');
  } on FormatException catch (e) {
    print('Bad number: ${e.message}');
  }

  try {
    withdraw(50, 80);
  } on InsufficientFunds catch (e) {
    print('Error: $e');
  } catch (e) {
    print('Something else: $e');
  } finally {
    print('finally always runs');
  }
}
''', run: 'd.errors'),
        h('Errors with async code'),
        code(r'''
Future<String> load() async {
  await Future.delayed(const Duration(milliseconds: 300));
  throw Exception('No internet');
}

Future<void> main() async {
  try {
    await load();
  } catch (e) {
    print('Caught: $e');
  }
}
''', run: 'd.errors2'),
        tip('Show users friendly messages ("Couldn\'t load — tap to retry") instead of letting the app crash.'),
      ],
      quiz: [
        q('Which block always runs?', ['try', 'catch', 'finally', 'on'], 2, 'finally runs whether or not an exception occurred.'),
        q('How do you catch only FormatException?', ['catch FormatException', 'on FormatException catch (e)', 'if (FormatException)', 'try FormatException'], 1,
            'on Type catch (e) filters by type.'),
      ],
    ),
    Lesson(
      id: 'dartplus.generics',
      title: 'Generics',
      summary: 'Write code that works with any type, safely.',
      minutes: 7,
      sections: [
        p('You\'ve used generics already: `List<String>`, `Future<int>`, `Map<String, int>`. The `<T>` is a **type parameter** — a placeholder for a type.'),
        code(r'''
class Box<T> {
  final T value;
  Box(this.value);
  T open() => value;
}

T firstOrDefault<T>(List<T> items, T fallback) =>
    items.isEmpty ? fallback : items.first;

void main() {
  final intBox = Box<int>(42);
  final strBox = Box('surprise'); // T inferred as String
  print(intBox.open() + 1);
  print(strBox.open().toUpperCase());

  print(firstOrDefault(<String>[], 'empty'));
  print(firstOrDefault([3, 2, 1], 0));
}
''', run: 'd.generics'),
        h('Constraints'),
        code(r'''
T biggest<T extends num>(List<T> items) => items.reduce((a, b) => a > b ? a : b);

void main() {
  print(biggest([3, 9, 4]));
  print(biggest([1.5, 0.2]));
}
''', run: 'd.generics2'),
        note('In Flutter: `StatefulWidget` uses `State<MyWidget>`, `FutureBuilder<User>`, `ValueNotifier<int>`, `Navigator.push<bool>` — all generics.'),
      ],
      quiz: [
        q('In List<String>, what is String?', ['A constraint', 'A type argument', 'A value', 'A mixin'], 1,
            'String fills the type parameter of List.'),
      ],
    ),
    Lesson(
      id: 'dartplus.extensions',
      title: 'Extension Methods',
      summary: 'Add methods to existing types.',
      minutes: 5,
      sections: [
        code(r'''
extension StringX on String {
  String get capitalized =>
      isEmpty ? this : this[0].toUpperCase() + substring(1);
  bool get isEmail => contains('@') && contains('.');
}

extension IntX on int {
  Duration get seconds => Duration(seconds: this);
}

void main() {
  print('flutter'.capitalized);
  print('me@site.com'.isEmail);
  print(5.seconds);
}
''', run: 'd.ext'),
        tip('A popular Flutter trick: `extension on BuildContext { ThemeData get theme => Theme.of(this); }` so you can write `context.theme`.'),
      ],
      quiz: [
        q('What do extensions let you do?', ['Change Dart syntax', 'Add methods to existing types without subclassing', 'Make variables private', 'Run code faster'], 1,
            'Extensions add functionality to types you don\'t own.'),
      ],
    ),
    Lesson(
      id: 'dartplus.records',
      title: 'Records, Patterns & Sealed Classes',
      summary: 'Modern Dart 3 features for cleaner code.',
      minutes: 12,
      sections: [
        h('Records — return multiple values'),
        code(r'''
(String, int) nameAndAge() => ('Ada', 36);

({double lat, double lng}) location() => (lat: 6.52, lng: 3.37);

void main() {
  final person = nameAndAge();
  print(person.$1);
  print(person.$2);

  // Destructuring
  final (name, age) = nameAndAge();
  print('$name is $age');

  final (:lat, :lng) = location();
  print('lat=$lat lng=$lng');
}
''', run: 'd.records'),
        h('Pattern matching'),
        code(r'''
String describe(Object value) => switch (value) {
      int n when n < 0 => 'negative int',
      int n => 'int $n',
      String s when s.isEmpty => 'empty string',
      String s => 'string "$s"',
      [var a, var b] => 'list of two: $a, $b',
      {'type': 'user', 'name': String name} => 'user named $name',
      _ => 'something else',
    };

void main() {
  print(describe(-3));
  print(describe(7));
  print(describe(''));
  print(describe('hi'));
  print(describe([1, 2]));
  print(describe({'type': 'user', 'name': 'Ada'}));
  print(describe(3.5));
}
''', run: 'd.patterns'),
        h('Sealed classes — exhaustive checks'),
        p('A `sealed` class has a fixed set of subclasses. `switch` then **forces** you to handle every case — perfect for app states like loading / success / error.'),
        code(r'''
sealed class LoadState {}
class Loading extends LoadState {}
class Success extends LoadState {
  final List<String> items;
  Success(this.items);
}
class Failure extends LoadState {
  final String message;
  Failure(this.message);
}

String render(LoadState state) => switch (state) {
      Loading() => '⏳ Loading...',
      Success(:final items) => '✅ ${items.length} items',
      Failure(:final message) => '❌ $message',
    };

void main() {
  print(render(Loading()));
  print(render(Success(['a', 'b'])));
  print(render(Failure('Offline')));
}
''', run: 'd.sealed'),
        note('FlutterLab itself uses a sealed class for lesson sections and a switch to render each kind!'),
      ],
      quiz: [
        q('What does `final (a, b) = (1, 2);` do?', ['Error', 'Destructures a record into a and b', 'Creates a list', 'Creates a map'], 1,
            'Records can be destructured with patterns.'),
        q('Why use a sealed class with switch?', ['Speed', 'The compiler ensures every subtype is handled', 'To hide fields', 'For animations'], 1,
            'Sealed classes enable exhaustiveness checking.'),
      ],
    ),
  ],
);
