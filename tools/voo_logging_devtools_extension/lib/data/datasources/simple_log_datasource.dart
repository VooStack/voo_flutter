import 'dart:async';

import 'package:voo_logging/core/domain/enums/log_level.dart';
import 'package:voo_logging/features/logging/data/models/log_entry_model.dart';

/// A simpler datasource that uses a timer to poll for logs
/// This is a temporary workaround for VM Service connection issues
class SimpleLogDataSource {
  final _logController = StreamController<LogEntryModel>.broadcast();
  final _cachedLogs = <LogEntryModel>[];
  final int maxCacheSize;

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
  }

  void _addLog(LogEntryModel log) {
    _cachedLogs.add(log);

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
    _logController.close();
  }
}
