// Runnable Dart examples for the "Run" button on code blocks.
// Each example receives a `print` function that writes to the in-app console,
// so the body reads exactly like the code shown in the lesson.
// ignore_for_file: prefer_interpolation_to_compose_strings, unnecessary_type_check, dead_code, unnecessary_null_comparison, prefer_const_declarations, unnecessary_cast, invalid_null_aware_operator, dead_null_aware_expression, unnecessary_non_null_assertion, prefer_adjacent_string_concatenation, prefer_function_declarations_over_variables
import 'dart:async';
import 'dart:convert';

typedef Printer = void Function(Object? line);
typedef DartExample = FutureOr<void> Function(Printer print);

final Map<String, DartExample> dartExamples = {
  'd.hello': (print) {
    print('Hello, Dart!');
    print('I am learning Flutter.');
  },
  'd.vars': (print) {
    String name = 'Ada';
    int age = 25;
    double height = 1.68;
    bool isStudent = true;
    print(name);
    print(age + 1);
    print(height);
    print(isStudent);
    age = 26;
    print('New age: $age');
  },
  'd.var': (print) {
    var city = 'Lagos';
    var score = 10;
    print(city.runtimeType);
    print(score.runtimeType);
  },
  'd.final': (print) {
    final today = DateTime.now();
    const pi = 3.14159;
    print(today.year > 2000);
    print(pi * 2);
  },
  'd.null1': (print) {
    String? nickname;
    print(nickname);
    nickname = 'Addy';
    print(nickname);
  },
  'd.null2': (print) {
    String? city = _nothing();
    print(city ?? 'Unknown');
    print(city?.length);
    city ??= 'Accra';
    print(city);
    String sure = city!;
    print(sure.toUpperCase());
    String? word = 'flutter';
    if (word != null) {
      print(word.length);
    }
  },
  'd.late': (print) {
    description = 'Set later';
    print(description);
  },
  'd.ops': (print) {
    print(7 + 2);
    print(7 - 2);
    print(7 * 2);
    print(7 / 2);
    print(7 ~/ 2);
    print(7 % 2);
    print(5 > 3);
    print(5 == 5);
    print(5 != 5);
    print(true && false);
    print(true || false);
    print(!true);
  },
  'd.ops2': (print) {
    var score = 10;
    score += 5;
    score -= 3;
    score *= 2;
    score++;
    print(score);
    var age = 20;
    var label = age >= 18 ? 'adult' : 'minor';
    print(label);
  },
  'd.ops3': (print) {
    Object thing = 'hello';
    print(thing is String);
    print(thing is! int);
    var s = thing as String;
    print(s.length);
  },
  'd.strings': (print) {
    var name = 'Ada';
    var age = 25;
    print('Hi $name!');
    print('Next year you will be ${age + 1}.');
    print('Flu' + 'tter');
    var poem = """
Roses are red,
Dart is cool.""";
    print(poem);
    var lang = '  Flutter  ';
    print(lang.trim());
    print(lang.trim().toUpperCase());
    print('flutter'.contains('utt'));
    print('a,b,c'.split(','));
    print('dart'.replaceAll('d', 'D'));
    print('hello'.length);
    print('5' + 5.toString());
    print(int.parse('42') + 1);
  },
  'd.if': (print) {
    var temp = 31;
    if (temp > 30) {
      print('Hot!');
    } else if (temp > 18) {
      print('Nice.');
    } else {
      print('Cold.');
    }
  },
  'd.switch': (print) {
    var day = _id('sat');
    switch (day) {
      case 'sat' || 'sun':
        print('Weekend');
      case 'mon':
        print('Back to work');
      default:
        print('Weekday');
    }
    var emoji = switch (day) {
      'sat' || 'sun' => '😎',
      _ => '💼',
    };
    print(emoji);
  },
  'd.loops': (print) {
    for (var i = 1; i <= 3; i++) {
      print('Count $i');
    }
    var fruits = ['apple', 'mango', 'kiwi'];
    for (final fruit in fruits) {
      print(fruit);
    }
    var lives = 3;
    while (lives > 0) {
      print('Lives left: $lives');
      lives--;
    }
    for (var i = 0; i < 10; i++) {
      if (i == 2) continue;
      if (i == 5) break;
      print(i);
    }
  },
  'd.fn1': (print) {
    int add(int a, int b) {
      return a + b;
    }

    int multiply(int a, int b) => a * b;
    void greet(String name) {
      print('Hello, $name!');
    }

    print(add(2, 3));
    print(multiply(4, 5));
    greet('Ada');
  },
  'd.fn2': (print) {
    void createUser({required String name, int age = 18, String? email}) {
      print('$name, $age, ${email ?? 'no email'}');
    }

    String shout(String text, [int times = 1]) => (text.toUpperCase() + '! ') * times;
    createUser(name: 'Ada');
    createUser(age: 30, name: 'Linus', email: 'l@x.com');
    print(shout('hey'));
    print(shout('hey', 3));
  },
  'd.fn3': (print) {
    var square = (int x) => x * x;
    print(square(6));
    void repeat(int times, void Function(int) action) {
      for (var i = 0; i < times; i++) {
        action(i);
      }
    }

    repeat(3, (i) => print('Run #$i'));
  },
  'd.list': (print) {
    List<String> fruits = ['apple', 'banana'];
    fruits.add('cherry');
    print(fruits);
    print(fruits[0]);
    print(fruits.length);
    fruits.remove('banana');
    print(fruits);
    print(fruits.contains('apple'));
    print(fruits.first + ' / ' + fruits.last);
  },
  'd.map': (print) {
    Map<String, int> ages = {'Ada': 36, 'Alan': 41};
    ages['Grace'] = 85;
    print(ages['Ada']);
    print(ages['Bob']);
    print(ages.keys);
    print(ages.containsKey('Alan'));
    ages.forEach((name, age) => print('$name is $age'));
  },
  'd.set': (print) {
    var tags = {'dart', 'flutter'};
    tags.add('dart');
    print(tags);
    print(tags.length);
  },
  'd.iter': (print) {
    var nums = [1, 2, 3, 4, 5, 6];
    var doubled = nums.map((n) => n * 2).toList();
    var evens = nums.where((n) => n.isEven).toList();
    var sum = nums.reduce((a, b) => a + b);
    var firstBig = nums.firstWhere((n) => n > 4);
    var anyNegative = nums.any((n) => n < 0);
    print(doubled);
    print(evens);
    print(sum);
    print(firstBig);
    print(anyNegative);
    var showExtra = _id(true);
    var all = [0, ...nums, if (showExtra) 99, for (var n in evens) n * 10];
    print(all);
  },
  'd.class': (print) {
    var rex = Dog('Rex', 1, print);
    var max = Dog('Max', 5, print);
    rex.bark();
    print(rex.isPuppy);
    print(max.isPuppy);
    max.age++;
    print(max.age);
  },
  'd.ctor': (print) {
    print(const User(name: 'Ada'));
    print(User.admin('Linus'));
    print(User.fromMap({'name': 'Grace', 'role': 'editor'}));
  },
  'd.copy': (print) {
    const s1 = Settings();
    final s2 = s1.copyWith(darkMode: true);
    print('${s1.darkMode} ${s2.darkMode} ${s2.fontSize}');
  },
  'd.inherit': (print) {
    Animal a = Animal('Generic', print);
    Animal c = Cat('Tom', print);
    a.speak();
    c.speak();
  },
  'd.abstract': (print) {
    final shapes = <Shape>[Circle(1, print), Square(3, print)];
    for (final s in shapes) {
      s.describe();
    }
  },
  'd.mixin': (print) {
    final d = Duck(print);
    d.swim();
    d.fly();
  },
  'd.enum': (print) {
    var light = _id(TrafficLight.red);
    print(light);
    print(light.name);
    print(TrafficLight.values);
    var action = switch (light) {
      TrafficLight.red => 'Stop',
      TrafficLight.yellow => 'Slow down',
      TrafficLight.green => 'Go',
    };
    print(action);
    print(Planet.jupiter.weightOn(70).toStringAsFixed(1));
  },
  'd.async1': (print) async {
    Future<String> fetchUsername() async {
      await Future.delayed(const Duration(seconds: 1));
      return 'flutter_fan';
    }

    print('Fetching...');
    final name = await fetchUsername();
    print('Got: $name');
    print('Done');
  },
  'd.async2': (print) async {
    print('1. Start');
    final f = Future.delayed(const Duration(milliseconds: 500), () => '3. Future done');
    print('2. Not waiting yet...');
    print(await f);
  },
  'd.async3': (print) async {
    Future<int> slowDouble(int x) async {
      await Future.delayed(const Duration(milliseconds: 400));
      return x * 2;
    }

    final watch = Stopwatch()..start();
    final results = await Future.wait([slowDouble(1), slowDouble(2), slowDouble(3)]);
    print(results);
    print('Took about ${(watch.elapsedMilliseconds / 100).round() * 100} ms, not 1200!');
  },
  'd.stream1': (print) async {
    Stream<int> countdown(int from) async* {
      for (var i = from; i >= 0; i--) {
        await Future.delayed(const Duration(milliseconds: 300));
        yield i;
      }
    }

    await for (final n in countdown(3)) {
      print(n == 0 ? 'Liftoff! 🚀' : '$n...');
    }
  },
  'd.stream2': (print) async {
    final stream = Stream.fromIterable([1, 2, 3, 4, 5]);
    final evensSquared = stream.where((n) => n.isEven).map((n) => n * n);
    await evensSquared.forEach(print);
    final ticks = Stream.periodic(const Duration(milliseconds: 200), (i) => i).take(3);
    await ticks.listen((t) => print('tick $t')).asFuture<void>();
  },
  'd.errors': (print) {
    void withdraw(double balance, double amount) {
      if (amount > balance) throw InsufficientFunds(amount - balance);
      print('Withdrew $amount');
    }

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
  },
  'd.errors2': (print) async {
    Future<String> load() async {
      await Future.delayed(const Duration(milliseconds: 300));
      throw Exception('No internet');
    }

    try {
      await load();
    } catch (e) {
      print('Caught: $e');
    }
  },
  'd.generics': (print) {
    T firstOrDefault<T>(List<T> items, T fallback) => items.isEmpty ? fallback : items.first;
    final intBox = Box<int>(42);
    final strBox = Box('surprise');
    print(intBox.open() + 1);
    print(strBox.open().toUpperCase());
    print(firstOrDefault(<String>[], 'empty'));
    print(firstOrDefault([3, 2, 1], 0));
  },
  'd.generics2': (print) {
    T biggest<T extends num>(List<T> items) => items.reduce((a, b) => a > b ? a : b);
    print(biggest([3, 9, 4]));
    print(biggest([1.5, 0.2]));
  },
  'd.ext': (print) {
    print('flutter'.capitalized);
    print('me@site.com'.isEmail);
    print(5.seconds);
  },
  'd.records': (print) {
    (String, int) nameAndAge() => ('Ada', 36);
    ({double lat, double lng}) location() => (lat: 6.52, lng: 3.37);
    final person = nameAndAge();
    print(person.$1);
    print(person.$2);
    final (name, age) = nameAndAge();
    print('$name is $age');
    final (:lat, :lng) = location();
    print('lat=$lat lng=$lng');
  },
  'd.patterns': (print) {
    String describe(Object value) => switch (value) {
          int n when n < 0 => 'negative int',
          int n => 'int $n',
          String s when s.isEmpty => 'empty string',
          String s => 'string "$s"',
          [var a, var b] => 'list of two: $a, $b',
          {'type': 'user', 'name': String name} => 'user named $name',
          _ => 'something else',
        };
    print(describe(-3));
    print(describe(7));
    print(describe(''));
    print(describe('hi'));
    print(describe([1, 2]));
    print(describe({'type': 'user', 'name': 'Ada'}));
    print(describe(3.5));
  },
  'd.json': (print) {
    const raw =
        '[{"id": 1, "title": "Hello", "published": true}, {"id": 2, "title": "Draft"}]';
    final list = (jsonDecode(raw) as List)
        .map((j) => Post.fromJson(j as Map<String, dynamic>))
        .toList();
    for (final post in list) {
      print('${post.id}: ${post.title} (published: ${post.published})');
    }
    print(jsonEncode(list.first.toJson()));
  },
  'd.sealed': (print) {
    String render(LoadState state) => switch (state) {
          Loading() => '⏳ Loading...',
          Success(:final items) => '✅ ${items.length} items',
          Failure(:final message) => '❌ $message',
        };
    print(render(Loading()));
    print(render(Success(['a', 'b'])));
    print(render(Failure('Offline')));
  },
};

