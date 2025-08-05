// ignore_for_file: avoid_print

import 'dart:developer' as developer;

void main() {
  print('Direct logging test starting...');

  // Test 1: Basic developer.log
  developer.log('Test 1: Basic log', name: 'DirectTest');

  // Test 2: Log with VooLogger name
  developer.log('Test 2: VooLogger named log', name: 'VooLogger');

  // Test 3: Log with different levels
  developer.log('Test 3: Info level', name: 'VooLogger', level: 800);
  developer.log('Test 4: Warning level', name: 'VooLogger', level: 900);
  developer.log('Test 5: Error level', name: 'VooLogger', level: 1000);

  // Test 4: JSON structured log
  developer.log(
    '{"__voo_logger__": true, "entry": {"id": "test123", "timestamp": "${DateTime.now().toIso8601String()}", "message": "Test 6: Structured JSON log", "level": "info", "category": "TestCategory", "tag": "TestTag"}}',
    name: 'VooLogger',
    level: 800,
  );

  // Test 5: Log with error
  try {
    throw Exception('Test exception');
  } catch (e, stack) {
    developer.log('Test 7: Log with error', name: 'VooLogger', error: e, stackTrace: stack, level: 1000);
  }

  print('All logs sent. Check the Logging tab in DevTools to see:');
  print('- All logs should appear in the Logging tab');
  print('- Logs with name "VooLogger" should be picked up by the extension');
  print('');
  print('To test:');
  print('1. Run this script: dart run example/direct_logging_test.dart');
  print('2. Open DevTools');
  print('3. Check the Logging tab (not Voo Logger tab) to see the logs');
  print('4. Then check the Voo Logger tab to see if they appear there');
}
