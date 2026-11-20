import 'package:flutter/material.dart';
import 'package:flutter_lab/data/catalog.dart';
import 'package:flutter_lab/data/curriculum.dart';
import 'package:flutter_lab/demos/dart_runner.dart';
import 'package:flutter_lab/demos/demo_registry.dart';
import 'package:flutter_lab/main.dart';
import 'package:flutter_lab/models/lesson.dart';
import 'package:flutter_lab/state/app_state.dart';
import 'package:flutter_lab/ui/common/sections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<AppState> _state() async {
  SharedPreferences.setMockInitialValues({});
  return AppState.load();
}

void main() {
  group('Content integrity', () {
    test('lesson ids are unique', () {
      final ids = allLessons.map((l) => l.id).toList();
      expect(ids.toSet().length, ids.length);
    });

    test('every demo referenced by a lesson exists', () {
      for (final l in allLessons) {
        for (final s in l.sections.whereType<DemoSection>()) {
          expect(
            demos.containsKey(s.demoKey),
            isTrue,
            reason: '${l.id} -> ${s.demoKey}',
          );
        }
      }
    });

    test('every runnable code block has an example', () {
      for (final l in allLessons) {
        for (final s in l.sections.whereType<CodeSection>()) {
          if (s.runKey != null) {
            expect(
              dartExamples.containsKey(s.runKey),
              isTrue,
              reason: '${l.id} -> ${s.runKey}',
            );
          }
        }
      }
    });

    test('quiz answers are valid indexes', () {
      for (final l in allLessons) {
        for (final q in l.quiz) {
          expect(
            q.answer,
            inInclusiveRange(0, q.options.length - 1),
            reason: '${l.id}: ${q.question}',
          );
        }
      }
    });

    test('catalog links point to real lessons and demos', () {
      for (final e in catalog) {
        if (e.lesson != null) {
          expect(lessonById.containsKey(e.lesson), isTrue, reason: e.name);
        }
        if (e.demo != null) {
          expect(demos.containsKey(e.demo), isTrue, reason: e.name);
        }
        expect(catalogCategories, contains(e.category));
      }
    });

    test('all runnable Dart examples complete and print something', () async {
      for (final entry in dartExamples.entries) {
        final out = <Object?>[];
        await entry.value(out.add);
        expect(out, isNotEmpty, reason: entry.key);
      }
    }, timeout: const Timeout(Duration(seconds: 60)));

    test('runnable examples print what the lessons promise', () async {
      Future<List<String>> run(String key) async {
        final out = <String>[];
        await dartExamples[key]!((l) => out.add('$l'));
        return out;
      }

      expect(await run('d.ops'), [
        '9',
        '5',
        '14',
        '3.5',
        '3',
        '1',
        'true',
        'true',
        'false',
        'false',
        'true',
        'false',
      ]);
      expect(await run('d.null2'), ['Unknown', 'null', 'Accra', 'ACCRA', '7']);
      expect(await run('d.sealed'), ['⏳ Loading...', '✅ 2 items', '❌ Offline']);
    });
  });

  group('App', () {
    testWidgets('home renders the learning path and tabs', (tester) async {
      final state = await _state();
      await tester.pumpWidget(
        AppScope(state: state, child: const FlutterLabApp()),
      );
      await tester.pumpAndSettle();

      expect(find.text('FlutterLab'), findsOneWidget);
      expect(find.text('Your learning path'), findsOneWidget);
      expect(find.text('Getting Started'), findsWidgets);
      expect(find.text('Widgets'), findsOneWidget);
      expect(find.text('Practice'), findsWidgets);
    });

    testWidgets('opening and completing a lesson moves to the next one', (
      tester,
    ) async {
      final state = await _state();
      await tester.pumpWidget(
        AppScope(state: state, child: const FlutterLabApp()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('START HERE'));
      await tester.pumpAndSettle();
      expect(find.text('Welcome to FlutterLab'), findsOneWidget);

      final button = find.text('Mark complete & continue');
      await tester.scrollUntilVisible(
        button,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(state.isCompleted('start.welcome'), isTrue);
      expect(find.text('What is Flutter?'), findsOneWidget);
    });

    testWidgets('every demo builds without errors', (tester) async {
      final state = await _state();
      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      for (final key in demos.keys) {
        if (key == 'overflow') {
          continue; // intentionally overflows to teach the error
        }
        await tester.pumpWidget(
          AppScope(
            state: state,
            child: MaterialApp(
              home: Scaffold(
                body: SingleChildScrollView(child: DemoFrame(demoKey: key)),
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));
        expect(tester.takeException(), isNull, reason: key);
      }
      // Dispose the last demo (cancels timers/controllers)
      await tester.pumpWidget(const SizedBox());
    });
  });
}
