import 'package:flutter/material.dart';

class MediaQueryHelper {
  final BuildContext context;

  MediaQueryHelper(this.context);

  // Get screen width
  double get width => MediaQuery.of(context).size.width;

  // Get screen height
  double get height => MediaQuery.of(context).size.height;

  // Get text scale factor
  double get textScaleFactor => MediaQuery.of(context).textScaleFactor;

  // Scaled height based on a fraction
  double scaledHeight(double fraction) => height * fraction;

  // Scaled width based on a fraction
  double scaledWidth(double fraction) => width * fraction;

  // Scaled font size based on a fraction
  double scaledFontSize(double fraction) => scaledWidth(fraction) / textScaleFactor;
}
