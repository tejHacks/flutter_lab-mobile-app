import 'package:flutter/material.dart';

import '../../models/lesson.dart';
import '../dsl.dart';

final dartBasics = LearningModule(
  id: 'dart',
  title: 'Dart Basics',
  description: 'The language behind Flutter: variables, types, functions, collections and classes.',
  level: Level.beginner,
  icon: Icons.code_rounded,
  color: const Color(0xFF00897B),
  lessons: [
    Lesson(
      id: 'dart.intro',
      title: 'Your First Dart Program',
      summary: 'main(), print(), statements and comments.',
      minutes: 5,
      sections: [
        p('A **program** is a list of instructions the computer follows from top to bottom. In Dart, every program starts at a function called `main`.'),
        code(r'''
void main() {
  print('Hello, Dart!');
  print('I am learning Flutter.');
}
''', run: 'd.hello'),
        bullets([
          '`void main()` — the starting point. `void` means it returns nothing.',
          '`{ }` — curly braces group the instructions that belong to `main`.',
          '`print(...)` — shows text in the console (output).',
          '`;` — every statement ends with a semicolon.',
          '`\'Hello\'` — text in quotes is a **String**.',
        ]),
        h('Comments'),
        code(r'''
// A single-line comment. Dart ignores it.

/* A multi-line
   comment. */

/// A documentation comment — used above classes and functions.
''', caption: 'Comments explain your code to humans'),
        tip('Try it yourself: go to **dartpad.dev** in your browser — it runs Dart and Flutter online without installing anything. Great for practicing these lessons.'),
      ],
      quiz: [
        q('Where does every Dart program start?', ['start()', 'main()', 'run()', 'init()'], 1,
            'Dart always begins execution in main().'),
        q('What ends a statement in Dart?', ['A period .', 'A colon :', 'A semicolon ;', 'A new line'], 2,
            'Statements end with ;'),
      ],
    ),
    Lesson(
      id: 'dart.variables',
      title: 'Variables & Types',
      summary: 'var, final, const and the basic data types.',
      minutes: 8,
      sections: [
        p('A **variable** is a named box that stores a value. You can read it later and (sometimes) change it.'),
        analogy('A variable is a labelled jar. The label is the name (`age`), the content is the value (`25`), and the jar\'s shape is the **type** — an `int` jar only holds whole numbers.'),
        code(r'''
void main() {
  String name = 'Ada';     // text
  int age = 25;            // whole number
  double height = 1.68;    // decimal number
  bool isStudent = true;   // true or false

  print(name);
  print(age + 1);
  print(height);
  print(isStudent);

  age = 26;                // change the value
  print('New age: $age');
}
''', run: 'd.vars'),
        h('The core types'),
        bullets([
          '`int` — whole numbers: `42`, `-7`',
          '`double` — decimals: `3.14`',
          '`num` — either int or double',
          '`String` — text: `\'hi\'` or `"hi"`',
          '`bool` — `true` or `false`',
          '`dynamic` — any type (avoid it; you lose safety)',
        ]),
        h('var — let Dart figure out the type'),
        code(r'''
void main() {
  var city = 'Lagos';  // Dart infers String
  var score = 10;      // Dart infers int
  print(city.runtimeType);
  print(score.runtimeType);
  // city = 5;  // ERROR: a String variable can't hold an int
}
''', run: 'd.var'),
        h('final and const — values that don\'t change'),
        code(r'''
void main() {
  final today = DateTime.now(); // set once, at runtime
  const pi = 3.14159;           // known at compile time
  // pi = 3;  // ERROR: can't reassign a const

  print(today.year > 2000);
  print(pi * 2);
}
''', run: 'd.final'),
        bullets([
          '`final` — assigned once, value can be computed while the app runs.',
          '`const` — a **compile-time** constant: the value must be known before the app runs.',
        ]),
        tip('Default to `final`. Use `var` only when the value must change. Use `const` for fixed values — in Flutter, `const` widgets make your app faster.'),
      ],
      quiz: [
        q('Which type stores 3.5?', ['int', 'double', 'bool', 'String'], 1, 'Decimal numbers are doubles.'),
        q('Difference between final and const?', [
          'No difference',
          'final is set once at runtime; const must be known at compile time',
          'const can be changed later',
          'final only works for numbers'], 1, 'const values are fixed before the program runs.'),
        q('What is the type of `var x = \'hi\';`?', ['dynamic', 'String', 'var', 'Object'], 1,
            'Dart infers String from the value.'),
      ],
    ),
    Lesson(
      id: 'dart.null',
      title: 'Null Safety',
      summary: 'Nullable types, ?, !, ?? and late.',
      minutes: 9,
      sections: [
        p('`null` means "no value". Many crashes in other languages come from using a value that is accidentally null. Dart prevents this with **sound null safety**: by default, a variable **can never be null**.'),
        code(r'''
void main() {
  String name = 'Ada';
  // name = null;  // ERROR: String can't be null

  String? nickname;       // the ? means "can be null"
  print(nickname);        // null

  nickname = 'Addy';
  print(nickname);
}
''', run: 'd.null1'),
        h('Working with nullable values'),
        code(r'''
void main() {
  String? city;

  // ?? gives a fallback when the value is null
  print(city ?? 'Unknown');

  // ?. only calls the method if not null
  print(city?.length);

  // ??= assigns only if currently null
  city ??= 'Accra';
  print(city);

  // ! says "trust me, it's not null" (crashes if wrong!)
  String sure = city!;
  print(sure.toUpperCase());

  // Type promotion: after a null check, Dart knows it's safe
  String? word = 'flutter';
  if (word != null) {
    print(word.length); // no ? needed here
  }
}
''', run: 'd.null2'),
        warn('Avoid `!` unless you are 100% sure. If the value is null, your app crashes with "Null check operator used on a null value" — one of the most common Flutter errors.'),
        h('late — "I promise to set it before use"'),
        code(r'''
late String description;

void main() {
  description = 'Set later';
  print(description);
}
''', run: 'd.late'),
        tip('You\'ll see `late` in Flutter for things created in `initState`, like animation controllers.'),
      ],
      quiz: [
        q('How do you declare a String that can be null?', ['String name', 'String? name', 'String! name', 'null String name'], 1,
            'Adding ? to a type makes it nullable.'),
        q('What does `a ?? b` return when a is null?', ['a', 'null', 'b', 'An error'], 2,
            '?? returns the right side when the left side is null.'),
        q('What happens if you use `!` on a null value?', ['Returns empty string', 'Runtime crash', 'Returns 0', 'Nothing'], 1,
            'The null-check operator throws when the value is null.'),
      ],
    ),
    Lesson(
      id: 'dart.operators',
      title: 'Operators',
      summary: 'Math, comparison, logic and handy shortcuts.',
      minutes: 6,
      sections: [
        code(r'''
void main() {
  // Arithmetic
  print(7 + 2);   // 9
  print(7 - 2);   // 5
  print(7 * 2);   // 14
  print(7 / 2);   // 3.5  (always a double)
  print(7 ~/ 2);  // 3    (integer division)
  print(7 % 2);   // 1    (remainder)

  // Comparison -> bool
  print(5 > 3);   // true
  print(5 == 5);  // true
  print(5 != 5);  // false

  // Logic
  print(true && false); // AND -> false
  print(true || false); // OR  -> true
  print(!true);         // NOT -> false
}
''', run: 'd.ops'),
        h('Assignment shortcuts'),
        code(r'''
void main() {
  var score = 10;
  score += 5;   // score = score + 5
  score -= 3;
  score *= 2;
  score++;      // add 1
  print(score);

  // Conditional (ternary) expression: condition ? ifTrue : ifFalse
  var age = 20;
  var label = age >= 18 ? 'adult' : 'minor';
  print(label);
}
''', run: 'd.ops2'),
        h('Type test and cast'),
        code(r'''
void main() {
  Object thing = 'hello';
  print(thing is String);   // true
  print(thing is! int);     // true
  var s = thing as String;  // cast
  print(s.length);
}
''', run: 'd.ops3'),
        tip('The ternary `a ? b : c` is used ALL the time in Flutter, e.g. `isDark ? Colors.black : Colors.white`.'),
      ],
      quiz: [
        q('What is 7 ~/ 2?', ['3.5', '3', '1', '4'], 1, '~/ is integer division.'),
        q('What is 10 % 3?', ['3', '1', '0', '3.33'], 1, '% gives the remainder.'),
      ],
    ),
    Lesson(
      id: 'dart.strings',
      title: 'Strings',
      summary: 'Interpolation, multi-line text and useful methods.',
      minutes: 6,
      sections: [
        code(r'''
void main() {
  var name = 'Ada';
  var age = 25;

  // String interpolation: put values inside strings
  print('Hi $name!');
  print('Next year you will be ${age + 1}.');

  // Concatenation
  print('Flu' + 'tter');

  // Multi-line strings
  var poem = """
Roses are red,
Dart is cool.""";
  print(poem);

  // Useful methods
  var lang = '  Flutter  ';
  print(lang.trim());
  print(lang.trim().toUpperCase());
  print('flutter'.contains('utt'));
  print('a,b,c'.split(','));
  print('dart'.replaceAll('d', 'D'));
  print('hello'.length);
  print('5' + 5.toString());
  print(int.parse('42') + 1);
}
''', run: 'd.strings'),
        bullets([
          '`\$name` inserts a variable; `\${expression}` inserts any expression.',
          'Use `int.parse()` / `double.parse()` to turn text into numbers, and `.toString()` to turn anything into text.',
          'Strings are **immutable**: methods return a new string; they don\'t change the original.',
        ]),
        tip('Prefer interpolation (`\'Hi \$name\'`) over `+`. It\'s the Dart style and the linter will remind you.'),
      ],
      quiz: [
        q('What prints for: var n = 3; print(\'n is \${n * 2}\');', ['n is n * 2', 'n is 6', 'n is 3', 'Error'], 1,
            '\${...} evaluates the expression.'),
        q('How do you convert \'42\' to an int?', ['\'42\'.toInt()', 'int.parse(\'42\')', 'int(\'42\')', '(int)\'42\''], 1,
            'int.parse converts a String to an int.'),
      ],
    ),
    Lesson(
      id: 'dart.control',
      title: 'Control Flow',
      summary: 'if/else, switch, for and while loops.',
      minutes: 9,
      sections: [
        p('Control flow decides **which** code runs and **how many times**.'),
        h('if / else'),
        code(r'''
void main() {
  var temp = 31;
  if (temp > 30) {
    print('Hot!');
  } else if (temp > 18) {
    print('Nice.');
  } else {
    print('Cold.');
  }
}
''', run: 'd.if'),
        h('switch'),
        code(r'''
void main() {
  var day = 'sat';
  switch (day) {
    case 'sat' || 'sun':
      print('Weekend');
    case 'mon':
      print('Back to work');
    default:
      print('Weekday');
  }

  // switch expression (Dart 3) — returns a value
  var emoji = switch (day) {
    'sat' || 'sun' => '😎',
    _ => '💼',
  };
  print(emoji);
}
''', run: 'd.switch'),
        h('Loops'),
        code(r'''
void main() {
  // for loop: start; condition; step
  for (var i = 1; i <= 3; i++) {
    print('Count $i');
  }

  // for-in: go through each item
  var fruits = ['apple', 'mango', 'kiwi'];
  for (final fruit in fruits) {
    print(fruit);
  }

  // while: repeat while condition is true
  var lives = 3;
  while (lives > 0) {
    print('Lives left: $lives');
    lives--;
  }

  // break & continue
  for (var i = 0; i < 10; i++) {
    if (i == 2) continue; // skip 2
    if (i == 5) break;    // stop at 5
    print(i);
  }
}
''', run: 'd.loops'),
        warn('A `while` loop whose condition never becomes false runs forever (an **infinite loop**) and freezes your app.'),
      ],
      quiz: [
        q('How many times does `for (var i = 0; i < 3; i++)` run?', ['2', '3', '4', 'Forever'], 1, 'i = 0, 1, 2.'),
        q('What does `continue` do in a loop?', ['Stops the loop', 'Skips to the next iteration', 'Restarts the program', 'Nothing'], 1,
            'continue skips the rest of the current iteration.'),
      ],
    ),
    Lesson(
      id: 'dart.functions',
      title: 'Functions',
      summary: 'Parameters, return values, named/optional params and arrow functions.',
      minutes: 10,
      sections: [
        p('A **function** is a reusable block of code with a name. You give it inputs (**parameters**) and it can give back an output (**return value**).'),
        code(r'''
int add(int a, int b) {
  return a + b;
}

// Arrow syntax for one-expression functions
int multiply(int a, int b) => a * b;

void greet(String name) {
  print('Hello, $name!');
}

void main() {
  print(add(2, 3));
  print(multiply(4, 5));
  greet('Ada');
}
''', run: 'd.fn1'),
        h('Named and optional parameters'),
        p('Flutter uses **named parameters** everywhere (`Text(\'hi\', style: ...)`), so this is important!'),
        code(r'''
// Named parameters go inside { }
void createUser({required String name, int age = 18, String? email}) {
  print('$name, $age, ${email ?? 'no email'}');
}

// Optional positional parameters go inside [ ]
String shout(String text, [int times = 1]) => (text.toUpperCase() + '! ') * times;

void main() {
  createUser(name: 'Ada');
  createUser(age: 30, name: 'Linus', email: 'l@x.com');
  print(shout('hey'));
  print(shout('hey', 3));
}
''', run: 'd.fn2'),
        bullets([
          '`required` — the caller must pass it.',
          '`int age = 18` — a **default value** if not passed.',
          '`String? email` — optional and can be null.',
        ]),
        h('Functions are values'),
        code(r'''
void main() {
  // Anonymous function stored in a variable
  var square = (int x) => x * x;
  print(square(6));

  // Passing a function to another function
  void repeat(int times, void Function(int) action) {
    for (var i = 0; i < times; i++) action(i);
  }
  repeat(3, (i) => print('Run #$i'));
}
''', run: 'd.fn3'),
        tip('In Flutter, `onPressed: () { ... }` is exactly this: you pass an anonymous function that runs when the button is tapped.'),
      ],
      quiz: [
        q('How do you make a named parameter mandatory?', ['Add !', 'Use required', 'Use final', 'Put it in [ ]'], 1,
            'The required keyword forces the caller to provide it.'),
        q('What does `int f(int x) => x + 1;` return for f(4)?', ['4', '5', 'x + 1', 'null'], 1, 'Arrow functions return the expression.'),
        q('In `onPressed: () {...}`, what is `() {...}`?', ['A class', 'An anonymous function', 'A list', 'A widget'], 1,
            'It\'s a function with no name passed as a value.'),
      ],
    ),
    Lesson(
      id: 'dart.collections',
      title: 'Lists, Maps & Sets',
      summary: 'Store many values and transform them with map/where/reduce.',
      minutes: 12,
      sections: [
        h('List — an ordered collection'),
        code(r'''
void main() {
  List<String> fruits = ['apple', 'banana'];
  fruits.add('cherry');
  print(fruits);
  print(fruits[0]);        // first item (index starts at 0!)
  print(fruits.length);
  fruits.remove('banana');
  print(fruits);
  print(fruits.contains('apple'));
  print(fruits.first + ' / ' + fruits.last);
}
''', run: 'd.list'),
        h('Map — key/value pairs'),
        code(r'''
void main() {
  Map<String, int> ages = {'Ada': 36, 'Alan': 41};
  ages['Grace'] = 85;          // add or update
  print(ages['Ada']);          // 36
  print(ages['Bob']);          // null (missing key)
  print(ages.keys);
  print(ages.containsKey('Alan'));
  ages.forEach((name, age) => print('$name is $age'));
}
''', run: 'd.map'),
        h('Set — unique items, no order'),
        code(r'''
void main() {
  var tags = {'dart', 'flutter'};
  tags.add('dart');   // ignored, already there
  print(tags);
  print(tags.length);
}
''', run: 'd.set'),
        h('Transforming collections'),
        p('These methods are used constantly in Flutter — for example to turn a list of data into a list of widgets.'),
        code(r'''
void main() {
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

  // Spread, collection-if and collection-for
  var showExtra = true;
  var all = [0, ...nums, if (showExtra) 99, for (var n in evens) n * 10];
  print(all);
}
''', run: 'd.iter'),
        tip('You\'ll write `items.map((item) => Text(item)).toList()` and `children: [for (final x in items) Text(x)]` all the time in Flutter.'),
      ],
      quiz: [
        q('What is the index of the first item in a List?', ['1', '0', '-1', 'first'], 1, 'Lists are zero-indexed.'),
        q('Which collection guarantees unique items?', ['List', 'Map', 'Set', 'Array'], 2, 'Sets ignore duplicates.'),
        q('What does [1,2,3].where((n) => n > 1).toList() give?', ['[1]', '[2, 3]', '[true, false]', '5'], 1,
            'where keeps items that match the condition.'),
      ],
    ),
    Lesson(
      id: 'dart.classes',
      title: 'Classes & Objects',
      summary: 'Blueprints, constructors, getters and methods.',
      minutes: 12,
      sections: [
        p('A **class** is a blueprint. An **object** (instance) is a thing built from that blueprint. Every Flutter widget is a class!'),
        analogy('A class is a cookie cutter; objects are the cookies. One `Dog` class can create many dogs, each with its own name.'),
        code(r'''
class Dog {
  // Fields (properties)
  final String name;
  int age;

  // Constructor — `this.name` assigns the parameter to the field
  Dog(this.name, this.age);

  // Method (a function inside a class)
  void bark() => print('$name says Woof!');

  // Getter — looks like a field, computed on demand
  bool get isPuppy => age < 2;
}

void main() {
  var rex = Dog('Rex', 1);
  var max = Dog('Max', 5);
  rex.bark();
  print(rex.isPuppy);
  print(max.isPuppy);
  max.age++;
  print(max.age);
}
''', run: 'd.class'),
        h('Named parameters & named constructors'),
        code(r'''
class User {
  final String name;
  final String role;

  // Named params, like Flutter widgets
  const User({required this.name, this.role = 'member'});

  // Named constructor
  User.admin(this.name) : role = 'admin';

  // Factory constructor: can contain logic
  factory User.fromMap(Map<String, String> map) {
    return User(name: map['name']!, role: map['role'] ?? 'member');
  }

  @override
  String toString() => 'User($name, $role)';
}

void main() {
  print(const User(name: 'Ada'));
  print(User.admin('Linus'));
  print(User.fromMap({'name': 'Grace', 'role': 'editor'}));
}
''', run: 'd.ctor'),
        h('Private members'),
        p('A name starting with `_` is **private** to its file: `_count`, `_helper()`. Flutter uses this for `_MyPageState`.'),
        h('copyWith — updating immutable objects'),
        code(r'''
class Settings {
  final bool darkMode;
  final double fontSize;
  const Settings({this.darkMode = false, this.fontSize = 14});

  Settings copyWith({bool? darkMode, double? fontSize}) => Settings(
        darkMode: darkMode ?? this.darkMode,
        fontSize: fontSize ?? this.fontSize,
      );
}

void main() {
  const s1 = Settings();
  final s2 = s1.copyWith(darkMode: true);
  print('${s1.darkMode} ${s2.darkMode} ${s2.fontSize}');
}
''', run: 'd.copy'),
      ],
      quiz: [
        q('What is an object?', ['A blueprint', 'An instance created from a class', 'A function', 'A package'], 1,
            'Objects are instances of classes.'),
        q('What makes a field private in Dart?', ['private keyword', 'Starting its name with _', 'Using final', 'Using static'], 1,
            'Leading underscore = library-private.'),
      ],
    ),
    Lesson(
      id: 'dart.oop',
      title: 'Inheritance, Abstract & Mixins',
      summary: 'extends, implements, with, and @override.',
      minutes: 12,
      sections: [
        h('Inheritance — extends'),
        p('A class can **extend** another, inheriting its fields and methods. That\'s how `class MyApp extends StatelessWidget` works.'),
        code(r'''
class Animal {
  final String name;
  Animal(this.name);
  void speak() => print('$name makes a sound');
}

class Cat extends Animal {
  Cat(super.name);

  @override
  void speak() => print('$name says Meow');
}

void main() {
  Animal a = Animal('Generic');
  Animal c = Cat('Tom');
  a.speak();
  c.speak(); // uses Cat's version — polymorphism
}
''', run: 'd.inherit'),
        h('Abstract classes & interfaces'),
        code(r'''
abstract class Shape {
  double get area;          // no body: subclasses must implement
  void describe() => print('Area: ${area.toStringAsFixed(2)}');
}

class Circle extends Shape {
  final double r;
  Circle(this.r);
  @override
  double get area => 3.14159 * r * r;
}

class Square implements Shape {
  final double side;
  Square(this.side);
  @override
  double get area => side * side;
  @override
  void describe() => print('Square of $side');
}

void main() {
  final shapes = <Shape>[Circle(1), Square(3)];
  for (final s in shapes) {
    s.describe();
  }
}
''', run: 'd.abstract'),
        bullets([
          '`extends` — inherit code (only one parent).',
          '`implements` — promise to provide the same API, but write everything yourself (can implement many).',
          '`abstract` — can\'t be created directly; it\'s a template.',
        ]),
        h('Mixins — reusable chunks of behaviour'),
        code(r'''
mixin Swimmer {
  void swim() => print('Swimming');
}
mixin Flyer {
  void fly() => print('Flying');
}

class Duck with Swimmer, Flyer {}

void main() {
  final d = Duck();
  d.swim();
  d.fly();
}
''', run: 'd.mixin'),
        note('In Flutter you\'ll write `class _MyState extends State<MyWidget> with SingleTickerProviderStateMixin` for animations — that\'s a mixin!'),
      ],
      quiz: [
        q('What does @override mean?', ['Delete a method', 'Replace a parent\'s method in a subclass', 'Make it private', 'Make it static'], 1,
            '@override marks a method that replaces the inherited version.'),
        q('How many classes can you extend?', ['One', 'Two', 'Unlimited', 'None'], 0,
            'Dart has single inheritance; use mixins/implements for more.'),
        q('Which keyword adds a mixin?', ['extends', 'implements', 'with', 'mixin'], 2, 'class A with M {}'),
      ],
    ),
    Lesson(
      id: 'dart.enums',
      title: 'Enums',
      summary: 'A fixed set of named values.',
      minutes: 5,
      sections: [
        code(r'''
enum TrafficLight { red, yellow, green }

// Enhanced enums can have fields and methods
enum Planet {
  mercury(0.38),
  earth(1.0),
  jupiter(2.53);

  const Planet(this.gravity);
  final double gravity;
  double weightOn(double kg) => kg * gravity;
}

void main() {
  var light = TrafficLight.red;
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
}
''', run: 'd.enum'),
        tip('Use enums instead of strings like `\'red\'` — the compiler catches typos, and `switch` warns you if you forget a case. Flutter uses enums everywhere: `MainAxisAlignment.center`, `FontWeight.bold`, `TextAlign.left`.'),
      ],
      quiz: [
        q('Which is an enum value in Flutter?', ['Text', 'MainAxisAlignment.center', 'setState', 'Column'], 1,
            'MainAxisAlignment is an enum.'),
      ],
    ),
  ],
);
