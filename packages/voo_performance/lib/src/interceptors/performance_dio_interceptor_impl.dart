import 'package:dio/dio.dart';
import 'package:voo_performance/src/interceptors/performance_dio_interceptor.dart';

/// Dio-specific implementation of PerformanceDioInterceptor
class PerformanceDioInterceptorImpl extends Interceptor {
  final PerformanceDioInterceptor _performanceInterceptor;

  PerformanceDioInterceptorImpl({bool enabled = true, bool trackTraces = true, bool trackMetrics = true})
    : _performanceInterceptor = PerformanceDioInterceptor(enabled: enabled, trackTraces: trackTraces, trackMetrics: trackMetrics);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final metadata = <String, dynamic>{'method': options.method};

    _performanceInterceptor.onRequest(
      method: options.method,
      url: options.uri.toString(),
      headers: options.headers.map((k, v) => MapEntry(k, v.toString())),
      body: options.data,
      metadata: metadata,
    );

    options.extra['performance_metadata'] = metadata;
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final requestOptions = response.requestOptions;
    final metadata = requestOptions.extra['performance_metadata'] as Map<String, dynamic>?;
    final startTime = metadata?['performance_start_time'] as DateTime?;
    final duration = startTime != null ? DateTime.now().difference(startTime) : Duration.zero;

    _performanceInterceptor.onResponse(
      statusCode: response.statusCode ?? 0,
      url: requestOptions.uri.toString(),
      duration: duration,
      headers: response.headers.map.map((k, v) => MapEntry(k, v.join(', '))),
      body: response.data,
      contentLength: int.tryParse(response.headers.value('content-length') ?? '0'),
      metadata: metadata,
    );

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final requestOptions = err.requestOptions;
    final metadata = requestOptions.extra['performance_metadata'] as Map<String, dynamic>?;

    _performanceInterceptor.onError(url: requestOptions.uri.toString(), error: err, stackTrace: err.stackTrace, metadata: metadata);

    handler.next(err);
  }
}
