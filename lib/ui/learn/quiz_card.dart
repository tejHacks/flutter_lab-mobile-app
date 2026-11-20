import 'package:flutter/material.dart';

import '../../models/lesson.dart';
import '../../state/app_state.dart';
import '../common/rich.dart';

/// One multiple-choice question. Tap an option to answer; shows feedback + why.
class QuizCard extends StatefulWidget {
  const QuizCard({super.key, required this.question, this.number, this.onAnswered});
  final QuizQuestion question;
  final int? number;
  final ValueChanged<bool>? onAnswered;

  @override
  State<QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  int? _picked;

  void _pick(int i) {
    if (_picked != null) return;
    setState(() => _picked = i);
    final correct = i == widget.question.answer;
    AppScope.read(context).recordQuizAnswer(correct);
    widget.onAnswered?.call(correct);
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.question;
    final scheme = Theme.of(context).colorScheme;
    const green = Color(0xFF2E9E5B);
    final red = scheme.error;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (widget.number != null)
            Text('QUESTION ${widget.number}',
                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, letterSpacing: 1, color: scheme.primary)),
          const SizedBox(height: 4),
          Rich(q.question, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          for (var i = 0; i < q.options.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _OptionTile(
                label: q.options[i],
                letter: String.fromCharCode(65 + i),
                state: _picked == null
                    ? _OptState.idle
                    : i == q.answer
                        ? _OptState.correct
                        : i == _picked
                            ? _OptState.wrong
                            : _OptState.dimmed,
                onTap: () => _pick(i),
              ),
            ),
          if (_picked != null)
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              child: Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (_picked == q.answer ? green : red).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(_picked == q.answer ? Icons.celebration : Icons.lightbulb_outline,
                      color: _picked == q.answer ? green : red),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Rich(
                      '${_picked == q.answer ? '**Correct!** ' : '**Not quite.** '}${q.explanation}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(height: 1.45),
                    ),
                  ),
                ]),
              ),
            ),
          if (_picked != null && _picked != q.answer)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => setState(() => _picked = null),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Try again'),
              ),
            ),
        ]),
      ),
    );
  }
}

enum _OptState { idle, correct, wrong, dimmed }

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.label, required this.letter, required this.state, required this.onTap});
  final String label, letter;
  final _OptState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const green = Color(0xFF2E9E5B);
    final (Color border, Color? fill, Widget? trailing) = switch (state) {
      _OptState.idle => (scheme.outlineVariant, null, null),
      _OptState.correct => (green, green.withValues(alpha: 0.12), const Icon(Icons.check_circle, color: green)),
      _OptState.wrong => (scheme.error, scheme.error.withValues(alpha: 0.1), Icon(Icons.cancel, color: scheme.error)),
      _OptState.dimmed => (scheme.outlineVariant.withValues(alpha: 0.4), null, null),
    };
    return Material(
      color: fill ?? Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: border, width: 1.5),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: state == _OptState.idle ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          child: Row(children: [
            CircleAvatar(
              radius: 13,
              backgroundColor: scheme.surfaceContainerHighest,
              child: Text(letter, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Opacity(
                opacity: state == _OptState.dimmed ? 0.5 : 1,
                child: Rich(label, style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
            ?trailing,
          ]),
        ),
      ),
    );
  }
}
