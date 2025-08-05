// ignore_for_file: avoid_print

import 'dart:developer' as developer;
import 'package:voo_logging/voo_logging.dart';

void main() async {
  print('Starting DevTools debug test...');

  // Initialize VooLogger
  await VooLogger.initialize(appName: 'DevTools Debug', appVersion: '1.0.0');

  print('VooLogger initialized');

  // Test regular developer.log
  developer.log('Test 1: Regular developer.log', name: 'Test');

  // Test VooLogger logs
  developer.log('Test 2: Direct VooLogger log', name: 'VooLogger');
  developer.log('Test 3: Direct AwesomeLogger log', name: 'AwesomeLogger');

  // Test VooLogger methods
  print('Sending VooLogger logs...');
  await VooLogger.info('Test 4: VooLogger.info message', category: 'Test');
  await VooLogger.error('Test 5: VooLogger.error message', category: 'Test');
  await VooLogger.debug('Test 6: VooLogger.debug message', category: 'Test');

  // Test structured log
  developer.log(
    '{"__voo_logger__": true, "entry": {"id": "test7", "timestamp": "${DateTime.now().toIso8601String()}", "message": "Test 7: Structured log", "level": "info", "category": "Test"}}',
    name: 'VooLogger',
  );

  print('All logs sent. Check DevTools now.');
  print('The DevTools extension should show:');
  print('- Initial log from extension');
  print('- Logs from VooLogger methods');
  print('- Structured log');

  // Keep the program running
  await Future<void>.delayed(const Duration(seconds: 60));
}
