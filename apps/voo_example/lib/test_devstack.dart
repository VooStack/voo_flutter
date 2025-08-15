import 'package:flutter/material.dart';
import 'package:voo_core/voo_core.dart';
import 'package:voo_logging/voo_logging.dart';

/// Simple test to verify DevStack telemetry is working
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // DevStack credentials for VooTest project
  const String devStackApiKey = 'ds_test_V--xoos6S8Q6SlEi2Rb_wFENHFdl2gzV6mB9SfWo-Tk';
  const String projectId = '21d20d74-22ef-46b2-8fb2-58c4ac13eb96'; // VooTest project
  const String organizationId = '0d1652a4-4251-4c8b-9930-238ec735c236'; // VooStack org

  print('Initializing DevStack telemetry...');
  
  // Initialize DevStack telemetry with debug mode enabled
  // Note: For iOS simulator, use host machine's IP address
  // For Android emulator, use 10.0.2.2 or host.docker.internal
  await DevStackTelemetry.initialize(
    apiKey: devStackApiKey,
    projectId: projectId,
    organizationId: organizationId,
    endpoint: 'http://192.168.1.194:5001/api/v1',  // Host machine IP for iOS simulator
    enableDebugMode: true, // Enable to see what's being sent
    syncInterval: const Duration(seconds: 5), // Sync every 5 seconds for testing
    batchSize: 5, // Small batch size for testing
  );

  print('Initializing VooLogging...');
  
  // Initialize VooLogging
  await VooLoggingPlugin.instance.initialize(
    maxEntries: 10000,
    enableConsoleOutput: true,
    enableFileStorage: true,
  );

  // Initialize VooLogger
  await VooLogger.initialize(
    appName: 'VooFlutter-DevStackTest',
    appVersion: '1.0.0',
    userId: 'test_user_123',
    minimumLevel: LogLevel.verbose,
  );

  print('\n=== Generating test logs ===');
  
  // Generate some test logs
  VooLogger.info('Test log 1: DevStack integration test started');
  VooLogger.debug('Test log 2: Debug information');
  VooLogger.warning('Test log 3: Warning message');
  VooLogger.error('Test log 4: Error occurred', error: Exception('Test error'));
  VooLogger.info('Test log 5: Final test message');

  // Print sync status
  print('\n=== Initial Sync Status ===');
  DevStackTelemetry.printSyncStatus();

  // Wait a bit then force sync
  print('\n=== Waiting 2 seconds then forcing sync ===');
  await Future.delayed(const Duration(seconds: 2));
  
  print('Forcing sync now...');
  await DevStackTelemetry.forceSync();
  
  // Print status again
  print('\n=== After Force Sync ===');
  DevStackTelemetry.printSyncStatus();
  
  // Check debug log
  print('\n=== Debug Log ===');
  final debugLog = DevStackTelemetry.getDebugLog();
  for (final entry in debugLog) {
    print(entry);
  }
  
  print('\n=== Test Complete ===');
  print('Check the DevStack API logs to verify data was received.');
  
  // Keep the app running for a bit to allow any pending syncs
  await Future.delayed(const Duration(seconds: 5));
  
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('DevStack Test')),
      body: const Center(
        child: Text('Check console for test results'),
      ),
    ),
  ));
}