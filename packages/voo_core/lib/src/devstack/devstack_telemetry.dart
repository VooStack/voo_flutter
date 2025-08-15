import 'package:flutter/foundation.dart';
import 'package:voo_core/src/voo.dart';
import 'package:voo_core/src/voo_options.dart';
import 'package:voo_core/src/cloud/cloud_sync_manager.dart';

/// Helper class to configure VooFlutter packages to send telemetry to DevStack API
class DevStackTelemetry {
  /// Initialize VooFlutter with DevStack configuration
  static Future<void> initialize({
    required String apiKey,
    required String projectId,
    required String organizationId,
    String? endpoint,
    bool enableDebugMode = false,
    Duration syncInterval = const Duration(seconds: 30),
    int batchSize = 50,
  }) async {
    // Enable debug mode if requested
    if (enableDebugMode) {
      CloudSyncManager.enableDebugMode();
    }
    
    // Configure VooOptions for DevStack
    final options = VooOptions(
      enableDebugLogging: enableDebugMode,
      autoRegisterPlugins: true,
      apiKey: apiKey,
      apiEndpoint: endpoint ?? 'http://localhost:5001/api/v1',
      enableCloudSync: true,
      syncInterval: syncInterval,
      batchSize: batchSize,
      customConfig: {
        'projectId': projectId,
        'organizationId': organizationId,
      },
    );
    
    // Initialize Voo with DevStack configuration
    await Voo.initializeApp(options: options);
    
    if (enableDebugMode && kDebugMode) {
      debugPrint('[DevStackTelemetry] Initialized with:');
      debugPrint('  - API Key: ${apiKey.substring(0, 10)}****');
      debugPrint('  - Endpoint: ${options.apiEndpoint}');
      debugPrint('  - Project ID: $projectId');
      debugPrint('  - Organization ID: $organizationId');
      debugPrint('  - Sync Interval: ${syncInterval.inSeconds}s');
      debugPrint('  - Batch Size: $batchSize');
      debugPrint('  - Cloud Sync: ${options.enableCloudSync}');
    }
  }
  
  /// Get the current sync status
  static Map<String, dynamic> getSyncStatus() {
    return CloudSyncManager.instance.getSyncStatus();
  }
  
  /// Force an immediate sync of queued telemetry data
  static Future<void> forceSync() async {
    await CloudSyncManager.instance.forceSync();
  }
  
  /// Get the current queue size
  static int get queueSize => CloudSyncManager.instance.queueSize;
  
  /// Check if currently syncing
  static bool get isSyncing => CloudSyncManager.instance.isSyncing;
  
  /// Get debug log entries
  static List<String> getDebugLog() => CloudSyncManager.getDebugLog();
  
  /// Clear debug log
  static void clearDebugLog() => CloudSyncManager.clearDebugLog();
  
  /// Print sync status to console (only in debug mode)
  static void printSyncStatus() {
    if (!kDebugMode) return;
    
    final status = getSyncStatus();
    debugPrint('╔══════════════════════════════════════════════════════════╗');
    debugPrint('║              DevStack Telemetry Status                   ║');
    debugPrint('╠══════════════════════════════════════════════════════════╣');
    debugPrint('║ Queue Size:       ${status['queueSize'].toString().padRight(38)} ║');
    debugPrint('║ Is Syncing:       ${status['isSyncing'].toString().padRight(38)} ║');
    debugPrint('║ Debug Mode:       ${status['debugMode'].toString().padRight(38)} ║');
    debugPrint('║ Cloud Sync:       ${status['cloudSyncEnabled'].toString().padRight(38)} ║');
    debugPrint('║ API Key Present:  ${status['apiKeyPresent'].toString().padRight(38)} ║');
    debugPrint('║ Endpoint:         ${(status['endpoint'] as String).padRight(38).substring(0, 38)} ║');
    debugPrint('╚══════════════════════════════════════════════════════════╝');
  }
}