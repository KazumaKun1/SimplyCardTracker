import 'package:flutter/material.dart';

const _fabTheme = FloatingActionButtonThemeData(
  backgroundColor: Color(0xFF0065BE),
  foregroundColor: Colors.white,
  shape: StadiumBorder(),
  sizeConstraints: .tightFor(width: 72, height: 72),
  iconSize: 40,
);

final lightTheme = ThemeData(
  colorScheme:
      ColorScheme.fromSeed(
        seedColor: const Color(0xFF0065BE),
        brightness: Brightness.light,
      ).copyWith(
        surface: const Color(0xFFFAF6F0),
        surfaceContainer: Colors.white,
        surfaceContainerHighest: const Color(0xFFE8E8E9),
        primary: const Color(0xFF0065BE),
        onPrimary: Colors.white,
        onSurface: Colors.black,
        onSurfaceVariant: const Color(0xFF707075), // ink-secondary
        outlineVariant: const Color(0xFFE4E1DD), // separator
        error: const Color(0xFFE30005), // destructive
      ),
  floatingActionButtonTheme: _fabTheme.copyWith(
    backgroundColor: const Color(0xFF007DDD),
  ),
);

final darkTheme = ThemeData(
  colorScheme:
      ColorScheme.fromSeed(
        seedColor: const Color(0xFF0091FF),
        brightness: Brightness.dark,
      ).copyWith(
        surface: Colors.black,
        surfaceContainer: const Color(0xFF232019),
        surfaceContainerHighest: const Color(0xFF383631),
        primary: const Color(0xFF0091FF),
        onPrimary: Colors.white,
        onSurface: Colors.white,
        onSurfaceVariant: const Color(0xFF8E8E93),
        outlineVariant: const Color(0xFF323235),
        error: const Color(0xFFFF4245),
      ),
  floatingActionButtonTheme: _fabTheme.copyWith(
    shape: const StadiumBorder(
      side: BorderSide(color: Color(0xFF0091FF), width: 1),
    ),
  ),
);
