import 'dart:async';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/foundation.dart';

/// Service for detecting which Voo packages are available in the app
class PackageDetectionService {
  static final PackageDetectionService _instance =
      PackageDetectionService._internal();
  factory PackageDetectionService() => _instance;
  PackageDetectionService._internal();

  final _packageStatusController =
      StreamController<Map<String, bool>>.broadcast();
  Stream<Map<String, bool>> get packageStatusStream =>
      _packageStatusController.stream;

  Map<String, bool> _packageStatus = {
    'voo_logging': false,
    'voo_analytics': false,
    'voo_performance': false,
    'voo_telemetry': false,
  };

  Map<String, bool> get packageStatus => Map.unmodifiable(_packageStatus);

  Timer? _checkTimer;

  void startMonitoring() {
    _checkPackageAvailability();
    _checkTimer?.cancel();
    _checkTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _checkPackageAvailability();
    });
  }

  void stopMonitoring() {
    _checkTimer?.cancel();
    _checkTimer = null;
  }

  Future<void> _checkPackageAvailability() async {
    try {
      final manager = serviceManager;
      if (manager.connectedState.value.connected == false) {
        // When not connected, we can still show UI based on what we know
        // For now, show all features as potentially available
        _updateStatus({
          'voo_logging': true,
          'voo_analytics': true,
          'voo_performance': true,
          'voo_telemetry': false, // Not ready yet
        });
        return;
      }

      final isolateId = manager.isolateManager.selectedIsolate.value?.id;
      if (isolateId == null) {
        return;
      }

      final newStatus = <String, bool>{};

      // Check for each package by trying to evaluate if the package's main class exists
      // This checks if the package is in dependencies, not if it's initialized
      final packageChecks = {
        'voo_logging': '''
          try {
            // Check if voo_logging package is available
            const Type t = (VooLogger);
            true;
          } catch (e) {
            false;
          }
        ''',
        'voo_analytics': '''
          try {
            // Check if voo_analytics package is available
            const Type t = (VooAnalytics);
            true;
          } catch (e) {
            false;
          }
        ''',
        'voo_performance': '''
          try {
            // Check if voo_performance package is available
            const Type t = (VooPerformance);
            true;
          } catch (e) {
            false;
          }
        ''',
        'voo_telemetry': '''
          try {
            // Check if voo_telemetry package is available
            const Type t = (VooTelemetry);
            true;
          } catch (e) {
            false;
          }
        ''',
      };

      for (final entry in packageChecks.entries) {
        try {
          // First try to check if Voo is initialized and has the plugin
          final vooCheckResponse = await manager.service!.evaluate(
            isolateId,
            'true',
            '''
              (() {
                try {
                  // Check if Voo exists and has the plugin
                  if (Voo != null && Voo.hasPlugin != null) {
                    return Voo.hasPlugin("${entry.key}");
                  }
                } catch (e) {
                  // Voo not available or not initialized
                }
                
                // Fallback: check if the package's main class exists
                ${entry.value}
              })()
            ''',
          );

          final json = vooCheckResponse.json;
          if (json != null && json['result'] != null) {
            final result = json['result'];
            newStatus[entry.key] = result == 'true' || result == true;
          } else {
            // If evaluation fails, try a simpler check
            newStatus[entry.key] = await _checkPackageViaImport(
              manager,
              isolateId,
              entry.key,
            );
          }
        } catch (e) {
          // If checking fails, assume package might be available
          // This ensures UI is shown even if detection fails
          newStatus[entry.key] = true;
          if (kDebugMode) {
            print('Failed to check package ${entry.key}: $e');
          }
        }
      }

      // Special handling for telemetry (not ready yet)
      newStatus['voo_telemetry'] = false;

      // Update status if changed
      if (!mapEquals(_packageStatus, newStatus)) {
        _updateStatus(newStatus);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking package availability: $e');
      }
      // On error, show all features as potentially available
      _updateStatus({
        'voo_logging': true,
        'voo_analytics': true,
        'voo_performance': true,
        'voo_telemetry': false,
      });
    }
  }

  Future<bool> _checkPackageViaImport(
    dynamic manager,
    String isolateId,
    String packageName,
  ) async {
    try {
      // Try to check if we can access package-specific functionality
      final checkCode =
          '''
        (() {
          try {
            // Check for package-specific classes
            ${_getPackageCheckCode(packageName)}
            return true;
          } catch (e) {
            return false;
          }
        })()
      ''';

      final response = await manager.service!.evaluate(
        isolateId,
        'true',
        checkCode,
      );

      final json = response.json;
      if (json != null && json['result'] != null) {
        final result = json['result'];
        return result == 'true' || result == true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Import check failed for $packageName: $e');
      }
    }
    // Default to showing the feature if we can't determine
    return true;
  }

  String _getPackageCheckCode(String packageName) {
    switch (packageName) {
      case 'voo_logging':
        return 'const t = (VooLogger);';
      case 'voo_analytics':
        return 'const t = (VooAnalytics);';
      case 'voo_performance':
        return 'const t = (VooPerformance);';
      case 'voo_telemetry':
        return 'const t = (VooTelemetry);';
      default:
        return 'false';
    }
  }

  void _updateStatus(Map<String, bool> newStatus) {
    _packageStatus = newStatus;
    _packageStatusController.add(_packageStatus);
  }

  /// Get display information for a package
  static PackageInfo getPackageInfo(String packageName) {
    switch (packageName) {
      case 'voo_logging':
        return PackageInfo(
          name: 'Logging',
          icon: '📝',
          description: 'Application logs and debugging',
        );
      case 'voo_analytics':
        return PackageInfo(
          name: 'Analytics',
          icon: '📊',
          description: 'User interaction tracking',
        );
      case 'voo_performance':
        return PackageInfo(
          name: 'Performance',
          icon: '⚡',
          description: 'Performance monitoring',
        );
      case 'voo_telemetry':
        return PackageInfo(
          name: 'Telemetry',
          icon: '📡',
          description: 'Unified telemetry data',
        );
      default:
        return PackageInfo(
          name: packageName,
          icon: '🔧',
          description: 'Package',
        );
    }
  }

  void dispose() {
    _checkTimer?.cancel();
    _packageStatusController.close();
  }
}

class PackageInfo {
  final String name;
  final String icon;
  final String description;

  const PackageInfo({
    required this.name,
    required this.icon,
    required this.description,
  });
}
