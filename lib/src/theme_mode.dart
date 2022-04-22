part of '../theme_config.dart';

final _themeModeProvider = StateNotifierProvider<_ThemeModeNotifier, ThemeMode>(
  (ref) => _ThemeModeNotifier._(),
);

class _ThemeModeNotifier extends StateNotifier<ThemeMode> {
  static const _themeModeKey = 'themeMode';
  _ThemeModeNotifier._() : super(_initial) {
    _Brightness.setFromThemeMode(state);
  }

  static ThemeMode get _initial {
    final i = ThemeConfig._preferences.getInt(_themeModeKey);
    return i == null ? ThemeMode.system : ThemeMode.values[i];
  }

  @override
  @protected
  set state(ThemeMode themeMode) {
    ThemeConfig._preferences.setInt(_themeModeKey, themeMode.index);
    super.state = themeMode;
    _Brightness.setFromThemeMode(state);
  }
}
