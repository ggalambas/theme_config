import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theme_config/theme_config.dart';

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
          debugShowCheckedModeBanner: false,
          title: 'ThemeConfig Example',
          home: const Example(),
          //* 4. Set the theme properties
          theme: theme.light,
          darkTheme: theme.dark,
          themeMode: theme.mode,
          //! add this line if you plan to use the OverlayStyle widget
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ThemeConfig Example')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...ThemeMode.values.map(
              (themeMode) => radioTile(themeMode, setState),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            OutlinedButton(
              child: const Text('navigate to light/dark overlay page'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OverlayPage()),
              ).then((_) => setState(() {})),
            ),
            OutlinedButton(
              child: const Text('navigate to custom overlay page'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CustomOverlayPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OverlayPage extends StatefulWidget {
  const OverlayPage({Key? key}) : super(key: key);

  @override
  State<OverlayPage> createState() => _OverlayPageState();
}

class _OverlayPageState extends State<OverlayPage> {
  @override
  Widget build(BuildContext context) {
    return OverlayStyle(
      light: const SystemUiOverlayStyle(
        statusBarColor: Colors.orange,
        systemNavigationBarColor: Colors.orange,
      ),
      dark: const SystemUiOverlayStyle(
        statusBarColor: Colors.blue,
        systemNavigationBarColor: Colors.blue,
      ),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...ThemeMode.values.map(
                  (themeMode) => radioTile(themeMode, setState),
                ),
                OutlinedButton(
                  child: const Text('back'),
                  onPressed: Navigator.of(context).pop,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomOverlayPage extends StatelessWidget {
  const CustomOverlayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlayStyle.custom(
      style: const SystemUiOverlayStyle(
        statusBarColor: Colors.green,
        systemNavigationBarColor: Colors.green,
      ),
      child: Scaffold(
        body: Center(
          child: OutlinedButton(
            child: const Text('back'),
            onPressed: Navigator.of(context).pop,
          ),
        ),
      ),
    );
  }
}

Widget radioTile(
  ThemeMode themeMode,
  void Function(void Function()) setState,
) =>
    RadioListTile<ThemeMode>(
      title: Text(themeMode.name),
      value: themeMode,
      groupValue: ThemeConfig.themeMode,
      onChanged: (mode) => setState(() => ThemeConfig.setThemeMode(mode!)),
    );
