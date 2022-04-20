part of 'theme_config.dart';

//! give the chance to update this
final themeModeProvider = StateProvider<ThemeMode>(
  (ref) {
    final themeMode = _preferences.getInt(_themeModeKey);
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
