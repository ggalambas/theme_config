library theme_config;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/extensions.dart';

export 'helpers/extensions.dart';

part 'providers/brightness.dart';
part 'providers/overlay.dart';
part 'providers/theme_mode.dart';
part 'src/custom_overlay_style.dart';
part 'src/route_aware_state.dart';
part 'src/theme_observer.dart';
part 'theme_builder.dart';
part 'theme_profile.dart';

/// The entry point for accessing ThemeConfig
abstract class ThemeConfig {
  static final _routeObserver = RouteObserver<PageRoute>();
  static late final Reader _read;
  static late final VoidCallback _refresh;
  static late final SharedPreferences _preferences;
  static late final ThemeProfile _profile;

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

  /// Gets the current [themeMode] of the application
  static ThemeMode get themeMode => _read(_themeModeProvider);
  static set themeMode(ThemeMode themeMode) =>
      _read(_themeModeProvider.notifier).state = themeMode;

  /// Gets the current [brightness] of the application
  static Brightness get brightness => _read(_brightnessProvider);

  static Overlay overlay;

  static set overlayStyle(SystemUiOverlayStyle style) {
    _profile._overlayStyle = style;
    _refresh();
  }

  static set darkOverlayStyle(SystemUiOverlayStyle style) {
    _profile._darkOverlayStyle = style;
    _refresh();
  }

  /// Overrides the previously set [overlayStyle]
  static void setOverlayStyle(SystemUiOverlayStyle style) {
    _profile._customOverlayStyle = style;
    _refresh();
    // avoid blinking when there's an app bar
    Future.delayed(
      const Duration(milliseconds: 200),
      () => SystemChrome.setSystemUIOverlayStyle(style),
    );
  }

  /// Resets the [overlayStyle]
  static void resetOverlayStyle() {
    _profile._customOverlayStyle = null;
    SystemChrome.setSystemUIOverlayStyle(
      brightness.isLight ? _profile._overlayStyle : _profile._darkOverlayStyle,
    );
    _refresh();
  }
}
