import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'controls.dart';

void _toast(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg), duration: const Duration(milliseconds: 1200)));
}

// ---------------------------------------------------------------- text_style
class TextStyleDemo extends StatefulWidget {
  const TextStyleDemo({super.key});
  @override
  State<TextStyleDemo> createState() => _TextStyleDemoState();
}

class _TextStyleDemoState extends State<TextStyleDemo> {
  double _size = 26, _spacing = 0;
  FontWeight _weight = FontWeight.w700;
  bool _italic = false, _underline = false;
  TextAlign _align = TextAlign.center;
  Color _color = demoColors[4];

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SizedBox(
        height: 90,
        child: Center(
          child: SizedBox(
            width: double.infinity,
            child: Text(
              'Hello Flutter',
              textAlign: _align,
              style: TextStyle(
                fontSize: _size,
                fontWeight: _weight,
                fontStyle: _italic ? FontStyle.italic : FontStyle.normal,
                letterSpacing: _spacing,
                color: _color,
                decoration: _underline ? TextDecoration.underline : null,
              ),
            ),
          ),
        ),
      ),
      LabeledSlider(label: 'fontSize', value: _size, min: 10, max: 44, onChanged: (v) => setState(() => _size = v)),
      LabeledSlider(
          label: 'letterSpacing', value: _spacing, min: -2, max: 8, decimals: 1, onChanged: (v) => setState(() => _spacing = v)),
      ChoiceRow<FontWeight>(
        label: 'fontWeight',
        values: const [FontWeight.w300, FontWeight.w400, FontWeight.w600, FontWeight.w700, FontWeight.w900],
        selected: _weight,
        nameOf: (w) => 'w${w.value}',
        onSelected: (v) => setState(() => _weight = v),
      ),
      ChoiceRow<TextAlign>(
        label: 'textAlign',
        values: const [TextAlign.left, TextAlign.center, TextAlign.right],
        selected: _align,
        onSelected: (v) => setState(() => _align = v),
      ),
      ChoiceRow<Color>(
          label: 'color', values: demoColors, selected: _color, nameOf: (_) => '●', onSelected: (v) => setState(() => _color = v)),
      Row(children: [
        FilterChip(label: const Text('italic'), selected: _italic, onSelected: (v) => setState(() => _italic = v)),
        const SizedBox(width: 8),
        FilterChip(label: const Text('underline'), selected: _underline, onSelected: (v) => setState(() => _underline = v)),
      ]),
      CodeHint('TextStyle(\n  fontSize: ${_size.round()},\n  fontWeight: FontWeight.w${_weight.value},\n'
          '  letterSpacing: ${_spacing.toStringAsFixed(1)},${_italic ? '\n  fontStyle: FontStyle.italic,' : ''}'
          '${_underline ? '\n  decoration: TextDecoration.underline,' : ''}\n)'),
    ]);
  }
}

// ---------------------------------------------------------------- icons
class IconsDemo extends StatefulWidget {
  const IconsDemo({super.key});
  @override
  State<IconsDemo> createState() => _IconsDemoState();
}

class _IconsDemoState extends State<IconsDemo> {
  static const _icons = <(IconData, String)>[
    (Icons.home, 'home'), (Icons.home_outlined, 'home_outlined'), (Icons.search, 'search'),
    (Icons.favorite, 'favorite'), (Icons.favorite_border, 'favorite_border'), (Icons.star_rounded, 'star_rounded'),
    (Icons.settings, 'settings'), (Icons.person, 'person'), (Icons.shopping_cart, 'shopping_cart'),
    (Icons.notifications, 'notifications'), (Icons.camera_alt, 'camera_alt'), (Icons.share, 'share'),
    (Icons.delete_outline, 'delete_outline'), (Icons.edit, 'edit'), (Icons.add_circle, 'add_circle'),
    (Icons.check_circle, 'check_circle'), (Icons.close, 'close'), (Icons.menu, 'menu'),
    (Icons.arrow_back_ios_new, 'arrow_back_ios_new'), (Icons.chat_bubble_outline, 'chat_bubble_outline'),
    (Icons.location_on, 'location_on'), (Icons.lock_outline, 'lock_outline'), (Icons.dark_mode, 'dark_mode'),
    (Icons.flutter_dash, 'flutter_dash'),
  ];
  String _selected = 'flutter_dash';

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          for (final (icon, name) in _icons)
            IconButton(
              tooltip: name,
              isSelected: name == _selected,
              onPressed: () => setState(() => _selected = name),
              icon: Icon(icon),
            ),
        ],
      ),
      CodeHint('Icon(Icons.$_selected)'),
      const SizedBox(height: 6),
      const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(CupertinoIcons.heart_fill, color: Colors.pink),
        SizedBox(width: 8),
        Flexible(child: Text('CupertinoIcons.heart_fill (iOS style)')),
      ]),
    ]);
  }
}

