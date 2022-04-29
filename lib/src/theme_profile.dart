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
    SystemUiOverlayStyle? overlayStyle,
    SystemUiOverlayStyle? darkOverlayStyle,
  })  : _light = theme ?? ThemeData.light(),
        _dark = darkTheme ?? ThemeData.dark() {
    LightOverlay().style = overlayStyle;
    DarkOverlay().style = darkOverlayStyle;
  }

  /// {@macro description}
  ///
  /// To set the styles independently, use [ThemeProfile()]
  ThemeProfile.fromColorScheme({
    required ColorScheme colorScheme,
    required ColorScheme darkColorScheme,
    ThemeData Function(ColorScheme colorScheme)? theme,
    SystemUiOverlayStyle? Function(ColorScheme colorScheme)? overlayStyle,
  })  : _light = theme?.call(colorScheme) ?? _defaultTheme(colorScheme),
        _dark = theme?.call(darkColorScheme) ?? _defaultTheme(darkColorScheme) {
    LightOverlay().style = overlayStyle?.call(colorScheme);
    DarkOverlay().style = overlayStyle?.call(darkColorScheme);
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
