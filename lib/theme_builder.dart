part of 'theme_config.dart';

class ThemeBuilder extends StatelessWidget {
  /// {@template builder}
  /// MaterialApp's theme, darkTheme and themeMode must be
  /// set to [theme.light], [theme.dark] and [theme.mode], repectively
  ///
  /// ```dart
  /// ThemeBuilder(
  ///   builder: (theme) => MaterialApp(
  ///     theme: theme.light,
  ///     darkTheme: theme.dark,
  ///     themeMode: theme.mode,
  ///   ),
  /// )
  /// ```
  /// {@endtemplate}
  final Widget Function(ThemeProfile theme) builder;

  /// Listens to the application themeMode and updates the UI accordingly.
  /// If the themeMode is set to system, also listens to brightness changes
  ///
  /// {@macro builder}
  const ThemeBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(child: _ThemeObserver(builder: builder));
  }
}
