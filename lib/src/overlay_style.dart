part of '../theme_config.dart';

class OverlayStyle extends StatefulWidget {
  final SystemUiOverlayStyle? lightStyle;
  final SystemUiOverlayStyle? darkStyle;
  final SystemUiOverlayStyle? customStyle;
  final Widget child;

  const OverlayStyle._({
    Key? key,
    this.lightStyle,
    this.darkStyle,
    this.customStyle,
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
  /// To set just one style for both themes, use [OverlayStyle.custom()]
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
        child: child,
      );

  /// {@macro description}
  ///
  /// To different styles for each theme, use [OverlayStyle()]
  factory OverlayStyle.custom({
    Key? key,
    required SystemUiOverlayStyle style,
    required Widget child,
  }) =>
      OverlayStyle._(
        key: key,
        customStyle: style,
        child: child,
      );

  @override
  State<OverlayStyle> createState() => _OverlayStyleState();
}

class _OverlayStyleState extends RouteAwareState<OverlayStyle> {
  late final SystemUiOverlayStyle oldLight;
  late final SystemUiOverlayStyle oldDark;
  late final SystemUiOverlayStyle? oldCustom;

  bool get isCustom => widget.customStyle != null;
  SystemUiOverlayStyle get light => widget.lightStyle ?? oldLight;
  SystemUiOverlayStyle get dark => widget.darkStyle ?? oldDark;

  void saveOldStyles() {
    oldLight = LightOverlay().style;
    oldDark = DarkOverlay().style;
    oldCustom = ThemeConfig._overlay is CustomOverlay
        ? ThemeConfig._overlay.style
        : null;
  }

  @override
  void onEnterScreen() {
    saveOldStyles();
    if (isCustom) {
      ThemeConfig.setCustomOverlayStyle(widget.customStyle!);
    } else if (oldCustom == null) {
      ThemeConfig._setOverlayStyle(light, refresh: false);
      ThemeConfig._setDarkOverlayStyle(dark);
    } else {
      ThemeConfig._setOverlayStyle(light, refresh: false);
      ThemeConfig._setDarkOverlayStyle(dark, refresh: false);
      ThemeConfig.removeCustomOverlayStyle();
    }
  }

  @override
  void onLeaveScreen() {
    if (isCustom) {
      oldCustom == null
          ? ThemeConfig.removeCustomOverlayStyle()
          : ThemeConfig.setCustomOverlayStyle(oldCustom!);
    } else if (oldCustom == null) {
      ThemeConfig._setOverlayStyle(oldLight, refresh: false);
      ThemeConfig._setDarkOverlayStyle(oldDark);
    } else {
      ThemeConfig._setOverlayStyle(oldLight, refresh: false);
      ThemeConfig._setDarkOverlayStyle(oldDark, refresh: false);
      ThemeConfig.setCustomOverlayStyle(oldCustom!);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
