part of '../theme_config.dart';

final _brightnessProvider =
    StateNotifierProvider<_BrightnessNotifier, Brightness>(
  (ref) {
    final themeMode = ref.watch(_themeModeProvider);
    return _BrightnessNotifier._(themeMode);
  },
);

class _BrightnessNotifier extends StateNotifier<Brightness> {
  final ThemeMode _themeMode;
  _BrightnessNotifier._(this._themeMode) : super(_resolve(_themeMode)) {
    _changeOverlayStyle();
  }

  static Brightness get _platformBrightness =>
      SchedulerBinding.instance!.window.platformBrightness;

  static Brightness _resolve(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.dark:
        return Brightness.dark;
      case ThemeMode.system:
        return _platformBrightness;
    }
  }

  @override
  @protected
  set state(Brightness brightness) {
    _changeOverlayStyle();
    super.state = brightness;
  }

  void _update() {
    if (!_themeMode.isSystem) state = _platformBrightness;
  }

  _changeOverlayStyle() => ThemeConfig.resetOverlayStyle();
}
