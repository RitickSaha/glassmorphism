import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:http/http.dart' as http;

import 'feature_gallery.dart';
import 'glass_styles.dart';
import 'pub_stats.dart';

/// A real-world style screen built from glass: a live pub.dev stats card and
/// a sign-in form, both on top of a large tinted glass panel.
class ShowcasePage extends StatefulWidget {
  const ShowcasePage({super.key, required this.client});

  /// Used to load the live stats from pub.dev.
  final http.Client client;

  @override
  State<ShowcasePage> createState() => _ShowcasePageState();
}

class _ShowcasePageState extends State<ShowcasePage> {
  late Future<PubStats> _stats = fetchPubStats(widget.client);

  void _reload() {
    setState(() {
      // FutureBuilder only listens after the next build; ignore() keeps a
      // fast failure from being reported as uncaught before then. The
      // FutureBuilder still receives the error.
      _stats = fetchPubStats(widget.client)..ignore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: const EdgeInsets.all(12),
                // A large, borderless, orange-tinted panel that fills the
                // screen. The cards below are glass on top of glass.
                child: GlassmorphicContainer(
                  constraints: const BoxConstraints.expand(),
                  borderRadius: 24,
                  blur: 7,
                  border: 0,
                  linearGradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Color(0x37F75035), Color(0x2DFFFFFF)],
                    stops: <double>[0.3, 1],
                  ),
                  borderGradient: glassBorder,
                  child: Stack(
                    children: <Widget>[
                      // Colorful shapes behind the sign-in card, so you can
                      // see the blur at work.
                      const Positioned(
                        left: 36,
                        bottom: 150,
                        child: _GradientShape(
                          size: Size(100, 100),
                          shape: BoxShape.circle,
                          colors: <Color>[Color(0xFFBC1642), Color(0xFFCB5AC6)],
                        ),
                      ),
                      const Positioned(
                        left: 24,
                        bottom: 80,
                        child: _GradientShape(
                          size: Size(80, 40),
                          shape: BoxShape.rectangle,
                          colors: <Color>[Color(0xFFFDFC47), Color(0xFF24FE41)],
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          // Fills the space the Column has left over.
                          GlassmorphicFlexContainer(
                            borderRadius: 32,
                            blur: 14,
                            border: 2,
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            padding: const EdgeInsets.all(20),
                            alignment: Alignment.center,
                            linearGradient: glassFill,
                            borderGradient: glassBorder,
                            child: FutureBuilder<PubStats>(
                              future: _stats,
                              builder: (context, snapshot) => _StatsCard(
                                snapshot: snapshot,
                                onRetry: _reload,
                              ),
                            ),
                          ),
                          // No width or height: sized by the form inside.
                          const GlassmorphicContainer(
                            borderRadius: 32,
                            blur: 10,
                            border: 2,
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
                            linearGradient: glassFill,
                            borderGradient: glassBorder,
                            child: _SignInForm(),
                          ),
                          const _GalleryButton(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.snapshot, required this.onRetry});

  final AsyncSnapshot<PubStats> snapshot;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    final PubStats? stats = snapshot.data;

    final Widget numbers;
    if (stats != null) {
      numbers = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _Stat(value: compactNumber(stats.likes), label: 'Likes'),
          _Stat(
            value: '${stats.grantedPoints}',
            suffix: '/${stats.maxPoints}',
            label: 'Pub points',
          ),
          _Stat(
            value: compactNumber(stats.downloads30Days),
            label: 'Downloads\n(30 days)',
          ),
        ],
      );
    } else if (snapshot.hasError) {
      numbers = Column(
        children: <Widget>[
          const Text(
            "Couldn't load live stats from pub.dev.",
            textAlign: TextAlign.center,
          ),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      );
    } else {
      numbers = const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox.square(
          dimension: 28,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            stats == null
                ? 'glassmorphism'
                : '${stats.name}: ^${stats.version}',
            textAlign: TextAlign.center,
            style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          if (stats != null)
            Text(
              'Published on ${formatDate(stats.published)}',
              style: text.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
            ),
          Text(
            'Published by Ritick Saha\n(The Flutter Foundry)',
            textAlign: TextAlign.center,
            style: text.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 16),
          numbers,
          if (stats != null && stats.description.isNotEmpty) ...<Widget>[
            const SizedBox(height: 16),
            Text(
              'Package description:',
              style: text.titleSmall?.copyWith(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 4),
            Text(
              stats.description,
              textAlign: TextAlign.center,
              style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w300),
            ),
          ],
          const SizedBox(height: 16),
          Image.asset('assets/logo.png', height: 30, cacheHeight: 90),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, this.suffix});

  final String value;
  final String? suffix;
  final String label;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Column(
      children: <Widget>[
        Text.rich(
          TextSpan(
            text: value,
            style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            children: <InlineSpan>[
              if (suffix != null)
                TextSpan(text: suffix, style: text.titleSmall),
            ],
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: text.bodySmall?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}

class _SignInForm extends StatelessWidget {
  const _SignInForm();

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text('Sign In', textAlign: TextAlign.center, style: text.titleLarge),
        Text(
          'An example use case of GlassmorphicContainer',
          textAlign: TextAlign.center,
          style: text.bodySmall,
        ),
        const SizedBox(height: 12),
        const _GlassTextField(hint: 'Your Email'),
        const SizedBox(height: 10),
        const _GlassTextField(hint: 'Password', obscure: true),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text('Next', style: text.titleLarge),
            Material(
              color: Colors.white,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This form is only a demo.')),
                ),
                child: const SizedBox.square(
                  dimension: 48,
                  child: Icon(Icons.arrow_forward, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GlassTextField extends StatelessWidget {
  const _GlassTextField({required this.hint, this.obscure = false});

  final String hint;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    const OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(40)),
      borderSide: BorderSide(color: Colors.white54, width: 0.5),
    );
    return TextField(
      obscureText: obscure,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}

class _GalleryButton extends StatelessWidget {
  const _GalleryButton();

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      height: 48,
      borderRadius: 24,
      blur: 10,
      border: 1,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      linearGradient: glassFill,
      borderGradient: glassBorder,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const FeatureGalleryPage(),
            ),
          ),
          child: const Center(child: Text('Explore every feature  →')),
        ),
      ),
    );
  }
}

class _GradientShape extends StatelessWidget {
  const _GradientShape({
    required this.size,
    required this.shape,
    required this.colors,
  });

  final Size size;
  final BoxShape shape;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        shape: shape,
        gradient: LinearGradient(colors: colors),
      ),
    );
  }
}
