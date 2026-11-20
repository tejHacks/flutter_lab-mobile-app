import 'package:flutter/material.dart';

import '../../models/lesson.dart';
import '../../state/app_state.dart';
import '../common/progress_ring.dart';
import 'lesson_screen.dart';

class ModuleScreen extends StatelessWidget {
  const ModuleScreen({super.key, required this.module});
  final LearningModule module;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final done = module.lessons.where((l) => state.isCompleted(l.id)).length;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 210,
          foregroundColor: Colors.white,
          backgroundColor: module.color,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsetsDirectional.only(start: 56, bottom: 14, end: 16),
            title: Text(module.title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [module.color, Color.lerp(module.color, Colors.black, 0.35)!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(children: [
                Positioned(
                  right: -20,
                  top: 10,
                  child: Icon(module.icon, size: 170, color: Colors.white.withValues(alpha: 0.12)),
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 54,
                  child: SafeArea(
                    child: Text(module.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.9), height: 1.35)),
                  ),
                ),
              ]),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Row(children: [
              ProgressRing(
                value: done / module.lessons.length,
                size: 44,
                stroke: 5,
                color: module.color,
                child: Text('$done', style: const TextStyle(fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text('$done of ${module.lessons.length} lessons · ~${module.minutes} min',
                    style: TextStyle(color: scheme.onSurfaceVariant)),
              ),
              LevelBadge(module.level.label, module.level.color),
            ]),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList.separated(
            itemCount: module.lessons.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final lesson = module.lessons[i];
              final isDone = state.isCompleted(lesson.id);
              return Card(
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  onTap: () => openLesson(context, lesson),
                  leading: CircleAvatar(
                    backgroundColor: isDone ? module.color : module.color.withValues(alpha: 0.12),
                    foregroundColor: isDone ? Colors.white : module.color,
                    child: isDone
                        ? const Icon(Icons.check_rounded)
                        : Text('${i + 1}', style: const TextStyle(fontWeight: FontWeight.w800)),
                  ),
                  title: Text(lesson.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text('${lesson.summary}\n${lesson.minutes} min'
                        '${lesson.quiz.isNotEmpty ? ' · ${lesson.quiz.length} quiz question${lesson.quiz.length > 1 ? 's' : ''}' : ''}'),
                  ),
                  isThreeLine: true,
                  trailing: state.isBookmarked(lesson.id)
                      ? Icon(Icons.bookmark, color: module.color)
                      : const Icon(Icons.chevron_right),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
