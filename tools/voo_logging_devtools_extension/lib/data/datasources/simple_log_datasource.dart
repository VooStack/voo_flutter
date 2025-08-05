import 'dart:async';
import 'dart:developer' as developer;

import 'package:voo_logging/core/domain/enums/log_level.dart';
import 'package:voo_logging/features/logging/data/models/log_entry_model.dart';

/// A simpler datasource that uses a timer to poll for logs
/// This is a temporary workaround for VM Service connection issues
class SimpleLogDataSource {
  final _logController = StreamController<LogEntryModel>.broadcast();
  final _cachedLogs = <LogEntryModel>[];
  final int maxCacheSize;
  Timer? _pollTimer;
  int _logCounter = 0;

  SimpleLogDataSource({this.maxCacheSize = 10000}) {
    // Add an initial log
    _addLog(
      LogEntryModel(
        'init_${DateTime.now().millisecondsSinceEpoch}',
        DateTime.now(),
        'DevTools extension started (Simple mode)',
        LogLevel.info,
        'System',
        'DevTools',
        {'mode': 'simple'},
        null,
        null,
        null,
        null,
      ),
    );

    // Start polling for demonstration
    _startPolling();
  }

  void _startPolling() {
    // Generate test logs every 2 seconds
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _logCounter++;

      // Add a test log
      _addLog(
        LogEntryModel(
          'poll_${DateTime.now().millisecondsSinceEpoch}',
          DateTime.now(),
          'Test log #$_logCounter from polling',
          _getRandomLogLevel(),
          'Test',
          'Polling',
          {'counter': _logCounter},
          null,
          null,
          null,
          null,
        ),
      );

      developer.log('Generated test log #$_logCounter', name: 'SimpleLogDataSource');
    });
  }

  LogLevel _getRandomLogLevel() {
    const levels = LogLevel.values;
    return levels[_logCounter % levels.length];
  }

  void _addLog(LogEntryModel log) {
    _cachedLogs.add(log);

    developer.log('Adding log to cache: ${log.message} (Total: ${_cachedLogs.length})', name: 'SimpleLogDataSource');

    // Maintain cache size
    if (_cachedLogs.length > maxCacheSize) {
      _cachedLogs.removeAt(0);
    }

    _logController.add(log);
  }

  Stream<LogEntryModel> get logStream => _logController.stream;

  List<LogEntryModel> getCachedLogs() => List.unmodifiable(_cachedLogs);

  void clearCache() {
    _cachedLogs.clear();
  }

  void dispose() {
    _pollTimer?.cancel();
    _logController.close();
  }
}
