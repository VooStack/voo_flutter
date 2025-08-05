import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:vm_service/vm_service.dart' as vm;
import 'package:voo_logging/core/domain/enums/log_level.dart';
import 'package:voo_logging/features/logging/data/models/log_entry_model.dart';

abstract class DevToolsLogDataSource {
  Stream<LogEntryModel> get logStream;
  List<LogEntryModel> getCachedLogs();
  void clearCache();
}

class DevToolsLogDataSourceImpl implements DevToolsLogDataSource {
  final _logController = StreamController<LogEntryModel>.broadcast();
  final _cachedLogs = <LogEntryModel>[];
  final int maxCacheSize;

  StreamSubscription<vm.Event>? _loggingSubscription;

  DevToolsLogDataSourceImpl({this.maxCacheSize = 10000}) {
    // Add an initial log immediately
    _addLog(
      LogEntryModel(
        'devtools_init_immediate',
        DateTime.now(),
        'DevTools extension initializing...',
        LogLevel.info,
        'System',
        'DevTools',
        {'status': 'initializing'}, // metadata
        null, // error
        null, // stackTrace
        null, // userId
        null, // sessionId
      ),
    );

    _listenToExtensionEvents();
  }

  Future<void> _listenToExtensionEvents() async {
    try {
      developer.log('DevTools extension starting...', name: 'VooLoggerDevTools');

      // Wait for service manager
      developer.log('Waiting for serviceManager...', name: 'VooLoggerDevTools');

      if (!serviceManager.connectedState.value.connected) {
        developer.log('No service connection, waiting...', name: 'VooLoggerDevTools');
        await serviceManager.onServiceAvailable;
      }

      final service = serviceManager.service;
      if (service == null) {
        developer.log('ERROR: VM Service is null after waiting!', name: 'VooLoggerDevTools', level: 1000);
        _addLog(
          LogEntryModel(
            'error_no_service',
            DateTime.now(),
            'ERROR: Could not connect to VM Service',
            LogLevel.error,
            'System',
            'DevTools',
            {'error': 'no_vm_service'},
            null,
            null,
            null,
            null,
          ),
        );
        return;
      }

      developer.log('VM Service available, setting up logging stream...', name: 'VooLoggerDevTools');

      // Enable the logging stream
      try {
        await service.streamListen(vm.EventStreams.kLogging);
        developer.log('Logging stream enabled', name: 'VooLoggerDevTools');
      } catch (e) {
        developer.log('Error enabling logging stream: $e', name: 'VooLoggerDevTools');
      }

      // Listen to logging events
      _loggingSubscription = service.onLoggingEvent.listen((vm.Event event) {
        if (event.logRecord != null) {
          final record = event.logRecord!;
          final loggerName = record.loggerName?.valueAsString ?? '';

          // Check if this is a VooLogger log
          if (loggerName.contains('VooLogger') || loggerName.contains('voo_logger') || loggerName == 'AwesomeLogger') {
            final message = record.message?.valueAsString ?? '';

            // Try to parse structured log data from the message
            if (message.startsWith('{') && message.endsWith('}')) {
              try {
                final data = jsonDecode(message) as Map<String, dynamic>;
                if (data['__voo_logger__'] == true) {
                  _handleStructuredLog(data);
                  return;
                }
              } catch (_) {
                // Not JSON, treat as regular message
              }
            }

            // Create log entry from regular logging
            final time = record.time;
            final level = record.level;

            final logEntry = LogEntryModel(
              DateTime.now().millisecondsSinceEpoch.toString(),
              DateTime.fromMillisecondsSinceEpoch(time ?? DateTime.now().millisecondsSinceEpoch),
              message,
              _mapLogLevel(level ?? 800),
              loggerName,
              null, // tag
              null, // metadata
              record.error?.valueAsString,
              record.stackTrace?.valueAsString,
              null, // userId
              null, // sessionId
            );

            _addLog(logEntry);
            developer.log('Log captured: $message', name: 'VooLoggerDevTools');
          }
        }
      });

      developer.log('Extension event listener setup complete', name: 'VooLoggerDevTools');

      // Send initial connection log
      _addLog(
        LogEntryModel(
          'devtools_init',
          DateTime.now(),
          'DevTools extension connected successfully',
          LogLevel.info,
          'System',
          'DevTools',
          {'initialized': true}, // metadata
          null, // error
          null, // stackTrace
          null, // userId
          null, // sessionId
        ),
      );
    } catch (e, stack) {
      developer.log('Error in _listenToExtensionEvents: $e\n$stack', name: 'VooLoggerDevTools', level: 1000);
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

    developer.log('Added log to cache: ${log.message} (Total: ${_cachedLogs.length})', name: 'VooLoggerDevTools', level: 800);

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
  void clearCache() {
    _cachedLogs.clear();
  }

  void _handleStructuredLog(Map<String, dynamic> data) {
    try {
      final entry = data['entry'] as Map<String, dynamic>;

      final logEntry = LogEntryModel(
        entry['id'] as String,
        DateTime.parse(entry['timestamp'] as String),
        entry['message'] as String,
        _parseLogLevel(entry['level'] as String),
        entry['category'] as String?,
        entry['tag'] as String?,
        entry['metadata'] as Map<String, dynamic>?,
        entry['error']?.toString(),
        entry['stackTrace'] as String?,
        entry['userId'] as String?,
        entry['sessionId'] as String?,
      );

      _addLog(logEntry);
    } catch (e) {
      developer.log('Error parsing structured log: $e', name: 'VooLoggerDevTools');
    }
  }

  LogLevel _mapLogLevel(int level) {
    // Map dart:developer log levels to LogLevel
    if (level >= 1000) return LogLevel.error;
    if (level >= 900) return LogLevel.warning;
    if (level >= 800) return LogLevel.info;
    if (level >= 700) return LogLevel.debug;
    return LogLevel.verbose;
  }

  void dispose() {
    _loggingSubscription?.cancel();
    _logController.close();
  }
}
