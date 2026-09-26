## [4.0.0]

Maintenance release that fixes long-standing bugs, adds the most requested
features and brings the package up to date with current Flutter.

### Breaking changes

- Requires Dart 3.5 / Flutter 3.24 or newer.
- `blur` is now applied uniformly. Previously the vertical blur was silently
  doubled (`sigmaY: blur * 2`). To keep the old, stronger look, increase
  `blur`.
- `GlassmorphicFlexContainer.padding` now pads the *child* inside the glass.
  Previously it inset the glass itself, which is what `margin` is for.
- `GlassmorphicFlexContainer.flex` is a non-nullable `int` (default `1`).
- `linearGradient` and `borderGradient` are typed as `Gradient`, so radial
  and sweep gradients work too. Code that reads these fields as
  `LinearGradient` needs a cast.

### New features

- `GlassmorphicContainer.width` and `height` are optional. Without them the
  glass sizes itself to its child, like `Container`
  ([#1](https://github.com/RitickSaha/glassmorphism/issues/1),
  [#6](https://github.com/RitickSaha/glassmorphism/issues/6),
  [#12](https://github.com/RitickSaha/glassmorphism/issues/12)).
- `boxShadow` adds drop shadows. They are painted only outside the glass,
  like CSS `box-shadow`, so they do not darken the translucent fill
  ([#10](https://github.com/RitickSaha/glassmorphism/issues/10)).
- `shape: BoxShape.circle` is now supported. The parameter already existed
  but was ignored.
- `clipBehavior` controls how the child is clipped to the glass.
- Constructors are `const`.

### Fixes

- Fixed `'dart:ui/geometry.dart': Failed assertion` when `border` is larger
  than `borderRadius` or the container has zero size
  ([#14](https://github.com/RitickSaha/glassmorphism/issues/14)).
- Fixed "Multiple widgets used the same GlobalKey" when a `GlobalKey` is
  passed. The key was also applied to an inner widget.
- `GlassmorphicContainer.padding` was ignored. It is now applied.
- `GlassmorphicFlexContainer.margin` and `constraints` were ignored. They are
  now applied.
- Widgets no longer require a `Directionality` ancestor.
- The border no longer rebuilds on every `MediaQuery` change and only
  repaints when its properties change.
- `blur: 0` skips the `BackdropFilter` entirely.

### Other

- Added widget tests, lints and CI.
- Rewrote the example app so it runs offline, and regenerated its platform
  folders for current Flutter.
- Removed committed build artifacts, IDE files and lock files.

## [3.0.0] - 26 April 2021.

- Added GlassmorphicFlexContainer That makes the ui responsive.
- Fixed minor bugs.

## [2.0.1] - 26 April 2021.

- Migration to Sound Null safer Version

## [1.0.3] - 02 January 2021.

- Minor Documentation Changes.

## [1.0.1] - 02 January 2021.

- Initial Publish To [`pub.dev`](https://pub.dev/packages/glassmorphism)

## [0.1.3] - 30 December 2020

- Fixed GestureDetection Bug.

## [0.1.2] - 31 December 2020

- Added ['GradientBorder'].

## [0.1.1] - 30 December 2020

- Added Features.

## [0.1.0] - 29 December 2020
