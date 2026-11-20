import 'package:flutter/material.dart';

import '../../data/catalog.dart';
import '../../data/curriculum.dart';
import '../common/code_block.dart';
import '../common/sections.dart';
import '../learn/lesson_screen.dart';

class WidgetDetailScreen extends StatelessWidget {
  const WidgetDetailScreen({super.key, required this.entry});
  final CatalogEntry entry;

  @override
  Widget build(BuildContext context) {
    final lesson = entry.lesson == null ? null : lessonById[entry.lesson];
    final related = catalog.where((e) => e.category == entry.category && e != entry).take(6).toList();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(entry.name)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Chip(label: Text(entry.category), visualDensity: VisualDensity.compact),
          ),
          const SizedBox(height: 8),
          Text(entry.description, style: theme.textTheme.bodyLarge!.copyWith(height: 1.5)),
          const SizedBox(height: 16),
          CodeBlock(code: entry.snippet, caption: 'Usage'),
          if (entry.demo != null) ...[
            const SizedBox(height: 16),
            DemoFrame(demoKey: entry.demo!),
          ],
          if (lesson != null) ...[
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: Icon(moduleOfLesson[lesson.id]!.icon, color: moduleOfLesson[lesson.id]!.color),
                title: Text('Learn more: ${lesson.title}'),
                subtitle: Text(moduleOfLesson[lesson.id]!.title),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () => openLesson(context, lesson),
              ),
            ),
          ],
          if (related.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text('Related widgets', style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final r in related)
                ActionChip(
                  label: Text(r.name),
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => WidgetDetailScreen(entry: r)),
                  ),
                ),
            ]),
          ],
          const SizedBox(height: 16),
          Text('Full API docs: api.flutter.dev → search "${entry.name.split(' ').first}"',
              style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
