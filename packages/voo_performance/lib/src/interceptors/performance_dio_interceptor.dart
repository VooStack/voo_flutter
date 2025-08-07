import 'package:voo_core/voo_core.dart';
import 'package:voo_performance/src/voo_performance_plugin.dart';
import 'package:voo_performance/src/domain/entities/network_metric.dart';
import 'package:voo_performance/src/domain/entities/performance_trace.dart';

class PerformanceDioInterceptor extends BaseInterceptor {
  @override
  final bool enabled;
  final bool trackTraces;
  final bool trackMetrics;

  PerformanceDioInterceptor({
    this.enabled = true,
    this.trackTraces = true,
    this.trackMetrics = true,
  });

  @override
  void onRequest({
    required String method,
    required String url,
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? metadata,
  }) {
    if (!enabled || !VooPerformancePlugin.instance.isInitialized) return;

    if (trackTraces) {
      final trace = VooPerformancePlugin.instance.newHttpTrace(url, method);
      trace.start();
      
      if (body != null) {
        final bodySize = _calculateSize(body);
        if (bodySize > 0) {
          trace.putMetric('request_size', bodySize);
        }
      }
      
      metadata?['performance_trace'] = trace;
    }

    metadata?['performance_start_time'] = DateTime.now();
  }

  @override
  void onResponse({
    required int statusCode,
    required String url,
    required Duration duration,
    Map<String, String>? headers,
    dynamic body,
    int? contentLength,
    Map<String, dynamic>? metadata,
  }) {
    if (!enabled || !VooPerformancePlugin.instance.isInitialized) return;

    if (trackTraces && metadata?['performance_trace'] != null) {
      final trace = metadata!['performance_trace'] as PerformanceTrace;
      trace.putMetric('status_code', statusCode);
      
      if (contentLength != null && contentLength > 0) {
        trace.putMetric('response_size', contentLength);
      } else if (body != null) {
        final bodySize = _calculateSize(body);
        if (bodySize > 0) {
          trace.putMetric('response_size', bodySize);
        }
      }
      
      trace.stop();
    }

    if (trackMetrics) {
      final metric = NetworkMetric(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        url: url,
        method: metadata?['method'] as String? ?? 'GET',
        statusCode: statusCode,
        duration: duration,
        timestamp: metadata?['performance_start_time'] as DateTime? ?? DateTime.now(),
        requestSize: metadata?['request_size'] as int?,
        responseSize: contentLength ?? _calculateSize(body),
        metadata: {
          if (headers != null) 'response_headers': headers,
          if (metadata != null)
            ...Map.fromEntries(metadata.entries.where((e) => !e.key.startsWith('performance_'))),
        },
      );
      
      VooPerformancePlugin.instance.recordNetworkMetric(metric);
    }
  }

  @override
  void onError({
    required String url,
    required Object error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) {
    if (!enabled || !VooPerformancePlugin.instance.isInitialized) return;

    if (trackTraces && metadata?['performance_trace'] != null) {
      final trace = metadata!['performance_trace'] as PerformanceTrace;
      trace.putAttribute('error', error.toString());
      trace.putMetric('status_code', 0);
      trace.stop();
    }

    if (trackMetrics) {
      final startTime = metadata?['performance_start_time'] as DateTime?;
      final duration = startTime != null 
          ? DateTime.now().difference(startTime)
          : Duration.zero;
      
      final metric = NetworkMetric(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        url: url,
        method: metadata?['method'] as String? ?? 'GET',
        statusCode: 0,
        duration: duration,
        timestamp: startTime ?? DateTime.now(),
        metadata: {
          'error': error.toString(),
          if (stackTrace != null) 'stack_trace': stackTrace.toString(),
          if (metadata != null)
            ...Map.fromEntries(metadata.entries.where((e) => !e.key.startsWith('performance_'))),
        },
      );
      
      VooPerformancePlugin.instance.recordNetworkMetric(metric);
    }
  }

  int _calculateSize(dynamic data) {
    if (data == null) return 0;
    
    try {
      if (data is String) {
        return data.length;
      } else if (data is List) {
        return data.toString().length;
      } else if (data is Map) {
        return data.toString().length;
      } else {
        return data.toString().length;
      }
    } catch (_) {
      return 0;
    }
  }
}

class VooPerformanceDioInterceptor {
  final PerformanceDioInterceptor interceptor;

