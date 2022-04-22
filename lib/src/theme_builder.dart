part of '../theme_config.dart';

class ThemeBuilder extends StatelessWidget {
  /// {@template builder}
  /// MaterialApp.themeMode must be set to [themeMode]
  ///
  /// ```dart
  /// ThemeBuilder(
  ///   builder: (themeMode) => MaterialApp(
  ///     themeMode: themeMode,
  ///   ),
  /// )
  /// ```
  /// {@endtemplate}
  final Widget Function(ThemeMode themeMode) builder;

  /// Listens to the application themeMode and updates the UI accordingly.
  /// If the themeMode is set to system, also listens to brightness changes.
  ///
  /// {@macro builder}
  ThemeBuilder({
    Key? key,
    SystemUiOverlayStyle overlayStyle = const SystemUiOverlayStyle(),
    SystemUiOverlayStyle darkOverlayStyle = const SystemUiOverlayStyle(),
    required this.builder,
  }) : super(key: key) {
    ThemeConfig.overlayStyle = overlayStyle;
    ThemeConfig.darkOverlayStyle = darkOverlayStyle;
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(child: _ThemeObserver(builder: builder));
  }
}
