import 'dart:async';
import 'package:flutter/foundation.dart';

/// A utility class for debouncing function calls
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 300)});

  /// Call the [action] after [delay] has passed since the last call
  void call(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Cancel any pending action
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Dispose the debouncer
  void dispose() {
    cancel();
  }

  /// Whether there's a pending action
  bool get isPending => _timer?.isActive ?? false;
}

/// A utility class for throttling function calls
class Throttler {
  final Duration interval;
  DateTime? _lastCall;
  Timer? _pendingTimer;

  Throttler({this.interval = const Duration(milliseconds: 100)});

  /// Call the [action] immediately if [interval] has passed since the last call,
  /// otherwise schedule it to run after the remaining time
  void call(VoidCallback action) {
    final now = DateTime.now();

    if (_lastCall == null || now.difference(_lastCall!) >= interval) {
      _lastCall = now;
      _pendingTimer?.cancel();
      action();
    } else {
      // Schedule the action to run after the remaining interval
      _pendingTimer?.cancel();
      final remaining = interval - now.difference(_lastCall!);
      _pendingTimer = Timer(remaining, () {
        _lastCall = DateTime.now();
        action();
      });
    }
  }

  /// Cancel any pending action
  void cancel() {
    _pendingTimer?.cancel();
    _pendingTimer = null;
  }

  /// Dispose the throttler
  void dispose() {
    cancel();
  }
}
