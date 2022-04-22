part of '../theme_config.dart';

class ThemeBuilder extends ConsumerStatefulWidget {
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
  _ThemeBuilderState createState() => _ThemeBuilderState();
}

class _ThemeBuilderState extends ConsumerState<ThemeBuilder>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    ThemeConfig._read = ref.read;
    updateBrightness();
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

  void updateBrightness() => _Brightness.update(ref.read(_themeModeProvider));

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(_themeModeProvider);
    return widget.builder(themeMode);
  }
}
