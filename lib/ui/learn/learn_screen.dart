import 'package:flutter/material.dart';

import '../../data/curriculum.dart';
import '../../models/lesson.dart';
import '../../state/app_state.dart';
import '../../sync/sync_service.dart';
import '../common/progress_ring.dart';
import '../me/account_card.dart';
import 'lesson_screen.dart';
import 'module_screen.dart';
import 'search.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final done = state.completed.where(lessonById.containsKey).length;
    final total = allLessons.length;
    final resume = state.lastLessonId != null && !state.isCompleted(state.lastLessonId!)
        ? lessonById[state.lastLessonId!]
        : firstIncomplete(state.completed);

    return SafeArea(
      bottom: false,
      child: CustomScrollView(slivers: [
        SliverAppBar(
          floating: true,
          title: const Row(children: [
            FlutterLogo(size: 26),
            SizedBox(width: 10),
            Flexible(child: Text('FlutterLab', overflow: TextOverflow.ellipsis)),
          ]),
          actions: [
            const _SyncButton(),
            IconButton(
              tooltip: 'Search',
              icon: const Icon(Icons.search),
              onPressed: () => showSearch(context: context, delegate: LabSearchDelegate()),
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          sliver: SliverToBoxAdapter(
            child: _Hero(done: done, total: total, streak: state.streak, resume: resume),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          sliver: SliverToBoxAdapter(
            child: Text('Your learning path',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w800)),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverList.builder(
            itemCount: curriculum.length,
            itemBuilder: (context, i) => _ModuleTile(
              module: curriculum[i],
              number: i + 1,
              isLast: i == curriculum.length - 1,
            ),
          ),
        ),
      ]),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.done, required this.total, required this.streak, required this.resume});
  final int done, total, streak;
  final Lesson? resume;

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : done / total;
    final module = resume == null ? null : moduleOfLesson[resume!.id];
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF0B6BCB), Color(0xFF02569B), Color(0xFF13B9FD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0, 0.55, 1],
        ),
        boxShadow: [
          BoxShadow(color: const Color(0xFF0B6BCB).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                done == 0 ? 'Welcome, future Flutter dev 👋' : 'Keep going! 💪',
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text('$done of $total lessons complete',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85))),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('🔥 $streak-day streak',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12.5)),
              ),
            ]),
          ),
          ProgressRing(
            value: pct,
            size: 76,
            stroke: 8,
            color: Colors.white,
            trackColor: Colors.white24,
            child: Text('${(pct * 100).round()}%',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17)),
          ),
        ]),
        if (resume != null) ...[
          const SizedBox(height: 16),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => openLesson(context, resume!),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: module!.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(module.icon, color: module.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(done == 0 ? 'START HERE' : 'CONTINUE',
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF0B6BCB), letterSpacing: 0.8)),
                      Text(resume!.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5, color: Colors.black87)),
                      Text('${module.title} · ${resume!.minutes} min',
                          style: const TextStyle(fontSize: 12.5, color: Colors.black54)),
                    ]),
                  ),
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFF0B6BCB),
                    child: Icon(Icons.play_arrow_rounded, color: Colors.white),
                  ),
                ]),
              ),
            ),
          ),
        ] else ...[
          const SizedBox(height: 12),
          const Text('🎉 You finished every lesson! Keep sharp in the Practice tab.',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ]),
    );
  }
}

class _ModuleTile extends StatelessWidget {
  const _ModuleTile({required this.module, required this.number, required this.isLast});
  final LearningModule module;
  final int number;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final done = module.lessons.where((l) => state.isCompleted(l.id)).length;
    final pct = done / module.lessons.length;
    final complete = done == module.lessons.length;
    final scheme = Theme.of(context).colorScheme;

    return IntrinsicHeight(
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // The "path" line with numbered node
        SizedBox(
          width: 40,
          child: Column(children: [
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(top: 18),
              decoration: BoxDecoration(
                color: complete ? module.color : scheme.surface,
                shape: BoxShape.circle,
                border: Border.all(color: module.color, width: 2.5),
              ),
              alignment: Alignment.center,
              child: complete
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : Text('$number', style: TextStyle(fontWeight: FontWeight.w800, color: module.color)),
            ),
            if (!isLast)
              Expanded(
                child: Container(width: 2.5, color: module.color.withValues(alpha: 0.25)),
              ),
          ]),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ModuleScreen(module: module)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: module.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(module.icon, color: module.color),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(module.title,
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                          const SizedBox(height: 3),
                          LevelBadge(module.level.label, module.level.color),
                        ]),
                      ),
                      const Icon(Icons.chevron_right),
                    ]),
                    const SizedBox(height: 10),
                    Text(module.description,
                        style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13.5, height: 1.35)),
                    const SizedBox(height: 10),
                    Row(children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: pct,
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(3),
                          color: module.color,
                          backgroundColor: module.color.withValues(alpha: 0.12),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text('$done/${module.lessons.length} · ${module.minutes} min',
                          style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                    ]),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

/// Cloud icon in the app bar: shows sync status, opens the account sheet.
class _SyncButton extends StatelessWidget {
  const _SyncButton();

  @override
  Widget build(BuildContext context) {
    final sync = SyncScope.maybeOf(context);
    if (sync == null) return const SizedBox.shrink();
    final (IconData icon, String tip) = !sync.signedIn
        ? (Icons.cloud_off_outlined, 'Sign in to sync')
        : sync.error != null
            ? (Icons.cloud_off, 'Sync problem')
            : sync.hasPendingWrites || sync.busy
                ? (Icons.cloud_upload_outlined, 'Syncing…')
                : (Icons.cloud_done_outlined, 'Progress synced');
    return IconButton(
      tooltip: tip,
      icon: Icon(icon),
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (sheetContext) => SyncScope(
          sync: sync,
          child: const SafeArea(
            child: Padding(padding: EdgeInsets.fromLTRB(16, 0, 16, 16), child: AccountCard()),
          ),
        ),
      ),
    );
  }
}
