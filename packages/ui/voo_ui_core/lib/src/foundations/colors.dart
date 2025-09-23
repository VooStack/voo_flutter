import 'package:flutter/material.dart';

class VooColors {
  static const Map<String, Color> logLevels = {
    'verbose': Colors.grey,
    'debug': Colors.blue,
    'info': Colors.green,
    'warning': Colors.orange,
    'error': Colors.red,
    'fatal': Color(0xFF9C27B0),
  };

  static const Map<String, Color> httpMethods = {
    'GET': Colors.blue,
    'POST': Colors.green,
    'PUT': Colors.orange,
    'DELETE': Colors.red,
    'PATCH': Colors.purple,
    'HEAD': Colors.teal,
    'OPTIONS': Colors.grey,
  };

  static Color getLogLevelColor(String level) => logLevels[level.toLowerCase()] ?? Colors.grey;

  static Color getHttpStatusColor(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) return Colors.green;
    if (statusCode >= 300 && statusCode < 400) return Colors.blue;
    if (statusCode >= 400 && statusCode < 500) return Colors.orange;
    if (statusCode >= 500) return Colors.red;
    return Colors.grey;
  }

  static Color getPerformanceColor(int milliseconds) {
    if (milliseconds < 100) return Colors.green;
    if (milliseconds < 300) return Colors.lightGreen;
    if (milliseconds < 500) return Colors.lime;
    if (milliseconds < 1000) return Colors.yellow;
    if (milliseconds < 3000) return Colors.orange;
    return Colors.red;
  }

  static Color getHttpMethodColor(String method) => httpMethods[method.toUpperCase()] ?? Colors.grey;
}
