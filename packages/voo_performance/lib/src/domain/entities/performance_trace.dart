class PerformanceTrace {
  final String id;
  final String name;
  final DateTime startTime;
  DateTime? endTime;
  final Map<String, String> attributes = {};
  final Map<String, int> metrics = {};
  void Function(PerformanceTrace)? _onStop;

  PerformanceTrace({required this.name, required this.startTime}) : id = '${name}_${DateTime.now().microsecondsSinceEpoch}';

  Duration? get duration {
    if (endTime == null) return null;
    return endTime!.difference(startTime);
  }

  bool get isRunning => endTime == null;

  void setStopCallback(void Function(PerformanceTrace) callback) {
    _onStop = callback;
  }

  void start() {
    if (endTime != null) {
      throw StateError('Trace already completed');
    }
  }

  void stop() {
    if (endTime != null) {
      throw StateError('Trace already stopped');
    }
    endTime = DateTime.now();
    _onStop?.call(this);
  }

  void putAttribute(String key, String value) {
    if (endTime != null) {
      throw StateError('Cannot modify completed trace');
    }
    attributes[key] = value;
  }

  void putMetric(String key, int value) {
    if (endTime != null) {
      throw StateError('Cannot modify completed trace');
    }
    metrics[key] = value;
  }

  void incrementMetric(String key, [int value = 1]) {
    if (endTime != null) {
      throw StateError('Cannot modify completed trace');
    }
    metrics[key] = (metrics[key] ?? 0) + value;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'start_time': startTime.toIso8601String(),
      if (endTime != null) 'end_time': endTime!.toIso8601String(),
      if (duration != null) 'duration_ms': duration!.inMilliseconds,
      'attributes': attributes,
      'metrics': metrics,
    };
  }

}
