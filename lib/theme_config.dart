library theme_config;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/extensions.dart';

export 'helpers/extensions.dart';

part 'src/brightness.dart';
part 'src/theme_builder.dart';
part 'src/theme_mode.dart';

/// The entry point for accessing ThemeConfig
abstract class ThemeConfig {
  static late Reader _read;
  static late SharedPreferences _preferences;

  /// This method must be called before any usage of this package
  ///
  /// ```dart
  /// Future<void> main() async {
  ///   await ThemeConfig.init();
  /// }
  /// ```
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// Gets the current [themeMode] of the application
  static ThemeMode get themeMode => _read(_themeModeProvider);
  static set themeMode(ThemeMode themeMode) =>
      _read(_themeModeProvider.notifier).state = themeMode;

  /// Gets the current [brightness] of the application
  static Brightness get brightness => _read(_brightnessProvider);

  static late SystemUiOverlayStyle _overlayStyle;
  static late SystemUiOverlayStyle _darkOverlayStyle;

  /// Overrides the previously set [overlayStyle]
  static void setOverlayStyle(SystemUiOverlayStyle style) =>
      SystemChrome.setSystemUIOverlayStyle(style);

  /// Resets the [overlayStyle]
  static void resetOverlayStyle() => SystemChrome.setSystemUIOverlayStyle(
      brightness.isLight ? _overlayStyle : _darkOverlayStyle);
}
