<p align="center">
  <h1 align="center" style="font-size: 48px;"> Glassmorphic Container 🔨</h1>
  </p>

A Flutter package for creating Glassmorphic UI designs in an easy and simple manner!
Supports iOS, Android, web, Windows, macOS, and Linux.

<p align="center">
  <img src="https://raw.githubusercontent.com/RitickSaha/glassmophism/master/images/s1.0.5x.jpg" width="30%" height="30%"/>
  <h1 align="center" style="font-size: 48px;">Glassmorphic Example App. With realtime pub.dev stats📱</h1>
  <h5 align="center">A package that simplefies your urge to create a interactive Glassmorphic Container.</h5>
  <p align="center">Inspired by <a href="https://glassmorphism.com/">Glassmorphism CSS Generator.</a>
      Highly customizable and helps developing beautiful Glassmorphic UI.
  </p>
</p>

## Usage 💻

> [![likes](https://badges.bar/glassmorphism/likes)](https://pub.dev/packages/glassmorphism/score)<br> > [![pub points](https://badges.bar/glassmorphism/pub%20points)](https://pub.dev/packages/glassmorphism/score)<br> > [![popularity](https://badges.bar/glassmorphism/popularity)](https://pub.dev/packages/glassmorphism/score)<br>

To use this plugin, add `glassmorphism` as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).
Use the below example to get started with the sample example.

> ## You can follow this tutorial and work around with the package.
>
> Glassmorphism UI Package For @Flutter || UI || A Glassy and easy to use Package #flutter

[![Everything Is AWESOME](https://raw.githubusercontent.com/RitickSaha/glassmorphism/master/images/embed.png)](https://www.youtube.com/watch?v=MKj_7zyeeOQ "Play the video.")

## Features 🔮

- Fully customizable components
- Easy To use
- Null Safe version
- Multiple Childs widgets supported
- Gesture Listener [GestureDetector](https://api.flutter.dev/flutter/widgets/GestureDetector-class.html)
- Circular Border / Traditional Borders
- Gradient Borders
- Gradient Fill on container `[Full Control to User]`

### To use `GlassmorphicContainer` with fixed Height and width:

```dart
GlassmorphicContainer(
  width: 350,
  height: 350,
  borderRadius: 20,
  blur: 20,
  alignment: Alignment.bottomCenter,
  border: 2,
  linearGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFffffff).withOpacity(0.1),
        Color(0xFFFFFFFF).withOpacity(0.05),
      ],
      stops: [
        0.1,
        1,
      ]),
  borderGradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFffffff).withOpacity(0.5),
      Color((0xFFFFFFFF)).withOpacity(0.5),
    ],
  ),
  child: null,
),
```

### Use `GlassmorphicFlexContainer` with responsiveness or take child widgets size. :

```dart
GlassmorphicFlexContainer(
  borderRadius: 20,
  blur: 20,
  padding: EdgeInsets.all(40),
  alignment: Alignment.bottomCenter,
  border: 2,
  linearGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFffffff).withOpacity(0.1),
        Color(0xFFFFFFFF).withOpacity(0.05),
      ],
      stops: [
        0.1,
        1,
      ]),
  borderGradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFffffff).withOpacity(0.5),
      Color((0xFFFFFFFF)).withOpacity(0.5),
    ],
  ),
  child: null,
),
```

> example, Simple Glassmorphic Container with Blur.

### Example

```dart
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'dart:ui';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GlassmorphicContainer Example',
      home: GlassmorphicSample(),
    );
  }
}

class GlassmorphicSample extends StatefulWidget {
  @override
  State<GlassmorphicSample> createState() => GlassmorphicSampleState();
}

class GlassmorphicSampleState extends State<GlassmorphicSample> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            Image.network(
              "https://github.com/RitickSaha/glassmophism/blob/master/example/assets/bg.png?raw=true",
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              scale: 1,
            ),
            SafeArea(
              child: Center(
                child: GlassmorphicContainer(
                    width: 350,
                    height: 750,
                    borderRadius: 20,
                    blur: 20,
                    alignment: Alignment.bottomCenter,
                    border: 2,
                    linearGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFffffff).withOpacity(0.1),
                          Color(0xFFFFFFFF).withOpacity(0.05),
                        ],
                        stops: [
                          0.1,
                          1,
                        ]),
                    borderGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFffffff).withOpacity(0.5),
                        Color((0xFFFFFFFF)).withOpacity(0.5),
                      ],
                    ),
                    child: null),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Parameters ⚙️

- `height` (double) **[`required`]** - Height for the Widget **[`required`]**.
- `width` (double) **[`required`]**- Width for the Widget **[`@required`]**.
- `borderRadius` (double) **[`required`]**- Border Radius for the widget `0` - `any` **[`@required`]**.
- `linearGradient` (LinearGradient) **[`required`]**- Fills the container with the gradient passed.
- `border` (double) **[`required`]**- Gives Width to the ContainerBorder.
- `blur` (double) **[`required`]**- Gives BlurFilter to the Container.
- `borderGradient` (LinearGradient) **[`required`]**- Fills the container's border with the gradient passed.
- `child` (widget) - [optional parameter] If there is a child widget then the widget will be rendered inside the container.
- `alignment` (optional) - Handles the alignment [`Default_value`] - [`Alignemt.topleft`].
- `padding` (EdgeInset) - Used to provide pading to the child widget [`Default_value`] - [`None`].
- `BoxShape` (Fixed) - This value is fixed to [`BoxFit.rectangle`].
- `constraints` (ChatUser) - The constructor `width` and `height` arguments are combined with the `constraints` argument to set this property.
- `margin` (double) - Empty space to surround the [decoration] and [child].

```dart
  GlassmorphicContainer(
    width: width,
    height: height,
    borderRadius:borderRadius,
    blur: blur,
    alignment: alignment,
    border:border,
    linearGradient: linearGradient,
    borderGradient:borderGradient,
    child: null),
  );
```

## My Socials 👩‍👦‍👦

- _Official_
  - [_Github_](https://www.github.com/riticksaha)
  - [_Instagram_](https://www.instagram.com/theflutterfoundry/)
  - [_Twitter_](https://twitter.com/flutterfoundry/)
  - [_Youtube_](https://www.youtube.com/channel/UCH7gICVJpoZPRV6h9O6Xu4g)
- _Personal_
  - [Instagram](https://www.instagram.com/riticksaha_/)
  - [Twitter](https://www.twitter.com/rsahatwt/)

## Credits 👨🏻‍💻

<center><a href="url"><img src="https://raw.githubusercontent.com/RitickSaha/glassmorphism/Glassmorphism--3.0.0/images/theFlutterFoundary.jpeg"align="left" height="48" width="48" ></center><BR></a><BR><BR>

[The Flutter Foundry 💙 - Instagram Link](https://www.instagram.com/theflutterfoundry)
## Found this project useful? ❤️

If you found this project useful, then please consider giving it a ⭐️ on Github and sharing it with your friends via social media.

## License ⚖️

- [MIT](https://github.com/RitickSaha/glassmophism/blob/master/LICENSE)

## API details 📝

See the [glassmorphic.dart](https://github.com/RitickSaha/glassmophism/blob/master/lib/glassmorphism.dart) for more API details

## Issues and feedback 💭

If you have any suggestion for including a feature or if something doesn't work.
Feel free to open a Github [issue](https://github.com/RitickSaha/glassmophism/issues) for us to have a discussion on it.
