import 'dart:developer' as developer;

/// Registers the Voo Logger extension with the Dart VM Service.
/// This must be called early in the app's lifecycle to ensure
/// DevTools can receive log events.
void registerVooLoggerExtension() {
  try {
    // Register the extension
    developer.registerExtension(
      'ext.voo_logger.getVersion',
      (method, parameters) async => developer.ServiceExtensionResponse.result('{"version": "1.0.0", "supported": true}'),
    );

    developer.log('Voo Logger extension registered successfully', name: 'VooLogger', level: 800);
  } catch (e) {
    developer.log('Failed to register Voo Logger extension: $e', name: 'VooLogger', level: 1000);
  }
}
