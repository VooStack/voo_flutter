import 'package:voo_logging_devtools_extension/core/models/log_entry_model.dart';

/// Represents a complete network request/response pair
class NetworkRequestModel {
  final String id;
  final String url;
  final String method;
  final DateTime timestamp;
  final int? statusCode;
  final int? duration;
  final int? requestSize;
  final int? responseSize;
  final Map<String, dynamic>? requestHeaders;
  final Map<String, dynamic>? responseHeaders;
  final dynamic requestBody;
  final dynamic responseBody;
  final String? error;
  final LogEntryModel? requestLog;
  final LogEntryModel? responseLog;
  final bool isComplete;
  final bool isInProgress;

  NetworkRequestModel({
    required this.id,
    required this.url,
    required this.method,
    required this.timestamp,
    this.statusCode,
    this.duration,
    this.requestSize,
    this.responseSize,
    this.requestHeaders,
    this.responseHeaders,
    this.requestBody,
    this.responseBody,
    this.error,
    this.requestLog,
    this.responseLog,
    this.isComplete = false,
    this.isInProgress = true,
  });

  /// Create from a log entry
  factory NetworkRequestModel.fromLogEntry(LogEntryModel log) {
    final metadata = log.metadata ?? {};
    final isResponse = metadata['statusCode'] != null;

    // Generate consistent ID based on URL and timestamp
    final baseId =
        '${metadata['url']}_${log.timestamp.millisecondsSinceEpoch ~/ 1000}';

    return NetworkRequestModel(
      id: baseId,
      url: metadata['url'] ?? log.message,
      method: metadata['method'] ?? 'GET',
      timestamp: log.timestamp,
      statusCode: isResponse ? metadata['statusCode'] : null,
      duration: metadata['duration'],
      requestSize: metadata['requestSize'],
      responseSize: metadata['responseSize'],
      requestHeaders: metadata['requestHeaders'],
      responseHeaders: metadata['responseHeaders'],
      requestBody: metadata['requestBody'],
      responseBody: metadata['responseBody'],
      error: metadata['error'] ?? log.error,
      requestLog: !isResponse ? log : null,
      responseLog: isResponse ? log : null,
      isComplete: isResponse,
      isInProgress: !isResponse,
    );
  }

  /// Merge with another network request (typically request + response)
  NetworkRequestModel merge(NetworkRequestModel other) {
    // Prefer response data when available
    return NetworkRequestModel(
      id: id,
      url: url,
      method: method,
      timestamp: timestamp,
      statusCode: statusCode ?? other.statusCode,
      duration: duration ?? other.duration,
      requestSize: requestSize ?? other.requestSize,
      responseSize: responseSize ?? other.responseSize,
      requestHeaders: requestHeaders ?? other.requestHeaders,
      responseHeaders: responseHeaders ?? other.responseHeaders,
      requestBody: requestBody ?? other.requestBody,
      responseBody: responseBody ?? other.responseBody,
      error: error ?? other.error,
      requestLog: requestLog ?? other.requestLog,
      responseLog: responseLog ?? other.responseLog,
      isComplete: statusCode != null,
      isInProgress: statusCode == null,
    );
  }

  /// Check if this is likely the same request as another
  bool isSameRequest(NetworkRequestModel other) {
    // Same URL and method within 5 seconds
    final timeDiff = timestamp.difference(other.timestamp).abs();
    return url == other.url && method == other.method && timeDiff.inSeconds < 5;
  }

  /// Get display status
  String get displayStatus {
    if (error != null) return 'Error';
    if (statusCode != null) return statusCode.toString();
    if (isInProgress) {
      // Check if request is stale (pending for more than 30 seconds)
      final age = DateTime.now().difference(timestamp);
      if (age.inSeconds > 30) return 'Timeout';
      return 'Pending';
    }
    return 'Unknown';
  }
  
  /// Check if request has timed out (pending for more than 30 seconds)
  bool get hasTimedOut {
    if (!isInProgress) return false;
    final age = DateTime.now().difference(timestamp);
    return age.inSeconds > 30;
  }

  /// Get display duration
  String get displayDuration {
    if (duration == null) return isInProgress ? '...' : '-';
    if (duration! < 1000) return '${duration}ms';
    return '${(duration! / 1000).toStringAsFixed(1)}s';
  }

  /// Get display size
  String get displaySize {
    final total = (requestSize ?? 0) + (responseSize ?? 0);
    if (total == 0) return '-';
    if (total < 1024) return '${total}B';
    if (total < 1024 * 1024) return '${(total / 1024).toStringAsFixed(1)}KB';
    return '${(total / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  NetworkRequestModel copyWith({
    String? id,
    String? url,
    String? method,
    DateTime? timestamp,
    int? statusCode,
    int? duration,
    int? requestSize,
    int? responseSize,
    Map<String, dynamic>? requestHeaders,
    Map<String, dynamic>? responseHeaders,
    dynamic requestBody,
    dynamic responseBody,
    String? error,
    LogEntryModel? requestLog,
    LogEntryModel? responseLog,
    bool? isComplete,
    bool? isInProgress,
  }) {
    return NetworkRequestModel(
      id: id ?? this.id,
      url: url ?? this.url,
      method: method ?? this.method,
      timestamp: timestamp ?? this.timestamp,
      statusCode: statusCode ?? this.statusCode,
      duration: duration ?? this.duration,
      requestSize: requestSize ?? this.requestSize,
      responseSize: responseSize ?? this.responseSize,
      requestHeaders: requestHeaders ?? this.requestHeaders,
      responseHeaders: responseHeaders ?? this.responseHeaders,
      requestBody: requestBody ?? this.requestBody,
      responseBody: responseBody ?? this.responseBody,
      error: error ?? this.error,
      requestLog: requestLog ?? this.requestLog,
      responseLog: responseLog ?? this.responseLog,
      isComplete: isComplete ?? this.isComplete,
      isInProgress: isInProgress ?? this.isInProgress,
    );
  }
}
