import 'package:flutter/material.dart';

import '../../data/catalog.dart';
import 'widget_detail_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});
  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _query = '';
  String? _category;

  static const _icons = {
    'Layout': Icons.dashboard_outlined,
    'Basics': Icons.text_fields,
    'Buttons': Icons.smart_button,
    'Input': Icons.keyboard_outlined,
    'Scrolling': Icons.swap_vert,
    'Navigation': Icons.alt_route,
    'Feedback': Icons.notifications_active_outlined,
    'Styling': Icons.palette_outlined,
    'Animation': Icons.animation,
    'Async & State': Icons.sync,
  };

  @override
  Widget build(BuildContext context) {
    final q = _query.toLowerCase();
    final items = catalog
        .where((e) => _category == null || e.category == _category)
        .where((e) => q.isEmpty || e.name.toLowerCase().contains(q) || e.description.toLowerCase().contains(q))
        .toList();
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      bottom: false,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(children: [
            Text('Widget Catalog',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w900)),
            const Spacer(),
            Text('${catalog.length} widgets', style: TextStyle(color: scheme.onSurfaceVariant)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: const InputDecoration(
              hintText: 'Search widgets…',
              prefixIcon: Icon(Icons.search),
              isDense: true,
            ),
          ),
        ),
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  label: const Text('All'),
                  selected: _category == null,
                  onSelected: (_) => setState(() => _category = null),
                ),
              ),
              for (final c in catalogCategories)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    avatar: Icon(_icons[c], size: 16),
                    label: Text(c),
                    selected: _category == c,
                    onSelected: (_) => setState(() => _category = _category == c ? null : c),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? const Center(child: Text('No widgets match.'))
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 240,
                    mainAxisExtent: 132,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final e = items[i];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => WidgetDetailScreen(entry: e)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(children: [
                              Icon(_icons[e.category], size: 18, color: scheme.primary),
                              const Spacer(),
                              if (e.demo != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: scheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text('LIVE',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: scheme.onPrimaryContainer)),
                                ),
                            ]),
                            const SizedBox(height: 8),
                            Text(e.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                            const SizedBox(height: 4),
                            Expanded(
                              child: Text(e.description,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant, height: 1.3)),
                            ),
                          ]),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ]),
    );
  }
}
