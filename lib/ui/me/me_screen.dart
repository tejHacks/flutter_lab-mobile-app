import 'package:flutter/material.dart';

import '../../data/curriculum.dart';
import '../../data/practice.dart';
import '../../state/app_state.dart';
import '../common/progress_ring.dart';
import '../learn/lesson_screen.dart';
import 'account_card.dart';

class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final scheme = Theme.of(context).colorScheme;
    final done = state.completed.where(lessonById.containsKey).length;
    final modulesDone = curriculum.where((m) => m.lessons.every((l) => state.isCompleted(l.id))).length;
    final minutes = allLessons.where((l) => state.isCompleted(l.id)).fold<int>(0, (s, l) => s + l.minutes);
    final bookmarks = state.bookmarks.where(lessonById.containsKey).toList();

    return SafeArea(
      bottom: false,
      child: ListView(padding: const EdgeInsets.fromLTRB(16, 12, 16, 32), children: [
        Text('Me', style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 14),
        const AccountCard(),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              ProgressRing(
                value: done / allLessons.length,
                size: 84,
                stroke: 9,
                child: Text('${(done / allLessons.length * 100).round()}%',
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_rank(done / allLessons.length),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  _line(Icons.menu_book, '$done / ${allLessons.length} lessons'),
                  _line(Icons.view_module, '$modulesDone / ${curriculum.length} modules'),
                  _line(Icons.timer_outlined, '~$minutes min studied'),
                  _line(Icons.local_fire_department, '${state.streak}-day streak'),
                ]),
              ),
            ]),
          ),
        ),
        const SizedBox(height: 18),
        _title(context, 'Module progress'),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(children: [
              for (final m in curriculum)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  child: Row(children: [
                    Icon(m.icon, size: 18, color: m.color),
                    const SizedBox(width: 10),
                    SizedBox(width: 130, child: Text(m.title, maxLines: 1, overflow: TextOverflow.ellipsis)),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: m.lessons.where((l) => state.isCompleted(l.id)).length / m.lessons.length,
                        minHeight: 6,
                        color: m.color,
                        backgroundColor: m.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ]),
                ),
            ]),
          ),
        ),
        const SizedBox(height: 18),
        _title(context, 'Bookmarks'),
        if (bookmarks.isEmpty)
          Card(
            child: ListTile(
              leading: const Icon(Icons.bookmark_border),
              title: const Text('No bookmarks yet'),
              subtitle: Text('Tap the bookmark icon in any lesson to save it here.',
                  style: TextStyle(color: scheme.onSurfaceVariant)),
            ),
          )
        else
          Card(
            child: Column(children: [
              for (final id in bookmarks)
                  ListTile(
                    leading: Icon(Icons.bookmark, color: moduleOfLesson[id]!.color),
                    title: Text(lessonById[id]!.title),
                    subtitle: Text(moduleOfLesson[id]!.title),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => openLesson(context, lessonById[id]!),
                  ),
            ]),
          ),
        const SizedBox(height: 18),
        _title(context, 'Reference'),
        Card(
          child: Column(children: [
            ListTile(
              leading: const Icon(Icons.menu_book_outlined),
              title: const Text('Glossary'),
              subtitle: Text('${glossary.length} Flutter & Dart terms explained'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GlossaryScreen())),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.terminal),
              title: const Text('CLI cheat sheet'),
              subtitle: const Text('The flutter commands you\'ll use daily'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CheatSheetScreen())),
            ),
          ]),
        ),
        const SizedBox(height: 18),
        _title(context, 'Settings'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const Text('Theme', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.brightness_auto), label: Text('System')),
                  ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode), label: Text('Light')),
                  ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode), label: Text('Dark')),
                ],
                selected: {state.themeMode},
                onSelectionChanged: (s) => state.setThemeMode(s.first),
              ),
              const SizedBox(height: 14),
              Text('Code font size: ${(state.codeFontScale * 100).round()}%',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              Slider(
                value: state.codeFontScale,
                min: 0.8,
                max: 1.4,
                divisions: 6,
                onChanged: state.setCodeFontScale,
              ),
            ]),
          ),
        ),
        const SizedBox(height: 10),
        Card(
          child: ListTile(
            leading: Icon(Icons.restart_alt, color: scheme.error),
            title: Text('Reset progress', style: TextStyle(color: scheme.error)),
            subtitle: const Text('Clears lessons, bookmarks, quiz stats and challenges'),
            onTap: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Reset all progress?'),
                  content: const Text('This can\'t be undone.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                    FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Reset')),
                  ],
                ),
              );
              if (ok == true) await state.resetProgress();
            },
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Column(children: [
            const FlutterLogo(size: 32),
            const SizedBox(height: 6),
            Text('FlutterLab v1.0', style: TextStyle(color: scheme.onSurfaceVariant)),
            Text('Built with Flutter — the app itself is a lesson. Read its source in lib/!',
                textAlign: TextAlign.center, style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12)),
          ]),
        ),
      ]),
    );
  }

  static String _rank(double p) => switch (p) {
        >= 1 => '🏆 Flutter Graduate',
        >= 0.75 => '🚀 Advanced Builder',
        >= 0.5 => '⚡ Intermediate Dev',
        >= 0.2 => '🌱 Rising Beginner',
        _ => '🐣 Fresh Starter',
      };

  static Widget _line(IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 3),
        child: Row(children: [Icon(icon, size: 16), const SizedBox(width: 6), Expanded(child: Text(text))]),
      );

  static Widget _title(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 4),
        child: Text(text, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w800)),
      );
}

class GlossaryScreen extends StatefulWidget {
  const GlossaryScreen({super.key});
  @override
  State<GlossaryScreen> createState() => _GlossaryScreenState();
}

class _GlossaryScreenState extends State<GlossaryScreen> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final items = glossary
        .where((g) => _q.isEmpty || g.$1.toLowerCase().contains(_q) || g.$2.toLowerCase().contains(_q))
        .toList()
      ..sort((a, b) => a.$1.toLowerCase().compareTo(b.$1.toLowerCase()));
    return Scaffold(
      appBar: AppBar(title: const Text('Glossary')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: TextField(
            decoration: const InputDecoration(hintText: 'Search terms…', prefixIcon: Icon(Icons.search), isDense: true),
            onChanged: (v) => setState(() => _q = v.toLowerCase()),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 24),
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) => ListTile(
              title: Text(items[i].$1, style: const TextStyle(fontWeight: FontWeight.w800)),
              subtitle: Text(items[i].$2),
            ),
          ),
        ),
      ]),
    );
  }
}

class CheatSheetScreen extends StatelessWidget {
  const CheatSheetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('CLI cheat sheet')),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        itemCount: cliCheatSheet.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final (cmd, desc) = cliCheatSheet[i];
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: scheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SelectableText(cmd,
                  style: TextStyle(
                      fontFamily: 'monospace',
                      fontFamilyFallback: const ['Menlo', 'Courier'],
                      fontWeight: FontWeight.w700,
                      color: scheme.primary)),
              const SizedBox(height: 2),
              Text(desc),
            ]),
          );
        },
      ),
    );
  }
}
