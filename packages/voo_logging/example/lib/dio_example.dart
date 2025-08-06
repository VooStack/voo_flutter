import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:voo_logging/voo_logging.dart';

/// Example demonstrating VooDioInterceptor integration
class DioExampleScreen extends StatefulWidget {
  const DioExampleScreen({super.key});

  @override
  State<DioExampleScreen> createState() => _DioExampleScreenState();
}

class _DioExampleScreenState extends State<DioExampleScreen> {
  late final Dio _dio;
  String _responseText = 'No requests made yet';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _setupDio();
  }

  void _setupDio() {
    _dio = Dio();
    
    // Create the VooDioInterceptor
    final vooInterceptor = VooDioInterceptor();
    
    // Add the interceptor to Dio
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: vooInterceptor.onRequest,
      onResponse: vooInterceptor.onResponse,
      onError: vooInterceptor.onError,
    ));
    
    // Optionally add a logging interceptor to see what's happening
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  Future<void> _makeSuccessfulRequest() async {
    setState(() {
      _isLoading = true;
      _responseText = 'Making request...';
    });

    try {
      // Example API that returns user data
      final response = await _dio.get('https://jsonplaceholder.typicode.com/users/1');
      
      setState(() {
        _responseText = 'Success! User: ${response.data['name']}\n'
            'Email: ${response.data['email']}\n'
            'Check VooLogger logs to see the network request details.';
      });
      
      // Log success
      VooLogger.info('Successfully fetched user data');
    } catch (e) {
      setState(() {
        _responseText = 'Error: $e';
      });
      VooLogger.error('Failed to fetch user data', error: e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _makeFailedRequest() async {
    setState(() {
      _isLoading = true;
      _responseText = 'Making request to invalid endpoint...';
    });

    try {
      // This will return a 404
      final response = await _dio.get('https://jsonplaceholder.typicode.com/invalid-endpoint');
      
      setState(() {
        _responseText = 'Unexpected success: ${response.data}';
      });
    } on DioException catch (e) {
      setState(() {
        _responseText = 'Expected error occurred!\n'
            'Status: ${e.response?.statusCode ?? "No response"}\n'
            'Message: ${e.message}\n'
            'Check VooLogger logs to see the error details.';
      });
      VooLogger.error('Expected 404 error caught', error: e);
    } catch (e) {
      setState(() {
        _responseText = 'Unexpected error: $e';
      });
      VooLogger.error('Unexpected error', error: e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _makePostRequest() async {
    setState(() {
      _isLoading = true;
      _responseText = 'Making POST request...';
    });

    try {
      final response = await _dio.post(
        'https://jsonplaceholder.typicode.com/posts',
        data: {
          'title': 'Test Post from VooLogging',
          'body': 'This is a test post to demonstrate VooDioInterceptor',
          'userId': 1,
        },
      );
      
      setState(() {
        _responseText = 'POST Success!\n'
            'Created post with ID: ${response.data['id']}\n'
            'Title: ${response.data['title']}\n'
            'Check VooLogger logs to see the request body and response.';
      });
      
      VooLogger.info('Successfully created post', metadata: {
        'postId': response.data['id'],
      });
    } catch (e) {
      setState(() {
        _responseText = 'Error: $e';
      });
      VooLogger.error('Failed to create post', error: e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _makeMultipleRequests() async {
    setState(() {
      _isLoading = true;
      _responseText = 'Making multiple concurrent requests...';
    });

    try {
      // Make multiple requests concurrently
      final results = await Future.wait([
        _dio.get('https://jsonplaceholder.typicode.com/users/1'),
        _dio.get('https://jsonplaceholder.typicode.com/posts/1'),
        _dio.get('https://jsonplaceholder.typicode.com/comments/1'),
      ]);
      
      setState(() {
        _responseText = 'All requests completed!\n'
            'User: ${results[0].data['name']}\n'
            'Post title: ${results[1].data['title']}\n'
            'Comment: ${results[2].data['name']}\n'
            'Check VooLogger logs to see all network requests.';
      });
      
      VooLogger.info('Successfully completed multiple requests');
    } catch (e) {
      setState(() {
        _responseText = 'Error in one or more requests: $e';
      });
      VooLogger.error('Failed to complete all requests', error: e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _makeTimeoutRequest() async {
    setState(() {
      _isLoading = true;
      _responseText = 'Making request with timeout...';
    });

    try {
      // Create a Dio instance with short timeout
      final timeoutDio = Dio(BaseOptions(
        connectTimeout: const Duration(milliseconds: 100),
        receiveTimeout: const Duration(milliseconds: 100),
      ));
      
      // Add VooDioInterceptor
      final vooInterceptor = VooDioInterceptor();
      timeoutDio.interceptors.add(InterceptorsWrapper(
        onRequest: vooInterceptor.onRequest,
        onResponse: vooInterceptor.onResponse,
        onError: vooInterceptor.onError,
      ));
      
      // This will likely timeout
      final response = await timeoutDio.get('https://httpbin.org/delay/5');
      
      setState(() {
        _responseText = 'Request completed without timeout: ${response.data}';
      });
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        setState(() {
          _responseText = 'Request timed out as expected!\n'
              'Type: ${e.type}\n'
              'Check VooLogger logs to see the timeout error.';
        });
        VooLogger.warning('Request timed out', metadata: {
          'type': e.type.toString(),
          'message': e.message,
        });
      } else {
        setState(() {
          _responseText = 'Different error: ${e.type} - ${e.message}';
        });
        VooLogger.error('Request failed', error: e);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dio Interceptor Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'VooDioInterceptor Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'All network requests below are automatically logged by VooLogger.\n'
              'Open DevTools to see the network logs in real-time.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            
            // Response display
            Container(
              height: 150,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: SingleChildScrollView(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Text(_responseText),
              ),
            ),
            const SizedBox(height: 16),
            
            // Action buttons
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 2.5,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _makeSuccessfulRequest,
                    icon: const Icon(Icons.check_circle),
                    label: const Text('GET Success'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _makeFailedRequest,
                    icon: const Icon(Icons.error),
                    label: const Text('GET 404'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _makePostRequest,
                    icon: const Icon(Icons.send),
                    label: const Text('POST Data'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _makeMultipleRequests,
                    icon: const Icon(Icons.layers),
                    label: const Text('Multiple'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _makeTimeoutRequest,
                    icon: const Icon(Icons.timer_off),
                    label: const Text('Timeout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // View logs
                      VooLogger.info('User requested to view logs');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Open Flutter DevTools to see VooLogger logs'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.list),
                    label: const Text('View Logs'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dio.close();
    super.dispose();
  }
}

// Standalone example function for documentation
void setupDioWithVooLogging() {
  // Create Dio instance
  final dio = Dio();
  
  // Create VooDioInterceptor
  final vooInterceptor = VooDioInterceptor();
  
  // Add interceptor to Dio
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: vooInterceptor.onRequest,
    onResponse: vooInterceptor.onResponse,
    onError: vooInterceptor.onError,
  ));
  
  // Now all requests made with this Dio instance will be logged
  // Example usage:
  dio.get('https://api.example.com/data').then((response) {
    print('Data received: ${response.data}');
  }).catchError((error) {
    print('Error occurred: $error');
  });
}