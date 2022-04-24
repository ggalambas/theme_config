part of '../theme_config.dart';

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
    ThemeConfig._refresh = () {
      if (mounted) setState(() {});
    };
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

  void updateBrightness() => ref
      .read(_brightnessProvider.notifier)
      .update(ref.read(_themeModeProvider));

  @override
  Widget build(BuildContext context) {
    ref.watch(_themeModeProvider);
    return widget.builder(ThemeConfig._profile);
  }
}
