/// Glassmorphic (frosted glass) containers for Flutter.
///
/// * [GlassmorphicContainer] – a frosted glass box that can have a fixed size
///   or size itself to its child.
/// * [GlassmorphicFlexContainer] – the same glass effect wrapped in an
///   [Expanded], for use directly inside a [Row], [Column] or [Flex].
/// * [GlassmorphicBorder] – just the gradient border, for custom layouts.
library;

import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// A container with a frosted glass (glassmorphism) look: a blurred backdrop,
/// a translucent gradient fill and a gradient border.
///
/// When [width] and [height] are omitted the container sizes itself to its
/// [child] (plus [padding]), just like a regular [Container]. When [alignment]
/// is set, the container expands to fill its parent, again like [Container].
///
/// ```dart
/// GlassmorphicContainer(
///   width: 250,
///   height: 250,
///   borderRadius: 20,
///   blur: 10,
///   border: 2,
///   alignment: Alignment.center,
///   linearGradient: const LinearGradient(
///     begin: Alignment.topLeft,
///     end: Alignment.bottomRight,
///     colors: [Color(0x33FFFFFF), Color(0x0DFFFFFF)],
///   ),
///   borderGradient: const LinearGradient(
///     begin: Alignment.topLeft,
///     end: Alignment.bottomRight,
///     colors: [Color(0x80FFFFFF), Color(0x80FFFFFF)],
///   ),
///   child: const Text('Glass'),
/// )
/// ```
///
/// The blur is applied with a [BackdropFilter], so it only affects what is
/// painted *behind* the container by Flutter. Platform views (for example
/// Google Maps or web views on iOS) may not be blurred, depending on the
/// platform and rendering backend.
class GlassmorphicContainer extends StatelessWidget {
  /// Creates a glassmorphic container.
  ///
  /// [borderRadius], [border] and [blur] must be non-negative.
  const GlassmorphicContainer({
    super.key,
    this.width,
    this.height,
    required this.borderRadius,
    required this.linearGradient,
    required this.border,
    required this.blur,
    required this.borderGradient,
    this.child,
    this.alignment,
    this.padding,
    this.margin,
    this.constraints,
    this.transform,
    this.shape = BoxShape.rectangle,
    this.boxShadow,
    this.clipBehavior = Clip.antiAlias,
  })  : assert(borderRadius >= 0, 'borderRadius must be non-negative'),
        assert(border >= 0, 'border must be non-negative'),
        assert(blur >= 0, 'blur must be non-negative'),
        assert(width == null || width >= 0, 'width must be non-negative'),
        assert(height == null || height >= 0, 'height must be non-negative');

  /// The fixed width of the container, including [padding].
  ///
  /// If null, the width is determined by the [child] and the incoming
  /// constraints.
  final double? width;

  /// The fixed height of the container, including [padding].
  ///
  /// If null, the height is determined by the [child] and the incoming
  /// constraints.
  final double? height;

  /// The radius of the corners. Ignored when [shape] is [BoxShape.circle].
  final double borderRadius;

  /// The gradient used to fill the glass. Use translucent colors so the
  /// blurred backdrop shows through.
  ///
  /// Despite its name, any [Gradient] (linear, radial or sweep) is accepted.
  final Gradient linearGradient;

  /// The width of the gradient border. Use `0` for no border.
  ///
  /// The border is drawn inside the bounds of the container.
  final double border;

  /// The blur sigma applied to what is behind the container, in logical
  /// pixels. Use `0` to disable the blur.
  final double blur;

  /// The gradient used to paint the border.
  final Gradient borderGradient;

  /// The widget below this widget in the tree, clipped to the glass shape.
  final Widget? child;

  /// Aligns the [child] within the container.
  ///
  /// If non-null, the container expands to fill its parent (within any fixed
  /// [width] or [height]) and positions its child within itself according to
  /// the given value. If the incoming constraints are unbounded, the child is
  /// shrink-wrapped instead.
  final AlignmentGeometry? alignment;

  /// Empty space inside the glass, around the [child].
  final EdgeInsetsGeometry? padding;

  /// Empty space around the glass.
  final EdgeInsetsGeometry? margin;

  /// Additional constraints to apply to the glass. [width] and [height]
  /// tighten these constraints.
  final BoxConstraints? constraints;

  /// The transformation matrix to apply before painting the container.
  final Matrix4? transform;

