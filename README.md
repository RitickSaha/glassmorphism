<p align="center">
  <h1 align="center" style="font-size: 48px;"> Glassmorphic Container 🔨</h1>
  <p align="center">First version of this v2 is expected in January, the v1 can still be used but do not expect additional development in it. You can still open issues for the v1 to indicate things we need to implement/fix in the v2</p>
</p>

A Flutter package for creating Glassmorphic UI designs in easy and simple manner!
Supports iOS, Android, web , Windows [`Still_Under_Build`], macOS [`Still_Under_Build`], and Linux [`Still_Under_Build`].

<p align="center">
  <img src="__________githublink" />
  <h1 align="center" style="font-size: 48px;">Glassmorphic Example App. With realtime pub.dev stats📱</h1>
  <h5 align="center">A package that simplefies your urge to create a interactive Glassmorphic Container.</h5>
  <p align="center">Inspired by <a href="https://glassmorphism.com/">Glassmorphism CSS Generator.</a>
      Highly customizable and helps developing beautiful Glassmorphic UI.
  </p>
</p>

## Usage 💻

To use this plugin, add `glassmorphism` as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).
Use the below example to get started with the sample example.

## Features 🔮

- Fully customizable components
- Easy To use
- Multiple Childs widgets supprted
- Gesture Listener [GestureDetector](https://api.flutter.dev/flutter/widgets/GestureDetector-class.html)
- Circular Border / Treditional Borders
- Gradient Borders
- Gradient Fill on container [Full_Control_to_User]

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
              "https://github.com/RitickSaha/glassmophism/blob/main/bg.png?raw=true",
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

- `height` (double) - Height for the Widget [@required].
- `width` (double) - Width for the Widget [@required].
- `borderRadius` (double) - Border Radius for the widget `0` - `any` [@required].
- `child` (widget) - [optional parameter] If there is a child widget then the widget will be rendered inside the container.
- `alignment` (optional) - Handles the alignment [`Default_value`] - [`Alignemt.topleft`].
- `padding` (EdgeInset) - Used to provide pading to the child widget [`Default_value`] - [`None`].
- `BoxShape` (Fixed) - This value is fixed to [`BoxFit.rectangle`].
- `constraints` (ChatUser) - The constructor `width` and `height` arguments are combined with the `constraints` argument to set this property.
- `margin` (double) - Empty space to surround the [decoration] and [child]..
- `linearGradient` (LinearGradient) - Fills the container with the gradient passed [@required].
- `border` (double) - Gives Width to the ContainerBorder [@required].
- `blur` (double) - Gives BlurFilter to the Container [@required].
- `borderGradient` (LinearGradient) - Fills the container's border with the gradient passed [@required].

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
> Oficial  [Github](https://www.github.com/riticksaha) 
> Oficial  [Instagram-offical](https://www.instagram.com/theflutterfoundry/)
> Oficial  [Twitter-offical](https://twitter.com/flutterfoundry/)
> Oficial  [Youtube-offical](https://www.youtube.com/channel/UCH7gICVJpoZPRV6h9O6Xu4g)
> Personal [Instagram](https://www.instagram.com/riticksaha_/)
> Personal [Twitter](https://www.twitter.com/rsahatwt/)

## Credits 👨🏻‍💻
- The Flutter Foundry 💙 - [Instagram](https://www.instagram.com/theflutterfoundry/)
- The Flutter Guy 💜 - [Instagram](https://www.instagram.com/theflutterguy)

## Found this project useful? ❤️

If you found this project useful, then please consider giving it a ⭐️ on Github and sharing it with your friends via social media.

## License ⚖️

- [MIT](______Linsese_Addlink______)

## API details 📝

See the [glassmorphic.dart](Addlink______) for more API details

## Issues and feedback 💭

If you have any suggestion for including a feature or if something doesn't work. 
Feel free to open a Github [issue](____IssueAddlink______) for us to have a discussion on it.
