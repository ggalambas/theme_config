part of '../theme_config.dart';

class CustomOverlayStyle extends StatefulWidget {
  final SystemUiOverlayStyle style;
  final Widget child;

  /// Route aware widget that sets an overlay style when entering the screen
  /// and resets it back when leaving
  const CustomOverlayStyle({
    Key? key,
    required this.style,
    required this.child,
  }) : super(key: key);

  @override
  State<CustomOverlayStyle> createState() => _CustomOverlayStyleState();
}

class _CustomOverlayStyleState extends _RouteAwareState<CustomOverlayStyle> {
  @override
  void onEnterScreen() => ThemeConfig.setOverlayStyle(widget.style);

  @override
  void onLeaveScreen() => ThemeConfig.resetOverlayStyle();

  @override
  Widget build(BuildContext context) => widget.child;
}
