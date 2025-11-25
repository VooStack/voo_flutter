import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
  final DateTimeRange? dateRange;

  /// Set of favorited log IDs
  final Set<String> favoriteIds;

  /// Whether to show only favorites
  final bool showFavoritesOnly;

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
    this.dateRange,
    this.favoriteIds = const {},
    this.showFavoritesOnly = false,
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
    DateTimeRange? dateRange,
    bool clearDateRange = false,
    Set<String>? favoriteIds,
    bool? showFavoritesOnly,
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
    dateRange: clearDateRange ? null : (dateRange ?? this.dateRange),
    favoriteIds: favoriteIds ?? this.favoriteIds,
    showFavoritesOnly: showFavoritesOnly ?? this.showFavoritesOnly,
  );

  /// Whether any filters are currently active
  bool get hasActiveFilters =>
      (selectedLevels != null && selectedLevels!.isNotEmpty) ||
      (selectedCategory != null && selectedCategory!.isNotEmpty && selectedCategory != 'All') ||
      searchQuery.isNotEmpty ||
      dateRange != null ||
      showFavoritesOnly;

  /// Check if a log is favorited
  bool isFavorite(String logId) => favoriteIds.contains(logId);

  /// Get the count of favorites
  int get favoriteCount => favoriteIds.length;

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
    dateRange,
    favoriteIds,
    showFavoritesOnly,
  ];
}
