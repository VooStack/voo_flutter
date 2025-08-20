import 'package:flutter/material.dart';
import 'package:voo_logging_devtools_extension/core/models/log_level.dart';

/// Adapter to convert domain colors to Flutter colors
class ColorAdapter {
  static Color toFlutterColor(LogLevelColor color) => Color(color.value);
}
