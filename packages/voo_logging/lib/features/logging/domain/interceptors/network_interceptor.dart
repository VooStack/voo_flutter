import 'package:voo_logging/features/logging/domain/entities/voo_logger.dart';

abstract class NetworkInterceptor {
  Future<void> onRequest({required String method, required String url, Map<String, String>? headers, dynamic body, Map<String, dynamic>? metadata});

  Future<void> onResponse({
    required int statusCode,
    required String url,
    required Duration duration,
    Map<String, String>? headers,
    dynamic body,
    int? contentLength,
    Map<String, dynamic>? metadata,
  });

  Future<void> onError({required String url, required Object error, StackTrace? stackTrace, Map<String, dynamic>? metadata});
}

class VooNetworkInterceptor implements NetworkInterceptor {
  final bool enabled;

  const VooNetworkInterceptor({this.enabled = true});

  @override
  Future<void> onRequest({required String method, required String url, Map<String, String>? headers, dynamic body, Map<String, dynamic>? metadata}) async {
    if (!enabled) return;

    final Map<String, dynamic> fullMetadata = {
      'method': method,
      'url': url,
      'requestHeaders': headers ?? {},
      'requestBody': body,
      'timestamp': DateTime.now().toIso8601String(),
    };

    if (metadata != null) {
      fullMetadata.addAll(metadata);
    }

    await VooLogger.info('$method $url', category: 'Network', tag: 'Request', metadata: fullMetadata);
  }

  @override
  Future<void> onResponse({
    required int statusCode,
    required String url,
    required Duration duration,
    Map<String, String>? headers,
    dynamic body,
    int? contentLength,
    Map<String, dynamic>? metadata,
  }) async {
    if (!enabled) return;

    final Map<String, Object> fullMetadata = {
      'statusCode': statusCode,
      'url': url,
      'method': (metadata?['method'] as String?) ?? 'GET',
      'duration': duration.inMilliseconds,
      'contentLength': contentLength ?? 0,
      'responseHeaders': (headers ?? <String, String>{}) as Object,
      if (body != null) 'responseBody': body as Object,
      'timestamp': DateTime.now().toIso8601String(),
    };

    if (metadata != null) {
      metadata.forEach((key, value) {
        if (value != null && key != 'method') {
          fullMetadata[key] = value as Object;
        }
      });
    }

    await VooLogger.info('HTTP $statusCode $url (${duration.inMilliseconds}ms)', category: 'Network', tag: 'Response', metadata: fullMetadata);
  }

  @override
  Future<void> onError({required String url, required Object error, StackTrace? stackTrace, Map<String, dynamic>? metadata}) async {
    if (!enabled) return;

    await VooLogger.error('Network error: $url', error: error, stackTrace: stackTrace, category: 'Network', tag: 'Error', metadata: metadata);
  }
}
