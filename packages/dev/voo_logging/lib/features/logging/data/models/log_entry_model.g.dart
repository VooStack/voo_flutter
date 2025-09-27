// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogEntryModel _$LogEntryModelFromJson(Map<String, dynamic> json) => LogEntryModel(
  json['id'] as String,
  DateTime.parse(json['timestamp'] as String),
  json['message'] as String,
  $enumDecode(_$LogLevelEnumMap, json['level']),
  json['category'] as String?,
  json['tag'] as String?,
  json['metadata'] as Map<String, dynamic>?,
  LogEntryModel._errorFromJson(json['error']),
  json['stackTrace'] as String?,
  json['userId'] as String?,
  json['sessionId'] as String?,
);

Map<String, dynamic> _$LogEntryModelToJson(LogEntryModel instance) => <String, dynamic>{
  'id': instance.id,
  'timestamp': instance.timestamp.toIso8601String(),
  'message': instance.message,
  'level': _$LogLevelEnumMap[instance.level]!,
  'category': instance.category,
  'tag': instance.tag,
  'metadata': instance.metadata,
  'error': LogEntryModel._errorToJson(instance.error),
  'stackTrace': instance.stackTrace,
  'userId': instance.userId,
  'sessionId': instance.sessionId,
};

const _$LogLevelEnumMap = {
  LogLevel.verbose: 'verbose',
  LogLevel.debug: 'debug',
  LogLevel.info: 'info',
  LogLevel.warning: 'warning',
  LogLevel.error: 'error',
  LogLevel.fatal: 'fatal',
};
