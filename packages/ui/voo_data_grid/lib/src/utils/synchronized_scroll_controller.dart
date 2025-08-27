import 'package:flutter/material.dart';

/// Synchronized scroll controller for coordinating multiple scrollables
class SynchronizedScrollController {
  final List<ScrollController> _controllers = [];
  bool _isUpdating = false;

  /// Register a scroll controller
  void registerController(ScrollController controller) {
    if (!_controllers.contains(controller)) {
      _controllers.add(controller);
      controller.addListener(() => _onScroll(controller));
    }
  }

  /// Unregister a scroll controller
  void unregisterController(ScrollController controller) {
    _controllers.remove(controller);
  }

  /// Handle scroll events
  void _onScroll(ScrollController controller) {
    if (_isUpdating || !controller.hasClients) return;
    
    _isUpdating = true;
    
    final offset = controller.offset;
    
    // Update all other controllers
    for (final other in _controllers) {
      if (other != controller && other.hasClients) {
        if (other.offset != offset) {
          other.jumpTo(offset);
        }
      }
    }
    
    _isUpdating = false;
  }

  /// Jump to a specific offset for all controllers
  void jumpTo(double offset) {
    _isUpdating = true;
    for (final controller in _controllers) {
      if (controller.hasClients && controller.offset != offset) {
        controller.jumpTo(offset);
      }
    }
    _isUpdating = false;
  }

  /// Animate to a specific offset for all controllers
  Future<void> animateTo(
    double offset, {
    required Duration duration,
    required Curve curve,
  }) async {
    _isUpdating = true;
    final futures = <Future>[];
    
    for (final controller in _controllers) {
      if (controller.hasClients && controller.offset != offset) {
        futures.add(
          controller.animateTo(
            offset,
            duration: duration,
            curve: curve,
          ),
        );
      }
    }
    
    await Future.wait(futures);
    _isUpdating = false;
  }

  /// Clear registered controllers
  void dispose() {
    // Don't dispose the controllers themselves as they are owned by VooDataGridController
    // Just clear the list
    _controllers.clear();
  }
}