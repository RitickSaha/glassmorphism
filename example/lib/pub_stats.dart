import 'dart:convert';

import 'package:http/http.dart' as http;

/// Live statistics for a package on pub.dev.
class PubStats {
  const PubStats({
    required this.name,
    required this.version,
    required this.published,
    required this.description,
    required this.likes,
    required this.grantedPoints,
    required this.maxPoints,
    required this.downloads30Days,
  });

  final String name;
  final String version;
  final DateTime published;
  final String description;
  final int likes;
  final int grantedPoints;
  final int maxPoints;
  final int downloads30Days;
}

/// Fetches [package]'s stats from pub.dev's official JSON API.
///
/// The API sends `Access-Control-Allow-Origin: *`, so this also works on the
/// web, unlike scraping pub.dev's HTML pages.
Future<PubStats> fetchPubStats(
  http.Client client, {
  String package = 'glassmorphism',
}) async {
  final List<http.Response> responses =
      await Future.wait(<Future<http.Response>>[
    client.get(Uri.https('pub.dev', '/api/packages/$package')),
    client.get(Uri.https('pub.dev', '/api/packages/$package/score')),
  ]);
  for (final http.Response response in responses) {
    if (response.statusCode != 200) {
      throw http.ClientException(
        'pub.dev returned HTTP ${response.statusCode}',
        response.request?.url,
      );
    }
  }

  final Map<String, dynamic> info =
      jsonDecode(responses[0].body) as Map<String, dynamic>;
  final Map<String, dynamic> score =
      jsonDecode(responses[1].body) as Map<String, dynamic>;
  final Map<String, dynamic> latest = info['latest'] as Map<String, dynamic>;
  final Map<String, dynamic> pubspec =
      latest['pubspec'] as Map<String, dynamic>;

  return PubStats(
    name: info['name'] as String,
    version: latest['version'] as String,
    published: DateTime.parse(latest['published'] as String),
    description: (pubspec['description'] as String? ?? '').trim(),
    likes: (score['likeCount'] as num?)?.toInt() ?? 0,
    grantedPoints: (score['grantedPoints'] as num?)?.toInt() ?? 0,
    maxPoints: (score['maxPoints'] as num?)?.toInt() ?? 0,
    downloads30Days: (score['downloadCount30Days'] as num?)?.toInt() ?? 0,
  );
}

/// Formats large counts compactly: 534, 13.7k, 1.2M.
String compactNumber(int value) {
  if (value < 1000) {
    return '$value';
  }
  if (value < 1000000) {
    return '${_oneDecimal(value / 1000)}k';
  }
  return '${_oneDecimal(value / 1000000)}M';
}

String _oneDecimal(double value) {
  final String text = value.toStringAsFixed(1);
  return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
}

const List<String> _months = <String>[
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// Formats a date like "30 Aug 2021".
String formatDate(DateTime date) {
  final DateTime local = date.toLocal();
  return '${local.day} ${_months[local.month - 1]} ${local.year}';
}