  /// The shape of the glass: a (rounded) rectangle or a circle.
  ///
  /// A circle is centered in the container and has a diameter equal to the
  /// shortest side, matching [BoxDecoration.shape].
  final BoxShape shape;

  /// Shadows cast by the glass.
  ///
  /// Shadows are only painted *outside* the glass shape (like CSS
  /// `box-shadow`), so they do not darken the translucent fill.
  final List<BoxShadow>? boxShadow;

  /// How the [child] is clipped to the glass shape.
  ///
  /// The blurred backdrop is always clipped (with anti-aliasing), otherwise it
  /// would blur the whole screen. Use [Clip.none] to let the child overflow
  /// the glass.
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final TextDirection? textDirection = Directionality.maybeOf(context);
    final _GlassShape glassShape =
        _GlassShape(shape: shape, borderRadius: borderRadius);

    Widget glass = Stack(
      // Directional alignment needs a Directionality ancestor; fall back to
      // top-left so the widget also works without one.
      alignment: textDirection == null
          ? Alignment.topLeft
          : AlignmentDirectional.topStart,
      clipBehavior: Clip.none,
      children: <Widget>[
        Positioned.fill(
          child: _GlassBackground(
            glassShape: glassShape,
            blur: blur,
            gradient: linearGradient,
          ),
        ),
        if (border > 0)
          Positioned.fill(
            child: CustomPaint(
              painter: _BorderPainter(
                glassShape: glassShape,
                strokeWidth: border,
                gradient: borderGradient,
                textDirection: textDirection,
              ),
            ),
          ),
        _clip(
          glassShape,
          clipBehavior,
          Container(alignment: alignment, padding: padding, child: child),
        ),
      ],
    );

    final List<BoxShadow>? shadows = boxShadow;
    if (shadows != null && shadows.isNotEmpty) {
      glass = CustomPaint(
        painter: _ShadowPainter(glassShape: glassShape, shadows: shadows),
        child: glass,
      );
    }

    return Container(
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      transform: transform,
      child: glass,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('width', width, defaultValue: null))
      ..add(DoubleProperty('height', height, defaultValue: null))
      ..add(DoubleProperty('borderRadius', borderRadius))
      ..add(DoubleProperty('border', border))
      ..add(DoubleProperty('blur', blur))
      ..add(DiagnosticsProperty<Gradient>('linearGradient', linearGradient))
      ..add(DiagnosticsProperty<Gradient>('borderGradient', borderGradient))
      ..add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment,
          showName: false, defaultValue: null))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding,
          defaultValue: null))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry>('margin', margin,
          defaultValue: null))
      ..add(DiagnosticsProperty<BoxConstraints>('constraints', constraints,
          defaultValue: null))
      ..add(ObjectFlagProperty<Matrix4>.has('transform', transform))
      ..add(EnumProperty<BoxShape>('shape', shape,
          defaultValue: BoxShape.rectangle))
      ..add(IterableProperty<BoxShadow>('boxShadow', boxShadow,
          defaultValue: null))
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior,
          defaultValue: Clip.antiAlias));
  }
}

/// A [GlassmorphicContainer] wrapped in an [Expanded], so it fills its share
/// of the main axis of a [Row], [Column] or [Flex] and the full cross axis.
///
/// This widget must be a direct child of a [Flex] widget. To make glass that
/// sizes itself to its child, use [GlassmorphicContainer] without a `width`
/// or `height` instead.
///
/// ```dart
/// Column(
///   children: [
///     GlassmorphicFlexContainer(
///       flex: 2,
///       borderRadius: 20,
///       blur: 10,
///       border: 2,
///       linearGradient: const LinearGradient(
///         colors: [Color(0x33FFFFFF), Color(0x0DFFFFFF)],
///       ),
///       borderGradient: const LinearGradient(
///         colors: [Color(0x80FFFFFF), Color(0x80FFFFFF)],
///       ),
///       child: const Text('Glass'),
///     ),
///   ],
/// )
/// ```
class GlassmorphicFlexContainer extends StatelessWidget {
  /// Creates a glassmorphic container that expands inside a [Flex].
  ///
  /// [flex] must be at least 1. [borderRadius], [border] and [blur] must be
  /// non-negative.
  const GlassmorphicFlexContainer({
    super.key,
    this.flex = 1,
    required this.borderRadius,
    required this.linearGradient,
    required this.border,
    required this.blur,
    required this.borderGradient,
    this.child,
    this.alignment,
    this.padding,
    this.margin,
    this.constraints,
    this.transform,
    this.shape = BoxShape.rectangle,
    this.boxShadow,
    this.clipBehavior = Clip.antiAlias,
  })  : assert(flex >= 1, 'flex must be at least 1, got $flex'),
        assert(borderRadius >= 0, 'borderRadius must be non-negative'),
        assert(border >= 0, 'border must be non-negative'),
        assert(blur >= 0, 'blur must be non-negative');

