import 'package:voo_logging/features/logging/domain/entities/voo_logger.dart';

/// Contextual logger for specific modules
/// Why? Automatically adds category/tag context so you don't have to repeat it
///
/// Example:
/// final logger = LoggerContext('UserService', defaultTag: 'API');
/// logger.info('User logged in'); // Automatically tagged with UserService/API
class LoggerContext {
  final String category;
  final String? defaultTag;
  final Map<String, dynamic> defaultMetadata;

  LoggerContext(this.category, {this.defaultTag, this.defaultMetadata = const {}});

  /// Create a child context with additional default metadata
  LoggerContext child(String tag, {Map<String, dynamic>? metadata}) =>
      LoggerContext(category, defaultTag: tag, defaultMetadata: {...defaultMetadata, ...?metadata});

  // Convenience methods that automatically apply context
  Future<void> verbose(String message, {String? tag, Map<String, dynamic>? metadata}) =>
      VooLogger.verbose(message, category: category, tag: tag ?? defaultTag, metadata: _mergeMetadata(metadata));

  Future<void> debug(String message, {String? tag, Map<String, dynamic>? metadata}) =>
      VooLogger.debug(message, category: category, tag: tag ?? defaultTag, metadata: _mergeMetadata(metadata));

  Future<void> info(String message, {String? tag, Map<String, dynamic>? metadata}) =>
      VooLogger.info(message, category: category, tag: tag ?? defaultTag, metadata: _mergeMetadata(metadata));

  Future<void> warning(String message, {String? tag, Map<String, dynamic>? metadata}) =>
      VooLogger.warning(message, category: category, tag: tag ?? defaultTag, metadata: _mergeMetadata(metadata));

  Future<void> error(String message, {Object? error, StackTrace? stackTrace, String? tag, Map<String, dynamic>? metadata}) =>
      VooLogger.error(message, error: error, stackTrace: stackTrace, category: category, tag: tag ?? defaultTag, metadata: _mergeMetadata(metadata));

  Future<void> fatal(String message, {Object? error, StackTrace? stackTrace, String? tag, Map<String, dynamic>? metadata}) =>
      VooLogger.fatal(message, error: error, stackTrace: stackTrace, category: category, tag: tag ?? defaultTag, metadata: _mergeMetadata(metadata));

  Map<String, dynamic>? _mergeMetadata(Map<String, dynamic>? metadata) {
    if (defaultMetadata.isEmpty && metadata == null) return null;
    return {...defaultMetadata, ...?metadata};
  }
}
