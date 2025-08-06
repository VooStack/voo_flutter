import 'package:voo_logging/features/logging/domain/entities/log_entry.dart';

class PerformanceLogEntry extends LogEntry {
  final String operation;
  final Duration duration;
  final Map<String, dynamic> metrics;
  final String? operationType;
  final int? memoryUsed;
  final double? cpuUsage;

  const PerformanceLogEntry({
    required super.id,
    required super.timestamp,
    required super.message,
    required super.level,
    required this.operation,
    required this.duration,
    required this.metrics,
    this.operationType,
    this.memoryUsed,
    this.cpuUsage,
    super.category = 'Performance',
    super.tag,
    super.metadata,
    super.error,
    super.stackTrace,
    super.userId,
    super.sessionId,
  });

  bool get isSlow => duration.inMilliseconds > 1000;
  bool get isVerySlow => duration.inMilliseconds > 3000;
}