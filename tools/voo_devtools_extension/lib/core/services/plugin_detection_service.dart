import 'dart:async';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/foundation.dart';

/// Service for detecting which Voo plugins are initialized
class PluginDetectionService {
  static final PluginDetectionService _instance =
      PluginDetectionService._internal();
  factory PluginDetectionService() => _instance;
  PluginDetectionService._internal();

  final _pluginStatusController =
      StreamController<Map<String, bool>>.broadcast();
  Stream<Map<String, bool>> get pluginStatusStream =>
      _pluginStatusController.stream;

  Map<String, bool> _pluginStatus = {
    'voo_logging': false,
    'voo_analytics': false,
    'voo_performance': false,
    'voo_telemetry': false,
  };

  Map<String, bool> get pluginStatus => Map.unmodifiable(_pluginStatus);

  Timer? _checkTimer;

  void startMonitoring() {
    _checkPluginStatus();
    _checkTimer?.cancel();
    _checkTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _checkPluginStatus();
    });
  }

  void stopMonitoring() {
    _checkTimer?.cancel();
    _checkTimer = null;
  }

  Future<void> _checkPluginStatus() async {
    try {
      final manager = serviceManager;
      if (manager.connectedState.value.connected == false) {
        _updateAllStatus(false);
        return;
      }

      final isolateId = manager.isolateManager.selectedIsolate.value?.id;
      if (isolateId == null) {
        _updateAllStatus(false);
        return;
      }

      final newStatus = <String, bool>{};

      // Check for each plugin by trying to get its info via eval
      for (final pluginName in _pluginStatus.keys) {
        try {
          final response = await manager.service!.evaluate(
            isolateId,
            'true',
            'Voo.hasPlugin("$pluginName")',
          );

          final json = response.json;
          if (json != null && json['result'] != null) {
            final result = json['result'];
            newStatus[pluginName] = result == 'true' || result == true;
          } else {
            newStatus[pluginName] = false;
          }
        } catch (e) {
          newStatus[pluginName] = false;
          if (kDebugMode) {
            print('Failed to check plugin $pluginName: $e');
          }
        }
      }

      // Update status if changed
      if (!mapEquals(_pluginStatus, newStatus)) {
        _pluginStatus = newStatus;
        _pluginStatusController.add(_pluginStatus);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking plugin status: $e');
      }
      _updateAllStatus(false);
    }
  }

  void _updateAllStatus(bool status) {
    final newStatus = Map<String, bool>.fromEntries(
      _pluginStatus.keys.map((key) => MapEntry(key, status)),
    );
    if (!mapEquals(_pluginStatus, newStatus)) {
      _pluginStatus = newStatus;
      _pluginStatusController.add(_pluginStatus);
    }
  }

  /// Get display information for a plugin
  static PluginInfo getPluginInfo(String pluginName) {
    switch (pluginName) {
      case 'voo_logging':
        return PluginInfo(
          name: 'Logging',
          icon: '📝',
          description: 'Application logs and debugging',
        );
      case 'voo_analytics':
        return PluginInfo(
          name: 'Analytics',
          icon: '📊',
          description: 'User interaction tracking',
        );
      case 'voo_network':
        return PluginInfo(
          name: 'Network',
          icon: '🌐',
          description: 'Network request monitoring',
        );
      case 'voo_performance':
        return PluginInfo(
          name: 'Performance',
          icon: '⚡',
          description: 'Performance monitoring',
        );
      case 'voo_telemetry':
        return PluginInfo(
          name: 'Telemetry',
          icon: '📡',
          description: 'Unified telemetry data',
        );
      default:
        return PluginInfo(name: pluginName, icon: '🔧', description: 'Plugin');
    }
  }

  void dispose() {
    _checkTimer?.cancel();
    _pluginStatusController.close();
  }
}

class PluginInfo {
  final String name;
  final String icon;
  final String description;

  const PluginInfo({
    required this.name,
    required this.icon,
    required this.description,
  });
}