  /// The flex factor passed to the [Expanded] wrapping the glass.
  final int flex;

  /// See [GlassmorphicContainer.borderRadius].
  final double borderRadius;

  /// See [GlassmorphicContainer.linearGradient].
  final Gradient linearGradient;

  /// See [GlassmorphicContainer.border].
  final double border;

  /// See [GlassmorphicContainer.blur].
  final double blur;

  /// See [GlassmorphicContainer.borderGradient].
  final Gradient borderGradient;

  /// See [GlassmorphicContainer.child].
  final Widget? child;

  /// See [GlassmorphicContainer.alignment].
  final AlignmentGeometry? alignment;

  /// See [GlassmorphicContainer.padding].
  final EdgeInsetsGeometry? padding;

  /// See [GlassmorphicContainer.margin].
  final EdgeInsetsGeometry? margin;

  /// Constraints for the glass. Defaults to filling all the space the
  /// [Expanded] provides.
  final BoxConstraints? constraints;

  /// See [GlassmorphicContainer.transform].
  final Matrix4? transform;

  /// See [GlassmorphicContainer.shape].
  final BoxShape shape;

  /// See [GlassmorphicContainer.boxShadow].
  final List<BoxShadow>? boxShadow;

  /// See [GlassmorphicContainer.clipBehavior].
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: GlassmorphicContainer(
        borderRadius: borderRadius,
        linearGradient: linearGradient,
        border: border,
        blur: blur,
        borderGradient: borderGradient,
        alignment: alignment,
        padding: padding,
        margin: margin,
        constraints: constraints ?? const BoxConstraints.expand(),
        transform: transform,
        shape: shape,
        boxShadow: boxShadow,
        clipBehavior: clipBehavior,
        child: child,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('flex', flex))
      ..add(DoubleProperty('borderRadius', borderRadius))
      ..add(DoubleProperty('border', border))
      ..add(DoubleProperty('blur', blur))
      ..add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment,
          showName: false, defaultValue: null))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding,
          defaultValue: null))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry>('margin', margin,
          defaultValue: null))
      ..add(EnumProperty<BoxShape>('shape', shape,
          defaultValue: BoxShape.rectangle));
  }
}

/// Paints a gradient border, as used by [GlassmorphicContainer].
///
/// Without [width] and [height] it expands to fill its parent, like an empty
/// [Container].
class GlassmorphicBorder extends StatelessWidget {
  /// Creates a gradient border.
  ///
  /// [strokeWidth] and [radius] must be non-negative.
  const GlassmorphicBorder({
    super.key,
    required this.strokeWidth,
    required this.radius,
    required this.gradient,
    this.width,
    this.height,
    this.shape = BoxShape.rectangle,
  })  : assert(strokeWidth >= 0, 'strokeWidth must be non-negative'),
        assert(radius >= 0, 'radius must be non-negative');

  /// The width of the border, drawn inside the bounds of this widget.
  final double strokeWidth;

  /// The corner radius. Ignored when [shape] is [BoxShape.circle].
  final double radius;

  /// The gradient used to paint the border.
  final Gradient gradient;

  /// The fixed width of the border, if any.
  final double? width;

  /// The fixed height of the border, if any.
  final double? height;

  /// The shape of the border.
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BorderPainter(
        glassShape: _GlassShape(shape: shape, borderRadius: radius),
        strokeWidth: strokeWidth,
        gradient: gradient,
        textDirection: Directionality.maybeOf(context),
      ),
      // Unlike SizedBox, an empty Container fills bounded constraints and
      // collapses under unbounded ones, matching the previous behavior.
      // ignore: sized_box_for_whitespace
      child: Container(width: width, height: height),
    );
  }
}

/// Describes the outline of the glass so the clip, border and shadow agree.
@immutable
class _GlassShape {
  const _GlassShape({required this.shape, required this.borderRadius});

  final BoxShape shape;
  final double borderRadius;

