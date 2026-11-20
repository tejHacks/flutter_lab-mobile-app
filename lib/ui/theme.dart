import 'package:flutter/material.dart';

const flutterBlue = Color(0xFF0B6BCB);

ThemeData buildTheme(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(seedColor: flutterBlue, brightness: brightness);
  final isDark = brightness == Brightness.dark;
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    scaffoldBackgroundColor: isDark ? const Color(0xFF0F1318) : const Color(0xFFF6F8FB),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      backgroundColor: isDark ? const Color(0xFF0F1318) : const Color(0xFFF6F8FB),
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: isDark ? const Color(0xFF181E26) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      filled: true,
      fillColor: isDark ? const Color(0xFF181E26) : Colors.white,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: isDark ? const Color(0xFF151A21) : Colors.white,
      indicatorColor: scheme.primaryContainer,
    ),
  );
}

/// Colours for the code highlighter (always a dark "editor" look).
class CodeColors {
  static const background = Color(0xFF1B2230);
  static const plain = Color(0xFFE6EDF3);
  static const keyword = Color(0xFFFF7B9C);
  static const type = Color(0xFF7DD3FC);
  static const string = Color(0xFFA5E075);
  static const number = Color(0xFFFFB86C);
  static const comment = Color(0xFF7D8799);
  static const annotation = Color(0xFFE5C07B);
  static const function = Color(0xFFC4A7FF);
}
