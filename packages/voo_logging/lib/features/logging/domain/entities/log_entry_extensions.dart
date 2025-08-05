import 'package:voo_logging/features/logging/data/models/log_entry_model.dart';
import 'package:voo_logging/features/logging/domain/entities/log_entry.dart';

extension LogEntryExtensions on LogEntry {
  LogEntryModel toModel() => LogEntryModel(id, timestamp, message, level, category, tag, metadata, error, stackTrace, userId, sessionId);
}
