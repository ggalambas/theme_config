import 'package:flutter/material.dart';

extension BrightnessX on Brightness {
  /// Whether this brightness is light
  bool get isLight => this == Brightness.light;

  /// Whether this brightness is dark
  bool get isDark => this == Brightness.dark;

  /// Gets the opposite brightness
  Brightness get other => isLight ? Brightness.dark : Brightness.light;
}

extension ThemeModeX on ThemeMode {
  /// Whether this theme mode is light
  bool get isLight => this == ThemeMode.light;

  /// Whether this theme mode is dark
  bool get isDark => this == ThemeMode.dark;

  /// Whether this theme mode is system
  bool get isSystem => this == ThemeMode.system;
}
