import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theme_config/theme_config.dart';

class ThemeModeBuilder extends ConsumerWidget {
  final Widget Function(ThemeMode themeMode) builder;
  const ThemeModeBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return builder(themeMode);
  }
}

class BrightnessBuilder extends ConsumerWidget {
  final Widget Function(Brightness brightness) builder;
  const BrightnessBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = ref.watch(brightnessProvider);
    return builder(brightness);
  }
}

class ThemeBuilder extends ConsumerStatefulWidget {
  final Widget Function(ThemeConfig themeConfig) builder;
  const ThemeBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  _ThemeBuilderState createState() => _ThemeBuilderState();
}

class _ThemeBuilderState extends ConsumerState<ThemeBuilder>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
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

  void updateBrightness() => ref.read(brightnessProvider.notifier).update();

  @override
  Widget build(BuildContext context) {
    ref.watch(brightnessProvider);
    final themeConfig = ref.watch(brightnessProvider.notifier);
    return widget.builder(themeConfig);
  }
}
