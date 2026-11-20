import 'package:flutter/material.dart';

import '../../models/lesson.dart';
import '../dsl.dart';

final theming = LearningModule(
  id: 'theme',
  title: 'Styling & Theming',
  description: 'Themes, colour schemes, dark mode, decorations, fonts and responsive layouts.',
  level: Level.intermediate,
  icon: Icons.palette_rounded,
  color: const Color(0xFFD81B60),
  lessons: [
    Lesson(
      id: 'theme.themedata',
      title: 'ThemeData & ColorScheme',
      summary: 'Style the whole app from one place.',
      minutes: 9,
      sections: [
        p('Instead of colouring every widget by hand, define a **theme** once in `MaterialApp`. All Material widgets use it automatically.'),
        code(r'''
MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(fontWeight: FontWeight.w800),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  ),
  home: const HomePage(),
)
'''),
        p('`ColorScheme.fromSeed` generates a full, accessible palette from **one** colour. Pick a seed and watch:'),
        demo('theme_seed', caption: 'Change the seed colour'),
        h('Use theme colours in your widgets'),
        code(r'''
final colors = Theme.of(context).colorScheme;

Container(color: colors.primaryContainer,
  child: Text('Hi', style: TextStyle(color: colors.onPrimaryContainer)),
)
'''),
        bullets([
          '`primary` / `onPrimary` — main brand colour and the text/icon colour on top of it.',
          '`secondary`, `tertiary` — accents.',
          '`surface` / `onSurface` — backgrounds of cards, sheets.',
          '`error` / `onError` — errors.',
          '`…Container` — softer versions for large areas.',
        ]),
        tip('Never hard-code `Colors.white` for text on a coloured background — use the matching `on…` colour so dark mode just works.'),
      ],
      quiz: [
        q('What does ColorScheme.fromSeed do?', ['Picks a random colour', 'Generates a full palette from one colour', 'Loads a theme file', 'Enables dark mode'], 1,
            'It derives a harmonious Material 3 palette.'),
        q('Which colour should text on a "primary" background use?', ['Colors.white', 'onPrimary', 'secondary', 'surface'], 1,
            'on* colours contrast with their base.'),
      ],
    ),
    Lesson(
      id: 'theme.dark',
      title: 'Dark Mode',
      summary: 'Light and dark themes, following the system setting.',
      minutes: 6,
      sections: [
        code(r'''
MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
  ),
  darkTheme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      brightness: Brightness.dark,
    ),
  ),
  themeMode: ThemeMode.system, // .light, .dark, or follow the phone
)

// Check the current brightness anywhere
final isDark = Theme.of(context).brightness == Brightness.dark;
'''),
        demo('dark_mode', caption: 'Same UI, light vs dark'),
        tip('FlutterLab has a theme switch in the **Me** tab — it stores your choice and passes it to `themeMode`.'),
      ],
      quiz: [
        q('Which ThemeMode follows the phone\'s setting?', ['ThemeMode.auto', 'ThemeMode.system', 'ThemeMode.device', 'ThemeMode.light'], 1, 'system follows the OS.'),
      ],
    ),
    Lesson(
      id: 'theme.decoration',
      title: 'BoxDecoration: Gradients, Shadows, Borders',
      summary: 'Make beautiful boxes.',
      minutes: 7,
      sections: [
        code(r'''
Container(
  height: 140,
  decoration: BoxDecoration(
    gradient: const LinearGradient(
      colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: Colors.white24, width: 2),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.25),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ],
  ),
)

// Circle
const BoxDecoration(shape: BoxShape.circle, color: Colors.amber)

// Background image
BoxDecoration(
  image: DecorationImage(image: AssetImage('assets/bg.png'), fit: BoxFit.cover),
)
'''),
        demo('decoration', caption: 'Decoration playground'),
        note('Other gradients: `RadialGradient` (from a centre outwards) and `SweepGradient` (around a centre, like a clock).'),
      ],
      quiz: [
        q('Which property adds a drop shadow?', ['shadow', 'boxShadow', 'elevation', 'blur'], 1, 'BoxDecoration.boxShadow takes a list of BoxShadows.'),
      ],
    ),
    Lesson(
      id: 'theme.responsive',
      title: 'Fonts, Assets & Responsive Design',
      summary: 'Custom fonts and layouts that adapt to any screen.',
      minutes: 10,
      sections: [
        h('Custom fonts'),
        code(r'''
# pubspec.yaml
flutter:
  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
        - asset: assets/fonts/Poppins-Bold.ttf
          weight: 700
''', caption: 'pubspec.yaml'),
        code(r'''
ThemeData(fontFamily: 'Poppins')            // whole app
Text('Hi', style: TextStyle(fontFamily: 'Poppins'))
'''),
        tip('The `google_fonts` package gives you 1,500+ fonts with one line: `GoogleFonts.poppins()`.'),
        h('Responsive layouts'),
        p('Phones, tablets and foldables have very different sizes. Two tools help:'),
        code(r'''
// 1. MediaQuery: info about the whole screen
final width = MediaQuery.sizeOf(context).width;
final isTablet = width > 600;

// 2. LayoutBuilder: the space available to THIS widget
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      return const TwoColumnLayout();
    }
    return const OneColumnLayout();
  },
)
'''),
        demo('responsive', caption: 'Drag to resize the "screen"'),
        bullets([
          'Avoid fixed widths for big areas; use `Expanded`, `Flexible`, `FractionallySizedBox`.',
          'Common breakpoints: < 600 phone, 600–840 tablet, > 840 desktop.',
          'Respect the user\'s text size: don\'t put text in tight fixed-height boxes.',
          '`SafeArea` keeps content away from notches and system bars.',
        ]),
      ],
      quiz: [
        q('Which widget tells you the space available to a specific widget?', ['MediaQuery', 'LayoutBuilder', 'SafeArea', 'Expanded'], 1,
            'LayoutBuilder gives the parent\'s constraints.'),
      ],
    ),
  ],
);
