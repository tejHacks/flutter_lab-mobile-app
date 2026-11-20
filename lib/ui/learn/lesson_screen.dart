import 'package:flutter/material.dart';

import '../../data/curriculum.dart';
import '../../models/lesson.dart';
import '../../state/app_state.dart';
import '../common/sections.dart';
import 'quiz_card.dart';

/// Opens a lesson and remembers it as the "continue" lesson.
void openLesson(BuildContext context, Lesson lesson, {bool replace = false}) {
  AppScope.read(context).openLesson(lesson.id);
  final route = MaterialPageRoute<void>(builder: (_) => LessonScreen(lesson: lesson));
  replace ? Navigator.of(context).pushReplacement(route) : Navigator.of(context).push(route);
}

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key, required this.lesson});
  final Lesson lesson;

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _complete() {
    final state = AppScope.read(context);
    state.setCompleted(widget.lesson.id, true);
    final next = nextLesson(widget.lesson.id);
    if (next != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('✅ "${widget.lesson.title}" complete!'),
          duration: const Duration(milliseconds: 1400),
        ));
      openLesson(context, next, replace: true);
    } else {
      Navigator.of(context).pop();
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Text('🏆', style: TextStyle(fontSize: 48)),
          title: const Text('You finished FlutterLab!'),
          content: const Text('Amazing work. Now go build something awesome — and keep practising in the Practice tab.'),
          actions: [FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Let\'s go!'))],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final module = moduleOfLesson[lesson.id]!;
    final state = AppScope.of(context);
    final done = state.isCompleted(lesson.id);
    final index = module.lessons.indexOf(lesson);
    final prev = previousLesson(lesson.id);
    final next = nextLesson(lesson.id);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(module.title.toUpperCase(),
              style: TextStyle(fontSize: 11.5, letterSpacing: 1, color: module.color, fontWeight: FontWeight.w800)),
          Text('Lesson ${index + 1} of ${module.lessons.length}', style: const TextStyle(fontSize: 15)),
        ]),
        actions: [
          IconButton(
            tooltip: state.isBookmarked(lesson.id) ? 'Remove bookmark' : 'Bookmark',
            icon: Icon(state.isBookmarked(lesson.id) ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () => state.toggleBookmark(lesson.id),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: ListenableBuilder(
            listenable: _scroll,
            builder: (context, _) {
              final p = _scroll.hasClients && _scroll.position.hasContentDimensions && _scroll.position.maxScrollExtent > 0
                  ? (_scroll.offset / _scroll.position.maxScrollExtent).clamp(0.0, 1.0)
                  : 0.0;
              return LinearProgressIndicator(
                value: p,
                minHeight: 3,
                color: module.color,
                backgroundColor: Colors.transparent,
              );
            },
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          controller: _scroll,
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 32),
          children: [
            // ---------------- Header
            Text(lesson.title, style: theme.textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text(lesson.summary, style: theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 10),
            Wrap(spacing: 8, children: [
              Chip(
                avatar: const Icon(Icons.schedule, size: 16),
                label: Text('${lesson.minutes} min read'),
                visualDensity: VisualDensity.compact,
              ),
              if (lesson.quiz.isNotEmpty)
                Chip(
                  avatar: const Icon(Icons.quiz_outlined, size: 16),
                  label: Text('${lesson.quiz.length} question${lesson.quiz.length > 1 ? 's' : ''}'),
                  visualDensity: VisualDensity.compact,
                ),
              if (done)
                const Chip(
                  avatar: Icon(Icons.check_circle, size: 16, color: Color(0xFF2E9E5B)),
                  label: Text('Completed'),
                  visualDensity: VisualDensity.compact,
                ),
            ]),
            const Divider(height: 28),

            // ---------------- Content
            for (final section in lesson.sections) ...[
              SectionView(section),
              const SizedBox(height: 16),
            ],

            // ---------------- Quiz
            if (lesson.quiz.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(children: [
                Icon(Icons.psychology_alt_rounded, color: module.color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Check your understanding',
                      style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w800)),
                ),
              ]),
              const SizedBox(height: 10),
              for (var i = 0; i < lesson.quiz.length; i++) ...[
                QuizCard(question: lesson.quiz[i], number: i + 1),
                const SizedBox(height: 10),
              ],
            ],

            // ---------------- Footer navigation
            const SizedBox(height: 12),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
                backgroundColor: module.color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _complete,
              icon: Icon(next == null ? Icons.emoji_events : Icons.check_rounded),
              label: Text(
                next == null ? 'Finish course' : (done ? 'Next lesson' : 'Mark complete & continue'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 8),
            Row(children: [
              if (prev != null)
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => openLesson(context, prev, replace: true),
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: Text(prev.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                )
              else
                const Spacer(),
              if (done)
                TextButton(
                  onPressed: () => state.setCompleted(lesson.id, false),
                  child: const Text('Mark incomplete'),
                ),
            ]),
            if (next != null)
              Center(
                child: Text('Up next: ${next.title}',
                    style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ),
          ],
        ),
      ),
    );
  }
}
