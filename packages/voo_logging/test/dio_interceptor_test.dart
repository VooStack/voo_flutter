import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:voo_logging/features/logging/domain/interceptors/dio_interceptor.dart';
import 'package:voo_logging/features/logging/domain/interceptors/network_interceptor.dart';

// Generate mocks - only mock our own classes, not Dio's
@GenerateMocks([NetworkInterceptor])
import 'dio_interceptor_test.mocks.dart';

// Mock handlers for Dio
class MockRequestHandler extends Mock implements RequestInterceptorHandler {
  @override
  void next(RequestOptions requestOptions) {
    super.noSuchMethod(Invocation.method(#next, [requestOptions]));
  }
}

class MockResponseHandler extends Mock implements ResponseInterceptorHandler {
  @override
  void next(Response response) {
    super.noSuchMethod(Invocation.method(#next, [response]));
  }
}

class MockErrorHandler extends Mock implements ErrorInterceptorHandler {
  @override
  void next(DioException err) {
    super.noSuchMethod(Invocation.method(#next, [err]));
  }
}

void main() {
  group('VooDioInterceptor', () {
    late VooDioInterceptor interceptor;
    late MockNetworkInterceptor mockNetworkInterceptor;
    late MockRequestHandler mockRequestHandler;
    late MockResponseHandler mockResponseHandler;
    late MockErrorHandler mockErrorHandler;

    setUp(() {
      mockNetworkInterceptor = MockNetworkInterceptor();
      mockRequestHandler = MockRequestHandler();
      mockResponseHandler = MockResponseHandler();
      mockErrorHandler = MockErrorHandler();

      interceptor = VooDioInterceptor(interceptor: mockNetworkInterceptor);

      // Setup default behavior for handlers
      when(
        mockNetworkInterceptor.onRequest(
          method: anyNamed('method'),
          url: anyNamed('url'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
          metadata: anyNamed('metadata'),
        ),
      ).thenAnswer((_) async {});

      when(
        mockNetworkInterceptor.onResponse(
          statusCode: anyNamed('statusCode'),
          url: anyNamed('url'),
          duration: anyNamed('duration'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
          contentLength: anyNamed('contentLength'),
          metadata: anyNamed('metadata'),
        ),
      ).thenAnswer((_) async {});

      when(
        mockNetworkInterceptor.onError(url: anyNamed('url'), error: anyNamed('error'), stackTrace: anyNamed('stackTrace'), metadata: anyNamed('metadata')),
      ).thenAnswer((_) async {});
    });

    group('onRequest', () {
      test('should capture GET request details', () {
        // Arrange
        final options = RequestOptions(
          path: '/api/users',
          method: 'GET',
          baseUrl: 'https://api.example.com',
          headers: {'Authorization': 'Bearer token123'},
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        );

        // Act
        interceptor.onRequest(options, mockRequestHandler);

        // Assert
        verify(
          mockNetworkInterceptor.onRequest(
            method: 'GET',
            url: 'https://api.example.com/api/users',
            headers: {'Authorization': 'Bearer token123'},
            body: null,
            metadata: argThat(
              allOf(
                containsPair('baseUrl', 'https://api.example.com'),
                containsPair('connectTimeout', 30000),
                containsPair('receiveTimeout', 30000),
                containsPair('requestHeaders', {'Authorization': 'Bearer token123'}),
              ),
              named: 'metadata',
            ),
          ),
        ).called(1);

        verify(mockRequestHandler.next(options)).called(1);
      });

      test('should capture POST request with body', () {
        // Arrange
        final requestBody = {'name': 'John Doe', 'email': 'john@example.com'};
        final options = RequestOptions(
          path: '/api/users',
          method: 'POST',
          baseUrl: 'https://api.example.com',
          data: requestBody,
          headers: {'Content-Type': 'application/json'},
        );

        // Act
        interceptor.onRequest(options, mockRequestHandler);

        // Assert
        verify(
          mockNetworkInterceptor.onRequest(
            method: 'POST',
            url: 'https://api.example.com/api/users',
            headers: {'Content-Type': 'application/json'},
            body: requestBody,
            metadata: argThat(contains('requestHeaders'), named: 'metadata'),
          ),
        ).called(1);

        verify(mockRequestHandler.next(options)).called(1);
      });

      test('should store start time for duration calculation', () {
        // Arrange
        final options = RequestOptions(path: '/api/test', extra: {});

        // Act
        interceptor.onRequest(options, mockRequestHandler);

        // Assert
        expect(options.extra['voo_start_time'], isA<DateTime>());
        verify(mockRequestHandler.next(options)).called(1);
      });

      test('should handle errors gracefully and continue request', () {
        // Arrange
        final options = RequestOptions(path: '/api/test');

        // Make the network interceptor throw an error
        when(
          mockNetworkInterceptor.onRequest(
            method: anyNamed('method'),
            url: anyNamed('url'),
            headers: anyNamed('headers'),
            body: anyNamed('body'),
            metadata: anyNamed('metadata'),
          ),
        ).thenThrow(Exception('Logging failed'));

        // Act
        interceptor.onRequest(options, mockRequestHandler);

        // Assert - Should still call next despite error
        verify(mockRequestHandler.next(options)).called(1);
      });
    });

    group('onResponse', () {
      test('should capture successful response details', () {
        // Arrange
        final startTime = DateTime.now().subtract(const Duration(milliseconds: 500));
        final requestOptions = RequestOptions(path: '/api/users/1', baseUrl: 'https://api.example.com', extra: {'voo_start_time': startTime});

        final responseData = {'id': 1, 'name': 'John Doe'};
        final headers = Headers.fromMap({
          'content-type': ['application/json'],
          'content-length': ['42'],
        });

        final response = Response(requestOptions: requestOptions, statusCode: 200, data: responseData, headers: headers, statusMessage: 'OK');

        // Act
        interceptor.onResponse(response, mockResponseHandler);

        // Assert
        verify(
          mockNetworkInterceptor.onResponse(
            statusCode: 200,
            url: 'https://api.example.com/api/users/1',
            duration: argThat(predicate<Duration>((d) => d.inMilliseconds >= 0), named: 'duration'),
            headers: argThat(containsPair('content-type', 'application/json'), named: 'headers'),
            body: responseData,
            contentLength: 42,
            metadata: argThat(allOf(containsPair('statusMessage', 'OK'), contains('responseHeaders')), named: 'metadata'),
          ),
        ).called(1);

        verify(mockResponseHandler.next(response)).called(1);
      });

      test('should handle response without start time', () {
        // Arrange
        final requestOptions = RequestOptions(
          path: '/api/test',
          baseUrl: 'https://api.example.com',
          // No start time in extra
        );

        final response = Response(requestOptions: requestOptions, statusCode: 200);

        // Act
        interceptor.onResponse(response, mockResponseHandler);

        // Assert
        verify(
          mockNetworkInterceptor.onResponse(
            statusCode: 200,
            url: 'https://api.example.com/api/test',
            duration: Duration.zero,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
            contentLength: anyNamed('contentLength'),
            metadata: anyNamed('metadata'),
          ),
        ).called(1);

        verify(mockResponseHandler.next(response)).called(1);
      });

      test('should handle response errors gracefully', () {
        // Arrange
        final response = Response(requestOptions: RequestOptions(path: '/api/test'), statusCode: 200);

        when(
          mockNetworkInterceptor.onResponse(
            statusCode: anyNamed('statusCode'),
            url: anyNamed('url'),
            duration: anyNamed('duration'),
            headers: anyNamed('headers'),
            body: anyNamed('body'),
            contentLength: anyNamed('contentLength'),
            metadata: anyNamed('metadata'),
          ),
        ).thenThrow(Exception('Logging failed'));

        // Act
        interceptor.onResponse(response, mockResponseHandler);

        // Assert - Should still call next despite error
        verify(mockResponseHandler.next(response)).called(1);
      });
    });

    group('onError', () {
      test('should capture error response with status code', () {
        // Arrange
        final startTime = DateTime.now().subtract(const Duration(milliseconds: 300));
        final requestOptions = RequestOptions(path: '/api/users/999', baseUrl: 'https://api.example.com', extra: {'voo_start_time': startTime});

        final errorResponse = Response(
          requestOptions: requestOptions,
          statusCode: 404,
          data: {'error': 'User not found'},
          headers: Headers.fromMap({
            'content-type': ['application/json'],
          }),
        );

        final error = DioException(
          requestOptions: requestOptions,
          response: errorResponse,
          type: DioExceptionType.badResponse,
          message: 'Http status error [404]',
        );

        // Act
        interceptor.onError(error, mockErrorHandler);

        // Assert
        verify(
          mockNetworkInterceptor.onResponse(
            statusCode: 404,
            url: 'https://api.example.com/api/users/999',
            duration: argThat(predicate<Duration>((d) => d.inMilliseconds >= 0), named: 'duration'),
            headers: argThat(containsPair('content-type', 'application/json'), named: 'headers'),
            body: {'error': 'User not found'},
            metadata: argThat(
              allOf(containsPair('error', 'Http status error [404]'), containsPair('type', 'DioExceptionType.badResponse'), contains('responseHeaders')),
              named: 'metadata',
            ),
          ),
        ).called(1);

        verify(mockErrorHandler.next(error)).called(1);
      });

      test('should capture network error without response', () {
        // Arrange
        final requestOptions = RequestOptions(path: '/api/test', baseUrl: 'https://api.example.com');

        final error = DioException(
          requestOptions: requestOptions,
          type: DioExceptionType.connectionTimeout,
          message: 'Connection timeout',
          error: SocketException('Connection failed'),
        );

        // Act
        interceptor.onError(error, mockErrorHandler);

        // Assert
        verify(
          mockNetworkInterceptor.onError(
            url: 'https://api.example.com/api/test',
            error: argThat(isA<Object>(), named: 'error'),
            stackTrace: anyNamed('stackTrace'),
            metadata: argThat(
              allOf(containsPair('message', 'Connection timeout'), containsPair('type', 'DioExceptionType.connectionTimeout')),
              named: 'metadata',
            ),
          ),
        ).called(1);

        verify(mockErrorHandler.next(error)).called(1);
      });

      test('should handle error logging failures gracefully', () {
        // Arrange
        final error = DioException(
          requestOptions: RequestOptions(path: '/api/test'),
          type: DioExceptionType.unknown,
        );

        when(
          mockNetworkInterceptor.onError(url: anyNamed('url'), error: anyNamed('error'), stackTrace: anyNamed('stackTrace'), metadata: anyNamed('metadata')),
        ).thenThrow(Exception('Logging failed'));

        // Act
        interceptor.onError(error, mockErrorHandler);

        // Assert - Should still call next despite error
        verify(mockErrorHandler.next(error)).called(1);
      });
    });

    group('Integration with Dio', () {
      test('interceptor can be added to Dio instance', () {
        // Arrange
        final dio = Dio();
        final vooInterceptor = VooDioInterceptor();
        final initialCount = dio.interceptors.length;

        // Act & Assert - Should not throw
        expect(() {
          dio.interceptors.add(
            InterceptorsWrapper(onRequest: vooInterceptor.onRequest, onResponse: vooInterceptor.onResponse, onError: vooInterceptor.onError),
          );
        }, returnsNormally);

        // Verify interceptor was added
        expect(dio.interceptors.length, initialCount + 1);
      });

      test('interceptor methods have correct signatures for Dio', () {
        // This test verifies that our methods match Dio's expected signatures
        final vooInterceptor = VooDioInterceptor();

        // These should be assignable to Dio's handler types
        void Function(RequestOptions, RequestInterceptorHandler) onRequest = vooInterceptor.onRequest;
        void Function(Response, ResponseInterceptorHandler) onResponse = vooInterceptor.onResponse;
        void Function(DioException, ErrorInterceptorHandler) onError = vooInterceptor.onError;

        // If this compiles, the signatures are correct
        expect(onRequest, isNotNull);
        expect(onResponse, isNotNull);
        expect(onError, isNotNull);
      });
    });
  });
}

// Additional test for SocketException if not imported
class SocketException implements Exception {
  final String message;
  SocketException(this.message);

  @override
  String toString() => 'SocketException: $message';
}
