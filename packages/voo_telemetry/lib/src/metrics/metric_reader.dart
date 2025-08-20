/// Metric reader (placeholder)
abstract class MetricReader {
  Future<void> collect();
  Future<void> shutdown();
}
