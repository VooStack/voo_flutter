import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:voo_logging/voo_logging.dart';
import 'package:voo_performance/voo_performance.dart';

class NetworkPage extends StatefulWidget {
  const NetworkPage({super.key});

  @override
  State<NetworkPage> createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  late Dio _dio;
  final List<Map<String, dynamic>> _requestHistory = [];
  bool _isLoading = false;
  String? _lastResponse;
  String? _lastError;

  @override
  void initState() {
    super.initState();
    _setupDio();
  }

  void _setupDio() {
    _dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 10), receiveTimeout: const Duration(seconds: 10)));

    // Add VooLogging interceptor using InterceptorsWrapper
    final vooInterceptor = VooDioInterceptor();
    // Use VooPerformanceDioInterceptor instead of PerformanceDioInterceptor
    final perfInterceptor = VooPerformanceDioInterceptor();

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) => vooInterceptor.onRequest(options, handler),
        onResponse: (response, handler) => vooInterceptor.onResponse(response, handler),
        onError: (error, handler) => vooInterceptor.onError(error, handler),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) => perfInterceptor.onRequest(options, handler),
        onResponse: (response, handler) => perfInterceptor.onResponse(response, handler),
        onError: (error, handler) => perfInterceptor.onError(error, handler),
      ),
    );

    // Add custom interceptor for UI updates
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          setState(() {
            _requestHistory.insert(0, {'method': options.method, 'url': options.uri.toString(), 'timestamp': DateTime.now(), 'status': 'pending'});
          });
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (_requestHistory.isNotEmpty) {
            setState(() {
              _requestHistory[0]['status'] = 'success';
              _requestHistory[0]['statusCode'] = response.statusCode;
              _requestHistory[0]['responseTime'] = DateTime.now().difference(_requestHistory[0]['timestamp'] as DateTime).inMilliseconds;
            });
          }
          handler.next(response);
        },
        onError: (error, handler) {
          if (_requestHistory.isNotEmpty) {
            setState(() {
              _requestHistory[0]['status'] = 'error';
              _requestHistory[0]['error'] = error.message;
              _requestHistory[0]['responseTime'] = DateTime.now().difference(_requestHistory[0]['timestamp'] as DateTime).inMilliseconds;
            });
          }
          handler.next(error);
        },
      ),
    );

    VooLogger.info('Dio client configured with Voo interceptors').then((_) {});
  }

  Future<void> _makeGetRequest() async {
    setState(() {
      _isLoading = true;
      _lastResponse = null;
      _lastError = null;
    });

    try {
      final response = await _dio.get('https://jsonplaceholder.typicode.com/posts/1');
      setState(() {
        _lastResponse = response.data.toString();
      });
      await VooLogger.info('GET request successful');
    } catch (e) {
      setState(() {
        _lastError = e.toString();
      });
      await VooLogger.error('GET request failed', error: e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _makePostRequest() async {
    setState(() {
      _isLoading = true;
      _lastResponse = null;
      _lastError = null;
    });

    try {
      final response = await _dio.post(
        'https://jsonplaceholder.typicode.com/posts',
        data: {'title': 'VooFlutter Test', 'body': 'Testing Dio interceptors with VooFlutter packages', 'userId': 1},
      );
      setState(() {
        _lastResponse = response.data.toString();
      });
      await VooLogger.info('POST request successful');
    } catch (e) {
      setState(() {
        _lastError = e.toString();
      });
      await VooLogger.error('POST request failed', error: e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _makePutRequest() async {
    setState(() {
      _isLoading = true;
      _lastResponse = null;
      _lastError = null;
    });

    try {
      final response = await _dio.put(
        'https://jsonplaceholder.typicode.com/posts/1',
        data: {'id': 1, 'title': 'Updated VooFlutter Test', 'body': 'Updated content with VooFlutter monitoring', 'userId': 1},
      );
      setState(() {
        _lastResponse = response.data.toString();
      });
      await VooLogger.info('PUT request successful');
    } catch (e) {
      setState(() {
        _lastError = e.toString();
      });
      await VooLogger.error('PUT request failed', error: e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _makeDeleteRequest() async {
    setState(() {
      _isLoading = true;
      _lastResponse = null;
      _lastError = null;
    });

    try {
      await _dio.delete('https://jsonplaceholder.typicode.com/posts/1');
      setState(() {
        _lastResponse = 'Delete successful (204 No Content)';
      });
      await VooLogger.info('DELETE request successful');
    } catch (e) {
      setState(() {
        _lastError = e.toString();
      });
      await VooLogger.error('DELETE request failed', error: e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _makeFailingRequest() async {
    setState(() {
      _isLoading = true;
      _lastResponse = null;
      _lastError = null;
    });

    try {
      await _dio.get('https://jsonplaceholder.typicode.com/posts/invalid');
      setState(() {
        _lastResponse = 'Should not succeed';
      });
    } catch (e) {
      setState(() {
        _lastError = e.toString();
      });
      await VooLogger.error('Intentional failing request', error: e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearHistory() {
    setState(() {
      _requestHistory.clear();
      _lastResponse = null;
      _lastError = null;
    });
    VooLogger.info('Request history cleared').then((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Interceptors Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [IconButton(icon: const Icon(Icons.delete_sweep), onPressed: _clearHistory, tooltip: 'Clear history')],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'All network requests are automatically logged and monitored using VooLogging and VooPerformance interceptors',
                        style: TextStyle(color: Colors.blue.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Request Buttons
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Test Network Requests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _isLoading ? null : _makeGetRequest,
                          icon: const Icon(Icons.download),
                          label: const Text('GET'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                        ),
                        ElevatedButton.icon(
                          onPressed: _isLoading ? null : _makePostRequest,
                          icon: const Icon(Icons.upload),
                          label: const Text('POST'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                        ),
                        ElevatedButton.icon(
                          onPressed: _isLoading ? null : _makePutRequest,
                          icon: const Icon(Icons.edit),
                          label: const Text('PUT'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                        ),
                        ElevatedButton.icon(
                          onPressed: _isLoading ? null : _makeDeleteRequest,
                          icon: const Icon(Icons.delete),
                          label: const Text('DELETE'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                        ),
                        ElevatedButton.icon(
                          onPressed: _isLoading ? null : _makeFailingRequest,
                          icon: const Icon(Icons.error),
                          label: const Text('Fail (404)'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, foregroundColor: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Loading Indicator
            if (_isLoading)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(children: [CircularProgressIndicator(), SizedBox(width: 16), Text('Making request...')]),
                ),
              ),

            // Response/Error Display
            if (_lastResponse != null || _lastError != null) ...[
              Card(
                color: _lastError != null ? Colors.red.shade50 : Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(_lastError != null ? Icons.error : Icons.check_circle, color: _lastError != null ? Colors.red : Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            _lastError != null ? 'Error Response' : 'Success Response',
                            style: TextStyle(fontWeight: FontWeight.bold, color: _lastError != null ? Colors.red : Colors.green),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: SelectableText(_lastError ?? _lastResponse ?? '', style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Request History
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Request History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('${_requestHistory.length} requests', style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_requestHistory.isEmpty)
                      const Center(
                        child: Padding(padding: EdgeInsets.all(32), child: Text('No requests made yet')),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _requestHistory.length,
                        itemBuilder: (context, index) {
                          final request = _requestHistory[index];
                          final status = request['status'] as String;
                          final method = request['method'] as String;
                          final url = request['url'] as String;
                          final responseTime = request['responseTime'] as int?;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(color: _getMethodColor(method).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: Text(
                                    method,
                                    style: TextStyle(color: _getMethodColor(method), fontWeight: FontWeight.bold, fontSize: 10),
                                  ),
                                ),
                              ),
                              title: Text(url.split('/').last, style: const TextStyle(fontSize: 14)),
                              subtitle: Text(
                                status == 'pending' ? 'In progress...' : '${responseTime}ms • ${request['statusCode'] ?? 'Error'}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: _getStatusIcon(status),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMethodColor(String method) {
    switch (method) {
      case 'GET':
        return Colors.green;
      case 'POST':
        return Colors.blue;
      case 'PUT':
        return Colors.orange;
      case 'DELETE':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2));
      case 'success':
        return const Icon(Icons.check_circle, color: Colors.green, size: 20);
      case 'error':
        return const Icon(Icons.error, color: Colors.red, size: 20);
      default:
        return const SizedBox();
    }
  }
}
