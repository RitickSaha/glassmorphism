import 'dart:ui' show ImageFilter;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glassmorphism/glassmorphism.dart';

const LinearGradient _fill = LinearGradient(
  colors: <Color>[Color(0x33FFFFFF), Color(0x0DFFFFFF)],
);
const LinearGradient _borderGradient = LinearGradient(
  colors: <Color>[Color(0x80FFFFFF), Color(0x80FFFFFF)],
);
const Key _childKey = Key('child');

Widget _app(Widget child) => Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: child),
    );

GlassmorphicContainer _glass({
  Key? key,
  double? width,
  double? height,
  double borderRadius = 20,
  double border = 2,
  double blur = 10,
  EdgeInsetsGeometry? padding,
  EdgeInsetsGeometry? margin,
  AlignmentGeometry? alignment,
  BoxShape shape = BoxShape.rectangle,
  List<BoxShadow>? boxShadow,
  Widget? child,
}) {
  return GlassmorphicContainer(
    key: key,
    width: width,
    height: height,
    borderRadius: borderRadius,
    border: border,
    blur: blur,
    padding: padding,
    margin: margin,
    alignment: alignment,
    shape: shape,
    boxShadow: boxShadow,
    linearGradient: _fill,
    borderGradient: _borderGradient,
    child: child,
  );
}

