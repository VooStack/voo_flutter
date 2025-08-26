import 'package:equatable/equatable.dart';
import 'package:voo_logging/core/domain/enums/log_level.dart';

/// Filter criteria for querying logs
class LogFilter extends Equatable {
  final DateTime? startTime;
  final DateTime? endTime;
  final List<LogLevel>? levels;
  final List<String>? categories;
  final List<String>? tags;
  final String? searchQuery;
  final String? userId;
  final String? sessionId;
  final bool? hasError;

  const LogFilter({this.startTime, this.endTime, this.levels, this.categories, this.tags, this.searchQuery, this.userId, this.sessionId, this.hasError});

  LogFilter copyWith({
    DateTime? startTime,
    DateTime? endTime,
    List<LogLevel>? levels,
    List<String>? categories,
    List<String>? tags,
    String? searchQuery,
    String? userId,
    String? sessionId,
    bool? hasError,
  }) => LogFilter(
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    levels: levels ?? this.levels,
    categories: categories ?? this.categories,
    tags: tags ?? this.tags,
    searchQuery: searchQuery ?? this.searchQuery,
    userId: userId ?? this.userId,
    sessionId: sessionId ?? this.sessionId,
    hasError: hasError ?? this.hasError,
  );

  @override
  List<Object?> get props => [startTime, endTime, levels, categories, tags, searchQuery, userId, sessionId, hasError];
}
