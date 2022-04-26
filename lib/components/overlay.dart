import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:theme_config/helpers/extensions.dart';

abstract class Overlay {
  static late final VoidCallback _refresh;
  static late final ValueChanged<Overlay> _changeOverlay;

  static Overlay init({
    required Brightness brightness,
    required VoidCallback refresh,
    required ValueChanged<Overlay> changeOverlay,
  }) {
    _refresh = refresh;
    _changeOverlay = changeOverlay;
    return (brightness.isLight ? LightOverlay() : DarkOverlay()).._apply();
  }

  Overlay _changeTo(Overlay overlay) {
    _changeOverlay(overlay);
    return overlay;
  }

  late SystemUiOverlayStyle _style;
  SystemUiOverlayStyle get style => _style;
  void setStyle(
    SystemUiOverlayStyle style, {
    bool refresh = true,
    bool apply = true,
  }) {
    _style = style;
    if (refresh && apply) {
      _refreshAndApply();
    } else if (refresh) {
      _refresh();
    } else if (apply) {
      _apply();
    }
  }

  Overlay([SystemUiOverlayStyle? style]) {
    if (style != null) _style = style;
  }

  void _refreshAndApply() {
    _refresh();
    Future.delayed(const Duration(milliseconds: 200), _apply);
  }

  void _apply() => SystemChrome.setSystemUIOverlayStyle(_style);

  SystemUiOverlayStyle? get customOrNull;
  void updateFromBrightness(Brightness brightness) {}
  void setCustom(SystemUiOverlayStyle style);
  void removeCustom(Brightness brightness) {}
}

abstract class BrightnessOverlay extends Overlay {
  static resolve(Brightness brightness) =>
      brightness.isLight ? LightOverlay() : DarkOverlay();

  @override
  void setCustom(SystemUiOverlayStyle style) =>
      _changeTo(CustomOverlay(style))._refreshAndApply();

  @override
  SystemUiOverlayStyle? get customOrNull => null;
}

class LightOverlay extends BrightnessOverlay {
  static final _instance = LightOverlay._();
  LightOverlay._();
  factory LightOverlay() => _instance;

  @override
  void updateFromBrightness(Brightness brightness) {
    if (brightness.isDark) _changeTo(DarkOverlay())._apply();
  }
}

class DarkOverlay extends BrightnessOverlay {
  static final _instance = DarkOverlay._();
  DarkOverlay._();
  factory DarkOverlay() => _instance;

  @override
  void updateFromBrightness(Brightness brightness) {
    if (brightness.isLight) _changeTo(LightOverlay())._apply();
  }
}

class CustomOverlay extends Overlay {
  CustomOverlay(style) : super(style);

  @override
  void setCustom(SystemUiOverlayStyle style) => setStyle(style);

  @override
  void removeCustom(Brightness brightness) =>
      _changeTo(BrightnessOverlay.resolve(brightness))._refreshAndApply();

  @override
  SystemUiOverlayStyle? get customOrNull => style;
}
