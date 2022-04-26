part of '../theme_config.dart';

class OverlayStyle extends StatefulWidget {
  final SystemUiOverlayStyle style;
  final SystemUiOverlayStyle? darkStyle;
  final Widget child;

  /// Route aware widget that sets an overlay style when entering the screen
  /// and resets it back when leaving
  ///
  /// To set just one style for both themes, use [OverlayStyle.custom()]
  const OverlayStyle({
    Key? key,
    required SystemUiOverlayStyle light,
    required SystemUiOverlayStyle dark,
    required this.child,
  })  : style = light,
        darkStyle = dark,
        super(key: key);

  /// Route aware widget that sets an overlay style when entering the screen
  /// and resets it back when leaving
  ///
  /// To different styles for each theme, use [OverlayStyle()]
  const OverlayStyle.custom({
    Key? key,
    required this.style,
    required this.child,
  })  : darkStyle = null,
        super(key: key);

  @override
  State<OverlayStyle> createState() => _OverlayStyleState();
}

class _OverlayStyleState extends RouteAwareState<OverlayStyle> {
  late final SystemUiOverlayStyle oldLight;
  late final SystemUiOverlayStyle oldDark;
  late final SystemUiOverlayStyle? oldCustom;

  bool get isCustom => widget.darkStyle == null;

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
      ThemeConfig.setCustomOverlayStyle(widget.style);
    } else if (oldCustom == null) {
      ThemeConfig.setOverlayStyle(widget.style, refresh: false);
      ThemeConfig.setDarkOverlayStyle(widget.darkStyle!);
    } else {
      ThemeConfig.setOverlayStyle(widget.style, refresh: false);
      ThemeConfig.setDarkOverlayStyle(widget.darkStyle!, refresh: false);
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
      ThemeConfig.setOverlayStyle(oldLight, refresh: false);
      ThemeConfig.setDarkOverlayStyle(oldDark);
    } else {
      ThemeConfig.setOverlayStyle(oldLight, refresh: false);
      ThemeConfig.setDarkOverlayStyle(oldDark, refresh: false);
      ThemeConfig.setCustomOverlayStyle(oldCustom!);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
