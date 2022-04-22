part of '../theme_config.dart';

abstract class _Brightness {
  static late Brightness _value;
  static Brightness get value => _value;
  static set value(Brightness brightness) {
    value = brightness;
    ThemeConfig.resetOverlayStyle();
  }

  static Brightness get _platformBrightness =>
      SchedulerBinding.instance!.window.platformBrightness;

  static void setFromThemeMode(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        value = Brightness.light;
        break;
      case ThemeMode.dark:
        value = Brightness.dark;
        break;
      case ThemeMode.system:
        value = _platformBrightness;
        break;
    }
  }

  static void update(ThemeMode themeMode) {
    if (!themeMode.isSystem) value = _platformBrightness;
  }
}
