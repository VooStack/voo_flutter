import 'package:flutter_test/flutter_test.dart';
import 'package:voo_logging/core/domain/enums/log_level.dart';
import 'package:voo_logging/features/logging/data/models/log_entry_model.dart';

void main() {
  group('LogEntryModel', () {
    test('should create a log entry with all properties', () {
      final now = DateTime.now();
      final logEntry = LogEntryModel(
        'test-id',
        now,
        'Test message',
        LogLevel.info,
        'TestCategory',
        'TestTag',
        {'key': 'value'},
        'Test error',
        'Stack trace here',
        'user123',
        'session456',
      );

      expect(logEntry.id, 'test-id');
      expect(logEntry.timestamp, now);
      expect(logEntry.message, 'Test message');
      expect(logEntry.level, LogLevel.info);
      expect(logEntry.category, 'TestCategory');
      expect(logEntry.tag, 'TestTag');
      expect(logEntry.metadata, {'key': 'value'});
      expect(logEntry.error, 'Test error');
      expect(logEntry.stackTrace, 'Stack trace here');
      expect(logEntry.userId, 'user123');
      expect(logEntry.sessionId, 'session456');
    });
  });

  group('Log Filtering', () {
    final testLogs = [
      LogEntryModel('1', DateTime.now(), 'Info log', LogLevel.info, 'Category1', null, null, null, null, null, null),
      LogEntryModel('2', DateTime.now(), 'Error log', LogLevel.error, 'Category2', null, null, null, null, null, null),
      LogEntryModel('3', DateTime.now(), 'Debug log', LogLevel.debug, 'Category1', null, null, null, null, null, null),
      LogEntryModel('4', DateTime.now(), 'Warning log', LogLevel.warning, 'Category2', null, null, null, null, null, null),
    ];

    test('should filter by log level', () {
      final filtered = testLogs.where((log) => log.level == LogLevel.error).toList();

      expect(filtered.length, 1);
      expect(filtered.first.message, 'Error log');
    });

    test('should filter by multiple log levels', () {
      final levels = [LogLevel.info, LogLevel.warning];
      final filtered = testLogs.where((log) => levels.contains(log.level)).toList();

      expect(filtered.length, 2);
      expect(filtered.map((log) => log.message), containsAll(['Info log', 'Warning log']));
    });

    test('should filter by category', () {
      final filtered = testLogs.where((log) => log.category == 'Category1').toList();

      expect(filtered.length, 2);
      expect(filtered.every((log) => log.category == 'Category1'), true);
    });

    test('should filter by search query', () {
      const query = 'error';
      final filtered = testLogs.where((log) => log.message.toLowerCase().contains(query.toLowerCase())).toList();

      expect(filtered.length, 1);
      expect(filtered.first.message, 'Error log');
    });
  });
}
