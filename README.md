ThemeConfig makes it easy to switch the status and navigation bars styles when the platform theme changes.

<p align="center">
<img alt="theme-mode" src="https://user-images.githubusercontent.com/23039652/165970262-181e2ef5-d2f0-4d99-a91e-317caf7c7935.gif" width="240px" style="padding:4px">
<img alt="overlay-style" src="https://user-images.githubusercontent.com/23039652/165970360-dcd9edb8-907d-4143-8199-087d1318e263.gif" width="240px" style="padding:4px">
<img alt="custom-overlay-style" src="https://user-images.githubusercontent.com/23039652/165970355-d2636d8b-9097-478e-b844-06217574ad37.gif" width="240px" style="padding:4px">
<img alt="page-overlay-style" src="https://user-images.githubusercontent.com/23039652/165970348-8e6de94a-8b2e-46b8-97dd-0a47e46dc4f9.gif" width="240px" style="padding:4px">
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
