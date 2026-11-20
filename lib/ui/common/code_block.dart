import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../demos/dart_runner.dart';
import '../../state/app_state.dart';
import '../theme.dart';

const _mono = TextStyle(
  fontFamily: 'monospace',
  fontFamilyFallback: ['Menlo', 'Courier'],
  height: 1.45,
);

/// A dark "code editor" box with syntax highlighting, horizontal scrolling,
/// a Copy button and (optionally) a Run button for runnable Dart examples.
class CodeBlock extends StatefulWidget {
  const CodeBlock({super.key, required this.code, this.caption, this.runKey, this.isShell = false});

  final String code;
  final String? caption;
  final String? runKey;
  final bool isShell;

  @override
  State<CodeBlock> createState() => _CodeBlockState();
}

class _CodeBlockState extends State<CodeBlock> {
  List<String>? _output;
  bool _running = false;

  Future<void> _run() async {
    final example = dartExamples[widget.runKey];
    if (example == null) return;
    setState(() {
      _running = true;
      _output = [];
    });
    try {
      await example((Object? line) {
        if (mounted) setState(() => _output!.add('$line'));
      });
    } catch (e) {
      if (mounted) setState(() => _output!.add('Uncaught exception: $e'));
    }
    if (mounted) setState(() => _running = false);
  }

  @override
  Widget build(BuildContext context) {
    final scale = AppScope.of(context).codeFontScale;
    final canRun = widget.runKey != null && dartExamples.containsKey(widget.runKey);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: CodeColors.background,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header bar
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 6, 4, 0),
                child: Row(
                  children: [
                    Icon(widget.isShell ? Icons.terminal : Icons.code,
                        size: 16, color: CodeColors.comment),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.caption ?? (widget.isShell ? 'Terminal' : 'Dart'),
                        style: const TextStyle(color: CodeColors.comment, fontSize: 12.5),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (canRun)
                      TextButton.icon(
                        onPressed: _running ? null : _run,
                        icon: const Icon(Icons.play_arrow_rounded, size: 18),
                        label: const Text('Run'),
                        style: TextButton.styleFrom(
                          foregroundColor: CodeColors.string,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    IconButton(
                      tooltip: 'Copy',
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.copy_rounded, size: 17, color: CodeColors.comment),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: widget.code));
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(const SnackBar(
                            content: Text('Code copied'),
                            duration: Duration(seconds: 1),
                          ));
                      },
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
                child: Text.rich(
                  TextSpan(
                    style: _mono.copyWith(fontSize: 13.5 * scale, color: CodeColors.plain),
                    children: widget.isShell ? _shell(widget.code) : highlightDart(widget.code),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_output != null) _OutputConsole(lines: _output!, running: _running, scale: scale),
      ],
    );
  }

  List<InlineSpan> _shell(String src) => [
        for (final line in src.split('\n'))
          TextSpan(
            text: '$line\n',
            style: TextStyle(
              color: line.trimLeft().startsWith('#') ? CodeColors.comment : CodeColors.plain,
            ),
          ),
      ];
}

class _OutputConsole extends StatelessWidget {
  const _OutputConsole({required this.lines, required this.running, required this.scale});
  final List<String> lines;
  final bool running;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CodeColors.string.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.chevron_right, size: 16, color: CodeColors.string),
            Text(running ? 'Running…' : 'Output',
                style: const TextStyle(color: CodeColors.string, fontSize: 12.5)),
          ]),
          const SizedBox(height: 6),
          if (lines.isEmpty && !running)
            Text('(nothing printed)', style: _mono.copyWith(color: CodeColors.comment)),
          for (final l in lines)
            Text(l, style: _mono.copyWith(fontSize: 13 * scale, color: CodeColors.plain)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// A small, dependency-free Dart syntax highlighter.
// ---------------------------------------------------------------------------

const _keywords = {
  'abstract', 'as', 'assert', 'async', 'await', 'base', 'break', 'case', 'catch',
  'class', 'const', 'continue', 'default', 'do', 'dynamic', 'else', 'enum',
  'extends', 'extension', 'external', 'factory', 'false', 'final', 'finally',
  'for', 'get', 'if', 'implements', 'import', 'in', 'interface', 'is', 'late',
  'library', 'mixin', 'new', 'null', 'on', 'operator', 'part', 'required',
  'rethrow', 'return', 'sealed', 'set', 'show', 'static', 'super', 'switch',
  'sync', 'this', 'throw', 'true', 'try', 'typedef', 'var', 'void', 'when',
  'while', 'with', 'yield', 'hide', 'export', 'covariant', 'deferred',
};

final _token = RegExp(
  r'(//[^\n]*|/\*[\s\S]*?\*/)' // 1 comment
  r"|('''[\s\S]*?'''|" r'"""[\s\S]*?"""' r"|'(?:\\.|[^'\\\n])*'" r'|"(?:\\.|[^"\\\n])*")' // 2 string
  r'|(@\w+)' // 3 annotation
  r'|(\b\d+(?:\.\d+)?\b)' // 4 number
  r'|(\b[A-Za-z_]\w*\b)', // 5 identifier
);

List<InlineSpan> highlightDart(String src) {
  final spans = <InlineSpan>[];
  var last = 0;
  for (final m in _token.allMatches(src)) {
    if (m.start > last) spans.add(TextSpan(text: src.substring(last, m.start)));
    final text = m.group(0)!;
    Color? color;
    var italic = false;
    if (m.group(1) != null) {
      color = CodeColors.comment;
      italic = true;
    } else if (m.group(2) != null) {
      color = CodeColors.string;
    } else if (m.group(3) != null) {
      color = CodeColors.annotation;
    } else if (m.group(4) != null) {
      color = CodeColors.number;
    } else if (_keywords.contains(text)) {
      color = CodeColors.keyword;
    } else if (text[0].toUpperCase() == text[0] && text[0] != '_') {
      color = CodeColors.type;
    } else if (m.end < src.length && src[m.end] == '(') {
      color = CodeColors.function;
    }
    spans.add(TextSpan(
      text: text,
      style: color == null
          ? null
          : TextStyle(color: color, fontStyle: italic ? FontStyle.italic : null),
    ));
    last = m.end;
  }
  if (last < src.length) spans.add(TextSpan(text: src.substring(last)));
  return spans;
}
