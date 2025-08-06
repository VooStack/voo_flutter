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
  } catch (_) {
    // Silent fail - extension registration is optional
  }
}
