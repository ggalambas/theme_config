ThemeConfig makes it easy to switch the status and navigation bars styles when the platform theme changes.

<p align="center">
<img alt="theme-mode" src="https://user-images.githubusercontent.com/23039652/165973836-f6931c27-b65b-4cd0-b036-8a32d6b88a75.gif" width="240px" style="padding:4px">
<img alt="overlay-style" src="https://user-images.githubusercontent.com/23039652/165973823-dd95daa4-774c-46f9-9913-632b43c44207.gif" width="240px" style="padding:4px">
<img alt="custom-overlay-style" src="https://user-images.githubusercontent.com/23039652/165973827-91841c80-388b-4a57-8b4c-b428792ddda1.gif" width="240px" style="padding:4px">
<img alt="page-overlay-style" src="https://user-images.githubusercontent.com/23039652/165973830-bc9eeea6-ac1f-4521-b46b-30ea8f6e4531.gif" width="240px" style="padding:4px">
</p>

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

For this widget to work you must also add our observer to the material app

```dart
MaterialApp(
	...
	navigatorObservers: [ThemeConfig.routeObserver],
)
```

## Additional information

If you notice any bugs not present in [issues](https://github.com/ggalambas/theme_config/issues), please file a new issue. If you are willing to fix or enhance things yourself, you are very welcome to make a pull request.
