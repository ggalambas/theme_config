library theme_config;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

//! Default code that came as template
/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}
//!

//! Add triple-bar comments

//? Decide what to do with the preferences
late SharedPreferences preferences;
const _themeModeKey = 'themeMode';

//? Make private
extension BrightnessX on Brightness {
  bool get isLight => this == Brightness.light;
  bool get isDark => this == Brightness.dark;
  Brightness get other => isLight ? Brightness.dark : Brightness.light;
}

//? Create functions to read/watch/listen the providers so people don't need to import riverpod
//? Make private
final themeModeProvider = StateProvider<ThemeMode>(
  (ref) {
    final themeMode = preferences.getInt(_themeModeKey);
    return themeMode == null ? ThemeMode.system : ThemeMode.values[themeMode];
  },
);

final brightnessProvider = StateNotifierProvider<ThemeConfig, Brightness>(
  (ref) {
    final themeMode = ref.watch(themeModeProvider);
    late final Brightness brightness;
    switch (themeMode) {
      case ThemeMode.light:
        brightness = Brightness.light;
        break;
      case ThemeMode.dark:
        brightness = Brightness.dark;
        break;
      case ThemeMode.system:
      default:
        brightness = SchedulerBinding.instance!.window.platformBrightness;
        break;
    }
    return ThemeConfig(themeMode, brightness);
  },
);

class ThemeConfig extends StateNotifier<Brightness> {
  final ThemeMode _themeMode;

  ThemeConfig(this._themeMode, Brightness brightness) : super(brightness) {
    preferences.setInt(_themeModeKey, _themeMode.index);
    setSystemBarsStyle();
  }

  //! check everything from here

  void update() {
    if (_themeMode == ThemeMode.system) {
      state = SchedulerBinding.instance!.window.platformBrightness;
      setSystemBarsStyle();
    }
  }

  void setSystemBarsStyle({
    bool transparentStatusBar = true,
    Color? systemNavigationBarColor,
  }) {
    SystemChrome.setSystemUIOverlayStyle(
      overlayStyle(
        state,
        transparentStatusBar: transparentStatusBar,
        systemNavigationBarColor: systemNavigationBarColor,
      ),
    );
  }

  //!
  // static ThemeData get light => theme(Palette.colorScheme);
  // static ThemeData get dark => theme(Palette.darkColorScheme);

  //! apply in the appBarTheme systemOverlayStyle property
  static SystemUiOverlayStyle overlayStyle(
    Brightness brightness, {
    bool transparentStatusBar = true,
    Color? systemNavigationBarColor,
  }) {
    const color = Colors.white; //!
    // final color = brightness.isLight
    //     ? Palette.colorScheme.background
    //     : Palette.darkColorScheme.background;
    return SystemUiOverlayStyle(
      statusBarColor: transparentStatusBar ? Colors.transparent : color,
      statusBarBrightness: brightness.other,
      statusBarIconBrightness: brightness.other,
      systemNavigationBarIconBrightness: brightness.other,
      systemNavigationBarColor: systemNavigationBarColor ?? color,
    );
  }
}