void main() {
  group('GlassmorphicContainer layout', () {
    testWidgets('uses the given width and height', (tester) async {
      await tester.pumpWidget(_app(_glass(width: 200, height: 120)));
      expect(tester.getSize(find.byType(GlassmorphicContainer)),
          const Size(200, 120));
    });

    testWidgets('sizes itself to its child when width/height are omitted',
        (tester) async {
      await tester.pumpWidget(_app(_glass(
        padding: const EdgeInsets.all(8),
        child: const SizedBox(key: _childKey, width: 50, height: 30),
      )));
      expect(tester.getSize(find.byType(GlassmorphicContainer)),
          const Size(66, 46));
    });

    testWidgets('applies padding inside the glass', (tester) async {
      await tester.pumpWidget(_app(_glass(
        width: 100,
        height: 100,
        padding: const EdgeInsets.all(20),
        child: const SizedBox(key: _childKey, width: 10, height: 10),
      )));
      final Offset origin =
          tester.getTopLeft(find.byType(GlassmorphicContainer));
      expect(tester.getTopLeft(find.byKey(_childKey)) - origin,
          const Offset(20, 20));
    });

    testWidgets('applies margin outside the glass', (tester) async {
      await tester.pumpWidget(_app(_glass(
        width: 100,
        height: 100,
        margin: const EdgeInsets.all(10),
      )));
      expect(tester.getSize(find.byType(GlassmorphicContainer)),
          const Size(120, 120));
      expect(tester.getSize(find.byType(BackdropFilter)), const Size(100, 100));
    });

    testWidgets('aligns the child within a fixed size', (tester) async {
      await tester.pumpWidget(_app(_glass(
        width: 100,
        height: 100,
        alignment: Alignment.bottomRight,
        child: const SizedBox(key: _childKey, width: 10, height: 10),
      )));
      expect(tester.getBottomRight(find.byKey(_childKey)),
          tester.getBottomRight(find.byType(GlassmorphicContainer)));
    });

    testWidgets('works without a Directionality ancestor', (tester) async {
      await tester.pumpWidget(Center(
        child: _glass(
          width: 100,
          height: 100,
          child: const SizedBox(key: _childKey, width: 10, height: 10),
        ),
      ));
      expect(tester.takeException(), isNull);
    });

    testWidgets('does not throw inside unbounded constraints', (tester) async {
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: ListView(children: <Widget>[
          _glass(child: const SizedBox(height: 40)),
          _glass(height: 60),
        ]),
      ));
      expect(tester.takeException(), isNull);
    });
  });

  group('GlassmorphicContainer painting', () {
    // https://github.com/RitickSaha/glassmorphism/issues/14
    testWidgets('border wider than the radius does not throw', (tester) async {
      await tester.pumpWidget(_app(_glass(
        width: 100,
        height: 45,
        borderRadius: 5,
        border: 10,
      )));
      expect(tester.takeException(), isNull);
    });

    testWidgets('zero size and oversized border do not throw', (tester) async {
      await tester.pumpWidget(_app(Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _glass(width: 0, height: 45, border: 10),
          _glass(width: 10, height: 10, border: 50),
          _glass(width: 10, height: 10, border: 50, shape: BoxShape.circle),
        ],
      )));
      expect(tester.takeException(), isNull);
    });

    testWidgets('can be given a GlobalKey', (tester) async {
      final GlobalKey key = GlobalKey();
      await tester.pumpWidget(_app(_glass(key: key, width: 50, height: 50)));
      expect(tester.takeException(), isNull);
      expect(key.currentWidget, isA<GlassmorphicContainer>());
    });

    testWidgets('blurs the backdrop uniformly', (tester) async {
      await tester.pumpWidget(_app(_glass(width: 50, height: 50, blur: 7)));
      final BackdropFilter filter = tester.widget(find.byType(BackdropFilter));
      expect(filter.filter, ImageFilter.blur(sigmaX: 7, sigmaY: 7));
    });

    testWidgets('skips the backdrop filter when blur is 0', (tester) async {
      await tester.pumpWidget(_app(_glass(width: 50, height: 50, blur: 0)));
      expect(find.byType(BackdropFilter), findsNothing);
    });

    testWidgets('paints the border as a stroke inside the bounds',
        (tester) async {
      await tester.pumpWidget(_app(_glass(width: 100, height: 60, border: 4)));
      final Finder borderPaint = find.descendant(
        of: find.byType(GlassmorphicContainer),
        matching: find.byWidgetPredicate((Widget w) =>
            w is CustomPaint && w.painter != null && w.child == null),
      );
      expect(
        borderPaint,
        paints
          ..path(
            style: PaintingStyle.stroke,
            strokeWidth: 4,
            // The stroke's centerline is inset by half the border width.
            includes: const <Offset>[Offset(3, 30), Offset(97, 30)],
            excludes: const <Offset>[Offset(1, 30), Offset(99, 30)],
          ),
      );
    });

    testWidgets('omits the border painter when border is 0', (tester) async {
      await tester.pumpWidget(_app(_glass(width: 100, height: 60, border: 0)));
      expect(
        find.descendant(
          of: find.byType(GlassmorphicContainer),
          matching: find.byType(CustomPaint),
        ),
        findsNothing,
      );
    });

    testWidgets('clips a circular shape', (tester) async {
      await tester.pumpWidget(_app(_glass(
        width: 80,
        height: 80,
        shape: BoxShape.circle,
      )));
      expect(find.byType(ClipPath), findsWidgets);
      expect(find.byType(ClipRRect), findsNothing);
    });

    // https://github.com/RitickSaha/glassmorphism/issues/10
    testWidgets('paints shadows outside the glass only', (tester) async {
      const Color shadowColor = Color(0x80000000);
      await tester.pumpWidget(_app(_glass(
        width: 100,
        height: 100,
        boxShadow: const <BoxShadow>[
          BoxShadow(color: shadowColor, offset: Offset(5, 5), blurRadius: 10),
        ],
      )));
      final Finder shadowPaint = find.descendant(
        of: find.byType(GlassmorphicContainer),
        matching: find.byWidgetPredicate(
            (Widget w) => w is CustomPaint && w.child is Stack),
      );
      expect(
        shadowPaint,
        paints
          ..save()
          ..clipPath(
            pathMatcher: isPathThat(
              includes: const <Offset>[Offset(-5, -5), Offset(110, 110)],
              excludes: const <Offset>[Offset(50, 50)],
            ),
          )
          ..path(color: shadowColor)
          ..restore(),
      );
    });
  });

  group('GlassmorphicFlexContainer', () {
    testWidgets('fills its flex share of a Column', (tester) async {
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: 200,
            height: 300,
            child: Column(children: <Widget>[
              const GlassmorphicFlexContainer(
                key: Key('two'),
                flex: 2,
                borderRadius: 10,
                border: 1,
                blur: 5,
                linearGradient: _fill,
                borderGradient: _borderGradient,
                child: SizedBox(width: 10, height: 10),
              ),
              GlassmorphicFlexContainer(
                key: const Key('one'),
                borderRadius: 10,
                border: 1,
                blur: 5,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(4),
                linearGradient: _fill,
                borderGradient: _borderGradient,
                child: Container(key: _childKey),
              ),
            ]),
          ),
        ),
      ));
      expect(
          tester.getSize(find.byKey(const Key('two'))), const Size(200, 200));
      expect(
          tester.getSize(find.byKey(const Key('one'))), const Size(200, 100));
      // margin 4 + padding 12 on each side.
      expect(tester.getSize(find.byKey(_childKey)), const Size(168, 68));
    });
  });

  group('GlassmorphicBorder', () {
    testWidgets('uses its fixed size', (tester) async {
      await tester.pumpWidget(_app(const GlassmorphicBorder(
        strokeWidth: 2,
        radius: 10,
        gradient: _borderGradient,
        width: 40,
        height: 30,
      )));
      expect(
          tester.getSize(find.byType(GlassmorphicBorder)), const Size(40, 30));
    });
  });
}
