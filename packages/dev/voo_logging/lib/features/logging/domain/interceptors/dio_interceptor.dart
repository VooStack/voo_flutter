import 'package:voo_logging/features/logging/domain/interceptors/network_interceptor.dart';

/// Dio interceptor for automatic network request/response logging.
///
/// Automatically logs all HTTP requests and responses with timing information.
/// Works with any Dio version and auto-initializes VooLogger if needed.
///
/// ## Simple Usage
/// ```dart
/// import 'package:dio/dio.dart';
/// import 'package:voo_logging/voo_logging.dart';
///
/// final dio = Dio();
/// final vooInterceptor = VooDioInterceptor();
///
/// dio.interceptors.add(InterceptorsWrapper(
///   onRequest: vooInterceptor.onRequest,
///   onResponse: vooInterceptor.onResponse,
///   onError: vooInterceptor.onError,
/// ));
///
/// // Now all requests are automatically logged!
/// await dio.get('https://api.example.com/data');
/// ```
///
/// ## What Gets Logged
/// - **Requests**: Method, URL, headers, timeouts
/// - **Responses**: Status code, duration, content length
/// - **Errors**: Error type, message, stack trace
///
/// Logs appear in the 'Network' category and are visible in DevTools.
class VooDioInterceptor {
  final NetworkInterceptor interceptor;

  VooDioInterceptor({NetworkInterceptor? interceptor}) : interceptor = interceptor ?? const VooNetworkInterceptor();

  /// Call this in Dio's onRequest interceptor
  /// The options parameter should be RequestOptions from Dio
  void onRequest(dynamic options, dynamic handler) {
    try {
      // Store start time for duration calculation
      final startTime = DateTime.now();
      if (options.extra is Map) {
        (options.extra as Map)['voo_start_time'] = startTime;
      }

      // Extract method and URL
      final String method = options.method?.toString() ?? 'GET';
      final String url = options.uri?.toString() ?? '';

      // Extract headers
      final Map<String, String> headers = {};
      if (options.headers is Map) {
        (options.headers as Map).forEach((key, value) {
          headers[key.toString()] = value?.toString() ?? '';
        });
      }

      // Extract metadata
      final Map<String, dynamic> metadata = {
        'baseUrl': options.baseUrl?.toString(),
        'connectTimeout': options.connectTimeout?.inMilliseconds,
        'receiveTimeout': options.receiveTimeout?.inMilliseconds,
      };

      interceptor.onRequest(method: method, url: url, headers: headers, body: options.data, metadata: {...metadata, 'requestHeaders': headers});
    } catch (_) {
      // Ignore logging errors to not break the request
    }

    // Continue with the request
    handler.next(options);
  }

  /// Call this in Dio's onResponse interceptor
  /// The response parameter should be Response from Dio
  void onResponse(dynamic response, dynamic handler) {
    try {
      DateTime? startTime;
      if (response.requestOptions?.extra is Map) {
        startTime = (response.requestOptions.extra as Map)['voo_start_time'] as DateTime?;
      }

      final duration = startTime != null ? DateTime.now().difference(startTime) : Duration.zero;

      final String url = response.requestOptions?.uri?.toString() ?? '';
      final int statusCode = (response.statusCode as int?) ?? 0;

      // Extract response headers
      final Map<String, String> headers = {};
      if (response.headers?.map is Map) {
        (response.headers.map as Map).forEach((key, values) {
          if (values is List && values.isNotEmpty) {
            headers[key.toString()] = values.first?.toString() ?? '';
          }
        });
      }

      // Calculate content length
      int? contentLength;
      final contentLengthHeader = response.headers?.value('content-length')?.toString();
      if (contentLengthHeader != null) {
        contentLength = int.tryParse(contentLengthHeader);
      }

      interceptor.onResponse(
        statusCode: statusCode,
        url: url,
        duration: duration,
        headers: headers,
        body: response.data,
        contentLength: contentLength,
        metadata: {'method': response.requestOptions?.method ?? 'GET', 'statusMessage': response.statusMessage?.toString(), 'responseHeaders': headers},
      );
    } catch (_) {
      // Ignore logging errors to not break the response
    }

    // Continue with the response
    handler.next(response);
  }

  /// Call this in Dio's onError interceptor
  /// The error parameter should be DioException/DioError from Dio
  void onError(dynamic error, dynamic handler) {
    try {
      final String url = error.requestOptions?.uri?.toString() ?? '';

      if (error.response != null) {
        // If we have a response, treat it as a response with error status
        DateTime? startTime;
        if (error.requestOptions?.extra is Map) {
          startTime = (error.requestOptions.extra as Map)['voo_start_time'] as DateTime?;
        }

        final duration = startTime != null ? DateTime.now().difference(startTime) : Duration.zero;

        final int statusCode = (error.response?.statusCode as int?) ?? 0;

        // Extract response headers
        final Map<String, String> headers = {};
        if (error.response?.headers?.map is Map) {
          (error.response.headers.map as Map).forEach((key, values) {
            if (values is List && values.isNotEmpty) {
              headers[key.toString()] = values.first?.toString() ?? '';
            }
          });
        }

        interceptor.onResponse(
          statusCode: statusCode,
          url: url,
          duration: duration,
          headers: headers,
          body: error.response?.data,
          metadata: {
            'method': error.requestOptions?.method ?? 'GET',
            'error': error.message?.toString(),
            'type': error.type?.toString(),
            'responseHeaders': headers,
          },
        );
      } else {
        // No response, log as error
        final errorObject = error.error ?? error;
        final stackTrace = error.stackTrace as StackTrace?;

        interceptor.onError(
          url: url,
          error: errorObject as Object,
          stackTrace: stackTrace,
          metadata: {'message': error.message?.toString(), 'type': error.type?.toString()},
        );
      }
    } catch (_) {
      // Ignore logging errors to not break error handling
    }

    // Continue with the error
    handler.next(error);
  }
}
