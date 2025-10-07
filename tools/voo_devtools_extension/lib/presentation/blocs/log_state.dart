import 'package:equatable/equatable.dart';
import 'package:voo_devtools_extension/core/models/log_level.dart';
import 'package:voo_devtools_extension/core/models/log_entry_model.dart';
import 'package:voo_devtools_extension/core/models/log_statistics.dart';

class LogState extends Equatable {
  final List<LogEntryModel> logs;
  final List<LogEntryModel> filteredLogs;
  final LogEntryModel? selectedLog;
  final List<LogLevel>? selectedLevels;
  final String? selectedCategory;
  final bool isLoading;
  final String? error;
  final bool autoScroll;
  final LogStatistics? statistics;
  final List<String> categories;
  final List<String> tags;
  final List<String> sessions;
  final String searchQuery;

  const LogState({
    this.logs = const [],
    this.filteredLogs = const [],
    this.selectedLog,
    this.selectedLevels,
    this.selectedCategory,
    this.isLoading = false,
    this.error,
    this.autoScroll = true,
    this.statistics,
    this.categories = const [],
    this.tags = const [],
    this.sessions = const [],
    this.searchQuery = '',
  });

  LogState copyWith({
    List<LogEntryModel>? logs,
    List<LogEntryModel>? filteredLogs,
    LogEntryModel? selectedLog,
    bool clearSelectedLog = false,
    List<LogLevel>? selectedLevels,
    String? selectedCategory,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool? autoScroll,
    LogStatistics? statistics,
    List<String>? categories,
    List<String>? tags,
    List<String>? sessions,
    String? searchQuery,
  }) => LogState(
    logs: logs ?? this.logs,
    filteredLogs: filteredLogs ?? this.filteredLogs,
    selectedLog: clearSelectedLog ? null : (selectedLog ?? this.selectedLog),
    selectedLevels: selectedLevels ?? this.selectedLevels,
    selectedCategory: selectedCategory ?? this.selectedCategory,
    isLoading: isLoading ?? this.isLoading,
    error: clearError ? null : (error ?? this.error),
    autoScroll: autoScroll ?? this.autoScroll,
    statistics: statistics ?? this.statistics,
    categories: categories ?? this.categories,
    tags: tags ?? this.tags,
    sessions: sessions ?? this.sessions,
    searchQuery: searchQuery ?? this.searchQuery,
  );

  @override
  List<Object?> get props => [
    logs,
    filteredLogs,
    selectedLog,
    selectedLevels,
    selectedCategory,
    isLoading,
    error,
    autoScroll,
    statistics,
    categories,
    tags,
    sessions,
    searchQuery,
  ];
}
