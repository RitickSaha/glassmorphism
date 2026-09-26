import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'showcase_page.dart';

void main() => runApp(GlassmorphismExampleApp(client: http.Client()));

class GlassmorphismExampleApp extends StatelessWidget {
  const GlassmorphismExampleApp({super.key, required this.client});

  /// Used to load the live package stats from pub.dev.
  final http.Client client;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glassmorphism Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: ShowcasePage(client: client),
    );
  }
}
