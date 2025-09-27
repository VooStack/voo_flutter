import 'package:json_annotation/json_annotation.dart';
import 'package:voo_logging/core/domain/enums/log_level.dart';

part 'log_entry_model.g.dart';

@JsonSerializable()
class LogEntryModel {
  final String id;
  final DateTime timestamp;
  final String message;
  final LogLevel level;
  final String? category;
  final String? tag;
  final Map<String, dynamic>? metadata;
  @JsonKey(toJson: _errorToJson, fromJson: _errorFromJson)
  final Object? error;
  final String? stackTrace;
  final String? userId;
  final String? sessionId;
  const LogEntryModel(
    this.id,
    this.timestamp,
    this.message,
    this.level,
    this.category,
    this.tag,
    this.metadata,
    this.error,
    this.stackTrace,
    this.userId,
    this.sessionId,
  );

  factory LogEntryModel.fromJson(Map<String, dynamic> json) => _$LogEntryModelFromJson(json);

  Map<String, dynamic> toJson() => _$LogEntryModelToJson(this);

  static String? _errorToJson(Object? error) {
    return error?.toString();
  }

  static Object? _errorFromJson(dynamic json) {
    return json;
  }
}
