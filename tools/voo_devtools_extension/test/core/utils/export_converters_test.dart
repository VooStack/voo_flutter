import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:voo_devtools_extension/core/models/log_entry_model.dart';
import 'package:voo_devtools_extension/core/models/log_level.dart';
import 'package:voo_devtools_extension/core/models/network_request_model.dart';
import 'package:voo_devtools_extension/core/utils/export_converters.dart';

void main() {
  group('ExportConverters - Logs Export', () {
    final testLogs = [
      LogEntryModel(
        id: 'log1',
        timestamp: DateTime(2024, 1, 15, 10, 30, 0),
        level: LogLevel.info,
        message: 'Test log message',
        category: 'TestCategory',
        tag: 'TestTag',
      ),
      LogEntryModel(
        id: 'log2',
        timestamp: DateTime(2024, 1, 15, 10, 31, 0),
        level: LogLevel.error,
        message: 'Error occurred',
        category: 'ErrorCategory',
        error: 'NullPointerException',
      ),
    ];

    test('logsToJson should export logs to valid JSON', () {
      final json = ExportConverters.logsToJson(testLogs);
      final decoded = jsonDecode(json) as Map<String, dynamic>;

      expect(decoded.containsKey('exportedAt'), true);
      expect(decoded['count'], 2);
      expect(decoded['logs'], isA<List>());
      expect((decoded['logs'] as List).length, 2);
    });

    test('logsToJson should include log details', () {
      final json = ExportConverters.logsToJson(testLogs);
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      final logs = decoded['logs'] as List;

      expect(logs[0]['id'], 'log1');
      expect(logs[0]['level'], 'info');
      expect(logs[0]['message'], 'Test log message');
      expect(logs[0]['category'], 'TestCategory');
      expect(logs[0]['tag'], 'TestTag');
    });

    test('logsToJson with pretty=false should produce compact JSON', () {
      final prettyJson = ExportConverters.logsToJson(testLogs, pretty: true);
      final compactJson = ExportConverters.logsToJson(testLogs, pretty: false);

      // Pretty JSON should be longer due to formatting
      expect(prettyJson.length > compactJson.length, true);
      // Both should parse to the same structure
      expect(jsonDecode(prettyJson)['count'], jsonDecode(compactJson)['count']);
    });

    test('logsToCsv should export logs with header', () {
      final csv = ExportConverters.logsToCsv(testLogs);
      final lines = csv.trim().split('\n');

      expect(lines[0], 'Timestamp,Level,Category,Tag,Message,Error');
      expect(lines.length, 3); // Header + 2 logs
    });

    test('logsToCsv should include log data in rows', () {
      final csv = ExportConverters.logsToCsv(testLogs);
      final lines = csv.trim().split('\n');

      expect(lines[1].contains('info'), true);
      expect(lines[1].contains('Test log message'), true);
      expect(lines[2].contains('error'), true);
      expect(lines[2].contains('NullPointerException'), true);
    });

    test('logsToCsv should escape special characters', () {
      final logsWithSpecialChars = [
        LogEntryModel(
          id: 'log3',
          timestamp: DateTime(2024, 1, 15, 10, 30, 0),
          level: LogLevel.info,
          message: 'Message with, comma',
          category: 'Category with "quotes"',
        ),
      ];

      final csv = ExportConverters.logsToCsv(logsWithSpecialChars);
      // Commas and quotes should be properly escaped
      expect(csv.contains('"Message with, comma"'), true);
      expect(csv.contains('"Category with ""quotes"""'), true);
    });
  });

  group('ExportConverters - Network Export', () {
    final testRequests = [
      NetworkRequestModel(
        id: 'req1',
        url: 'https://api.example.com/users',
        method: 'GET',
        timestamp: DateTime(2024, 1, 15, 10, 30, 0),
        statusCode: 200,
        duration: 150,
        requestSize: 100,
        responseSize: 2048,
      ),
      NetworkRequestModel(
        id: 'req2',
        url: 'https://api.example.com/posts',
        method: 'POST',
        timestamp: DateTime(2024, 1, 15, 10, 31, 0),
        statusCode: 500,
        duration: 300,
        error: 'Internal Server Error',
      ),
    ];

    test('networkToJson should export requests to valid JSON', () {
      final json = ExportConverters.networkToJson(testRequests);
      final decoded = jsonDecode(json) as Map<String, dynamic>;

      expect(decoded.containsKey('exportedAt'), true);
      expect(decoded['count'], 2);
      expect(decoded['requests'], isA<List>());
      expect((decoded['requests'] as List).length, 2);
    });

    test('networkToJson should include request details', () {
      final json = ExportConverters.networkToJson(testRequests);
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      final requests = decoded['requests'] as List;

      expect(requests[0]['id'], 'req1');
      expect(requests[0]['url'], 'https://api.example.com/users');
      expect(requests[0]['method'], 'GET');
      expect(requests[0]['statusCode'], 200);
      expect(requests[0]['duration'], 150);
    });

    test('networkToCsv should export requests with header', () {
      final csv = ExportConverters.networkToCsv(testRequests);
      final lines = csv.trim().split('\n');

      expect(
        lines[0],
        'Timestamp,Method,URL,Status,Duration (ms),Request Size,Response Size,Error',
      );
      expect(lines.length, 3); // Header + 2 requests
    });

    test('networkToCsv should include request data in rows', () {
      final csv = ExportConverters.networkToCsv(testRequests);
      final lines = csv.trim().split('\n');

      expect(lines[1].contains('GET'), true);
      expect(lines[1].contains('200'), true);
      expect(lines[2].contains('POST'), true);
      expect(lines[2].contains('500'), true);
    });
  });

  group('ExportConverters - Analytics Export', () {
    final testEvents = [
      LogEntryModel(
        id: 'event1',
        timestamp: DateTime(2024, 1, 15, 10, 30, 0),
        level: LogLevel.info,
        message: 'Button clicked',
        category: 'user_interaction',
        metadata: {'button_id': 'submit_btn'},
      ),
    ];

    test('analyticsToJson should export events to valid JSON', () {
      final json = ExportConverters.analyticsToJson(testEvents);
      final decoded = jsonDecode(json) as Map<String, dynamic>;

      expect(decoded.containsKey('exportedAt'), true);
      expect(decoded['count'], 1);
      expect(decoded['events'], isA<List>());
    });

    test('analyticsToJson should include metadata fields', () {
      final json = ExportConverters.analyticsToJson(testEvents);
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      final events = decoded['events'] as List;

      expect(events[0]['button_id'], 'submit_btn');
    });

    test('analyticsToCsv should export events with header', () {
      final csv = ExportConverters.analyticsToCsv(testEvents);
      final lines = csv.trim().split('\n');

      expect(lines[0], 'Timestamp,Type,Message');
      expect(lines.length, 2);
    });
  });

  group('ExportConverters - Performance Export', () {
    final testMetrics = [
      LogEntryModel(
        id: 'perf1',
        timestamp: DateTime(2024, 1, 15, 10, 30, 0),
        level: LogLevel.info,
        message: 'API call completed',
        category: 'api_performance',
        metadata: {'duration': 150, 'endpoint': '/users'},
      ),
    ];

    test('performanceToJson should export metrics to valid JSON', () {
      final json = ExportConverters.performanceToJson(testMetrics);
      final decoded = jsonDecode(json) as Map<String, dynamic>;

      expect(decoded.containsKey('exportedAt'), true);
      expect(decoded['count'], 1);
      expect(decoded['metrics'], isA<List>());
    });

    test('performanceToCsv should include duration from metadata', () {
      final csv = ExportConverters.performanceToCsv(testMetrics);
      final lines = csv.trim().split('\n');

      expect(lines[0], 'Timestamp,Operation,Duration (ms),Message');
      expect(lines[1].contains('150'), true);
    });
  });

  group('ExportConverters - CSV Escaping', () {
    test('should escape strings with commas', () {
      final logs = [
        LogEntryModel(
          id: '1',
          timestamp: DateTime.now(),
          level: LogLevel.info,
          message: 'Value one, value two',
        ),
      ];
      final csv = ExportConverters.logsToCsv(logs);
      expect(csv.contains('"Value one, value two"'), true);
    });

    test('should escape strings with newlines', () {
      final logs = [
        LogEntryModel(
          id: '1',
          timestamp: DateTime.now(),
          level: LogLevel.info,
          message: 'Line one\nLine two',
        ),
      ];
      final csv = ExportConverters.logsToCsv(logs);
      expect(csv.contains('"Line one\nLine two"'), true);
    });

    test('should escape double quotes by doubling them', () {
      final logs = [
        LogEntryModel(
          id: '1',
          timestamp: DateTime.now(),
          level: LogLevel.info,
          message: 'Said "hello"',
        ),
      ];
      final csv = ExportConverters.logsToCsv(logs);
      expect(csv.contains('"Said ""hello"""'), true);
    });
  });

  group('ExportFormat enum', () {
    test('should have json and csv values', () {
      expect(ExportFormat.values.length, 2);
      expect(ExportFormat.values.contains(ExportFormat.json), true);
      expect(ExportFormat.values.contains(ExportFormat.csv), true);
    });
  });
}
