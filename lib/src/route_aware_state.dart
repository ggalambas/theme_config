part of '../theme_config.dart';

abstract class _RouteAwareState<T extends StatefulWidget> extends State<T>
    with RouteAware {
  bool _enteredScreen = false;

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    // Subscribe to route changes
    ThemeConfig._routeObserver
        .subscribe(this, ModalRoute.of(context) as PageRoute);
    // Execute asynchronously as soon as possible
    Timer.run(_enterScreen);
  }

  @override
  @mustCallSuper
  void dispose() {
    if (_enteredScreen) _leaveScreen();
    ThemeConfig._routeObserver.unsubscribe(this);
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
