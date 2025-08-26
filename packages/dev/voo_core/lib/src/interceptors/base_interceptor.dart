import 'dart:async';

abstract class BaseInterceptor {
  bool get enabled;

  FutureOr<void> onRequest({
    required String method,
    required String url,
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? metadata,
  });

  FutureOr<void> onResponse({
    required int statusCode,
    required String url,
    required Duration duration,
    Map<String, String>? headers,
    dynamic body,
    int? contentLength,
    Map<String, dynamic>? metadata,
  });

  FutureOr<void> onError({
    required String url,
    required Object error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  });
}
