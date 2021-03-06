/// theme_config  package
library theme_config;

import 'dart:async';

import 'package:flutter/material.dart' hide Overlay;
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_config/components/overlay.dart';
import 'package:theme_config/components/route_aware_state.dart';

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
  static final routeObserver = RouteObserver<PageRoute>();

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

  /// Gets the current theme mode of the application
  static ThemeMode get themeMode => _read(_themeModeProvider);

  /// Sets a new [themeMode] for the application
  static setThemeMode(ThemeMode themeMode) =>
      _read(_themeModeProvider.notifier).state = themeMode;

  /// Gets the current brightness of the application
  static Brightness get brightness => _read(_brightnessProvider);

  /// Overrides the previously set overlay style
  static setOverlayStyle(SystemUiOverlayStyle style) {
    LightOverlay().style = style;
    _overlay.refreshAndApply(apply: _overlay is LightOverlay);
  }

  /// Overrides the previously set dark overlay style
  static setDarkOverlayStyle(SystemUiOverlayStyle style) {
    DarkOverlay().style = style;
    _overlay.refreshAndApply(apply: _overlay is DarkOverlay);
  }

  /// Overrides all the styles, to reset you can call [removeCustomOverlayStyle]
  static void setCustomOverlayStyle(SystemUiOverlayStyle style) =>
      _overlay.setCustom(style);

  /// Removes the custom overlay style
  static void removeCustomOverlayStyle() => _overlay.removeCustom(brightness);
}
