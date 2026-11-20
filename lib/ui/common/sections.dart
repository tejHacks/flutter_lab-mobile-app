import 'package:flutter/material.dart';

import '../../demos/demo_registry.dart';
import '../../models/lesson.dart';
import 'code_block.dart';
import 'rich.dart';

/// Turns a [Section] into a widget. Uses Dart 3 pattern matching on a sealed class.
class SectionView extends StatelessWidget {
  const SectionView(this.section, {super.key});
  final Section section;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return switch (section) {
      TextSection(:final text) => Rich(text),
      HeadingSection(:final text) => Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(text,
              style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w800)),
        ),
      CodeSection(:final code, :final caption, :final runKey, :final isShell) =>
        CodeBlock(code: code, caption: caption, runKey: runKey, isShell: isShell),
      CalloutSection(:final kind, :final text) => Callout(kind: kind, text: text),
      BulletsSection(:final items, :final numbered) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < items.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 28,
                      child: numbered
                          ? CircleAvatar(
                              radius: 11,
                              backgroundColor: theme.colorScheme.primaryContainer,
                              child: Text('${i + 1}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onPrimaryContainer)),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 9, left: 6),
                              child: CircleAvatar(
                                  radius: 3, backgroundColor: theme.colorScheme.primary),
                            ),
                    ),
                    Expanded(child: Rich(items[i])),
                  ],
                ),
              ),
          ],
        ),
      DemoSection(:final demoKey, :final caption) => DemoFrame(demoKey: demoKey, caption: caption),
    };
  }
}

class Callout extends StatelessWidget {
  const Callout({super.key, required this.kind, required this.text});
  final CalloutKind kind;
  final String text;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final (IconData icon, String label, Color color) = switch (kind) {
      CalloutKind.tip => (Icons.lightbulb_rounded, 'Tip', const Color(0xFF2E9E5B)),
      CalloutKind.note => (Icons.info_rounded, 'Good to know', const Color(0xFF0B6BCB)),
      CalloutKind.warning => (Icons.warning_amber_rounded, 'Watch out', const Color(0xFFE08A00)),
      CalloutKind.analogy => (Icons.emoji_objects_outlined, 'Think of it like…', const Color(0xFF8E5BD8)),
    };
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: dark ? 0.16 : 0.09),
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w800))),
          ]),
          const SizedBox(height: 6),
          Rich(text, style: Theme.of(context).textTheme.bodyMedium!.copyWith(height: 1.5)),
        ],
      ),
    );
  }
}

/// A framed box hosting a live widget demo.
class DemoFrame extends StatelessWidget {
  const DemoFrame({super.key, required this.demoKey, this.caption});
  final String demoKey;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final builder = demos[demoKey];
    // A Material (not a coloured Container) so ListTile ripples inside demos show.
    return Material(
      color: scheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.primary.withValues(alpha: 0.5), width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: scheme.primary.withValues(alpha: 0.1),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(children: [
              Icon(Icons.touch_app_rounded, size: 18, color: scheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(caption ?? 'Live demo — try it!',
                    style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w700)),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: builder == null ? Text('Missing demo: $demoKey') : Builder(builder: builder),
          ),
        ],
      ),
    );
  }
}