// ---------------------------------------------------------------- boxfit
class BoxFitDemo extends StatefulWidget {
  const BoxFitDemo({super.key});
  @override
  State<BoxFitDemo> createState() => _BoxFitDemoState();
}

class _BoxFitDemoState extends State<BoxFitDemo> {
  BoxFit _fit = BoxFit.cover;

  @override
  Widget build(BuildContext context) {
    // A wide "photo" (2:1) placed into a square box.
    final photo = Container(
      width: 200,
      height: 100,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFFFF9A44), Color(0xFFFC6076), Color(0xFF6A11CB)]),
      ),
      child: const Stack(children: [
        Positioned(left: 12, bottom: 10, child: Icon(Icons.landscape, color: Colors.white, size: 44)),
        Positioned(right: 14, top: 10, child: Icon(Icons.wb_sunny, color: Colors.yellow, size: 28)),
        Center(child: Text('2:1 image', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      ]),
    );
    return Column(children: [
      Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          border: Border.all(color: Theme.of(context).colorScheme.outline, width: 2),
        ),
        child: FittedBox(fit: _fit, clipBehavior: Clip.hardEdge, child: photo),
      ),
      ChoiceRow<BoxFit>(
        label: 'fit',
        values: const [BoxFit.cover, BoxFit.contain, BoxFit.fill, BoxFit.fitWidth, BoxFit.fitHeight, BoxFit.none],
        selected: _fit,
        onSelected: (v) => setState(() => _fit = v),
      ),
      CodeHint('Image.asset(..., width: 150, height: 150, fit: BoxFit.${_fit.name})'),
    ]);
  }
}

// ---------------------------------------------------------------- buttons
class ButtonsDemo extends StatelessWidget {
  const ButtonsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    void tap(String name) => _toast(context, '$name pressed');
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        FilledButton(onPressed: () => tap('FilledButton'), child: const Text('Filled')),
        FilledButton.tonal(onPressed: () => tap('FilledButton.tonal'), child: const Text('Tonal')),
        ElevatedButton(onPressed: () => tap('ElevatedButton'), child: const Text('Elevated')),
        OutlinedButton(onPressed: () => tap('OutlinedButton'), child: const Text('Outlined')),
        TextButton(onPressed: () => tap('TextButton'), child: const Text('Text')),
        FilledButton.icon(
            onPressed: () => tap('FilledButton.icon'), icon: const Icon(Icons.send), label: const Text('Send')),
        IconButton(onPressed: () => tap('IconButton'), icon: const Icon(Icons.share)),
        IconButton.filled(onPressed: () => tap('IconButton.filled'), icon: const Icon(Icons.favorite)),
        IconButton.outlined(onPressed: () => tap('IconButton.outlined'), icon: const Icon(Icons.bookmark_border)),
        FloatingActionButton.small(
            heroTag: null, onPressed: () => tap('FloatingActionButton'), child: const Icon(Icons.add)),
        CupertinoButton.filled(
          onPressed: () => tap('CupertinoButton'),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text('Cupertino'),
        ),
        const ElevatedButton(onPressed: null, child: Text('Disabled')),
      ],
    );
  }
}

// ---------------------------------------------------------------- cards
class CardsDemo extends StatefulWidget {
  const CardsDemo({super.key});
  @override
  State<CardsDemo> createState() => _CardsDemoState();
}

class _CardsDemoState extends State<CardsDemo> {
  bool _notify = true;
  bool _starred = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Card(
        elevation: 2,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            leading: const CircleAvatar(child: Text('A')),
            title: const Text('Ada Lovelace'),
            subtitle: const Text('First programmer'),
            trailing: IconButton(
              icon: Icon(_starred ? Icons.star : Icons.star_border, color: Colors.amber),
              onPressed: () => setState(() => _starred = !_starred),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('ada@example.com'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _toast(context, 'ListTile tapped'),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Notifications'),
            value: _notify,
            onChanged: (v) => setState(() => _notify = v),
          ),
        ]),
      ),
      const SizedBox(height: 8),
      Row(children: const [
        Expanded(child: Card.filled(child: Padding(padding: EdgeInsets.all(16), child: Text('Card.filled')))),
        SizedBox(width: 8),
        Expanded(child: Card.outlined(child: Padding(padding: EdgeInsets.all(16), child: Text('Card.outlined')))),
      ]),
    ]);
  }
}

