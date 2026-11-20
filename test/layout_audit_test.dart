// Renders every screen of the app on a small phone and fails on any layout
// error (overflow, unbounded size, etc.). Runs at normal and large text size.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lab/data/catalog.dart';
import 'package:flutter_lab/data/curriculum.dart';
import 'package:flutter_lab/data/practice.dart';
import 'package:flutter_lab/state/app_state.dart';
import 'package:flutter_lab/ui/catalog/catalog_screen.dart';
import 'package:flutter_lab/ui/catalog/widget_detail_screen.dart';
import 'package:flutter_lab/ui/learn/learn_screen.dart';
import 'package:flutter_lab/ui/learn/lesson_screen.dart';
import 'package:flutter_lab/ui/learn/module_screen.dart';
import 'package:flutter_lab/ui/me/me_screen.dart';
import 'package:flutter_lab/ui/practice/practice_screen.dart';
import 'package:flutter_lab/ui/theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lessons whose demo overflows on purpose (to teach the overflow error).
const _intentionalOverflow = {'layout.overflow'};

final _problems = <String>{};

void main() {
  late AppState state;

  setUpAll(() async {
    // Load real fonts so text measures like on a phone (tests default to a
    // block font where every glyph is a full square).
    final dir =
        '${Platform.environment['FLUTTER_ROOT']}/bin/cache/artifacts/material_fonts';
    final roboto = FontLoader('Roboto');
    for (final f in ['Regular', 'Medium', 'Bold', 'Black', 'Italic', 'Light']) {
      final file = File('$dir/Roboto-$f.ttf');
      if (file.existsSync()) {
        roboto.addFont(
          Future.value(ByteData.sublistView(file.readAsBytesSync())),
        );
      }
    }
    await roboto.load();
    final icons = FontLoader('MaterialIcons');
    final iconFile = File('$dir/MaterialIcons-Regular.otf');
    if (iconFile.existsSync()) {
      icons.addFont(
        Future.value(ByteData.sublistView(iconFile.readAsBytesSync())),
      );
    }
    await icons.load();
  });

  tearDownAll(() {
    for (final p in _problems) {
      // ignore: avoid_print
      print('PROBLEM: $p');
    }
    expect(
      _problems,
      isEmpty,
      reason: 'Layout problems found (see PROBLEM lines above)',
    );
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    state = await AppState.load();
  });

  for (final scale in [1.0, 1.3]) {
    for (final brightness in Brightness.values) {
      final label = 'text x$scale, ${brightness.name}';

      Future<void> pumpScreen(WidgetTester tester, Widget screen) async {
        tester.view.physicalSize = const Size(360, 740);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final original = FlutterError.onError;
        FlutterError.onError = (details) {
          final text = details.toString();
          final loc =
              RegExp(
                r'error-causing widget was:\s+\S+ \S*?(lib/[a-z_/]+\.dart:\d+)',
              ).firstMatch(text)?.group(1) ??
              '?';
          _problems.add(
            '${details.exceptionAsString().split('\n').first} @ $loc',
          );
          if (loc == '?') {
            _problems.add(
              text
                  .split('\n')
                  .where((l) => l.contains('lib/'))
                  .take(3)
                  .join(' | '),
            );
          }
          original?.call(details);
        };
        addTearDown(() => FlutterError.onError = original);
        await tester.pumpWidget(
          AppScope(
            state: state,
            child: MaterialApp(
              theme: buildTheme(brightness).copyWith(
                textTheme: buildTheme(brightness).textTheme
                    .apply(fontFamily: 'Roboto'),
              ),
              home: MediaQuery(
                data: MediaQueryData(
                  size: const Size(360, 740),
                  textScaler: TextScaler.linear(scale),
                ),
                child: screen,
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 50));
      }

      void check(WidgetTester tester, String what, bool allow) {
        final err = tester.takeException();
        if (err == null || allow) return;
        _problems.add('$what [$label]: $err');
      }

      /// Scroll every scrollable to the end so lazily-built content is laid out.
      Future<void> scrollThrough(
        WidgetTester tester,
        String what, {
        bool allowOverflow = false,
      }) async {
        final scrollables = find.byType(Scrollable);
        if (scrollables.evaluate().isEmpty) return;
        final main = scrollables.evaluate().reduce((a, b) {
          final sa = (a.renderObject as RenderBox?)?.size.height ?? 0;
          final sb = (b.renderObject as RenderBox?)?.size.height ?? 0;
          return sb > sa ? b : a;
        });
        final finder = find.byElementPredicate((e) => e == main);
        for (var i = 0; i < 200; i++) {
          final state = tester.state<ScrollableState>(finder);
          final pos = state.position;
          check(tester, what, allowOverflow);
          if (pos.pixels >= pos.maxScrollExtent) break;
          pos.jumpTo((pos.pixels + 500).clamp(0, pos.maxScrollExtent));
          await tester.pump(const Duration(milliseconds: 16));
        }
        check(tester, what, allowOverflow);
      }

      testWidgets('all lessons lay out cleanly ($label)', (tester) async {
        for (final lesson in allLessons) {
          await pumpScreen(tester, LessonScreen(lesson: lesson));
          await scrollThrough(
            tester,
            lesson.id,
            allowOverflow: _intentionalOverflow.contains(lesson.id),
          );
        }
        await tester.pumpWidget(const SizedBox());
      });

      testWidgets('tabs and modules lay out cleanly ($label)', (tester) async {
        final screens = <String, Widget>{
          'learn': const Scaffold(body: LearnScreen()),
          'catalog': const Scaffold(body: CatalogScreen()),
          'practice': const Scaffold(body: PracticeScreen()),
          'me': const Scaffold(body: MeScreen()),
          'glossary': const GlossaryScreen(),
          'cheatsheet': const CheatSheetScreen(),
          for (final m in curriculum) 'module ${m.id}': ModuleScreen(module: m),
          for (final c in challenges)
            'challenge ${c.id}': ChallengeScreen(challenge: c),
          'quiz': QuizSessionScreen(
            title: 'Quiz',
            questions: allLessons.expand((l) => l.quiz).take(3).toList(),
          ),
        };
        for (final e in screens.entries) {
          await pumpScreen(tester, e.value);
          await scrollThrough(tester, e.key);
        }
        await tester.pumpWidget(const SizedBox());
      });

      testWidgets('all widget detail pages lay out cleanly ($label)', (
        tester,
      ) async {
        for (final entry in catalog) {
          await pumpScreen(tester, WidgetDetailScreen(entry: entry));
          await scrollThrough(tester, 'widget ${entry.name}');
        }
        await tester.pumpWidget(const SizedBox());
      });
    }
  }
}
