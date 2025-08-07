class AnalyticsEvent {
  final String name;
  final Map<String, dynamic> parameters;
  final DateTime timestamp;
  final String? userId;
  final String? sessionId;

  AnalyticsEvent({required this.name, this.parameters = const {}, DateTime? timestamp, this.userId, this.sessionId}) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'parameters': parameters,
      'timestamp': timestamp.toIso8601String(),
      if (userId != null) 'user_id': userId,
      if (sessionId != null) 'session_id': sessionId,
    };
  }

  @override
  String toString() {
    return 'AnalyticsEvent(name: $name, parameters: $parameters, timestamp: $timestamp)';
  }
}