// ---------------------------------------------------------------- chips
class ChipsDemo extends StatefulWidget {
  const ChipsDemo({super.key});
  @override
  State<ChipsDemo> createState() => _ChipsDemoState();
}

class _ChipsDemoState extends State<ChipsDemo> {
  final _filters = <String>{'Vegan'};
  String _size = 'M';
  final _inputs = ['dart', 'flutter', 'mobile'];
  int _notifications = 3;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('FilterChip (multi-select)'),
      Wrap(spacing: 6, children: [
        for (final f in ['Vegan', 'Spicy', 'Gluten-free'])
          FilterChip(
            label: Text(f),
            selected: _filters.contains(f),
            onSelected: (v) => setState(() => v ? _filters.add(f) : _filters.remove(f)),
          ),
      ]),
      const SizedBox(height: 8),
      const Text('ChoiceChip (single-select)'),
      Wrap(spacing: 6, children: [
        for (final s in ['S', 'M', 'L', 'XL'])
          ChoiceChip(label: Text(s), selected: _size == s, onSelected: (_) => setState(() => _size = s)),
      ]),
      const SizedBox(height: 8),
      const Text('InputChip (deletable)'),
      Wrap(spacing: 6, children: [
        for (final t in _inputs)
          InputChip(label: Text(t), onDeleted: () => setState(() => _inputs.remove(t))),
        ActionChip(
          avatar: const Icon(Icons.refresh, size: 18),
          label: const Text('Reset'),
          onPressed: () => setState(() => _inputs
            ..clear()
            ..addAll(['dart', 'flutter', 'mobile'])),
        ),
      ]),
      const Divider(height: 24),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        const CircleAvatar(child: Text('AL')),
        const CircleAvatar(backgroundColor: Colors.teal, child: Icon(Icons.person, color: Colors.white)),
        IconButton(
          onPressed: () => setState(() => _notifications++),
          icon: Badge(
            label: Text('$_notifications'),
            isLabelVisible: _notifications > 0,
            child: const Icon(Icons.notifications),
          ),
        ),
        const Tooltip(message: 'I am a Tooltip! (long-press or hover)', child: Icon(Icons.info_outline)),
      ]),
      const Text('Tap the bell to add notifications. Long-press the ⓘ for a tooltip.',
          style: TextStyle(fontSize: 12.5)),
    ]);
  }
}

// ---------------------------------------------------------------- progress
class ProgressDemo extends StatefulWidget {
  const ProgressDemo({super.key});
  @override
  State<ProgressDemo> createState() => _ProgressDemoState();
}

class _ProgressDemoState extends State<ProgressDemo> {
  double _value = 0.4;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Wrap(alignment: WrapAlignment.spaceEvenly, spacing: 16, runSpacing: 12, children: [
        Column(children: [CircularProgressIndicator(value: _value), const SizedBox(height: 6), const Text('determinate')]),
        const Column(children: [CircularProgressIndicator(), SizedBox(height: 6), Text('indeterminate')]),
        const Column(children: [CupertinoActivityIndicator(radius: 14), SizedBox(height: 10), Text('Cupertino')]),
      ]),
      const SizedBox(height: 16),
      LinearProgressIndicator(value: _value, minHeight: 8, borderRadius: BorderRadius.circular(4)),
      const SizedBox(height: 10),
      const LinearProgressIndicator(),
      LabeledSlider(
          label: 'value', value: _value, min: 0, max: 1, decimals: 2, onChanged: (v) => setState(() => _value = v)),
    ]);
  }
}

// ================================================================ INPUT

// ---------------------------------------------------------------- textfield
class TextFieldDemo extends StatefulWidget {
  const TextFieldDemo({super.key});
  @override
  State<TextFieldDemo> createState() => _TextFieldDemoState();
}

