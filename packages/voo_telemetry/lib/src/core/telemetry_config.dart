/// Configuration for VooTelemetry
class TelemetryConfig {
  final String endpoint;
  final String? apiKey;
  final Duration batchInterval;
  final int maxBatchSize;
  final bool debug;
  final Duration timeout;
  final int maxRetries;
  final Duration retryDelay;
  final bool enableCompression;
  final Map<String, String> headers;

  TelemetryConfig({
    required this.endpoint,
    this.apiKey,
    this.batchInterval = const Duration(seconds: 30),
    this.maxBatchSize = 100,
    this.debug = false,
    this.timeout = const Duration(seconds: 10),
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.enableCompression = true,
    Map<String, String>? headers,
  }) : headers = {'Content-Type': 'application/json', if (apiKey != null) 'X-API-Key': apiKey, ...?headers};

  /// Create a copy with updated values
  TelemetryConfig copyWith({
    String? endpoint,
    String? apiKey,
    Duration? batchInterval,
    int? maxBatchSize,
    bool? debug,
    Duration? timeout,
    int? maxRetries,
    Duration? retryDelay,
    bool? enableCompression,
    Map<String, String>? headers,
  }) => TelemetryConfig(
    endpoint: endpoint ?? this.endpoint,
    apiKey: apiKey ?? this.apiKey,
    batchInterval: batchInterval ?? this.batchInterval,
    maxBatchSize: maxBatchSize ?? this.maxBatchSize,
    debug: debug ?? this.debug,
    timeout: timeout ?? this.timeout,
    maxRetries: maxRetries ?? this.maxRetries,
    retryDelay: retryDelay ?? this.retryDelay,
    enableCompression: enableCompression ?? this.enableCompression,
    headers: headers ?? this.headers,
  );
}
