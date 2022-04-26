import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/widgets.dart';
import 'package:theme_config/theme_config.dart';

abstract class RouteAwareState<T extends StatefulWidget> extends State<T>
    with RouteAware, AfterLayoutMixin<T> {
  bool _enteredScreen = false;

  @override
  @mustCallSuper
  void afterFirstLayout(BuildContext context) {
    if (mounted) {
      // Subscribe to route changes
      ThemeConfig.routeObserver
          .subscribe(this, ModalRoute.of(context) as PageRoute);
      // Execute asynchronously as soon as possible
      Timer.run(_enterScreen);
    }
  }

  @override
  @mustCallSuper
  void dispose() {
    if (_enteredScreen) _leaveScreen();
    ThemeConfig.routeObserver.unsubscribe(this);
    super.dispose();
  }

  void _enterScreen() {
    onEnterScreen();
    _enteredScreen = true;
  }

  void _leaveScreen() {
    onLeaveScreen();
    _enteredScreen = false;
  }

  @override
  @mustCallSuper
  void didPopNext() => Timer.run(_enterScreen);

  @override
  @mustCallSuper
  void didPop() => _leaveScreen();

  @override
  @mustCallSuper
  void didPushNext() => _leaveScreen();

  /// This method will always be executed when entering this screen
  void onEnterScreen();

  /// This method will always be executed when leaving this screen
  void onLeaveScreen();
}