  VooPerformanceDioInterceptor({
    bool enabled = true,
    bool trackTraces = true,
    bool trackMetrics = true,
  }) : interceptor = PerformanceDioInterceptor(
          enabled: enabled,
          trackTraces: trackTraces,
          trackMetrics: trackMetrics,
        );

  void onRequest(dynamic options, dynamic handler) {
    try {
      final startTime = DateTime.now();
      if (options.extra is Map) {
        (options.extra as Map)['performance_start_time'] = startTime;
      }

      final String method = options.method?.toString() ?? 'GET';
      final String url = options.uri?.toString() ?? '';

      final Map<String, String> headers = {};
      if (options.headers is Map) {
        (options.headers as Map).forEach((key, value) {
          headers[key.toString()] = value?.toString() ?? '';
        });
      }

      final Map<String, dynamic> metadata = {
        'method': method,
        ...options.extra as Map? ?? {},
      };

      interceptor.onRequest(
        method: method,
        url: url,
        headers: headers,
        body: options.data,
        metadata: metadata,
      );

      if (options.extra is Map && metadata['performance_trace'] != null) {
        (options.extra as Map)['performance_trace'] = metadata['performance_trace'];
      }
    } catch (_) {}

    handler.next(options);
  }

  void onResponse(dynamic response, dynamic handler) {
    try {
      DateTime? startTime;
      PerformanceTrace? trace;
      
      if (response.requestOptions?.extra is Map) {
        final extra = response.requestOptions.extra as Map;
        startTime = extra['performance_start_time'] as DateTime?;
        trace = extra['performance_trace'] as PerformanceTrace?;
      }

      final duration = startTime != null 
          ? DateTime.now().difference(startTime)
          : Duration.zero;

      final String url = response.requestOptions?.uri?.toString() ?? '';
      final int statusCode = (response.statusCode as int?) ?? 0;

      final Map<String, String> headers = {};
      if (response.headers?.map is Map) {
        (response.headers.map as Map).forEach((key, values) {
          if (values is List && values.isNotEmpty) {
            headers[key.toString()] = values.first?.toString() ?? '';
          }
        });
      }

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
        metadata: {
          'method': response.requestOptions?.method ?? 'GET',
          if (trace != null) 'performance_trace': trace,
          if (startTime != null) 'performance_start_time': startTime,
        },
      );
    } catch (_) {}

    handler.next(response);
  }

  void onError(dynamic error, dynamic handler) {
    try {
      final String url = error.requestOptions?.uri?.toString() ?? '';
      DateTime? startTime;
      PerformanceTrace? trace;
      
      if (error.requestOptions?.extra is Map) {
        final extra = error.requestOptions.extra as Map;
        startTime = extra['performance_start_time'] as DateTime?;
        trace = extra['performance_trace'] as PerformanceTrace?;
      }

      if (error.response != null) {
        final duration = startTime != null 
            ? DateTime.now().difference(startTime)
            : Duration.zero;

        final int statusCode = (error.response?.statusCode as int?) ?? 0;

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
            'error': error.message?.toString(),
            'type': error.type?.toString(),
            'method': error.requestOptions?.method ?? 'GET',
            if (trace != null) 'performance_trace': trace,
            if (startTime != null) 'performance_start_time': startTime,
          },
        );
      } else {
        final errorObject = error.error ?? error;
        final stackTrace = error.stackTrace as StackTrace?;

        interceptor.onError(
          url: url,
          error: errorObject as Object,
          stackTrace: stackTrace,
          metadata: {
            'message': error.message?.toString(),
            'type': error.type?.toString(),
            'method': error.requestOptions?.method ?? 'GET',
            if (trace != null) 'performance_trace': trace,
            if (startTime != null) 'performance_start_time': startTime,
          },
        );
      }
    } catch (_) {}

    handler.next(error);
  }
}