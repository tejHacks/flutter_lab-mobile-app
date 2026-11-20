import 'package:flutter/material.dart';

import '../../models/lesson.dart';
import '../dsl.dart';

final commonWidgets = LearningModule(
  id: 'widgets',
  title: 'Common Widgets',
  description: 'Text, images, icons, every kind of button, cards, list tiles, chips and loaders.',
  level: Level.beginner,
  icon: Icons.category_rounded,
  color: const Color(0xFF8E24AA),
  lessons: [
    Lesson(
      id: 'widgets.text',
      title: 'Text & TextStyle',
      summary: 'Fonts, sizes, weights, alignment and rich text.',
      minutes: 8,
      sections: [
        code(r'''
Text(
  'Hello Flutter',
  textAlign: TextAlign.center,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,   // "..." when too long
  style: const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    color: Colors.deepPurple,
    letterSpacing: 1.2,
    height: 1.4,                      // line height
    decoration: TextDecoration.underline,
  ),
)
'''),
        demo('text_style', caption: 'TextStyle playground'),
        h('Use the theme\'s text styles'),
        code(r'''
Text('Title', style: Theme.of(context).textTheme.headlineMedium)
Text('Body',  style: Theme.of(context).textTheme.bodyLarge)
'''),
        p('Material 3 provides: `displayLarge/Medium/Small`, `headline…`, `title…`, `body…`, `label…`. Using these keeps your app consistent and makes dark mode and font changes easy.'),
        h('Mixed styles: Text.rich'),
        code(r'''
Text.rich(
  TextSpan(
    text: 'By continuing you agree to our ',
    children: [
      TextSpan(
        text: 'Terms',
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
      TextSpan(text: '.'),
    ],
  ),
)
'''),
        tip('Use `SelectableText` when users should be able to copy the text.'),
      ],
      quiz: [
        q('How do you show "..." for text that is too long?', ['maxLines + overflow: TextOverflow.ellipsis', 'softWrap: false', 'Use FittedBox', 'fontSize: 0'], 0,
            'Combine maxLines with TextOverflow.ellipsis.'),
        q('How do you style parts of a sentence differently?', ['Multiple Text in Row', 'Text.rich with TextSpans', 'Use HTML', 'Impossible'], 1,
            'TextSpan children can each have their own style.'),
      ],
    ),
    Lesson(
      id: 'widgets.images',
      title: 'Images & Icons',
      summary: 'Asset images, network images, BoxFit and icons.',
      minutes: 9,
      sections: [
        h('Icons'),
        code(r'''
const Icon(Icons.favorite, color: Colors.red, size: 32)
const Icon(Icons.favorite_border)
const Icon(Icons.home_rounded)       // rounded / outlined / sharp variants
'''),
        demo('icons', caption: 'A few of the 2000+ Material icons'),
        tip('Search all icons at **fonts.google.com/icons**. For iOS-style icons use `CupertinoIcons` from `package:flutter/cupertino.dart`.'),
        h('Images from the internet'),
        code(r'''
Image.network(
  'https://picsum.photos/400/300',
  width: 300,
  height: 200,
  fit: BoxFit.cover,
  loadingBuilder: (context, child, progress) =>
      progress == null ? child : const CircularProgressIndicator(),
  errorBuilder: (context, error, stack) => const Icon(Icons.broken_image),
)
'''),
        h('Images bundled with your app (assets)'),
        steps([
          'Create a folder, e.g. `assets/images/`, and put `logo.png` there.',
          'Register it in `pubspec.yaml` (mind the indentation!).',
          'Use `Image.asset(...)`. Stop and re-run the app after editing pubspec.',
        ]),
        code(r'''
# pubspec.yaml
flutter:
  assets:
    - assets/images/
''', caption: 'pubspec.yaml'),
        code(r'''
Image.asset('assets/images/logo.png', width: 120)
'''),
        h('BoxFit'),
        bullets([
          '`cover` — fill the box, crop the extra (most common for photos).',
          '`contain` — show the whole image, may leave empty space.',
          '`fill` — stretch (distorts!).',
          '`fitWidth` / `fitHeight` — match one dimension.',
        ]),
        demo('boxfit', caption: 'Compare BoxFit values'),
        h('Rounded images'),
        code(r'''
ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: Image.network(url, fit: BoxFit.cover),
)

const CircleAvatar(
  radius: 32,
  backgroundImage: NetworkImage('https://i.pravatar.cc/150'),
)
'''),
        note('For production apps, the `cached_network_image` package caches downloaded images on the device.'),
      ],
      quiz: [
        q('Which BoxFit fills the box and crops the excess?', ['contain', 'fill', 'cover', 'none'], 2, 'cover fills without distortion, cropping edges.'),
        q('What must you do before using Image.asset?', ['Nothing', 'Register the asset in pubspec.yaml', 'Upload it online', 'Add it to Info.plist'], 1,
            'Assets must be declared in pubspec.yaml.'),
      ],
    ),
    Lesson(
      id: 'widgets.buttons',
      title: 'Buttons',
      summary: 'Elevated, Filled, Outlined, Text, Icon and Floating buttons.',
      minutes: 9,
      sections: [
        demo('buttons', caption: 'Every Material button'),
        code(r'''
FilledButton(onPressed: () {}, child: const Text('Filled'))
ElevatedButton(onPressed: () {}, child: const Text('Elevated'))
OutlinedButton(onPressed: () {}, child: const Text('Outlined'))
TextButton(onPressed: () {}, child: const Text('Text'))
IconButton(onPressed: () {}, icon: const Icon(Icons.share))
FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add))

// With an icon
FilledButton.icon(
  onPressed: () {},
  icon: const Icon(Icons.send),
  label: const Text('Send'),
)

// Disabled: pass null to onPressed
const ElevatedButton(onPressed: null, child: Text('Disabled'))
'''),
        h('Which one should I use?'),
        bullets([
          '**FilledButton** — the main action on a screen ("Save", "Continue").',
          '**ElevatedButton / FilledButton.tonal** — important but secondary.',
          '**OutlinedButton** — medium emphasis ("Cancel" next to "Save").',
          '**TextButton** — low emphasis (dialogs, "Forgot password?").',
          '**IconButton** — toolbar actions.',
          '**FloatingActionButton** — the single primary action of a screen.',
        ]),
        h('Styling'),
        code(r'''
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.orange,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    minimumSize: const Size.fromHeight(52), // full width
  ),
  onPressed: () {},
  child: const Text('Get Started'),
)
'''),
        tip('`onPressed: null` disables a button automatically (greyed out). Great for "fill the form first" logic: `onPressed: isValid ? submit : null`.'),
      ],
      quiz: [
        q('How do you disable a button?', ['enabled: false', 'onPressed: null', 'disabled: true', 'Remove it'], 1,
            'A null onPressed disables the button.'),
        q('Best button for the main action?', ['TextButton', 'FilledButton', 'IconButton', 'OutlinedButton'], 1,
            'FilledButton has the highest emphasis.'),
      ],
    ),
    Lesson(
      id: 'widgets.cards',
      title: 'Card, ListTile & Divider',
      summary: 'Ready-made building blocks for lists and content.',
      minutes: 7,
      sections: [
        code(r'''
Card(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const ListTile(
        leading: CircleAvatar(child: Text('A')),
        title: Text('Ada Lovelace'),
        subtitle: Text('First programmer'),
        trailing: Icon(Icons.chevron_right),
      ),
      const Divider(height: 1),
      ListTile(
        leading: const Icon(Icons.email_outlined),
        title: const Text('ada@example.com'),
        onTap: () {},  // makes it tappable with ripple
      ),
    ],
  ),
)
'''),
        demo('cards', caption: 'Cards & ListTiles'),
        bullets([
          '`ListTile` — a row with `leading`, `title`, `subtitle`, `trailing`, `onTap`. Used in settings, contacts, menus.',
          '`Card` — a rounded surface with elevation. Variants: `Card.filled`, `Card.outlined`.',
          '`Divider` / `VerticalDivider` — thin separator lines.',
          '`SwitchListTile`, `CheckboxListTile`, `RadioListTile` — ListTiles with controls built-in.',
        ]),
      ],
      quiz: [
        q('Which ListTile slot is on the left?', ['trailing', 'leading', 'title', 'left'], 1, 'leading is at the start.'),
      ],
    ),
    Lesson(
      id: 'widgets.chips',
      title: 'Chips, Avatars, Badges & Tooltips',
      summary: 'Small but useful UI elements.',
      minutes: 7,
      sections: [
        demo('chips', caption: 'Tap the chips'),
        code(r'''
const Chip(avatar: Icon(Icons.tag), label: Text('flutter'))

FilterChip(
  label: const Text('Vegan'),
  selected: isVegan,
  onSelected: (value) => setState(() => isVegan = value),
)

ChoiceChip(label: const Text('Small'), selected: size == 'S', onSelected: (_) {})

const CircleAvatar(child: Text('AL'))

const Badge(
  label: Text('3'),
  child: Icon(Icons.notifications),
)

const Tooltip(
  message: 'Long-press me shows this',
  child: Icon(Icons.info_outline),
)
'''),
      ],
      quiz: [
        q('Which chip toggles on/off for filters?', ['Chip', 'FilterChip', 'ActionChip', 'InputChip'], 1, 'FilterChip has selected/onSelected.'),
      ],
    ),
    Lesson(
      id: 'widgets.progress',
      title: 'Progress Indicators',
      summary: 'Spinners and progress bars.',
      minutes: 5,
      sections: [
        code(r'''
const CircularProgressIndicator()            // spinning forever
const LinearProgressIndicator()

CircularProgressIndicator(value: 0.7)         // 70% determinate
LinearProgressIndicator(
  value: progress,
  minHeight: 8,
  borderRadius: BorderRadius.circular(4),
)

// iOS-style spinner
const CupertinoActivityIndicator()
'''),
        demo('progress', caption: 'Drag to set progress'),
        bullets([
          '**Indeterminate** (no `value`) — "working, unknown time".',
          '**Determinate** (`value` 0.0–1.0) — "this much is done".',
        ]),
      ],
      quiz: [
        q('What value range does a determinate progress indicator use?', ['0–100', '0.0–1.0', '1–10', 'Any'], 1, '0.0 = empty, 1.0 = full.'),
      ],
    ),
  ],
);
