import 'otlp_exporter.dart';

/// OTLP gRPC exporter (placeholder for future implementation)
class OTLPGrpcExporter extends OTLPExporter {
  @override
  Future<bool> export(Map<String, dynamic> data) async {
    // TODO: Implement gRPC export
    throw UnimplementedError('gRPC export not yet implemented');
  }
  
  @override
  void shutdown() {
    // Cleanup
  }
}