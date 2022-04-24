part of '../theme_config.dart';

abstract class Overlay {
  set overlay(Overlay overlay) => ThemeConfig.overlay = overlay;

  void updateFromBrightness(Brightness brightness) {}
  void setCustom(SystemUiOverlayStyle style) {}
  void removeCustom() {}
}

class LightOverlay extends Overlay {
  @override
  void updateFromBrightness(Brightness brightness) {
    if (brightness.isDark) overlay = DarkOverlay();
  }

  @override
  void setCustom(SystemUiOverlayStyle style) {
    overlay = CustomOverlay(style);
  }
}

class DarkOverlay extends Overlay {
  @override
  void updateFromBrightness(Brightness brightness) {
    if (brightness.isLight) overlay = LightOverlay();
  }

  @override
  void setCustom(SystemUiOverlayStyle style) {
    overlay = CustomOverlay(style);
  }
}

class CustomOverlay extends Overlay {
  SystemUiOverlayStyle style;
  CustomOverlay(this.style);

  @override
  void setCustom(SystemUiOverlayStyle style) {
    this.style = style;
  }

  @override
  void removeCustom() {
    overlay = ThemeConfig.brightness.isLight ? LightOverlay() : DarkOverlay();
  }
}
