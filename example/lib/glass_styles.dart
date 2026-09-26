import 'package:flutter/widgets.dart';

/// Gradients shared by the example screens.
///
/// Glass looks best with translucent white fills and a brighter border.
const LinearGradient glassFill = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: <Color>[Color(0x33FFFFFF), Color(0x0DFFFFFF)],
  stops: <double>[0.1, 1],
);

const LinearGradient glassBorder = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: <Color>[Color(0x80FFFFFF), Color(0x1AFFFFFF)],
);
