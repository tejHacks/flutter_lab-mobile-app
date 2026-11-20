import 'package:flutter/material.dart';

/// Renders text with lightweight inline formatting:
///   `code`  -> monospace chip
///   **bold** -> bold
class Rich extends StatelessWidget {
  const Rich(this.text, {super.key, this.style});
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final base = style ?? Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.55);
    return Text.rich(TextSpan(style: base, children: parseInline(context, text, base)));
  }
}

final _inline = RegExp(r'`([^`]+)`|\*\*([^*]+)\*\*');

List<InlineSpan> parseInline(BuildContext context, String text, TextStyle base) {
  final scheme = Theme.of(context).colorScheme;
  final spans = <InlineSpan>[];
  var last = 0;
  for (final m in _inline.allMatches(text)) {
    if (m.start > last) spans.add(TextSpan(text: text.substring(last, m.start)));
    if (m.group(1) != null) {
      spans.add(TextSpan(
        text: m.group(1),
        style: TextStyle(
          fontFamily: 'monospace',
          fontFamilyFallback: const ['Menlo', 'Courier'],
          fontSize: (base.fontSize ?? 16) * 0.9,
          color: scheme.primary,
          backgroundColor: scheme.primaryContainer.withValues(alpha: 0.45),
        ),
      ));
    } else {
      spans.add(TextSpan(text: m.group(2), style: const TextStyle(fontWeight: FontWeight.w700)));
    }
    last = m.end;
  }
  if (last < text.length) spans.add(TextSpan(text: text.substring(last)));
  return spans;
}
