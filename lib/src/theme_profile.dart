part of '../theme_config.dart';

class ThemeProfile {
  final ThemeData _light;
  final ThemeData _dark;

  /// {@template description}
  /// Provides the app's themes and overlay styles for the ThemeConfig to handle
  /// {@endtemplate}
  ///
  /// To set the styles based on a colorScheme, use [ThemeProfile.fromColorScheme()]
  ThemeProfile({
    ThemeData? theme,
    ThemeData? darkTheme,
    SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle.light,
    SystemUiOverlayStyle darkOverlayStyle = SystemUiOverlayStyle.dark,
  })  : _light = theme ?? ThemeData.light(),
        _dark = darkTheme ?? ThemeData.dark() {
    LightOverlay().setStyle(overlayStyle, refresh: false);
    DarkOverlay().setStyle(darkOverlayStyle, refresh: false);
  }

  /// {@macro description}
  ///
  /// To set the styles independently, use [ThemeProfile()]
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

  /// Light theme with the light overlay style applied
  ThemeData get light => _light.copyWith(
        appBarTheme: _light.appBarTheme.copyWith(
          systemOverlayStyle:
              ThemeConfig._overlay.customOrNull ?? LightOverlay().style,
        ),
      );

  /// Dark theme with the dark overlay style applied
  ThemeData get dark => _dark.copyWith(
        appBarTheme: _dark.appBarTheme.copyWith(
          systemOverlayStyle:
              ThemeConfig._overlay.customOrNull ?? DarkOverlay().style,
        ),
      );

  ThemeMode get mode => ThemeConfig.themeMode;
}
