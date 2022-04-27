ThemeConfig makes it easy to switch the status and navigation bars styles when the platform theme changes.

## Features

* Sets system bars' light and dark styles
* Updates system bars automatically when platform brightness changes
* Listens to theme mode changes

## Getting started

Create a theme profile defining each style independently

```dart
final themeProfile = ThemeProfile(
	theme: ThemeData.light(),
	darkTheme: ThemeData.dark(),
	overlayStyle: SystemUiOverlayStyle.light,
	darkOverlayStyle: SystemUiOverlayStyle.dark,
);
```

Or based on color schemes

```dart
final themeProfile = ThemeProfile.fromColorScheme(
	colorScheme: ColorScheme.light(),
	darkColorScheme: ColorScheme.dark(),
	theme: (colorScheme) => ThemeData.from(colorScheme: colorScheme),
	overlayStyle: (colorScheme) => SystemUiOverlayStyle(...),
);
```

ThemeConfig must be initialized so it can save and load the theme mode preferences

```dart
Future<void> main() async {
	...
  await ThemeConfig.init(themeProfile);
	runApp(MyApp());
}
```

Wrap the MaterialApp with the ThemeBuilder widget so it can listen to the platform brightness and theme mode changes and change the system bars accordingly

```dart
ThemeBuilder(
  builder: (theme) => MaterialApp(
		...
		theme: theme.light,
		darkTheme: theme.dark,
    themeMode: theme.mode,
  ),
)
```

## Usage

Access the app's brightness and theme mode anywhere in the project

```dart
final brightness = ThemeConfig.brightness;
final themeMode = ThemeConfig.themeMode;
```

Change between theme modes

```dart
ThemeConfig.setThemeMode(ThemeMode.light);
ThemeConfig.setThemeMode(ThemeMode.dark);
ThemeConfig.setThemeMode(ThemeMode.system);
```

* Example with radio list tile:

```dart
Widget myRadioListTile(ThemeMode themeMode) {
	return RadioListTile<ThemeMode>(
		title: Text(themeMode.name),
		value: themeMode,
		groupValue: ThemeConfig.themeMode,
		onChanged: (mode) => setState(() => ThemeConfig.setThemeMode(mode)),
	);
}
```

```dart
Column(children: ThemeMode.values.map(myRadioListTile).toList())
```

Dynamically redefine the overlay styles

```dart
ThemeConfig.setOverlayStyle(newOverlayStyle);
ThemeConfig.setDarkOverlayStyle(newDarkOverlayStyle);
```

Change the current overlay style

```dart
ThemeConfig.setCustomOverlayStyle(customOverlayStyle);
```

Remove the current overlay style

```dart
ThemeConfig.removeCustomOverlayStyle();
```

Temporarily change the light and/or dark overlay styles when on a specific page

```dart
OverlayStyle(
	light: newOverlayStyle,
	dark: newDarkOverlayStyle,
	child: ...
)
```

Or the custom overlay style

```dart
OverlayStyle.custom(
	style: customOverlayStyle,
	child: ...
)
```

## Additional information

If you notice any bugs not present in [issues](), please file a new issue. If you are willing to fix or enhance things yourself, you are very welcome to make a pull request.