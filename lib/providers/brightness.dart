part of '../theme_config.dart';

final _brightnessProvider =
    StateNotifierProvider<_BrightnessNotifier, Brightness>(
  (ref) {
    final themeMode = ref.watch(_themeModeProvider);
    return _BrightnessNotifier._(themeMode);
  },
);

class _BrightnessNotifier extends StateNotifier<Brightness> {
  _BrightnessNotifier._(ThemeMode themeMode) : super(_fromThemeMode(themeMode));

  void update(ThemeMode themeMode) => state = _fromThemeMode(themeMode);

  static Brightness _fromThemeMode(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.dark:
        return Brightness.dark;
      case ThemeMode.system:
        return _platformBrightness;
    }
  }

  static Brightness get _platformBrightness =>
      SchedulerBinding.instance!.window.platformBrightness;
}
