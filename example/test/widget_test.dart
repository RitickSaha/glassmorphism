import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:glassmorphism_example/feature_gallery.dart';
import 'package:glassmorphism_example/main.dart';
import 'package:glassmorphism_example/pub_stats.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

final Map<String, Object> _info = <String, Object>{
  'name': 'glassmorphism',
  'latest': <String, Object>{
    'version': '4.0.0',
    'published': '2021-08-30T07:47:21.148334Z',
    'pubspec': <String, Object>{'description': 'Glass containers.'},
  },
};

const Map<String, Object> _score = <String, Object>{
  'grantedPoints': 140,
  'maxPoints': 160,
  'likeCount': 534,
  'downloadCount30Days': 13721,
};

MockClient _pubDev({bool fail = false}) => MockClient((request) async {
      if (fail) {
        return http.Response('oops', 500);
      }
      final bool isScore = request.url.path.endsWith('/score');
      return http.Response(jsonEncode(isScore ? _score : _info), 200);
    });

void main() {
  group('fetchPubStats', () {
    test('reads the package info and score APIs', () async {
      final PubStats stats = await fetchPubStats(_pubDev());
      expect(stats.name, 'glassmorphism');
      expect(stats.version, '4.0.0');
      expect(stats.description, 'Glass containers.');
      expect(stats.likes, 534);
      expect(stats.grantedPoints, 140);
      expect(stats.maxPoints, 160);
      expect(stats.downloads30Days, 13721);
    });

    test('throws on an HTTP error', () {
      expect(fetchPubStats(_pubDev(fail: true)),
          throwsA(isA<http.ClientException>()));
    });
  });

  test('compactNumber', () {
    expect(compactNumber(534), '534');
    expect(compactNumber(13721), '13.7k');
    expect(compactNumber(2000), '2k');
    expect(compactNumber(1250000), '1.3M');
  });

  testWidgets('shows live stats once loaded', (tester) async {
    await tester.pumpWidget(GlassmorphismExampleApp(client: _pubDev()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('glassmorphism: ^4.0.0'), findsOneWidget);
    expect(find.text('Published on 30 Aug 2021'), findsOneWidget);
    expect(find.text('534'), findsOneWidget);
    expect(find.text('13.7k'), findsOneWidget);
    expect(find.text('Glass containers.'), findsOneWidget);
    expect(find.byType(GlassmorphicFlexContainer), findsOneWidget);
    expect(find.byType(GlassmorphicContainer), findsWidgets);
  });

  testWidgets('shows an error with retry when pub.dev fails', (tester) async {
    await tester
        .pumpWidget(GlassmorphismExampleApp(client: _pubDev(fail: true)));
    await tester.pumpAndSettle();
    expect(find.text("Couldn't load live stats from pub.dev."), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text("Couldn't load live stats from pub.dev."), findsOneWidget);
  });

  testWidgets('opens the feature gallery', (tester) async {
    await tester.pumpWidget(GlassmorphismExampleApp(client: _pubDev()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Explore every feature  →'));
    await tester.pumpAndSettle();
    expect(find.byType(FeatureGalleryPage), findsOneWidget);
    expect(find.text('280 × 160'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
