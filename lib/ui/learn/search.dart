import 'package:flutter/material.dart';

import '../../data/catalog.dart';
import '../../data/curriculum.dart';
import '../catalog/widget_detail_screen.dart';
import 'lesson_screen.dart';

/// Searches lessons and the widget catalog.
class LabSearchDelegate extends SearchDelegate<void> {
  LabSearchDelegate() : super(searchFieldLabel: 'Search lessons & widgets');

  @override
  List<Widget> buildActions(BuildContext context) => [
        if (query.isNotEmpty) IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
      ];

  @override
  Widget buildLeading(BuildContext context) =>
      IconButton(icon: const BackButtonIcon(), onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) => _results(context);

  @override
  Widget buildSuggestions(BuildContext context) => _results(context);

  Widget _results(BuildContext context) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      return ListView(padding: const EdgeInsets.all(16), children: [
        const Text('Try: "row", "setState", "null", "list", "animation", "http"'),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final s in ['Row', 'setState', 'Null Safety', 'ListView', 'Navigator', 'Future', 'Theme', 'Hero'])
            ActionChip(label: Text(s), onPressed: () => query = s),
        ]),
      ]);
    }
    bool matchesText(String text) => text.toLowerCase().contains(q);
    final lessons = allLessons.where((l) => matchesText(l.title) || matchesText(l.summary)).toList();
    final widgets = catalog.where((w) => matchesText(w.name) || matchesText(w.description)).toList();

    if (lessons.isEmpty && widgets.isEmpty) {
      return const Center(child: Text('No results. Try another word.'));
    }

    return ListView(children: [
      if (lessons.isNotEmpty) const _Header('Lessons'),
      for (final l in lessons)
        ListTile(
          leading: Icon(moduleOfLesson[l.id]!.icon, color: moduleOfLesson[l.id]!.color),
          title: Text(l.title),
          subtitle: Text('${moduleOfLesson[l.id]!.title} · ${l.summary}', maxLines: 2, overflow: TextOverflow.ellipsis),
          onTap: () => openLesson(context, l),
        ),
      if (widgets.isNotEmpty) const _Header('Widgets'),
      for (final w in widgets)
        ListTile(
          leading: const Icon(Icons.widgets_outlined),
          title: Text(w.name),
          subtitle: Text(w.description, maxLines: 1, overflow: TextOverflow.ellipsis),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => WidgetDetailScreen(entry: w))),
        ),
    ]);
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Text(text.toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.w800, letterSpacing: 1, fontSize: 12, color: Theme.of(context).colorScheme.primary)),
      );
}
