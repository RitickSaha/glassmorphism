import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

void main() => runApp(const GlassmorphismExampleApp());

const LinearGradient _glassFill = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: <Color>[Color(0x33FFFFFF), Color(0x0DFFFFFF)],
  stops: <double>[0.1, 1],
);

const LinearGradient _glassBorder = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: <Color>[Color(0x80FFFFFF), Color(0x1AFFFFFF)],
);

class GlassmorphismExampleApp extends StatelessWidget {
  const GlassmorphismExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glassmorphism Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          const Positioned.fill(
            child: Image(
              image: AssetImage('assets/bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: const <Widget>[
                _Section('Fixed size'),
                Center(child: _FixedSizeCard()),
                _Section('Sized by its child'),
                _SizedByChildCard(),
                _Section('Drop shadow'),
                _ShadowCard(),
                _Section('Circle'),
                Center(child: _CircleButton()),
                _Section('Inside a Row (GlassmorphicFlexContainer)'),
                _FlexRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class _FixedSizeCard extends StatelessWidget {
  const _FixedSizeCard();

  @override
  Widget build(BuildContext context) {
    return const GlassmorphicContainer(
      width: 280,
      height: 160,
      borderRadius: 20,
      blur: 20,
      border: 2,
      alignment: Alignment.center,
      linearGradient: _glassFill,
      borderGradient: _glassBorder,
      child: Text('280 × 160', style: TextStyle(fontSize: 24)),
    );
  }
}

class _SizedByChildCard extends StatelessWidget {
  const _SizedByChildCard();

  @override
  Widget build(BuildContext context) {
    // No width or height: the glass wraps the text plus padding.
    return const GlassmorphicContainer(
      borderRadius: 16,
      blur: 12,
      border: 1.5,
      padding: EdgeInsets.all(16),
      linearGradient: _glassFill,
      borderGradient: _glassBorder,
      child: Text(
        'This card has no fixed height. It grows with its content, so it '
        'works in lists and with dynamic text.',
      ),
    );
  }
}

class _ShadowCard extends StatelessWidget {
  const _ShadowCard();

  @override
  Widget build(BuildContext context) {
    return const GlassmorphicContainer(
      height: 100,
      borderRadius: 24,
      blur: 15,
      border: 0,
      alignment: Alignment.center,
      linearGradient: _glassFill,
      borderGradient: _glassBorder,
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Color(0x40000000),
          offset: Offset(5, 5),
          blurRadius: 10,
          spreadRadius: 2,
        ),
      ],
      child: Text('No border, just a shadow'),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton();

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: 96,
      height: 96,
      shape: BoxShape.circle,
      borderRadius: 0,
      blur: 10,
      border: 2,
      linearGradient: _glassFill,
      borderGradient: _glassBorder,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tapped the glass')),
          ),
          child: const Center(child: Icon(Icons.favorite, size: 36)),
        ),
      ),
    );
  }
}

class _FlexRow extends StatelessWidget {
  const _FlexRow();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 100,
      child: Row(
        children: <Widget>[
          GlassmorphicFlexContainer(
            flex: 2,
            borderRadius: 16,
            blur: 10,
            border: 1.5,
            margin: EdgeInsets.only(right: 8),
            alignment: Alignment.center,
            linearGradient: _glassFill,
            borderGradient: _glassBorder,
            child: Text('flex: 2'),
          ),
          GlassmorphicFlexContainer(
            borderRadius: 16,
            blur: 10,
            border: 1.5,
            margin: EdgeInsets.only(left: 8),
            alignment: Alignment.center,
            linearGradient: _glassFill,
            borderGradient: _glassBorder,
            child: Text('flex: 1'),
          ),
        ],
      ),
    );
  }
}
