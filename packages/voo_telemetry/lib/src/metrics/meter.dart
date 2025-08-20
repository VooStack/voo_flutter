import 'package:voo_telemetry/src/metrics/instruments.dart';
import 'package:voo_telemetry/src/metrics/meter_provider.dart';

/// Meter for creating metric instruments
class Meter {
  final String name;
  final MeterProvider provider;
  final Map<String, dynamic> _instruments = {};

  Meter({required this.name, required this.provider});

  /// Create a counter instrument
  Counter createCounter(String name, {String? description, String? unit}) =>
      _instruments.putIfAbsent(name, () => Counter(name: name, description: description, unit: unit, meter: this)) as Counter;

  /// Create an up-down counter instrument
  UpDownCounter createUpDownCounter(String name, {String? description, String? unit}) =>
      _instruments.putIfAbsent(name, () => UpDownCounter(name: name, description: description, unit: unit, meter: this)) as UpDownCounter;

  /// Create a histogram instrument
  Histogram createHistogram(String name, {String? description, String? unit, List<double>? explicitBounds}) =>
      _instruments.putIfAbsent(name, () => Histogram(name: name, description: description, unit: unit, explicitBounds: explicitBounds, meter: this))
          as Histogram;

  /// Create a gauge instrument
  Gauge createGauge(String name, {String? description, String? unit}) =>
      _instruments.putIfAbsent(name, () => Gauge(name: name, description: description, unit: unit, meter: this)) as Gauge;
}
