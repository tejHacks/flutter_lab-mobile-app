import 'dart:math';

import 'package:flutter/material.dart';

import '../../data/curriculum.dart';
import '../../data/practice.dart';
import '../../models/lesson.dart';
import '../../state/app_state.dart';
import '../common/code_block.dart';
import '../common/rich.dart';
import '../learn/quiz_card.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  void _startQuiz(BuildContext context, String title, List<QuizQuestion> pool, {int count = 10}) {
    final questions = List.of(pool)..shuffle(Random());
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => QuizSessionScreen(title: title, questions: questions.take(count).toList()),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final scheme = Theme.of(context).colorScheme;
    final allQuestions = [for (final l in allLessons) ...l.quiz];
    final accuracy = state.quizAnswered == 0 ? 0 : (state.quizCorrect / state.quizAnswered * 100).round();
    final completedQuestions = [
      for (final l in allLessons)
        if (state.isCompleted(l.id)) ...l.quiz,
    ];

    return SafeArea(
      bottom: false,
      child: ListView(padding: const EdgeInsets.fromLTRB(16, 12, 16, 24), children: [
        Text('Practice', style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        Text('Retrieval practice makes knowledge stick. Little and often!',
            style: TextStyle(color: scheme.onSurfaceVariant)),
        const SizedBox(height: 14),
        Row(children: [
          _Stat(value: '${state.quizAnswered}', label: 'Answered', icon: Icons.quiz, color: const Color(0xFF0B6BCB)),
          const SizedBox(width: 10),
          _Stat(value: '$accuracy%', label: 'Accuracy', icon: Icons.track_changes, color: const Color(0xFF2E9E5B)),
          const SizedBox(width: 10),
          _Stat(
              value: '${state.solvedChallenges.length}/${challenges.length}',
              label: 'Challenges',
              icon: Icons.code,
              color: const Color(0xFF8E24AA)),
        ]),
        const SizedBox(height: 16),
        _BigAction(
          title: 'Quick Quiz',
          subtitle: '10 random questions from the whole course',
          icon: Icons.bolt,
          colors: const [Color(0xFFFF8A00), Color(0xFFE52E71)],
          onTap: () => _startQuiz(context, 'Quick Quiz', allQuestions),
        ),
        const SizedBox(height: 10),
        _BigAction(
          title: 'Review what you learned',
          subtitle: completedQuestions.isEmpty
              ? 'Complete some lessons first'
              : '${completedQuestions.length} questions from completed lessons',
          icon: Icons.replay,
          colors: const [Color(0xFF0B6BCB), Color(0xFF13B9FD)],
          onTap: completedQuestions.isEmpty
              ? null
              : () => _startQuiz(context, 'Review', completedQuestions, count: 15),
        ),
        const SizedBox(height: 22),
        _SectionTitle('Coding challenges'),
        const SizedBox(height: 8),
        for (final c in challenges)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: state.solvedChallenges.contains(c.id)
                      ? const Color(0xFF2E9E5B)
                      : scheme.surfaceContainerHighest,
                  child: Icon(
                    state.solvedChallenges.contains(c.id) ? Icons.check : Icons.terminal,
                    color: state.solvedChallenges.contains(c.id) ? Colors.white : scheme.onSurfaceVariant,
                  ),
                ),
                title: Text(c.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(c.level),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChallengeScreen(challenge: c))),
              ),
            ),
          ),
        const SizedBox(height: 14),
        _SectionTitle('Quiz by module'),
        const SizedBox(height: 8),
        for (final m in curriculum)
          if (m.lessons.any((l) => l.quiz.isNotEmpty))
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: ListTile(
                  leading: Icon(m.icon, color: m.color),
                  title: Text(m.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text('${m.lessons.fold<int>(0, (s, l) => s + l.quiz.length)} questions'),
                  trailing: const Icon(Icons.play_circle_outline),
                  onTap: () => _startQuiz(context, m.title, [for (final l in m.lessons) ...l.quiz], count: 12),
                ),
              ),
            ),
      ]),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;
  @override
  Widget build(BuildContext context) =>
      Text(text, style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w800));
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, required this.icon, required this.color});
  final String value, label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            FittedBox(child: Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900))),
            Text(label, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ]),
        ),
      ),
    );
  }
}

class _BigAction extends StatelessWidget {
  const _BigAction({required this.title, required this.subtitle, required this.icon, required this.colors, this.onTap});
  final String title, subtitle;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap == null ? 0.5 : 1,
      child: Material(
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(gradient: LinearGradient(colors: colors)),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(children: [
                Icon(icon, color: Colors.white, size: 34),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                    Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.9))),
                  ]),
                ),
                const Icon(Icons.arrow_forward, color: Colors.white),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================ Quiz session