class _TextFieldDemoState extends State<TextFieldDemo> {
  final _controller = TextEditingController();
  bool _obscure = false;
  String _submitted = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      TextField(
        controller: _controller,
        obscureText: _obscure,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          labelText: 'Your name',
          hintText: 'e.g. Ada',
          prefixIcon: const Icon(Icons.person),
          suffixIcon: IconButton(
            icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
        ),
        onChanged: (_) => setState(() {}),
        onSubmitted: (t) => setState(() => _submitted = t),
      ),
      const SizedBox(height: 8),
      Text('onChanged → "${_controller.text}" (${_controller.text.length} chars)'),
      Text('onSubmitted → "$_submitted"'),
      const SizedBox(height: 6),
      Wrap(spacing: 8, children: [
        OutlinedButton(onPressed: () => setState(() => _controller.text = 'Linus'), child: const Text("controller.text = 'Linus'")),
        OutlinedButton(onPressed: () => setState(_controller.clear), child: const Text('controller.clear()')),
      ]),
    ]);
  }
}

// ---------------------------------------------------------------- form
class FormDemo extends StatefulWidget {
  const FormDemo({super.key});
  @override
  State<FormDemo> createState() => _FormDemoState();
}

class _FormDemoState extends State<FormDemo> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  bool _hide = true;
  String? _result;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _result = '✅ Welcome, $_email!');
    } else {
      setState(() => _result = '❌ Fix the errors above');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        TextFormField(
          decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Email is required';
            if (!value.contains('@') || !value.contains('.')) return 'Enter a valid email';
            return null;
          },
          onSaved: (v) => _email = v!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          obscureText: _hide,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_hide ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _hide = !_hide),
            ),
          ),
          validator: (v) => (v ?? '').length < 6 ? 'Min 6 characters' : null,
        ),
        const SizedBox(height: 12),
        FilledButton(onPressed: _submit, child: const Text('Sign up')),
        if (_result != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_result!, textAlign: TextAlign.center)),
      ]),
    );
  }
}

// ---------------------------------------------------------------- toggles
class TogglesDemo extends StatefulWidget {
  const TogglesDemo({super.key});
  @override
  State<TogglesDemo> createState() => _TogglesDemoState();
}

class _TogglesDemoState extends State<TogglesDemo> {
  bool _agree = false, _wifi = true;
  String _size = 'M';

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        title: const Text('I agree (Checkbox)'),
        value: _agree,
        onChanged: (v) => setState(() => _agree = v!),
      ),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('Wi-Fi (Switch)'),
        value: _wifi,
        onChanged: (v) => setState(() => _wifi = v),
      ),
      RadioGroup<String>(
        groupValue: _size,
        onChanged: (v) => setState(() => _size = v!),
        child: const Column(children: [
          RadioListTile(value: 'S', title: Text('Small'), dense: true),
          RadioListTile(value: 'M', title: Text('Medium'), dense: true),
          RadioListTile(value: 'L', title: Text('Large'), dense: true),
        ]),
      ),
      Wrap(alignment: WrapAlignment.center, crossAxisAlignment: WrapCrossAlignment.center, spacing: 6, runSpacing: 6, children: [
        Switch.adaptive(value: _wifi, onChanged: (v) => setState(() => _wifi = v)),
        const Text('Switch.adaptive'),
        const SizedBox(width: 10),
        CupertinoSwitch(value: _wifi, onChanged: (v) => setState(() => _wifi = v)),
        const Text('Cupertino'),
      ]),
      CodeHint('_agree = $_agree, _wifi = $_wifi, _size = \'$_size\''),
    ]);
  }
}

// ---------------------------------------------------------------- selection
class SelectionDemo extends StatefulWidget {
  const SelectionDemo({super.key});
  @override
  State<SelectionDemo> createState() => _SelectionDemoState();
}

