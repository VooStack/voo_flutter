/// Base class for OTLP exporters
abstract class OTLPExporter {
  Future<bool> export(Map<String, dynamic> data);
  void shutdown();
}