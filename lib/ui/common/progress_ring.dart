import 'package:flutter/material.dart';

class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.value,
    this.size = 56,
    this.stroke = 6,
    this.color,
    this.trackColor,
    this.child,
  });

  final double value;
  final double size, stroke;
  final Color? color, trackColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(fit: StackFit.expand, children: [
        CircularProgressIndicator(
          value: value.clamp(0, 1),
          strokeWidth: stroke,
          strokeCap: StrokeCap.round,
          color: color,
          backgroundColor: trackColor ?? Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        if (child != null) Center(child: child),
      ]),
    );
  }
}

class LevelBadge extends StatelessWidget {
  const LevelBadge(this.label, this.color, {super.key});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11.5, fontWeight: FontWeight.w700)),
    );
  }
}
