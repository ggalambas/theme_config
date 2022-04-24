part of '../theme_config.dart';

final _brightnessProvider =
    StateNotifierProvider<_BrightnessNotifier, Brightness>(
  (ref) {
    final themeMode = ref.watch(_themeModeProvider);
    return _BrightnessNotifier._(themeMode);
  },
);

class _BrightnessNotifier extends StateNotifier<Brightness> {
  _BrightnessNotifier._(ThemeMode themeMode) : super(fromThemeMode(themeMode)) {
    // ThemeConfig.swapOverlayStyle();
  }

  @override
  @protected
  set state(Brightness brightness) {
    super.state = brightness;
    // ThemeConfig.swapOverlayStyle();
  }

  void update(ThemeMode themeMode) => state = fromThemeMode(themeMode);

  static Brightness fromThemeMode(ThemeMode themeMode) {
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
