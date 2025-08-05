import 'package:flutter/material.dart';

/// Adapter to convert domain colors to Flutter colors
class ColorAdapter {
  static Color toFlutterColor(LogLevelColor color) => Color.fromRGBO(color.red, color.green, color.blue, color.opacity);
}
