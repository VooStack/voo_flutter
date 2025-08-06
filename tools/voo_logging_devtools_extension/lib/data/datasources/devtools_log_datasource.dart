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
    _addLog(
      LogEntryModel(
        'devtools_init_immediate',
        DateTime.now(),
        'DevTools extension initializing...',
        LogLevel.info,
        'System',
        'DevTools',
        {'status': 'initializing'},
        null,
        null,
        null,
        null,
      ),
    );

    _initializeConnection();
  }

  Future<void> _initializeConnection() async {
    await _tryConnect();

    serviceManager.connectedState.addListener(() {
      if (serviceManager.connectedState.value.connected) {
        _tryConnect();
      }
    });
  }

  Future<void> _tryConnect() async {
    try {
      developer.log('Attempting to connect to VM Service...', name: 'VooLoggerDevTools');

      final service = serviceManager.service;
      if (service == null) {
        developer.log('Service not yet available, will retry when connected', name: 'VooLoggerDevTools');
        return;
      }

      if (_loggingSubscription != null) {
        developer.log('Already connected to logging stream', name: 'VooLoggerDevTools');
        return;
      }

      developer.log('VM Service available, setting up streams...', name: 'VooLoggerDevTools');

      try {
        await service.streamListen(vm.EventStreams.kLogging);
        developer.log('Logging stream enabled', name: 'VooLoggerDevTools');
      } catch (e) {
        developer.log('Error enabling logging stream: $e', name: 'VooLoggerDevTools');
      }

      try {
        await service.streamListen(vm.EventStreams.kExtension);
        developer.log('Extension stream enabled', name: 'VooLoggerDevTools');

        service.onExtensionEvent.listen((vm.Event event) {
          developer.log('Extension event received: ${event.extensionKind}', name: 'VooLoggerDevTools');

          if (event.extensionKind == 'voo_logger_event' && event.extensionData != null) {
            final data = event.extensionData!.data;
            if (data['__voo_logger__'] == true) {
              developer.log('Handling VooLogger extension event', name: 'VooLoggerDevTools');
              _handleStructuredLog(data);
            }
          }
        });
      } catch (e) {
        developer.log('Error enabling extension stream: $e', name: 'VooLoggerDevTools');
      }

      _loggingSubscription = service.onLoggingEvent.listen((vm.Event event) {
        if (event.logRecord != null) {
          final record = event.logRecord!;
          final loggerName = record.loggerName?.valueAsString ?? '';
          final message = record.message?.valueAsString ?? '';

          developer.log('Received log event - Logger: "$loggerName", Message: "${message.length > 100 ? "${message.substring(0, 100)}..." : message}"', name: 'VooLoggerDevTools');

          if (message.startsWith('{') && message.endsWith('}')) {
            try {
              final data = jsonDecode(message) as Map<String, dynamic>;
              if (data['__voo_logger__'] == true) {
                developer.log('Found VooLogger structured log!', name: 'VooLoggerDevTools');
                _handleStructuredLog(data);
                return;
              }
            } catch (e) {
              developer.log('Failed to parse JSON: $e', name: 'VooLoggerDevTools');
            }
          }

          if (!loggerName.contains('VooLogger') && !message.contains('__voo_logger__')) {
            return;
          }

          final time = record.time;
          final level = record.level;

          final logEntry = LogEntryModel(
            DateTime.now().millisecondsSinceEpoch.toString(),
            DateTime.fromMillisecondsSinceEpoch(time ?? DateTime.now().millisecondsSinceEpoch),
            message,
            _mapLogLevel(level ?? 800),
            loggerName,
            null,
            null,
            record.error?.valueAsString,
            record.stackTrace?.valueAsString,
            null,
            null,
          );

          _addLog(logEntry);
          developer.log('Log captured (fallback): $message', name: 'VooLoggerDevTools');
        }
      });

      developer.log('Extension event listener setup complete', name: 'VooLoggerDevTools');

      _addLog(
        LogEntryModel(
          'devtools_init',
          DateTime.now(),
          'DevTools extension connected successfully',
          LogLevel.info,
          'System',
          'DevTools',
          {'initialized': true},
          null,
          null,
          null,
          null,
        ),
      );
    } catch (e, stack) {
      developer.log('Error in _tryConnect: $e\n$stack', name: 'VooLoggerDevTools', level: 1000);

      _addLog(
        LogEntryModel(
          'error_${DateTime.now().millisecondsSinceEpoch}',
          DateTime.now(),
          'Error connecting to VM Service: $e',
          LogLevel.error,
          'System',
          'DevTools',
          {'error': e.toString()},
          null,
          null,
          null,
          null,
        ),
      );
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
