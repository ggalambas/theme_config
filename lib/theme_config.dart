library theme_config;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/extensions.dart';

export 'helpers/extensions.dart';

part 'src/brightness.dart';
part 'src/custom_overlay_style.dart';
part 'src/route_aware_state.dart';
part 'src/theme_builder.dart';
part 'src/theme_mode.dart';
part 'src/theme_observer.dart';

/// The entry point for accessing ThemeConfig
abstract class ThemeConfig {
  static late final Reader _read;
  static late final SharedPreferences _preferences;
  static final _routeObserver = RouteObserver<PageRoute>();

  /// This method must be called before any usage of this package
  ///
  /// ```dart
  /// Future<void> main() async {
  ///   await ThemeConfig.init();
  ///   runApp(MyApp());
  /// }
  /// ```
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _preferences = await SharedPreferences.getInstance();
  }

  /// Gets the current [themeMode] of the application
  static ThemeMode get themeMode => _read(_themeModeProvider);
  static set themeMode(ThemeMode themeMode) =>
      _read(_themeModeProvider.notifier).state = themeMode;

  /// Gets the current [brightness] of the application
  static Brightness get brightness => _Brightness.value;

  static late SystemUiOverlayStyle _overlayStyle;
  static late SystemUiOverlayStyle _darkOverlayStyle;

  static set overlayStyle(SystemUiOverlayStyle style) {
    _overlayStyle = style;
    resetOverlayStyle();
  }

  static set darkOverlayStyle(SystemUiOverlayStyle style) {
    _darkOverlayStyle = style;
    resetOverlayStyle();
  }

  /// Overrides the previously set [overlayStyle]
  static void setOverlayStyle(SystemUiOverlayStyle style) =>
      SystemChrome.setSystemUIOverlayStyle(style);

  /// Resets the [overlayStyle]
  static void resetOverlayStyle() => SystemChrome.setSystemUIOverlayStyle(
      brightness.isLight ? _overlayStyle : _darkOverlayStyle);
}
