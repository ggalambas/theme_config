part of '../theme_config.dart';

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

class _ThemeObserver extends ConsumerStatefulWidget {
  final Widget Function(ThemeProfile) builder;
  const _ThemeObserver({Key? key, required this.builder}) : super(key: key);

  @override
  _ThemeObserverState createState() => _ThemeObserverState();
}

class _ThemeObserverState extends ConsumerState<_ThemeObserver>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    ThemeConfig._read = ref.read;
    ThemeConfig._initOverlay(refresh: () => mounted ? setState(() {}) : null);
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    updateBrightness();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  void updateBrightness() => ref
      .read(_brightnessProvider.notifier)
      .update(ref.read(_themeModeProvider));

  @override
  Widget build(BuildContext context) {
    ref.watch(_themeModeProvider);
    return widget.builder(ThemeConfig._profile);
  }
}
