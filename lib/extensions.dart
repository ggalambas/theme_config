import 'package:flutter/material.dart';

extension BrightnessX on Brightness {
  bool get isLight => this == Brightness.light;
  bool get isDark => this == Brightness.dark;
  Brightness get other => isLight ? Brightness.dark : Brightness.light;
}

extension ThemeModeX on ThemeMode {
  bool get isLight => this == ThemeMode.light;
  bool get isDark => this == ThemeMode.dark;
  bool get isSystem => this == ThemeMode.system;
}
