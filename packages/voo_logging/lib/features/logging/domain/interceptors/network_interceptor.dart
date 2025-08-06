import 'package:voo_logging/features/logging/domain/entities/voo_logger.dart';

abstract class NetworkInterceptor {
  Future<void> onRequest({
    required String method,
    required String url,
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? metadata,
  });

  Future<void> onResponse({
    required int statusCode,
    required String url,
    required Duration duration,
    Map<String, String>? headers,
    dynamic body,
    int? contentLength,
    Map<String, dynamic>? metadata,
  });

  Future<void> onError({
    required String url,
    required Object error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  });
}

class VooNetworkInterceptor implements NetworkInterceptor {
  final bool enabled;

  const VooNetworkInterceptor({this.enabled = true});

  @override
  Future<void> onRequest({
    required String method,
    required String url,
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? metadata,
  }) async {
    if (!enabled) return;
    
    final Map<String, String> requestHeaders = {};
    if (headers != null) {
      headers.forEach((key, value) {
        requestHeaders[key] = value.toString();
      });
    }
    
    final Map<String, String> metadataMap = {};
    if (metadata != null) {
      metadata.forEach((key, value) {
        metadataMap[key] = value?.toString() ?? '';
      });
    }
    if (body != null) {
      metadataMap['requestBody'] = body.toString();
    }
    metadataMap['timestamp'] = DateTime.now().toIso8601String();
    
    await VooLogger.networkRequest(
      method,
      url,
      headers: requestHeaders,
      metadata: metadataMap,
    );
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
    
    final Map<String, String> responseHeaders = {};
    if (headers != null) {
      headers.forEach((key, value) {
        responseHeaders[key] = value.toString();
      });
    }
    
    final Map<String, Object> metadataMap = {};
    if (metadata != null) {
      metadata.forEach((key, value) {
        if (value != null) {
          metadataMap[key] = value as Object;
        }
      });
    }
    if (body != null) {
      metadataMap['responseBody'] = body as Object;
    }
    metadataMap['timestamp'] = DateTime.now().toIso8601String();
    
    await VooLogger.networkResponse(
      statusCode,
      url,
      duration,
      headers: responseHeaders,
      contentLength: contentLength ?? 0,
      metadata: metadataMap,
    );
  }

  @override
  Future<void> onError({
    required String url,
    required Object error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) async {
    if (!enabled) return;
    
    await VooLogger.error(
      'Network error: $url',
      error: error,
      stackTrace: stackTrace,
      category: 'Network',
      tag: 'Error',
      metadata: metadata,
    );
  }
}