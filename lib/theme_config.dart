library theme_config;

import 'dart:async';

import 'package:flutter/material.dart' hide Overlay;
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_config/components/overlay.dart';
import 'package:theme_config/components/route_aware_state.dart';
import 'package:theme_config/helpers/extensions.dart';

export 'helpers/extensions.dart';

part 'providers/brightness.dart';
part 'providers/theme_mode.dart';
part 'src/overlay_style.dart';
part 'src/theme_builder.dart';
part 'src/theme_profile.dart';

/// The entry point for accessing ThemeConfig
abstract class ThemeConfig {
  static late final Reader _read;
  static late final SharedPreferences _preferences;
  static late final ThemeProfile _profile;
  static late Overlay _overlay;

  /// This method must be called before any usage of this package
  ///
  /// ```dart
  /// Future<void> main() async {
  ///   await ThemeConfig.init(themeProfile);
  ///   runApp(MyApp());
  /// }
  /// ```
  static Future<void> init(ThemeProfile profile) async {
    WidgetsFlutterBinding.ensureInitialized();
    _preferences = await SharedPreferences.getInstance();
    _profile = profile;
  }

  static void _initOverlay({required VoidCallback refresh}) =>
      _overlay = Overlay.init(
        brightness: brightness,
        refresh: refresh,
        changeOverlay: (overlay) => _overlay = overlay,
      );

  /// Gets the current [themeMode] of the application
  static ThemeMode get themeMode => _read(_themeModeProvider);

  /// Sets a new [themeMode] for the application
  static setThemeMode(ThemeMode themeMode) =>
      _read(_themeModeProvider.notifier).state = themeMode;

  /// Gets the current [brightness] of the application
  static Brightness get brightness => _read(_brightnessProvider);

  /// Overrides the previously set [overlayStyle]
  /// todo [refresh]
  static setOverlayStyle(SystemUiOverlayStyle style) => _setOverlayStyle(style);
  static _setOverlayStyle(
    SystemUiOverlayStyle style, {
    bool refresh = true,
  }) =>
      LightOverlay().setStyle(
        style,
        refresh: refresh,
        apply: brightness.isLight,
      );

  /// Overrides the previously set [darkOverlayStyle]
  /// todo [refresh]
  static setDarkOverlayStyle(SystemUiOverlayStyle style) =>
      _setDarkOverlayStyle(style);
  static _setDarkOverlayStyle(
    SystemUiOverlayStyle style, {
    bool refresh = true,
  }) =>
      DarkOverlay().setStyle(
        style,
        refresh: refresh,
        apply: brightness.isDark,
      );

  /// Overrides all the styles, to reset you can call [removeCustomOverlayStyle]
  static void setCustomOverlayStyle(SystemUiOverlayStyle style) =>
      _overlay.setCustom(style);

  /// Removes the [customOverlay]
  static void removeCustomOverlayStyle() => _overlay.removeCustom(brightness);
}
