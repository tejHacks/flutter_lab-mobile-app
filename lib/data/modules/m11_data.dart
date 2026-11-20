import 'package:flutter/material.dart';

import '../../models/lesson.dart';
import '../dsl.dart';

final data = LearningModule(
  id: 'data',
  title: 'Async, Data & Networking',
  description: 'FutureBuilder, StreamBuilder, HTTP requests, JSON parsing and saving data on the device.',
  level: Level.intermediate,
  icon: Icons.cloud_sync_rounded,
  color: const Color(0xFF039BE5),
  lessons: [
    Lesson(
      id: 'data.futurebuilder',
      title: 'FutureBuilder',
      summary: 'Show loading, data and error states for async work.',
      minutes: 9,
      sections: [
        p('`FutureBuilder` runs a Future and rebuilds as it progresses: **loading → data** or **loading → error**.'),
        code(r'''
class _ProfileState extends State<Profile> {
  late final Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = api.fetchUser(); // start ONCE, not in build()
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final user = snapshot.data!;
        return Text('Hello ${user.name}');
      },
    );
  }
}
'''),
        demo('future_builder', caption: 'Simulate success and failure'),
        warn('Don\'t create the Future inside `build()` (e.g. `future: api.fetchUser()`). `build` runs often, so you\'d fire a new network request on every rebuild! Create it in `initState`.'),
      ],
      quiz: [
        q('Where should you create the Future for a FutureBuilder?', ['Inside build()', 'In initState (or a state object)', 'In main()', 'In dispose()'], 1,
            'Creating it in build restarts it on every rebuild.'),
        q('What does snapshot.hasError mean?', ['Still loading', 'The Future completed with an error', 'No data yet', 'Widget disposed'], 1,
            'hasError is true when the Future threw.'),
      ],
    ),
    Lesson(
      id: 'data.streambuilder',
      title: 'StreamBuilder',
      summary: 'Rebuild on every new value from a Stream.',
      minutes: 7,
      sections: [
        code(r'''
StreamBuilder<int>(
  stream: Stream.periodic(const Duration(seconds: 1), (i) => i),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return const Text('Waiting...');
    return Text('Seconds: ${snapshot.data}');
  },
)
'''),
        demo('stream_builder', caption: 'A live stream of values'),
        p('Real-world streams: Firebase Firestore snapshots, WebSocket messages, location updates, Bluetooth data, download progress.'),
      ],
      quiz: [
        q('When does StreamBuilder rebuild?', ['Once', 'Every time the stream emits', 'Every second', 'Never'], 1,
            'It rebuilds for each new event.'),
      ],
    ),
    Lesson(
      id: 'data.http',
      title: 'HTTP Requests',
      summary: 'Talk to web APIs with the http package.',
      minutes: 11,
      sections: [
        p('Most apps fetch data from a server through an **API** (a URL that returns data, usually JSON).'),
        sh('flutter pub add http'),
        code(r'''
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Post>> fetchPosts() async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((j) => Post.fromJson(j)).toList();
  } else {
    throw Exception('Failed: ${response.statusCode}');
  }
}

// Sending data
Future<void> createPost(String title) async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'title': title, 'body': '...', 'userId': 1}),
  );
  print(response.statusCode); // 201 = created
}
'''),
        h('HTTP status codes'),
        bullets([
          '`200` OK, `201` Created',
          '`400` Bad request, `401` Not logged in, `403` Forbidden, `404` Not found',
          '`500` Server error',
        ]),
        h('Platform permissions'),
        bullets([
          '**Android**: add `<uses-permission android:name="android.permission.INTERNET"/>` to `android/app/src/main/AndroidManifest.xml` (needed for release builds).',
          '**macOS**: enable "Outgoing Connections" in the entitlements file.',
          '**iOS**: works out of the box for HTTPS. Plain `http://` URLs are blocked by default.',
        ]),
        tip('The `dio` package is a popular, more powerful alternative (interceptors, file uploads, cancellation).'),
      ],
      quiz: [
        q('Which status code means success?', ['404', '500', '200', '301'], 2, '2xx codes mean success.'),
        q('Which function turns a JSON string into Dart maps/lists?', ['jsonEncode', 'jsonDecode', 'parse', 'toJson'], 1,
            'jsonDecode parses JSON text.'),
      ],
    ),
    Lesson(
      id: 'data.json',
      title: 'JSON & Model Classes',
      summary: 'Turn raw JSON into safe, typed Dart objects.',
      minutes: 10,
      sections: [
        p('APIs send **JSON** text. `jsonDecode` turns it into `Map<String, dynamic>`. Working with raw maps is error-prone (typos, wrong types), so we convert them into **model classes**.'),
        code(r'''
import 'dart:convert';

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

void main() {
  const raw = '[{"id": 1, "title": "Hello", "published": true}, {"id": 2, "title": "Draft"}]';

  final list = (jsonDecode(raw) as List)
      .map((j) => Post.fromJson(j as Map<String, dynamic>))
      .toList();

  for (final post in list) {
    print('${post.id}: ${post.title} (published: ${post.published})');
  }
  print(jsonEncode(list.first.toJson()));
}
''', run: 'd.json'),
        tip('For big models, generate this code automatically with `json_serializable` or `freezed`. Or paste JSON into a "JSON to Dart" converter website.'),
      ],
      quiz: [
        q('What type does jsonDecode give for a JSON object?', ['String', 'Map<String, dynamic>', 'List<int>', 'Post'], 1,
            'JSON objects become maps.'),
        q('What is fromJson usually?', ['A getter', 'A factory constructor', 'A mixin', 'A widget'], 1,
            'A factory constructor builds the object from a map.'),
      ],
    ),
    Lesson(
      id: 'data.storage',
      title: 'Saving Data on the Device',
      summary: 'shared_preferences, files and databases.',
      minutes: 9,
      sections: [
        h('shared_preferences — small key/value data'),
        sh('flutter pub add shared_preferences'),
        code(r'''
import 'package:shared_preferences/shared_preferences.dart';

final prefs = await SharedPreferences.getInstance();

// Save
await prefs.setBool('darkMode', true);
await prefs.setInt('highScore', 420);
await prefs.setStringList('favorites', ['dart', 'flutter']);

// Read (null if never saved)
final dark = prefs.getBool('darkMode') ?? false;
final score = prefs.getInt('highScore') ?? 0;
'''),
        note('FlutterLab saves your progress, bookmarks and theme with shared_preferences!'),
        h('Choosing storage'),
        bullets([
          '**shared_preferences** — settings, flags, small lists.',
          '**flutter_secure_storage** — passwords and tokens (encrypted).',
          '**sqflite / drift** — relational SQL database for lots of structured data.',
          '**hive / isar / objectbox** — fast NoSQL object databases.',
          '**path_provider + dart:io File** — save files (images, JSON exports).',
          '**Firebase / Supabase** — cloud database that syncs between devices.',
        ]),
        warn('Never store passwords or auth tokens in shared_preferences — it isn\'t encrypted. Use flutter_secure_storage.'),
      ],
      quiz: [
        q('Best place to store a login token?', ['shared_preferences', 'flutter_secure_storage', 'A global variable', 'A text file'], 1,
            'Secure storage encrypts sensitive values.'),
      ],
    ),
  ],
);
