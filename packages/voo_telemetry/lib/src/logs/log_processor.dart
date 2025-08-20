import 'package:voo_telemetry/src/logs/log_record.dart';

/// Processor for log records (placeholder)
abstract class LogProcessor {
  void onEmit(LogRecord record);
  Future<void> shutdown();
}
