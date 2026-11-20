import 'package:flutter/material.dart';

import '../../models/lesson.dart';
import '../dsl.dart';

final input = LearningModule(
  id: 'input',
  title: 'Input & Forms',
  description: 'Text fields, validation, switches, sliders, dropdowns, pickers and gestures.',
  level: Level.intermediate,
  icon: Icons.edit_note_rounded,
  color: const Color(0xFF00ACC1),
  lessons: [
    Lesson(
      id: 'input.textfield',
      title: 'TextField & Controllers',
      summary: 'Read what users type.',
      minutes: 10,
      sections: [
        code(r'''
class _NameInputState extends State<NameInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose(); // controllers must be disposed!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: const InputDecoration(
        labelText: 'Your name',
        hintText: 'e.g. Ada',
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.done,
      onChanged: (text) => print('Typing: $text'),
      onSubmitted: (text) => print('Done: $text'),
    );
  }
}

// Anywhere: read or set the text
_controller.text;            // current value
_controller.text = 'Linus';  // set value
_controller.clear();
'''),
        demo('textfield', caption: 'Type something'),
        h('Useful options'),
        bullets([
          '`obscureText: true` — hide input (passwords).',
          '`keyboardType:` — `TextInputType.emailAddress`, `.number`, `.phone`, `.multiline`…',
          '`maxLines: null` — grows with content; `maxLength: 140` — character counter.',
          '`textCapitalization: TextCapitalization.words`',
          '`autofocus: true` — open keyboard immediately.',
          '`enabled: false` / `readOnly: true`',
        ]),
        tip('Tap outside to close the keyboard: wrap your page in `GestureDetector(onTap: () => FocusScope.of(context).unfocus(), child: ...)`.'),
      ],
      quiz: [
        q('Which property hides password characters?', ['hidden: true', 'obscureText: true', 'password: true', 'secure: true'], 1, 'obscureText hides input.'),
        q('What must you do with a TextEditingController when the widget is removed?', ['Nothing', 'Call dispose()', 'Set it to null', 'Clear it'], 1,
            'Controllers hold resources and must be disposed.'),
      ],
    ),
    Lesson(
      id: 'input.forms',
      title: 'Forms & Validation',
      summary: 'Validate several fields at once with Form and GlobalKey.',
      minutes: 11,
      sections: [
        code(r'''
class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';

  void _submit() {
    if (_formKey.currentState!.validate()) {  // runs every validator
      _formKey.currentState!.save();           // runs every onSaved
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome $_email')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Email is required';
              if (!value.contains('@')) return 'Enter a valid email';
              return null; // null means valid ✅
            },
            onSaved: (value) => _email = value!,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (v) => (v ?? '').length < 6 ? 'Min 6 characters' : null,
          ),
          FilledButton(onPressed: _submit, child: const Text('Sign up')),
        ],
      ),
    );
  }
}
'''),
        demo('form', caption: 'Try submitting with bad input'),
        bullets([
          'A **validator** returns an error message (String) or `null` if valid.',
          '`Form` + `GlobalKey<FormState>` lets you validate all fields with one call.',
          '`autovalidateMode: AutovalidateMode.onUserInteraction` validates as the user types.',
        ]),
      ],
      quiz: [
        q('What should a validator return when input is valid?', ['true', 'An empty string', 'null', '"OK"'], 2, 'null means no error.'),
        q('How do you validate all fields of a Form?', ['formKey.currentState!.validate()', 'Form.validate()', 'setState()', 'validateAll()'], 0,
            'Use the GlobalKey<FormState> to call validate().'),
      ],
    ),
    Lesson(
      id: 'input.toggles',
      title: 'Checkbox, Switch & Radio',
      summary: 'Yes/no and pick-one controls.',
      minutes: 7,
      sections: [
        demo('toggles'),
        code(r'''
bool _agree = false;
bool _wifi = true;
String _size = 'M';

Checkbox(
  value: _agree,
  onChanged: (v) => setState(() => _agree = v!),
)

Switch(
  value: _wifi,
  onChanged: (v) => setState(() => _wifi = v),
)

// A RadioGroup holds the selected value for all Radios inside it
RadioGroup<String>(
  groupValue: _size,
  onChanged: (v) => setState(() => _size = v!),
  child: const Column(
    children: [
      RadioListTile(value: 'S', title: Text('Small')),
      RadioListTile(value: 'M', title: Text('Medium')),
      RadioListTile(value: 'L', title: Text('Large')),
    ],
  ),
)

// Switch with a label, the whole row tappable:
SwitchListTile(
  title: const Text('Wi-Fi'),
  value: _wifi,
  onChanged: (v) => setState(() => _wifi = v),
)
'''),
        note('These are **controlled** widgets: they don\'t store their own value. You keep the value in state and update it in `onChanged`. If you forget `setState`, the control won\'t move!'),
        tip('Use `Switch.adaptive` and `Checkbox.adaptive` to get the iOS look automatically on iPhones.'),
      ],
      quiz: [
        q('A Switch doesn\'t move when tapped. Likely cause?', ['Wrong colour', 'onChanged doesn\'t update the state with setState', 'Missing key', 'Needs const'], 1,
            'Controlled widgets reflect the value you pass in.'),
      ],
    ),
    Lesson(
      id: 'input.selection',
      title: 'Slider, Dropdown & SegmentedButton',
      summary: 'Pick values from ranges and lists.',
      minutes: 8,
      sections: [
        demo('selection'),
        code(r'''
Slider(
  value: _volume,
  min: 0,
  max: 100,
  divisions: 10,                 // snap to steps
  label: _volume.round().toString(),
  onChanged: (v) => setState(() => _volume = v),
)

DropdownButton<String>(
  value: _country,
  items: const [
    DropdownMenuItem(value: 'NG', child: Text('Nigeria')),
    DropdownMenuItem(value: 'GH', child: Text('Ghana')),
    DropdownMenuItem(value: 'KE', child: Text('Kenya')),
  ],
  onChanged: (v) => setState(() => _country = v!),
)

SegmentedButton<String>(
  segments: const [
    ButtonSegment(value: 'day', label: Text('Day')),
    ButtonSegment(value: 'week', label: Text('Week')),
    ButtonSegment(value: 'month', label: Text('Month')),
  ],
  selected: {_range},
  onSelectionChanged: (s) => setState(() => _range = s.first),
)
'''),
        tip('`RangeSlider` picks a min and max (e.g. price filters). `DropdownMenu` is the newer Material 3 dropdown with search.'),
      ],
      quiz: [
        q('What does `divisions` do on a Slider?', ['Sets colour', 'Makes it snap to discrete steps', 'Sets max', 'Splits into two sliders'], 1,
            'divisions creates discrete steps.'),
      ],
    ),
    Lesson(
      id: 'input.gestures',
      title: 'Gestures: Tap, Drag, Swipe',
      summary: 'GestureDetector, InkWell and Dismissible.',
      minutes: 9,
      sections: [
        p('Make **any** widget respond to touch with `GestureDetector` or `InkWell`.'),
        code(r'''
GestureDetector(
  onTap: () => print('tap'),
  onDoubleTap: () => print('double tap'),
  onLongPress: () => print('long press'),
  onPanUpdate: (details) => print('drag by ${details.delta}'),
  child: Container(width: 100, height: 100, color: Colors.amber),
)

// InkWell = tap + Material ripple effect
InkWell(
  onTap: () {},
  borderRadius: BorderRadius.circular(12),
  child: const Padding(
    padding: EdgeInsets.all(16),
    child: Text('Tap for ripple'),
  ),
)
'''),
        demo('gestures', caption: 'Tap, double-tap, long-press, drag'),
        h('Swipe to delete'),
        code(r'''
Dismissible(
  key: ValueKey(item.id),
  direction: DismissDirection.endToStart,
  background: Container(
    color: Colors.red,
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(right: 20),
    child: const Icon(Icons.delete, color: Colors.white),
  ),
  onDismissed: (_) => setState(() => items.remove(item)),
  child: ListTile(title: Text(item.title)),
)
'''),
        demo('dismissible', caption: 'Swipe items left to delete'),
        note('InkWell needs a `Material` ancestor to draw the ripple. Inside Scaffold/Card it\'s already there.'),
      ],
      quiz: [
        q('Which gives a ripple effect on tap?', ['GestureDetector', 'InkWell', 'Listener', 'Container'], 1, 'InkWell draws a Material ink splash.'),
        q('Which widget implements swipe-to-delete?', ['Draggable', 'Dismissible', 'Swiper', 'PageView'], 1, 'Dismissible handles swipe-away.'),
      ],
    ),
    Lesson(
      id: 'input.pickers',
      title: 'Date & Time Pickers',
      summary: 'Built-in dialogs for picking dates and times.',
      minutes: 5,
      sections: [
        code(r'''
Future<void> _pickDate() async {
  final picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );
  if (picked != null) setState(() => _date = picked);
}

Future<void> _pickTime() async {
  final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
  if (time != null) setState(() => _time = time);
}
'''),
        demo('pickers'),
        note('`showDatePicker` returns a **Future** — that\'s why we `await` it. It completes with the chosen date or `null` if cancelled.'),
      ],
      quiz: [
        q('What does showDatePicker return if the user cancels?', ['Today', 'null', 'An error', 'DateTime(0)'], 1, 'Cancelled pickers return null.'),
      ],
    ),
  ],
);
