import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theme_config/theme_config.dart';

//TODO example

//* 1. Create a theme profile
final themeProfile = ThemeProfile.fromColorScheme(
  // define the color schemes
  colorScheme: const ColorScheme.light(),
  darkColorScheme: const ColorScheme.dark(),
  // define the theme
  theme: (colorScheme) => ThemeData(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.background,
    appBarTheme: AppBarTheme(
      elevation: 0,
      color: colorScheme.background,
      foregroundColor: colorScheme.onBackground,
    ),
  ),
  // define the overlay style
  overlayStyle: (colorScheme) => SystemUiOverlayStyle(
    // android
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: colorScheme.brightness.other,
    systemNavigationBarColor: colorScheme.background,
    systemNavigationBarIconBrightness: colorScheme.brightness.other,
    // ios
    statusBarBrightness: colorScheme.brightness,
  ),
);

void main() async {
  //* 2. Initialize the package
  await ThemeConfig.init(themeProfile);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //* 3. Wrap the app with ThemeBuilder
    // listen to theme and brightness changes
    return ThemeBuilder(
      builder: (theme) {
        return MaterialApp(
          title: 'ThemeConfig Example',
          home: const Example(),
          //* 4. Set the theme properties
          theme: theme.light,
          darkTheme: theme.dark,
          themeMode: theme.mode,
          navigatorObservers: [ThemeConfig.routeObserver],
        );
      },
    );
  }
}

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  Widget myRadioListTile(ThemeMode themeMode) {
    return RadioListTile<ThemeMode>(
      title: Text(themeMode.name),
      value: themeMode,
      groupValue: ThemeConfig.themeMode,
      onChanged: (mode) => setState(() => ThemeConfig.setThemeMode(mode!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ThemeConfig Example')),
      body: ListView(
        children: [
          ...ThemeMode.values.map(myRadioListTile),
          OutlinedButton(
            child: const Text('set light overlay style'),
            onPressed: () => ThemeConfig.setOverlayStyle(
              const SystemUiOverlayStyle(
                statusBarColor: Colors.yellow,
                systemNavigationBarColor: Colors.yellow,
              ),
            ),
          ),
          OutlinedButton(
            child: const Text('set dark overlay style'),
            onPressed: () => ThemeConfig.setDarkOverlayStyle(
              const SystemUiOverlayStyle(
                statusBarColor: Colors.deepPurple,
                systemNavigationBarColor: Colors.deepPurple,
              ),
            ),
          ),
          OutlinedButton(
            child: const Text('set custom overlay style'),
            onPressed: () => ThemeConfig.setCustomOverlayStyle(
              const SystemUiOverlayStyle(
                statusBarColor: Colors.pink,
                systemNavigationBarColor: Colors.pink,
              ),
            ),
          ),
          OutlinedButton(
            child: const Text('remove custom overlay style'),
            onPressed: () => ThemeConfig.removeCustomOverlayStyle(),
          ),
          OutlinedButton(
            child: const Text('navigate to custom overlay page'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const OverlayStyle.custom(
                  style: SystemUiOverlayStyle(
                    statusBarColor: Colors.green,
                    systemNavigationBarColor: Colors.green,
                  ),
                  child: Scaffold(),
                ),
              ),
            ),
          ),
          OutlinedButton(
            child: const Text('navigate to light/dark overlay page'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const OverlayStyle(
                  light: SystemUiOverlayStyle(
                    statusBarColor: Colors.yellow,
                    systemNavigationBarColor: Colors.yellow,
                  ),
                  dark: SystemUiOverlayStyle(
                    statusBarColor: Colors.deepPurple,
                    systemNavigationBarColor: Colors.deepPurple,
                  ),
                  child: Scaffold(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
