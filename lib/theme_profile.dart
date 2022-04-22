part of 'theme_config.dart';

class ThemeProfile {
  late final ThemeData _light;
  late final ThemeData _dark;
  late final SystemUiOverlayStyle _overlayStyle;
  late final SystemUiOverlayStyle _darkOverlayStyle;
  SystemUiOverlayStyle? _customOverlayStyle;

  ThemeProfile({
    ColorScheme colorScheme = const ColorScheme.light(),
    ColorScheme darkColorScheme = const ColorScheme.dark(),
    ThemeData Function(ColorScheme colorScheme)? theme,
    SystemUiOverlayStyle Function(ColorScheme colorScheme)? overlayStyle,
  }) {
    _light = theme?.call(colorScheme) ?? _defaultTheme(colorScheme);
    _dark = theme?.call(darkColorScheme) ?? _defaultTheme(darkColorScheme);
    _overlayStyle =
        overlayStyle?.call(colorScheme) ?? SystemUiOverlayStyle.light;
    _darkOverlayStyle =
        overlayStyle?.call(darkColorScheme) ?? SystemUiOverlayStyle.dark;
  }

  ThemeData _defaultTheme(ColorScheme colorScheme) =>
      ThemeData.from(colorScheme: colorScheme);

  ThemeData get light => _light.copyWith(
        appBarTheme: _light.appBarTheme.copyWith(
          systemOverlayStyle: _customOverlayStyle ?? _overlayStyle,
        ),
      );
  ThemeData get dark => _dark.copyWith(
        appBarTheme: _dark.appBarTheme.copyWith(
          systemOverlayStyle: _customOverlayStyle ?? _darkOverlayStyle,
        ),
      );

  ThemeMode get mode => ThemeConfig.themeMode;
}