class QuizSessionScreen extends StatefulWidget {
  const QuizSessionScreen({super.key, required this.title, required this.questions});
  final String title;
  final List<QuizQuestion> questions;

  @override
  State<QuizSessionScreen> createState() => _QuizSessionScreenState();
}

class _QuizSessionScreenState extends State<QuizSessionScreen> {
  int _index = 0;
  int _score = 0;
  bool _answered = false;

  @override
  Widget build(BuildContext context) {
    final total = widget.questions.length;
    final finished = _index >= total;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(value: finished ? 1 : _index / total, minHeight: 4),
        ),
      ),
      body: SafeArea(
        child: finished
            ? _Results(score: _score, total: total, onRetry: () => Navigator.of(context).pop())
            : ListView(padding: const EdgeInsets.all(16), children: [
                Row(children: [
                  Text('Question ${_index + 1} of $total', style: Theme.of(context).textTheme.titleMedium),
                  const Spacer(),
                  Chip(avatar: const Icon(Icons.star, size: 16, color: Colors.amber), label: Text('$_score')),
                ]),
                const SizedBox(height: 8),
                QuizCard(
                  key: ValueKey(_index),
                  question: widget.questions[_index],
                  onAnswered: (correct) => setState(() {
                    if (correct && !_answered) _score++;
                    _answered = true;
                  }),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                  onPressed: _answered
                      ? () => setState(() {
                            _index++;
                            _answered = false;
                          })
                      : null,
                  child: Text(_index == total - 1 ? 'See results' : 'Next question'),
                ),
              ]),
      ),
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({required this.score, required this.total, required this.onRetry});
  final int score, total;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0 : score / total;
    final (emoji, msg) = pct >= 0.9
        ? ('🏆', 'Outstanding! You really know this.')
        : pct >= 0.7
            ? ('🎉', 'Great job! A little review and you\'ll master it.')
            : pct >= 0.5
                ? ('💪', 'Good effort. Revisit the lessons you missed.')
                : ('📚', 'Keep going — re-read the lessons and try again.');
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(emoji, style: const TextStyle(fontSize: 72)),
          const SizedBox(height: 8),
          Text('$score / $total', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(msg, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 24),
          FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.check), label: const Text('Done')),
        ]),
      ),
    );
  }
}

// ============================================================ Challenge

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key, required this.challenge});
  final Challenge challenge;

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  int _hintsShown = 0;
  bool _showSolution = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.challenge;
    final state = AppScope.of(context);
    final solved = state.solvedChallenges.contains(c.id);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(c.title)),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 32), children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Chip(label: Text(c.level), visualDensity: VisualDensity.compact),
        ),
        const SizedBox(height: 8),
        Text('Your task', style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Rich(c.task),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('How to practise', style: TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              const Rich('1. Open **dartpad.dev** (or your editor).\n'
                  '2. Write the solution yourself — no peeking!\n'
                  '3. Stuck? Reveal one hint at a time.\n'
                  '4. Compare with the solution, then mark it solved.'),
            ]),
          ),
        ),
        const SizedBox(height: 16),
        Text('Hints', style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        for (var i = 0; i < _hintsShown; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('💡 '),
              Expanded(child: Rich(c.hints[i])),
            ]),
          ),
        if (_hintsShown < c.hints.length)
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: () => setState(() => _hintsShown++),
              icon: const Icon(Icons.lightbulb_outline),
              label: Text('Show hint ${_hintsShown + 1} of ${c.hints.length}'),
            ),
          ),
        const SizedBox(height: 16),
        if (!_showSolution)
          FilledButton.tonalIcon(
            onPressed: () => setState(() => _showSolution = true),
            icon: const Icon(Icons.visibility),
            label: const Text('Reveal solution'),
          )
        else
          CodeBlock(code: c.solution, caption: 'One possible solution'),
        const SizedBox(height: 16),
        if (solved)
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
            onPressed: () => state.toggleChallenge(c.id),
            icon: const Icon(Icons.undo),
            label: const Text('Solved ✓  (tap to undo)'),
          )
        else
          FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: const Color(0xFF2E9E5B),
              foregroundColor: Colors.white,
            ),
            onPressed: () => state.toggleChallenge(c.id),
            icon: const Icon(Icons.check),
            label: const Text('I solved it!'),
          ),
      ]),
    );
  }
}
