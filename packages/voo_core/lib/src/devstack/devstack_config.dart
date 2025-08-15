/// Configuration for DevStack telemetry API integration
class DevStackConfig {
  final String apiKey;
  final String endpoint;
  final String projectId;
  final bool enableDebugLogging;
  
  const DevStackConfig({
    required this.apiKey,
    this.endpoint = 'http://localhost:5001/api/v1',
    required this.projectId,
    this.enableDebugLogging = false,
  });
  
  const DevStackConfig.production({
    required this.apiKey,
    required this.projectId,
    this.enableDebugLogging = false,
  }) : endpoint = 'https://api.devstack.com/v1';
  
  const DevStackConfig.development({
    required this.apiKey,
    required this.projectId,
    this.enableDebugLogging = true,
  }) : endpoint = 'http://localhost:5001/api/v1';
  
  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'X-API-Key': apiKey,
    'X-Project-Id': projectId,
  };
}