class _SelectionDemoState extends State<SelectionDemo> {
  double _volume = 40;
  RangeValues _price = const RangeValues(20, 80);
  String _country = 'NG';
  String _range = 'week';

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Slider: ${_volume.round()}'),
      Slider(
        value: _volume,
        max: 100,
        divisions: 10,
        label: _volume.round().toString(),
        onChanged: (v) => setState(() => _volume = v),
      ),
      Text('RangeSlider: \$${_price.start.round()} – \$${_price.end.round()}'),
      RangeSlider(
        values: _price,
        max: 100,
        divisions: 20,
        labels: RangeLabels('\$${_price.start.round()}', '\$${_price.end.round()}'),
        onChanged: (v) => setState(() => _price = v),
      ),
      Row(children: [
        const Text('DropdownButton:  '),
        DropdownButton<String>(
          value: _country,
          items: const [
            DropdownMenuItem(value: 'NG', child: Text('🇳🇬 Nigeria')),
            DropdownMenuItem(value: 'GH', child: Text('🇬🇭 Ghana')),
            DropdownMenuItem(value: 'KE', child: Text('🇰🇪 Kenya')),
            DropdownMenuItem(value: 'US', child: Text('🇺🇸 USA')),
          ],
          onChanged: (v) => setState(() => _country = v!),
        ),
      ]),
      const SizedBox(height: 8),
      SegmentedButton<String>(
        segments: const [
          ButtonSegment(value: 'day', label: Text('Day')),
          ButtonSegment(value: 'week', label: Text('Week')),
          ButtonSegment(value: 'month', label: Text('Month')),
        ],
        selected: {_range},
        onSelectionChanged: (s) => setState(() => _range = s.first),
      ),
    ]);
  }
}

// ---------------------------------------------------------------- gestures
class GesturesDemo extends StatefulWidget {
  const GesturesDemo({super.key});
  @override
  State<GesturesDemo> createState() => _GesturesDemoState();
}

class _GesturesDemoState extends State<GesturesDemo> {
  String _last = 'Try a gesture on the box';
  Offset _pos = const Offset(110, 50);
  Color _color = demoColors[3];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      LayoutBuilder(builder: (context, c) {
        return Container(
          height: 160,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(children: [
            Positioned(
              left: _pos.dx,
              top: _pos.dy,
              child: GestureDetector(
                onTap: () => setState(() => _last = 'onTap'),
                onDoubleTap: () => setState(() {
                  _last = 'onDoubleTap → colour changed';
                  _color = demoColors[(demoColors.indexOf(_color) + 1) % demoColors.length];
                }),
                onLongPress: () => setState(() => _last = 'onLongPress'),
                onPanUpdate: (d) => setState(() {
                  _last = 'onPanUpdate (dragging)';
                  _pos = Offset(
                    (_pos.dx + d.delta.dx).clamp(0, c.maxWidth - 64),
                    (_pos.dy + d.delta.dy).clamp(0, 160 - 64),
                  );
                }),
                child: DemoBox('drag', color: _color, width: 64, height: 64),
              ),
            ),
          ]),
        );
      }),
      const SizedBox(height: 8),
      Text(_last, style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 8),
      Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Ink(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
            child: const Text('InkWell — tap for a ripple'),
          ),
        ),
      ),
    ]);
  }
}

// ---------------------------------------------------------------- dismissible
class DismissibleDemo extends StatefulWidget {
  const DismissibleDemo({super.key});
  @override
  State<DismissibleDemo> createState() => _DismissibleDemoState();
}

class _DismissibleDemoState extends State<DismissibleDemo> {
  static const _all = ['Buy milk', 'Learn Row & Column', 'Walk the dog', 'Read Flutter docs', 'Call mum'];
  List<String> _items = List.of(_all);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      for (final item in _items)
        Dismissible(
          key: ValueKey(item),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) {
            setState(() => _items.remove(item));
            _toast(context, 'Deleted "$item"');
          },
          child: ListTile(leading: const Icon(Icons.drag_indicator), title: Text(item)),
        ),
      if (_items.isEmpty) const Padding(padding: EdgeInsets.all(12), child: Text('All gone! 🎉')),
      TextButton.icon(
        onPressed: () => setState(() => _items = List.of(_all)),
        icon: const Icon(Icons.refresh),
        label: const Text('Reset list'),
      ),
    ]);
  }
}

// ---------------------------------------------------------------- pickers
class PickersDemo extends StatefulWidget {
  const PickersDemo({super.key});
  @override
  State<PickersDemo> createState() => _PickersDemoState();
}

class _PickersDemoState extends State<PickersDemo> {
  DateTime? _date;
  TimeOfDay? _time;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.calendar_month),
            label: const Text('Pick date'),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _date ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) setState(() => _date = picked);
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.schedule),
            label: const Text('Pick time'),
            onPressed: () async {
              final t = await showTimePicker(context: context, initialTime: _time ?? TimeOfDay.now());
              if (t != null) setState(() => _time = t);
            },
          ),
        ),
      ]),
      const SizedBox(height: 10),
      Text('Date: ${_date == null ? '—' : '${_date!.year}-${_date!.month}-${_date!.day}'}   '
          'Time: ${_time?.format(context) ?? '—'}'),
    ]);
  }
}
