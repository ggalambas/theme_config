part of '../theme_config.dart';

class OverlayStyle extends StatefulWidget {
  final SystemUiOverlayStyle? lightStyle;
  final SystemUiOverlayStyle? darkStyle;
  final SystemUiOverlayStyle? customStyle;
  final bool isCustom;
  final Widget child;

  const OverlayStyle._({
    Key? key,
    this.lightStyle,
    this.darkStyle,
    this.customStyle,
    required this.isCustom,
    required this.child,
  }) : super(key: key);

  /// {@template description}
  /// Route aware widget that sets an overlay style when entering the screen
  /// and resets it back when leaving
  ///
  /// For this widget to work you must add [ThemeConfig.routeObserver] to
  /// [MaterialApp.navigatorObservers]
  ///
  /// ```dart
  /// MaterialApp(
  ///   navigatorObservers: [ThemeConfig.routeObserver]
  /// )
  /// ```
  /// {@endtemplate}
  ///
  /// To set just one style for both themes, use [OverlayStyle.custom]
  factory OverlayStyle({
    Key? key,
    SystemUiOverlayStyle? light,
    SystemUiOverlayStyle? dark,
    required Widget child,
  }) =>
      OverlayStyle._(
        key: key,
        lightStyle: light,
        darkStyle: dark,
        isCustom: false,
        child: child,
      );

  /// {@macro description}
  ///
  /// To different styles for each theme, use [OverlayStyle]
  factory OverlayStyle.custom({
    Key? key,
    required SystemUiOverlayStyle? style,
    required Widget child,
  }) =>
      OverlayStyle._(
        key: key,
        customStyle: style,
        isCustom: true,
        child: child,
      );

  @override
  State<OverlayStyle> createState() => _OverlayStyleState();
}

class _OverlayStyleState extends RouteAwareState<OverlayStyle> {
  late final bool wasCustom;
  late final SystemUiOverlayStyle? oldLight;
  late final SystemUiOverlayStyle? oldDark;
  late final SystemUiOverlayStyle? oldCustom;

  void saveOldStyles() {
    wasCustom = ThemeConfig._overlay is CustomOverlay;
    oldLight = LightOverlay().style;
    oldDark = DarkOverlay().style;
    oldCustom = wasCustom ? ThemeConfig._overlay.style : null;
  }

  @override
  void onEnterScreen() {
    saveOldStyles();
    if (widget.isCustom) {
      ThemeConfig.setCustomOverlayStyle(widget.customStyle!);
    } else if (wasCustom) {
      LightOverlay().style = widget.lightStyle;
      DarkOverlay().style = widget.darkStyle;
      ThemeConfig._overlay.refreshAndApply();
    } else {
      LightOverlay().style = widget.lightStyle;
      DarkOverlay().style = widget.darkStyle;
      ThemeConfig.removeCustomOverlayStyle();
    }
  }

  @override
  void onLeaveScreen() {
    if (widget.isCustom) {
      wasCustom
          ? ThemeConfig.setCustomOverlayStyle(oldCustom!)
          : ThemeConfig.removeCustomOverlayStyle();
    } else if (wasCustom) {
      LightOverlay().style = oldLight;
      DarkOverlay().style = oldDark;
      ThemeConfig._overlay.refreshAndApply();
    } else {
      LightOverlay().style = oldLight;
      DarkOverlay().style = oldDark;
      ThemeConfig.setCustomOverlayStyle(oldCustom!);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
