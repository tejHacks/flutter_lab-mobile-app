import 'package:flutter_lab/state/app_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Records every call AppState makes to the sync layer.
class FakeSink implements SyncSink {
  final calls = <String>[];
  @override
  void lessonCompleted(String id, bool done) => calls.add('completed $id $done');
  @override
  void bookmarkChanged(String id, bool on) => calls.add('bookmark $id $on');
  @override
  void challengeChanged(String id, bool solved) => calls.add('challenge $id $solved');
  @override
  void quizAnswered(bool correct) => calls.add('quiz $correct');
  @override
  void lessonOpened(String id) => calls.add('opened $id');
  @override
  void streakChanged(int streak, String lastActive) => calls.add('streak $streak');
  @override
  void progressReset() => calls.add('reset');
}

void main() {
  late AppState state;
  late FakeSink sink;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    state = await AppState.load();
    sink = FakeSink();
    state.attachSync(sink);
  });

  test('every local change is sent to the sync layer', () {
    state.setCompleted('dart.null', true);
    state.setCompleted('dart.null', false);
    state.toggleBookmark('dart.intro');
    state.toggleBookmark('dart.intro');
    state.toggleChallenge('c.fizzbuzz');
    state.recordQuizAnswer(true);
    state.recordQuizAnswer(false);
    state.openLesson('layout.rowcol');
    expect(sink.calls, [
      'completed dart.null true',
      'completed dart.null false',
      'bookmark dart.intro true',
      'bookmark dart.intro false',
      'challenge c.fizzbuzz true',
      'quiz true',
      'quiz false',
      'opened layout.rowcol',
    ]);
  });

  test('signed out (no sink) changes stay local only', () {
    state.attachSync(null);
    state.setCompleted('dart.null', true);
    expect(sink.calls, isEmpty);
    expect(state.isCompleted('dart.null'), isTrue);
  });

  test('applyRemote updates local progress and does not echo back', () async {
    state.applyRemote({
      'completed': ['start.welcome', 'dart.null'],
      'bookmarks': ['layout.stack'],
      'challenges': ['c.like'],
      'quizAnswered': 12,
      'quizCorrect': 9,
      'lastLesson': 'dart.null',
    });
    expect(sink.calls, isEmpty);
    expect(state.completed, {'start.welcome', 'dart.null'});
    expect(state.bookmarks, {'layout.stack'});
    expect(state.solvedChallenges, {'c.like'});
    expect(state.quizAnswered, 12);
    expect(state.quizCorrect, 9);
    expect(state.lastLessonId, 'dart.null');

    // Persisted: a fresh load sees the synced data.
    final reloaded = await AppState.load();
    expect(reloaded.completed, {'start.welcome', 'dart.null'});
  });

  test('a newer remote streak wins, an older one is ignored', () {
    final today = state.toSyncMap()['lastActive'] as String;
    state.applyRemote({'streak': 9, 'lastActive': '2000-01-01'});
    expect(state.streak, 1);
    state.applyRemote({'streak': 9, 'lastActive': today});
    expect(state.streak, 9);
  });

  test('toSyncMap has sortable yyyy-mm-dd dates', () {
    expect(state.toSyncMap()['lastActive'], matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
  });
}
