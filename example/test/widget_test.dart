import 'package:flutter_test/flutter_test.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:glassmorphism_example/main.dart';

void main() {
  testWidgets('example renders glass widgets without errors', (tester) async {
    await tester.pumpWidget(const GlassmorphismExampleApp());
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(GlassmorphicContainer), findsWidgets);
    expect(find.text('280 × 160'), findsOneWidget);
  });
}
