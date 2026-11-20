import 'package:flutter/material.dart';

/// A label followed by a wrap of choice chips. Used by demo playgrounds.
class ChoiceRow<T> extends StatelessWidget {
  const ChoiceRow({
    super.key,
    required this.label,
    required this.values,
    required this.selected,
    required this.onSelected,
    this.nameOf,
  });

  final String label;
  final List<T> values;
  final T selected;
  final ValueChanged<T> onSelected;
  final String Function(T)? nameOf;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final v in values)
                ChoiceChip(
                  // Colour options show a real colour swatch instead of text.
                  label: v is Color
                      ? Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(color: v, shape: BoxShape.circle),
                        )
                      : Text(nameOf?.call(v) ?? _name(v)),
                  selected: v == selected,
                  visualDensity: VisualDensity.compact,
                  onSelected: (_) => onSelected(v),
                ),
            ],
          ),
        ],
      ),
    );
  }

  static String _name(Object? v) => v is Enum ? v.name : '$v';
}

/// A label + value readout + slider.
class LabeledSlider extends StatelessWidget {
  const LabeledSlider({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.divisions,
    this.decimals = 0,
  });

  final String label;
  final double value, min, max;
  final int? divisions;
  final int decimals;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 118,
          child: Text('$label: ${value.toStringAsFixed(decimals)}',
              style: Theme.of(context).textTheme.labelLarge),
        ),
        Expanded(
          child: Slider(value: value, min: min, max: max, divisions: divisions, onChanged: onChanged),
        ),
      ],
    );
  }
}

/// A small monospace caption showing the code equivalent of the demo state.
class CodeHint extends StatelessWidget {
  const CodeHint(this.code, {super.key});
  final String code;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        code,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontFamilyFallback: ['Menlo', 'Courier'],
          fontSize: 12.5,
        ),
      ),
    );
  }
}

/// Coloured box with a label — handy for layout demos.
class DemoBox extends StatelessWidget {
  const DemoBox(this.label, {super.key, this.color = Colors.blue, this.width = 50, this.height = 50});
  final String label;
  final Color color;
  final double? width, height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Text(label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}

const demoColors = [
  Color(0xFF1E88E5),
  Color(0xFFE53935),
  Color(0xFF43A047),
  Color(0xFFFB8C00),
  Color(0xFF8E24AA),
  Color(0xFF00ACC1),
];
