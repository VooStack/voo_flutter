import 'package:equatable/equatable.dart';
import 'package:voo_logging/core/domain/enums/log_level.dart';

class LogEntry extends Equatable {
  final String id;
  final DateTime timestamp;
  final String message;
  final LogLevel level;
  final String? category;
  final String? tag;
  final Map<String, dynamic>? metadata;
  final Object? error;
  final String? stackTrace;
  final String? userId;
  final String? sessionId;

  const LogEntry({
    required this.id,
    required this.timestamp,
    required this.message,
    required this.level,
    this.category,
    this.tag,
    this.metadata,
    this.error,
    this.stackTrace,
    this.userId,
    this.sessionId,
  });

  @override
  List<Object?> get props => [id, timestamp, message, level, category, tag, metadata, error, stackTrace, userId, sessionId];
}
