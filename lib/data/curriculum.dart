import '../models/lesson.dart';
import 'modules/m00_getting_started.dart';
import 'modules/m01_dart_basics.dart';
import 'modules/m02_dart_advanced.dart';
import 'modules/m03_fundamentals.dart';
import 'modules/m04_layout.dart';
import 'modules/m05_widgets.dart';
import 'modules/m06_input.dart';
import 'modules/m07_lists.dart';
import 'modules/m08_navigation.dart';
import 'modules/m09_theming.dart';
import 'modules/m10_state.dart';
import 'modules/m11_data.dart';
import 'modules/m12_animations.dart';
import 'modules/m13_advanced.dart';

/// The full learning path, in recommended order.
final List<LearningModule> curriculum = [
  gettingStarted,
  dartBasics,
  fundamentals,
  layout,
  commonWidgets,
  input,
  lists,
  navigation,
  theming,
  dartAdvanced,
  stateManagement,
  data,
  animations,
  advanced,
  capstone,
];

final List<Lesson> allLessons = [for (final m in curriculum) ...m.lessons];

final Map<String, Lesson> lessonById = {for (final l in allLessons) l.id: l};

final Map<String, LearningModule> moduleOfLesson = {
  for (final m in curriculum)
    for (final l in m.lessons) l.id: m,
};

Lesson? nextLesson(String id) {
  final i = allLessons.indexWhere((l) => l.id == id);
  return i >= 0 && i + 1 < allLessons.length ? allLessons[i + 1] : null;
}

Lesson? previousLesson(String id) {
  final i = allLessons.indexWhere((l) => l.id == id);
  return i > 0 ? allLessons[i - 1] : null;
}

/// First lesson the learner hasn't completed (in path order).
Lesson? firstIncomplete(Set<String> completed) {
  for (final l in allLessons) {
    if (!completed.contains(l.id)) return l;
  }
  return null;
}
