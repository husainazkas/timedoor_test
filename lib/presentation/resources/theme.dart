import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme {
    final baseTheme = ThemeData();
    return _createTheme(baseTheme);
  }

  static ThemeData get darkTheme {
    final baseTheme = ThemeData.dark();
    return _createTheme(baseTheme);
  }

  static ThemeData _createTheme(ThemeData baseTheme) {
    return baseTheme.copyWith(
      inputDecorationTheme: _createInputDecorationTheme(baseTheme),
    );
  }

  static InputDecorationTheme _createInputDecorationTheme(ThemeData baseTheme) {
    return const InputDecorationTheme(border: OutlineInputBorder());
  }
}
