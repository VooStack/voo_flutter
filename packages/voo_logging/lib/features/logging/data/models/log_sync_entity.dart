import 'package:voo_core/voo_core.dart';
import 'package:voo_logging/voo_logging.dart';

class LogSyncEntity extends SyncEntity {
  final LogEntry logEntry;
  
  LogSyncEntity({
    required this.logEntry,
    super.isSynced,
    super.retryCount,
  }) : super(
          id: logEntry.id,
          type: 'log',
          timestamp: logEntry.timestamp,
          data: {
            'message': logEntry.message,
            'level': logEntry.level.name,
            'category': logEntry.category,
            'tag': logEntry.tag,
            'metadata': logEntry.metadata,
            'error': logEntry.error?.toString(),
            'stackTrace': logEntry.stackTrace,
            'userId': logEntry.userId,
            'sessionId': logEntry.sessionId,
          },
        );
  
  @override
  SyncEntity copyWith({
    bool? isSynced,
    int? retryCount,
  }) {
    return LogSyncEntity(
      logEntry: logEntry,
      isSynced: isSynced ?? this.isSynced,
      retryCount: retryCount ?? this.retryCount,
    );
  }
}