<h1 align="center">Glassmorphic Container ⭐️</h1>

<p align="center">
  <a href="https://pub.dev/packages/glassmorphism"><img src="https://img.shields.io/pub/v/glassmorphism.svg" alt="pub version"></a>
  <a href="https://pub.dev/packages/glassmorphism/score"><img src="https://img.shields.io/pub/likes/glassmorphism" alt="pub likes"></a>
  <a href="https://pub.dev/packages/glassmorphism/score"><img src="https://img.shields.io/pub/points/glassmorphism" alt="pub points"></a>
  <a href="https://github.com/RitickSaha/glassmorphism/actions/workflows/ci.yml"><img src="https://github.com/RitickSaha/glassmorphism/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
</p>

A Flutter package for creating Glassmorphic (frosted glass) UI designs in an
easy and simple manner. Supports iOS, Android, web, Windows, macOS and Linux.

<p align="center">
  <img src="https://raw.githubusercontent.com/RitickSaha/glassmorphism/master/images/s1.0.5x.jpg" width="30%"/>
</p>

Inspired by the [Glassmorphism CSS Generator](https://glassmorphism.com/).

> ### Tutorial
>
> Glassmorphism UI Package For @Flutter || UI || A Glassy and easy to use Package
>
> [![Watch the tutorial](https://raw.githubusercontent.com/RitickSaha/glassmorphism/master/images/embed.png)](https://www.youtube.com/watch?v=MKj_7zyeeOQ "Play the video.")

## Features

- Backdrop blur with a translucent gradient fill
- Gradient borders
- Fixed size, or sized by its child like a `Container`
- Drop shadows that don't bleed through the glass
- Rounded rectangles and circles
- A `Flex`-friendly variant for rows and columns
- Works with gestures, ink splashes and any child widgets

## Getting started

```sh
flutter pub add glassmorphism
```

```dart
import 'package:glassmorphism/glassmorphism.dart';
```

The glass effect blurs whatever is painted *behind* it, so place it over an
image, a gradient or other colorful content.

## Usage

### Fixed size

```dart
GlassmorphicContainer(
  width: 350,
  height: 350,
  borderRadius: 20,
  blur: 20,
  alignment: Alignment.bottomCenter,
  border: 2,
  linearGradient: const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x1AFFFFFF), Color(0x0DFFFFFF)],
    stops: [0.1, 1],
  ),
  borderGradient: const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x80FFFFFF), Color(0x80FFFFFF)],
  ),
  child: const Text('Glass'),
)
```

### Sized by its child

Leave out `width` and `height` and the glass wraps its child, plus `padding`.
This works in lists and with text of unknown length.

```dart
GlassmorphicContainer(
  borderRadius: 16,
  blur: 12,
  border: 1.5,
  padding: const EdgeInsets.all(16),
  linearGradient: glassFill,
  borderGradient: glassBorder,
  child: Text(message),
)
```

As with `Container`, setting `alignment` makes the glass expand to fill its
parent.

### Drop shadow

Shadows are painted only *outside* the glass, like CSS `box-shadow`, so they
don't darken the translucent fill.

```dart
GlassmorphicContainer(
  height: 100,
  borderRadius: 24,
  blur: 15,
  border: 0,
  linearGradient: glassFill,
  borderGradient: glassBorder,
  boxShadow: const [
    BoxShadow(
      color: Color(0x40000000),
      offset: Offset(5, 5),
      blurRadius: 10,
      spreadRadius: 2,
    ),
  ],
  child: const Center(child: Text('Shadow')),
)
```

### Circle

```dart
GlassmorphicContainer(
  width: 96,
  height: 96,
  shape: BoxShape.circle,
  borderRadius: 0,
  blur: 10,
  border: 2,
  linearGradient: glassFill,
  borderGradient: glassBorder,
  child: const Icon(Icons.favorite),
)
```

### Inside a `Row` or `Column`

`GlassmorphicFlexContainer` wraps the glass in an `Expanded`, so it must be a
direct child of a `Row`, `Column` or `Flex`. It fills its `flex` share of the
main axis and the full cross axis.

```dart
Row(
  children: [
    GlassmorphicFlexContainer(
      flex: 2,
      borderRadius: 16,
      blur: 10,
      border: 1.5,
      linearGradient: glassFill,
      borderGradient: glassBorder,
      child: const Text('flex: 2'),
    ),
    GlassmorphicFlexContainer(
      borderRadius: 16,
      blur: 10,
      border: 1.5,
      linearGradient: glassFill,
      borderGradient: glassBorder,
      child: const Text('flex: 1'),
    ),
  ],
)
```

See the [example app](example/lib/main.dart) for all of the above.

## Parameters

| Parameter | Type | Description |
| --- | --- | --- |
| `borderRadius` | `double` | **Required.** Corner radius. Ignored for circles. |
| `blur` | `double` | **Required.** Blur sigma of the backdrop. `0` disables the blur. |
| `border` | `double` | **Required.** Border width, drawn inside the bounds. `0` for no border. |
| `linearGradient` | `Gradient` | **Required.** Fill of the glass. Use translucent colors. |
| `borderGradient` | `Gradient` | **Required.** Gradient of the border. |
| `width`, `height` | `double?` | Fixed size, including padding. Omit to size by the child. |
| `child` | `Widget?` | Content, clipped to the glass shape. |
| `alignment` | `AlignmentGeometry?` | Aligns the child. Makes the glass expand, like `Container`. |
| `padding` | `EdgeInsetsGeometry?` | Space inside the glass, around the child. |
| `margin` | `EdgeInsetsGeometry?` | Space outside the glass. |
| `constraints` | `BoxConstraints?` | Extra constraints, tightened by `width` and `height`. |
| `transform` | `Matrix4?` | Transform applied before painting. |
| `shape` | `BoxShape` | `BoxShape.rectangle` (default) or `BoxShape.circle`. |
| `boxShadow` | `List<BoxShadow>?` | Shadows painted outside the glass. |
| `clipBehavior` | `Clip` | How the child is clipped. Defaults to `Clip.antiAlias`. |

`GlassmorphicFlexContainer` takes the same parameters except `width` and
`height`, plus `flex` (default `1`).

## Known platform limitations

The blur is Flutter's
[`BackdropFilter`](https://api.flutter.dev/flutter/widgets/BackdropFilter-class.html),
so it inherits the engine's behavior:

- **Platform views** (Google Maps, web views, video players) may not be
  blurred on iOS, because they are composited outside Flutter.
- **Impeller** renders blur differently from the old Skia backend. Some
  Flutter versions made blur look weaker on iOS
  ([flutter/flutter#162951](https://github.com/flutter/flutter/issues/162951)).
  Upgrading Flutter fixes this.
- Some older Android devices and GPU drivers show a flat translucent fill
  instead of a blur. If you can reproduce this, please add details to
  [#15](https://github.com/RitickSaha/glassmorphism/issues/15).
- Many overlapping blurred widgets are expensive to render. Prefer a few
  larger glass surfaces over many small ones.

## Upgrading from 3.x

See the [changelog](CHANGELOG.md) for the full list. In short:

- Flutter 3.24 or newer is required.
- `blur` is now uniform. It used to double the vertical blur, so you may want
  a larger value.
- `padding` on `GlassmorphicFlexContainer` now pads the child. Use `margin`
  for space around the glass.

## Social handles

- _Official_
  - [_GitHub_](https://www.github.com/riticksaha)
  - [_Instagram_](https://www.instagram.com/theflutterfoundry/)
  - [_Twitter_](https://twitter.com/flutterfoundry/)
  - [_YouTube_](https://www.youtube.com/channel/UCH7gICVJpoZPRV6h9O6Xu4g)
- _Personal_
  - [Instagram](https://www.instagram.com/riticksaha_/)
  - [Twitter](https://www.twitter.com/rsahatwt/)

<img src="https://raw.githubusercontent.com/RitickSaha/glassmorphism/master/images/theFlutterFoundary.jpeg" align="left" height="48" width="48">

[The Flutter Foundry 💙](https://www.instagram.com/theflutterfoundry)

<br clear="left">

If you found this project useful, please consider giving it a ⭐️ on GitHub
and sharing it with your friends.

## Contributing

Suggestions and bug reports are welcome. Please open a
[GitHub issue](https://github.com/RitickSaha/glassmorphism/issues).

Before sending a pull request, run:

```sh
dart format lib test example/lib example/test
flutter analyze
flutter test
```

## License

[MIT](LICENSE)
