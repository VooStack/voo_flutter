import 'dart:async';
import 'dart:convert';

import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:vm_service/vm_service.dart' as vm;
import 'package:voo_logging_devtools_extension/core/models/log_level.dart';
import 'package:voo_logging_devtools_extension/core/models/log_entry_model.dart';
import 'package:voo_logging_devtools_extension/domain/datasources/devtools_log_datasource.dart';

/// Implementation of DevTools log data source that connects to VM Service
class DevToolsLogDataSourceImpl implements DevToolsLogDataSource {
  final _logController = StreamController<LogEntryModel>.broadcast();
  final _cachedLogs = <LogEntryModel>[];
  final int maxCacheSize;

  StreamSubscription<vm.Event>? _loggingSubscription;
  StreamSubscription<vm.Event>? _extensionSubscription;

  DevToolsLogDataSourceImpl({this.maxCacheSize = 10000}) {
    // Delay initialization to ensure serviceManager is available
    Future.delayed(Duration.zero, () {
      _initializeConnection();
    });
  }

  Future<void> _initializeConnection() async {
    try {
      // Wait a bit to ensure DevToolsExtension is initialized
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Try immediate connection
      await _connect();

      // Listen for future connections
      serviceManager.connectedState.addListener(() {
        if (serviceManager.connectedState.value.connected) {
          _connect();
        }
      });
    } catch (e) {
      // If serviceManager isn't ready yet, try again later
      Future.delayed(const Duration(seconds: 1), () {
        _initializeConnection();
      });
    }
  }

  Future<void> _connect() async {
    try {
      final service = serviceManager.service;
      if (service == null || _loggingSubscription != null) return;

      // Enable logging stream (catch error if already subscribed)
      try {
        await service.streamListen(vm.EventStreams.kLogging);
      } catch (e) {
        // Stream might already be subscribed, that's ok
      }

      // Enable extension stream for postEvent (catch error if already subscribed)
      try {
        await service.streamListen(vm.EventStreams.kExtension);
      } catch (e) {
        // Stream might already be subscribed, that's ok
      }

      // Listen to logging events
      _loggingSubscription = service.onLoggingEvent.listen(_handleLoggingEvent);

      // Listen to extension events
      _extensionSubscription = service.onExtensionEvent.listen(_handleExtensionEvent);

      // Add connection success log
      _addLog(
        LogEntryModel(
          id: 'connected_${DateTime.now().millisecondsSinceEpoch}',
          timestamp: DateTime.now(),
          message: 'DevTools extension connected',
          level: LogLevel.info,
          category: 'System',
          tag: 'DevTools',
          metadata: {'connected': true},
        ),
      );
    } catch (e) {
      _addLog(
        LogEntryModel(
          id: 'error_${DateTime.now().millisecondsSinceEpoch}',
          timestamp: DateTime.now(),
          message: 'Connection error: $e',
          level: LogLevel.error,
          category: 'System',
          tag: 'DevTools',
          metadata: {'error': e.toString()},
        ),
      );
    }
  }

  void _handleLoggingEvent(vm.Event event) {
    if (event.logRecord == null) return;

    final record = event.logRecord!;
    final message = record.message?.valueAsString ?? '';

    // Check for VooLogger structured logs
    if (message.startsWith('{') && message.contains('__voo_logger__')) {
      try {
        final data = jsonDecode(message) as Map<String, dynamic>;
        if (data['__voo_logger__'] == true) {
          _handleStructuredLog(data);
        }
      } catch (_) {
        // Not valid JSON, ignore
      }
    }
  }

  void _handleExtensionEvent(vm.Event event) {
    if (event.extensionKind == 'voo_logger_event' && event.extensionData != null) {
      final data = event.extensionData!.data;
      if (data['__voo_logger__'] == true) {
        _handleStructuredLog(data);
      }
    }
  }

  void _handleStructuredLog(Map<String, dynamic> data) {
    try {
      final entry = data['entry'] as Map<String, dynamic>;

      final logEntry = LogEntryModel(
        id: entry['id'] as String,
        timestamp: DateTime.parse(entry['timestamp'] as String),
        message: entry['message'] as String,
        level: _parseLogLevel(entry['level'] as String),
        category: entry['category'] as String?,
        tag: entry['tag'] as String?,
        metadata: entry['metadata'] as Map<String, dynamic>?,
        error: entry['error']?.toString(),
        stackTrace: entry['stackTrace'] as String?,
      );

      _addLog(logEntry);
    } catch (_) {
      // Failed to parse, ignore
    }
  }

  LogLevel _parseLogLevel(String levelName) {
    switch (levelName) {
      case 'verbose':
        return LogLevel.verbose;
      case 'debug':
        return LogLevel.debug;
      case 'info':
        return LogLevel.info;
      case 'warning':
        return LogLevel.warning;
      case 'error':
        return LogLevel.error;
      case 'fatal':
        return LogLevel.fatal;
      default:
        return LogLevel.info;
    }
  }

  void _addLog(LogEntryModel log) {
    _cachedLogs.add(log);

    // Maintain cache size
    if (_cachedLogs.length > maxCacheSize) {
      _cachedLogs.removeAt(0);
    }

    _logController.add(log);
  }

  @override
  Stream<LogEntryModel> get logStream => _logController.stream;

  @override
  List<LogEntryModel> getCachedLogs() => List.unmodifiable(_cachedLogs);

  @override
  void clearCache() => _cachedLogs.clear();

  @override
  void dispose() {
    _loggingSubscription?.cancel();
    _extensionSubscription?.cancel();
    _logController.close();
  }
}