// Helpers that hide constant values from the analyzer so examples stay
// identical to the lesson code without lint noise.
T _id<T>(T v) => v;
String? _nothing() => null;

late String description;

// ---- Supporting types used by the examples -------------------------------

class Dog {
  Dog(this.name, this.age, this._print);
  final String name;
  int age;
  final Printer _print;
  void bark() => _print('$name says Woof!');
  bool get isPuppy => age < 2;
}

class User {
  final String name;
  final String role;
  const User({required this.name, this.role = 'member'});
  User.admin(this.name) : role = 'admin';
  factory User.fromMap(Map<String, String> map) =>
      User(name: map['name']!, role: map['role'] ?? 'member');
  @override
  String toString() => 'User($name, $role)';
}

class Settings {
  final bool darkMode;
  final double fontSize;
  const Settings({this.darkMode = false, this.fontSize = 14});
  Settings copyWith({bool? darkMode, double? fontSize}) => Settings(
        darkMode: darkMode ?? this.darkMode,
        fontSize: fontSize ?? this.fontSize,
      );
}

class Animal {
  Animal(this.name, this.out);
  final String name;
  final Printer out;
  void speak() => out('$name makes a sound');
}

class Cat extends Animal {
  Cat(super.name, super.out);
  @override
  void speak() => out('$name says Meow');
}

