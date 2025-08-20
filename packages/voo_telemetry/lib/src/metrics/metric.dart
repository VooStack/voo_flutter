/// Base class for metrics
abstract class Metric {
  final String name;
  final String? description;
  final String? unit;
  final DateTime timestamp;
  final Map<String, dynamic> attributes;

  Metric({required this.name, this.description, this.unit, DateTime? timestamp, Map<String, dynamic>? attributes})
    : timestamp = timestamp ?? DateTime.now(),
      attributes = attributes ?? {};

  /// Convert to OTLP format
  Map<String, dynamic> toOtlp();
}

/// Counter metric
class CounterMetric extends Metric {
  final int value;
  final bool isMonotonic;

  CounterMetric({required super.name, required this.value, this.isMonotonic = true, super.description, super.unit, super.timestamp, super.attributes});

  @override
  Map<String, dynamic> toOtlp() => {
    'name': name,
    if (description != null) 'description': description,
    if (unit != null) 'unit': unit,
    'sum': {
      'dataPoints': [
        {
          'asInt': value,
          'timeUnixNano': timestamp.microsecondsSinceEpoch * 1000,
          'attributes': attributes.entries.map((e) => {'key': e.key, 'value': _convertValue(e.value)}).toList(),
        },
      ],
      'aggregationTemporality': 2, // CUMULATIVE
      'isMonotonic': isMonotonic,
    },
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
    } else {
      return {'stringValue': value.toString()};
    }
  }
}

/// Gauge metric
class GaugeMetric extends Metric {
  final double value;

  GaugeMetric({required super.name, required this.value, super.description, super.unit, super.timestamp, super.attributes});

  @override
  Map<String, dynamic> toOtlp() => {
    'name': name,
    if (description != null) 'description': description,
    if (unit != null) 'unit': unit,
    'gauge': {
      'dataPoints': [
        {
          'asDouble': value,
          'timeUnixNano': timestamp.microsecondsSinceEpoch * 1000,
          'attributes': attributes.entries.map((e) => {'key': e.key, 'value': _convertValue(e.value)}).toList(),
        },
      ],
    },
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
    } else {
      return {'stringValue': value.toString()};
    }
  }
}

/// Histogram metric
class HistogramMetric extends Metric {
  final List<double> values;
  final List<double>? explicitBounds;

  HistogramMetric({required super.name, required this.values, this.explicitBounds, super.description, super.unit, super.timestamp, super.attributes});

  @override
  Map<String, dynamic> toOtlp() {
    final bounds = explicitBounds ?? [0, 5, 10, 25, 50, 75, 100, 250, 500, 1000];
    final bucketCounts = _calculateBuckets(values, bounds);

    return {
      'name': name,
      if (description != null) 'description': description,
      if (unit != null) 'unit': unit,
      'histogram': {
        'dataPoints': [
          {
            'count': values.length,
            'sum': values.fold<double>(0, (sum, v) => sum + v),
            'bucketCounts': bucketCounts,
            'explicitBounds': bounds,
            'timeUnixNano': timestamp.microsecondsSinceEpoch * 1000,
            'attributes': attributes.entries.map((e) => {'key': e.key, 'value': _convertValue(e.value)}).toList(),
            if (values.isNotEmpty) 'min': values.reduce((a, b) => a < b ? a : b),
            if (values.isNotEmpty) 'max': values.reduce((a, b) => a > b ? a : b),
          },
        ],
        'aggregationTemporality': 2, // CUMULATIVE
      },
    };
  }

  List<int> _calculateBuckets(List<double> values, List<double> bounds) {
    final buckets = List.filled(bounds.length + 1, 0);

    for (final value in values) {
      var placed = false;
      for (int i = 0; i < bounds.length; i++) {
        if (value <= bounds[i]) {
          buckets[i]++;
          placed = true;
          break;
        }
      }
      if (!placed) {
        buckets[bounds.length]++;
      }
    }

    return buckets;
  }

  Map<String, dynamic> _convertValue(dynamic value) {
    if (value is String) {
      return {'stringValue': value};
    } else if (value is bool) {
      return {'boolValue': value};
    } else if (value is int) {
      return {'intValue': value};
    } else if (value is double) {
      return {'doubleValue': value};
    } else {
      return {'stringValue': value.toString()};
    }
  }
}
