library theme_config;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_config/extensions.dart';

part 'providers.dart';

//! Add triple-bar comments

late SharedPreferences _preferences;
const _themeModeKey = 'themeMode';

class ThemeConfig extends StateNotifier<Brightness> {
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  final ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;

  ThemeConfig(this._themeMode, Brightness brightness) : super(brightness) {
    _preferences.setInt(_themeModeKey, _themeMode.index);
    setSystemBarsStyle();
  }

  void update() {
    if (!_themeMode.isSystem) return;
    state = SchedulerBinding.instance!.window.platformBrightness;
    setSystemBarsStyle();
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
    final color = Colors.white;
    // final color = brightness.isLight
    //     ? Palette.colorScheme.background
    //     : Palette.darkColorScheme.background;
    return SystemUiOverlayStyle(
      statusBarColor: transparentStatusBar ? Colors.transparent : color,
      statusBarBrightness: brightness.other,
      statusBarIconBrightness: brightness.other,
      systemStatusBarContrastEnforced: null,
      systemNavigationBarColor: systemNavigationBarColor ?? color,
      systemNavigationBarIconBrightness: brightness.other,
      systemNavigationBarDividerColor: null,
      systemNavigationBarContrastEnforced: null,
    );
  }
}
