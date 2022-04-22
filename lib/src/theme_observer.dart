part of '../theme_config.dart';

class _ThemeObserver extends ConsumerStatefulWidget {
  final Widget Function(ThemeMode themeMode) builder;
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
