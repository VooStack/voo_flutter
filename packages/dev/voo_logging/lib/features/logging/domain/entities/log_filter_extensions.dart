import 'package:voo_logging/features/logging/domain/entities/log_entry.dart';
import 'package:voo_logging/features/logging/domain/entities/log_filter.dart';

extension LogFilterExtensions on LogFilter {
  bool matches(LogEntry log) {
    // Check time range
    if (startTime != null && log.timestamp.isBefore(startTime!)) {
      return false;
    }
    if (endTime != null && log.timestamp.isAfter(endTime!)) {
      return false;
    }

    // Check log level
    if (levels != null && levels!.isNotEmpty && !levels!.contains(log.level)) {
      return false;
    }

    // Check category
    if (categories != null && categories!.isNotEmpty) {
      if (log.category == null || !categories!.contains(log.category)) {
        return false;
      }
    }

    // Check tag
    if (tags != null && tags!.isNotEmpty) {
      if (log.tag == null || !tags!.contains(log.tag)) {
        return false;
      }
    }

    // Check search query
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      final query = searchQuery!.toLowerCase();
      final matchesMessage = log.message.toLowerCase().contains(query);
      final matchesCategory = log.category?.toLowerCase().contains(query) ?? false;
      final matchesTag = log.tag?.toLowerCase().contains(query) ?? false;

      if (!matchesMessage && !matchesCategory && !matchesTag) {
        return false;
      }
    }

    // Check user ID
    if (userId != null && log.userId != userId) {
      return false;
    }

    // Check session ID
    if (sessionId != null && log.sessionId != sessionId) {
      return false;
    }

    // Check error presence
    if (hasError != null) {
      final logHasError = log.error != null;
      if (hasError != logHasError) {
        return false;
      }
    }

    return true;
  }
}
