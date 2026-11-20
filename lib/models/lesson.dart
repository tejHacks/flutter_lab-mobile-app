import 'package:flutter/material.dart';

/// How hard a module is. Used for badges and colours.
enum Level {
  beginner('Beginner', Color(0xFF2E9E5B)),
  intermediate('Intermediate', Color(0xFFE08A00)),
  advanced('Advanced', Color(0xFFD2414B));

  const Level(this.label, this.color);
  final String label;
  final Color color;
}

/// A lesson is made of a list of sections, rendered top to bottom.
sealed class Section {
  const Section();
}

class TextSection extends Section {
  const TextSection(this.text);
  final String text;
}

class HeadingSection extends Section {
  const HeadingSection(this.text);
  final String text;
}

class CodeSection extends Section {
  const CodeSection(this.code, {this.caption, this.runKey, this.isShell = false});
  final String code;
  final String? caption;

  /// If set, the code block gets a "Run" button that executes the matching
  /// example in `dart_runner.dart` and shows its printed output.
  final String? runKey;
  final bool isShell;
}

enum CalloutKind { tip, note, warning, analogy }

class CalloutSection extends Section {
  const CalloutSection(this.kind, this.text);
  final CalloutKind kind;
  final String text;
}

class BulletsSection extends Section {
  const BulletsSection(this.items, {this.numbered = false});
  final List<String> items;
  final bool numbered;
}

/// A live, interactive widget demo rendered inside the lesson.
class DemoSection extends Section {
  const DemoSection(this.demoKey, {this.caption});
  final String demoKey;
  final String? caption;
}

class QuizQuestion {
  const QuizQuestion(this.question, this.options, this.answer, this.explanation);
  final String question;
  final List<String> options;
  final int answer;
  final String explanation;
}

class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.summary,
    required this.minutes,
    required this.sections,
    this.quiz = const [],
  });

  final String id;
  final String title;
  final String summary;
  final int minutes;
  final List<Section> sections;
  final List<QuizQuestion> quiz;
}

class LearningModule {
  const LearningModule({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.icon,
    required this.color,
    required this.lessons,
  });

  final String id;
  final String title;
  final String description;
  final Level level;
  final IconData icon;
  final Color color;
  final List<Lesson> lessons;

  int get minutes => lessons.fold(0, (sum, l) => sum + l.minutes);
}
