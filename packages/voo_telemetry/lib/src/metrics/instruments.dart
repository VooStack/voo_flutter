import 'package:voo_telemetry/src/metrics/meter.dart';
import 'package:voo_telemetry/src/metrics/metric.dart';

/// Counter instrument for monotonic values
class Counter {
  final String name;
  final String? description;
  final String? unit;
  final Meter meter;
  int _value = 0;
  
  Counter({
    required this.name,
    this.description,
    this.unit,
    required this.meter,
  });
  
  /// Add to the counter
  void add(int value, {Map<String, dynamic>? attributes}) {
    if (value < 0) {
      throw ArgumentError('Counter values must be non-negative');
    }
    
    _value += value;
    
    final metric = CounterMetric(
      name: name,
      value: _value,
      description: description,
      unit: unit,
      attributes: attributes,
    );
    
    meter.provider.addMetric(metric);
  }
  
  /// Increment the counter by 1
  void increment({Map<String, dynamic>? attributes}) {
    add(1, attributes: attributes);
  }
}

/// UpDownCounter instrument for non-monotonic values
class UpDownCounter {
  final String name;
  final String? description;
  final String? unit;
  final Meter meter;
  int _value = 0;
  
  UpDownCounter({
    required this.name,
    this.description,
    this.unit,
    required this.meter,
  });
  
  /// Add to the counter (can be negative)
  void add(int value, {Map<String, dynamic>? attributes}) {
    _value += value;
    
    final metric = CounterMetric(
      name: name,
      value: _value,
      isMonotonic: false,
      description: description,
      unit: unit,
      attributes: attributes,
    );
    
    meter.provider.addMetric(metric);
  }
}

/// Histogram instrument for recording distributions
class Histogram {
  final String name;
  final String? description;
  final String? unit;
  final List<double>? explicitBounds;
  final Meter meter;
  final List<double> _values = [];
  
  Histogram({
    required this.name,
    this.description,
    this.unit,
    this.explicitBounds,
    required this.meter,
  });
  
  /// Record a value
  void record(double value, {Map<String, dynamic>? attributes}) {
    _values.add(value);
    
    // Batch values and send periodically
    if (_values.length >= 100) {
      _flush(attributes: attributes);
    }
  }
  
  void _flush({Map<String, dynamic>? attributes}) {
    if (_values.isEmpty) return;
    
    final metric = HistogramMetric(
      name: name,
      values: List.from(_values),
      explicitBounds: explicitBounds,
      description: description,
      unit: unit,
      attributes: attributes,
    );
    
    meter.provider.addMetric(metric);
    _values.clear();
  }
}

/// Gauge instrument for current values
class Gauge {
  final String name;
  final String? description;
  final String? unit;
  final Meter meter;
  double _value = 0;
  
  Gauge({
    required this.name,
    this.description,
    this.unit,
    required this.meter,
  });
  
  /// Set the gauge value
  void set(double value, {Map<String, dynamic>? attributes}) {
    _value = value;
    
    final metric = GaugeMetric(
      name: name,
      value: _value,
      description: description,
      unit: unit,
      attributes: attributes,
    );
    
    meter.provider.addMetric(metric);
  }
  
  /// Get the current value
  double get value => _value;
}