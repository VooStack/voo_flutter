/// Represents an analytics event that can be tracked and logged.
///
/// This class encapsulates all the information about a single analytics event,
/// including its name, parameters, timestamp, and optional user/session identifiers.
class AnalyticsEvent {
  /// The name of the analytics event.
  ///
  /// This should be a descriptive identifier for the event type,
  /// such as 'button_clicked' or 'page_viewed'.
  final String name;

  /// Additional parameters associated with the event.
  ///
  /// These can include any custom data relevant to the event,
  /// such as button labels, page names, or user actions.
  final Map<String, dynamic> parameters;

  /// The timestamp when the event occurred.
  ///
  /// If not provided during construction, defaults to the current time.
  final DateTime timestamp;

  /// Optional user identifier associated with the event.
  ///
  /// This can be used to track events for specific users.
  final String? userId;

  /// Optional session identifier associated with the event.
  ///
  /// This can be used to group events within a user session.
  final String? sessionId;

  /// Creates a new analytics event.
  ///
  /// The [name] parameter is required and identifies the event type.
  /// Optional [parameters] can provide additional context.
  /// If [timestamp] is not provided, the current time is used.
  /// [userId] and [sessionId] are optional identifiers for tracking.
  AnalyticsEvent({
    required this.name,
    this.parameters = const {},
    DateTime? timestamp,
    this.userId,
    this.sessionId,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Converts this analytics event to a Map representation.
  ///
  /// This is useful for serialization and storage.
  /// The timestamp is converted to ISO 8601 string format.
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
