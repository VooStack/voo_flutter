/// Conditional export for DevTools extension
/// Exports the actual extension on web, stub on other platforms
export 'devtools_extension_stub.dart' if (dart.library.js_interop) 'main.dart';
