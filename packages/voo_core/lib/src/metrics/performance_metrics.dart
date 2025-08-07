import 'package:flutter/foundation.dart';

@immutable
class PerformanceMetrics {
  final DateTime timestamp;
  final Duration duration;
  final int? memoryUsage;
  final double? cpuUsage;
  final Map<String, dynamic> customMetrics;

  const PerformanceMetrics({
    required this.timestamp,
    required this.duration,
    this.memoryUsage,
    this.cpuUsage,
    this.customMetrics = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'duration_ms': duration.inMilliseconds,
      if (memoryUsage != null) 'memory_bytes': memoryUsage,
      if (cpuUsage != null) 'cpu_percentage': cpuUsage,
      'custom': customMetrics,
    };
  }

  @override
  String toString() {
    return 'PerformanceMetrics(timestamp: $timestamp, duration: $duration, memory: $memoryUsage, cpu: $cpuUsage)';
  }
}