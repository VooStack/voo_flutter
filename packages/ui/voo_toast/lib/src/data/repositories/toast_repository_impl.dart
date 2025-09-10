import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:voo_toast/src/domain/entities/toast.dart';
import 'package:voo_toast/src/domain/entities/toast_config.dart';
import 'package:voo_toast/src/domain/repositories/toast_repository.dart';

class ToastRepositoryImpl implements ToastRepository {
  ToastRepositoryImpl({
    ToastConfig? config,
  }) : _config = config ?? const ToastConfig();

  final ToastConfig _config;
  final _toastsSubject = BehaviorSubject<List<Toast>>.seeded([]);
  final _queueSubject = BehaviorSubject<List<Toast>>.seeded([]);
  final Map<String, Timer> _timers = {};

  @override
  Stream<List<Toast>> get toastsStream => _toastsSubject.stream;

  @override
  List<Toast> get currentToasts => _toastsSubject.value;

  @override
  void show(Toast toast) {
    if (_config.preventDuplicates) {
      final exists = currentToasts.any((t) => t.message == toast.message);
      if (exists) return;
    }

    if (_config.queueMode && currentToasts.length >= _config.maxToasts) {
      _addToQueue(toast);
      return;
    }

    if (!_config.queueMode && currentToasts.length >= _config.maxToasts) {
      final toRemove = currentToasts.first;
      dismiss(toRemove.id);
    }

    final updatedToasts = [...currentToasts, toast]
      ..sort((a, b) => b.priority.compareTo(a.priority));
    
    _toastsSubject.add(updatedToasts);
    
    if (toast.duration != Duration.zero) {
      _startTimer(toast);
    }
  }

  @override
  void dismiss(String toastId) {
    _cancelTimer(toastId);
    
    // Find the toast to dismiss (if it exists)
    final toastIndex = currentToasts.indexWhere((t) => t.id == toastId);
    
    // If toast not found, just return (already dismissed)
    if (toastIndex == -1) return;
    
    final dismissedToast = currentToasts[toastIndex];
    final updatedToasts = currentToasts.where((t) => t.id != toastId).toList();
    _toastsSubject.add(updatedToasts);
    
    dismissedToast.onDismissed?.call();
    
    _processQueue();
  }

  @override
  void dismissAll() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
    
    for (final toast in currentToasts) {
      toast.onDismissed?.call();
    }
    
    _toastsSubject.add([]);
    _queueSubject.add([]);
  }

  @override
  void clearQueue() {
    _queueSubject.add([]);
  }

  void _addToQueue(Toast toast) {
    final queue = [..._queueSubject.value, toast];
    _queueSubject.add(queue);
  }

  void _processQueue() {
    if (_queueSubject.value.isEmpty) return;
    if (currentToasts.length >= _config.maxToasts) return;
    
    final nextToast = _queueSubject.value.first;
    final updatedQueue = _queueSubject.value.skip(1).toList();
    _queueSubject.add(updatedQueue);
    
    show(nextToast);
  }

  void _startTimer(Toast toast) {
    _timers[toast.id] = Timer(toast.duration, () {
      dismiss(toast.id);
    });
  }

  void _cancelTimer(String toastId) {
    _timers[toastId]?.cancel();
    _timers.remove(toastId);
  }

  void dispose() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
    _toastsSubject.close();
    _queueSubject.close();
  }
}