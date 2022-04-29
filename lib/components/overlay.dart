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
    return (brightness.isLight ? LightOverlay() : DarkOverlay())..apply();
  }

  Overlay _changeTo(Overlay overlay) {
    _changeOverlay(overlay);
    return overlay;
  }

  late SystemUiOverlayStyle style;

  Overlay([SystemUiOverlayStyle? style]) {
    if (style != null) this.style = style;
  }

  void refreshAndApply({bool apply = true}) {
    _refresh();
    if (apply) Future.delayed(const Duration(milliseconds: 200), this.apply);
  }

  void apply() => SystemChrome.setSystemUIOverlayStyle(style);

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
      _changeTo(CustomOverlay(style)).refreshAndApply();

  @override
  SystemUiOverlayStyle? get customOrNull => null;
}

class LightOverlay extends BrightnessOverlay {
  static final _instance = LightOverlay._();
  LightOverlay._();
  factory LightOverlay() => _instance;

  @override
  void updateFromBrightness(Brightness brightness) {
    if (brightness.isDark) _changeTo(DarkOverlay()).refreshAndApply();
  }
}

class DarkOverlay extends BrightnessOverlay {
  static final _instance = DarkOverlay._();
  DarkOverlay._();
  factory DarkOverlay() => _instance;

  @override
  void updateFromBrightness(Brightness brightness) {
    if (brightness.isLight) _changeTo(LightOverlay()).refreshAndApply();
  }
}

class CustomOverlay extends Overlay {
  CustomOverlay(style) : super(style);

  @override
  void setCustom(SystemUiOverlayStyle style) {
    this.style = style;
    refreshAndApply();
  }

  @override
  void removeCustom(Brightness brightness) =>
      _changeTo(BrightnessOverlay.resolve(brightness)).refreshAndApply();

  @override
  SystemUiOverlayStyle? get customOrNull => style;
}
