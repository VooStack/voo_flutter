/// Represents a resource that produces telemetry
class TelemetryResource {
  final String serviceName;
  final String serviceVersion;
  final Map<String, dynamic> attributes;

  TelemetryResource({required this.serviceName, required this.serviceVersion, Map<String, dynamic>? attributes}) : attributes = attributes ?? {};

  /// Convert to OTLP resource format
  Map<String, dynamic> toOtlp() => {
    'attributes': attributes.entries.map((e) => {'key': e.key, 'value': _convertValue(e.value)}).toList(),
  };

  Map<String, dynamic> _convertValue(dynamic value) {
    if (value is String) {
      return {'stringValue': value};
    } else if (value is bool) {
      return {'boolValue': value};
    } else if (value is int) {
      return {'intValue': value};
    } else if (value is double) {
      return {'doubleValue': value};
    } else if (value is List) {
      return {
        'arrayValue': {'values': value.map(_convertValue).toList()},
      };
    } else if (value is Map) {
      return {
        'kvlistValue': {
          'values': value.entries.map((e) => {'key': e.key.toString(), 'value': _convertValue(e.value)}).toList(),
        },
      };
    } else {
      return {'stringValue': value.toString()};
    }
  }
}
