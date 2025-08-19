/// Common telemetry attributes
class TelemetryAttributes {
  // Service attributes
  static const String serviceName = 'service.name';
  static const String serviceNamespace = 'service.namespace';
  static const String serviceInstanceId = 'service.instance.id';
  static const String serviceVersion = 'service.version';
  
  // HTTP attributes
  static const String httpMethod = 'http.method';
  static const String httpUrl = 'http.url';
  static const String httpTarget = 'http.target';
  static const String httpHost = 'http.host';
  static const String httpScheme = 'http.scheme';
  static const String httpStatusCode = 'http.status_code';
  static const String httpFlavor = 'http.flavor';
  static const String httpUserAgent = 'http.user_agent';
  static const String httpRequestContentLength = 'http.request_content_length';
  static const String httpResponseContentLength = 'http.response_content_length';
  
  // Network attributes
  static const String netTransport = 'net.transport';
  static const String netPeerIp = 'net.peer.ip';
  static const String netPeerPort = 'net.peer.port';
  static const String netPeerName = 'net.peer.name';
  static const String netHostIp = 'net.host.ip';
  static const String netHostPort = 'net.host.port';
  static const String netHostName = 'net.host.name';
  
  // Database attributes
  static const String dbSystem = 'db.system';
  static const String dbConnectionString = 'db.connection_string';
  static const String dbUser = 'db.user';
  static const String dbName = 'db.name';
  static const String dbStatement = 'db.statement';
  static const String dbOperation = 'db.operation';
  
  // Exception attributes
  static const String exceptionType = 'exception.type';
  static const String exceptionMessage = 'exception.message';
  static const String exceptionStacktrace = 'exception.stacktrace';
  
  // Code attributes
  static const String codeFunction = 'code.function';
  static const String codeNamespace = 'code.namespace';
  static const String codeFilepath = 'code.filepath';
  static const String codeLineno = 'code.lineno';
  
  // Device attributes
  static const String deviceId = 'device.id';
  static const String deviceModel = 'device.model';
  static const String deviceManufacturer = 'device.manufacturer';
  
  // OS attributes
  static const String osType = 'os.type';
  static const String osDescription = 'os.description';
  static const String osName = 'os.name';
  static const String osVersion = 'os.version';
  
  // User attributes
  static const String enduserId = 'enduser.id';
  static const String enduserRole = 'enduser.role';
  static const String enduserScope = 'enduser.scope';
}