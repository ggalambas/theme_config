part of '../theme_config.dart';

class ThemeProfile {
  final ThemeData _light;
  final ThemeData _dark;

  ThemeProfile({
    ThemeData? lightTheme,
    ThemeData? darkTheme,
    SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle.light,
    SystemUiOverlayStyle darkOverlayStyle = SystemUiOverlayStyle.dark,
  })  : _light = lightTheme ?? ThemeData.light(),
        _dark = darkTheme ?? ThemeData.dark();

  ThemeProfile.fromColorScheme({
    ColorScheme colorScheme = const ColorScheme.light(),
    ColorScheme darkColorScheme = const ColorScheme.dark(),
    ThemeData Function(ColorScheme colorScheme)? theme,
    SystemUiOverlayStyle Function(ColorScheme colorScheme)? overlayStyle,
  })  : _light = theme?.call(colorScheme) ?? _defaultTheme(colorScheme),
        _dark = theme?.call(darkColorScheme) ?? _defaultTheme(darkColorScheme) {
    LightOverlay().setStyle(
        overlayStyle?.call(colorScheme) ?? SystemUiOverlayStyle.light,
        refresh: false);
    DarkOverlay().setStyle(
        overlayStyle?.call(darkColorScheme) ?? SystemUiOverlayStyle.dark,
        refresh: false);
  }

  static ThemeData _defaultTheme(ColorScheme colorScheme) =>
      ThemeData.from(colorScheme: colorScheme);

  ThemeData get light => _light.copyWith(
        appBarTheme: _light.appBarTheme.copyWith(
          systemOverlayStyle: ThemeConfig._overlay.style,
        ),
      );

  ThemeData get dark => _dark.copyWith(
        appBarTheme: _dark.appBarTheme.copyWith(
          systemOverlayStyle: ThemeConfig._overlay.style,
        ),
      );

  ThemeMode get mode => ThemeConfig.themeMode;
}
