ThemeConfig makes it easy to switch the status and navigation bars styles when the platform theme changes.

## Features

* Sets system bars' light and dark styles
* Updates system bars automatically when platform brightness changes
* Listens to theme mode changes

## Getting started

ThemeConfig must be initialized so it can save and load the theme mode preference

```dart
Future<void> main() async {
	...
  await ThemeConfig.init();
	runApp(MyApp());
}
```

Wrap the MaterialApp with the ThemeBuilder widget so it can listen to the platform brightness and theme mode changes and change the system bars accordingly

```dart
ThemeBuilder(
	overlayStyle: myOverlayStyle,
	darkOverlayStyle: myDarkOverlayStyle,
  builder: (themeMode) => MaterialApp(
		...
    themeMode: themeMode,
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
ThemeConfig.themeMode = ThemeMode.light;
ThemeConfig.themeMode = ThemeMode.dark;
ThemeConfig.themeMode = ThemeMode.system;
```

* Example with radio list tile:

```dart
Widget myRadioListTile(ThemeMode themeMode) {
	return RadioListTile<ThemeMode>(
		title: Text(themeMode.name),
		value: themeMode
		groupValue: ThemeConfig.themeMode
		onChanged (mode) => ThemeConfig.themeMode = mode;
		),
}
```

```dart
Column(children: ThemeMode.values.map(myRadioListTile).toList())
```

Dynamically redefine the overlay styles

```dart
ThemeConfig.overlayStyle: myNewOverlayStyle,
ThemeConfig.darkOverlayStyle: myNewDarkOverlayStyle,
```

Change the current overlay style

```dart
ThemeConfig.setOverlayStyle(myCustomOverlayStyle);
```

Reset the overlay style to the initially defined

```dart
ThemeConfig.resetOverlayStyle();
```

Temporarily change the overlay style when on a specific page

```dart
CustomOverlayStyle(
	style: myCustomOverlayStyle,
	child: ...
)
```

## Additional information

If you notice any bugs not present in [issues](), please file a new issue. If you are willing to fix or enhance things yourself, you are very welcome to make a pull request.