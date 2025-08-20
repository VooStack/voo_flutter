import 'package:voo_logging_devtools_extension/core/models/log_level.dart';

/// Model representing a log entry
class LogEntryModel {
  final String id;
  final DateTime timestamp;
  final LogLevel level;
  final String message;
  final String? category;
  final String? tag;
  final String? error;
  final String? stackTrace;
  final Map<String, dynamic>? metadata;

  LogEntryModel({
    required this.id,
    required this.timestamp,
    required this.level,
    required this.message,
    this.category,
    this.tag,
    this.error,
    this.stackTrace,
    this.metadata,
  });

  /// Create from JSON
  factory LogEntryModel.fromJson(Map<String, dynamic> json) {
    return LogEntryModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      level: _parseLogLevel(json['level']),
      message: json['message'] ?? '',
      category: json['category'],
      tag: json['tag'],
      error: json['error'],
      stackTrace: json['stackTrace'],
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'level': level.name,
      'message': message,
      if (category != null) 'category': category,
      if (tag != null) 'tag': tag,
      if (error != null) 'error': error,
      if (stackTrace != null) 'stackTrace': stackTrace,
      if (metadata != null) 'metadata': metadata,
    };
  }

  /// Parse log level from string
  static LogLevel _parseLogLevel(dynamic level) {
    if (level is LogLevel) return level;
    if (level is String) {
      return LogLevel.values.firstWhere(
        (e) => e.name.toLowerCase() == level.toLowerCase(),
        orElse: () => LogLevel.info,
      );
    }
    return LogLevel.info;
  }

  /// Create a copy with modifications
  LogEntryModel copyWith({
    String? id,
    DateTime? timestamp,
    LogLevel? level,
    String? message,
    String? category,
    String? tag,
    String? error,
    String? stackTrace,
    Map<String, dynamic>? metadata,
  }) {
    return LogEntryModel(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      level: level ?? this.level,
      message: message ?? this.message,
      category: category ?? this.category,
      tag: tag ?? this.tag,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LogEntryModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}