  /// The outline of the glass in [rect], grown by [inflate] logical pixels
  /// (or shrunk, if negative).
  Path outline(Rect rect, {double inflate = 0}) {
    switch (shape) {
      case BoxShape.circle:
        return Path()
          ..addOval(Rect.fromCircle(
            center: rect.center,
            radius: math.max(0, rect.shortestSide / 2 + inflate),
          ));
      case BoxShape.rectangle:
        // Never shrink past the center, which would invert the rect.
        final double delta = math.max(inflate, -rect.shortestSide / 2);
        return Path()..addRRect(_rrect(rect).inflate(delta));
    }
  }

  RRect _rrect(Rect rect) =>
      RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

  @override
  bool operator ==(Object other) =>
      other is _GlassShape &&
      other.shape == shape &&
      other.borderRadius == borderRadius;

  @override
  int get hashCode => Object.hash(shape, borderRadius);
}

class _GlassClipper extends CustomClipper<Path> {
  const _GlassClipper(this.glassShape);

  final _GlassShape glassShape;

  @override
  Path getClip(Size size) => glassShape.outline(Offset.zero & size);

  @override
  bool shouldReclip(_GlassClipper oldClipper) =>
      oldClipper.glassShape != glassShape;
}

Widget _clip(_GlassShape glassShape, Clip clipBehavior, Widget child) {
  if (clipBehavior == Clip.none) {
    return child;
  }
  if (glassShape.shape == BoxShape.rectangle) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(glassShape.borderRadius),
      clipBehavior: clipBehavior,
      child: child,
    );
  }
  return ClipPath(
    clipper: _GlassClipper(glassShape),
    clipBehavior: clipBehavior,
    child: child,
  );
}

/// The blurred, gradient-filled glass surface.
class _GlassBackground extends StatelessWidget {
  const _GlassBackground({
    required this.glassShape,
    required this.blur,
    required this.gradient,
  });

  final _GlassShape glassShape;
  final double blur;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    Widget fill = DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradient,
        shape: glassShape.shape,
        borderRadius: glassShape.shape == BoxShape.rectangle
            ? BorderRadius.circular(glassShape.borderRadius)
            : null,
      ),
    );
    if (blur > 0) {
      fill = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: fill,
      );
    }
    // The backdrop must always be clipped, or it would blur the whole screen.
    return _clip(glassShape, Clip.antiAlias, fill);
  }
}

class _BorderPainter extends CustomPainter {
  _BorderPainter({
    required this.glassShape,
    required this.strokeWidth,
    required this.gradient,
    required this.textDirection,
  });

  final _GlassShape glassShape;
  final double strokeWidth;
  final Gradient gradient;
  final TextDirection? textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    if (strokeWidth <= 0 || size.isEmpty) {
      return;
    }
    final Rect rect = Offset.zero & size;
    // A border wider than the shape would otherwise produce a negative inner
    // rect or radius and trip assertions in dart:ui.
    final double stroke = math.min(strokeWidth, size.shortestSide / 2);
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..shader = gradient.createShader(rect, textDirection: textDirection);
    canvas.drawPath(glassShape.outline(rect, inflate: -stroke / 2), paint);
  }

  @override
  bool shouldRepaint(_BorderPainter oldDelegate) =>
      oldDelegate.glassShape != glassShape ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.gradient != gradient ||
      oldDelegate.textDirection != textDirection;
}

class _ShadowPainter extends CustomPainter {
  _ShadowPainter({required this.glassShape, required this.shadows});

  final _GlassShape glassShape;
  final List<BoxShadow> shadows;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    double extent = 0;
    for (final BoxShadow shadow in shadows) {
      extent = math.max(
        extent,
        shadow.offset.distance +
            shadow.spreadRadius.abs() +
            shadow.blurRadius * 2,
      );
    }
    // Clip out the glass itself so the shadow does not show through the
    // translucent fill.
    final Path outside = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(rect.inflate(extent + 1))
      ..addPath(glassShape.outline(rect), Offset.zero);
    canvas
      ..save()
      ..clipPath(outside);
    for (final BoxShadow shadow in shadows) {
      canvas.drawPath(
        glassShape.outline(
          rect.shift(shadow.offset),
          inflate: shadow.spreadRadius,
        ),
        shadow.toPaint(),
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ShadowPainter oldDelegate) =>
      oldDelegate.glassShape != glassShape ||
      !listEquals(oldDelegate.shadows, shadows);
}