abstract class Shape {
  Shape(this.out);
  final Printer out;
  double get area;
  void describe() => out('Area: ${area.toStringAsFixed(2)}');
}

class Circle extends Shape {
  Circle(this.r, super.out);
  final double r;
  @override
  double get area => 3.14159 * r * r;
}

class Square extends Shape {
  Square(this.side, super.out);
  final double side;
  @override
  double get area => side * side;
  @override
  void describe() => out('Square of $side');
}

mixin Swimmer {
  Printer get out;
  void swim() => out('Swimming');
}

mixin Flyer {
  Printer get out;
  void fly() => out('Flying');
}

class Duck with Swimmer, Flyer {
  Duck(this.out);
  @override
  final Printer out;
}

enum TrafficLight { red, yellow, green }

enum Planet {
  mercury(0.38),
  earth(1.0),
  jupiter(2.53);

  const Planet(this.gravity);
  final double gravity;
  double weightOn(double kg) => kg * gravity;
}

class InsufficientFunds implements Exception {
  final double needed;
  InsufficientFunds(this.needed);
  @override
  String toString() => 'Need $needed more';
}

class Box<T> {
  final T value;
  Box(this.value);
  T open() => value;
}

extension StringX on String {
  String get capitalized => isEmpty ? this : this[0].toUpperCase() + substring(1);
  bool get isEmail => contains('@') && contains('.');
}

extension IntX on int {
  Duration get seconds => Duration(seconds: this);
}

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

class Post {
  final int id;
  final String title;
  final bool published;

  const Post({required this.id, required this.title, required this.published});

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json['id'] as int,
        title: json['title'] as String,
        published: json['published'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'published': published};
}
