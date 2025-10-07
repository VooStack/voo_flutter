import 'package:equatable/equatable.dart';
import 'package:voo_devtools_extension/core/models/log_entry_model.dart';

class PerformanceState extends Equatable {
  final List<LogEntryModel> performanceLogs;
  final List<LogEntryModel> filteredPerformanceLogs;
  final LogEntryModel? selectedLog;
  final bool isLoading;
  final String? error;
  final String? operationTypeFilter;
  final bool showSlowOnly;
  final String? searchQuery;
  final Map<String, double> averageDurations;

  const PerformanceState({
    this.performanceLogs = const [],
    this.filteredPerformanceLogs = const [],
    this.selectedLog,
    this.isLoading = false,
    this.error,
    this.operationTypeFilter,
    this.showSlowOnly = false,
    this.searchQuery,
    this.averageDurations = const {},
  });

  PerformanceState copyWith({
    List<LogEntryModel>? performanceLogs,
    List<LogEntryModel>? filteredPerformanceLogs,
    LogEntryModel? selectedLog,
    bool? isLoading,
    String? error,
    String? operationTypeFilter,
    bool? showSlowOnly,
    String? searchQuery,
    Map<String, double>? averageDurations,
  }) {
    return PerformanceState(
      performanceLogs: performanceLogs ?? this.performanceLogs,
      filteredPerformanceLogs:
          filteredPerformanceLogs ?? this.filteredPerformanceLogs,
      selectedLog: selectedLog,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      operationTypeFilter: operationTypeFilter ?? this.operationTypeFilter,
      showSlowOnly: showSlowOnly ?? this.showSlowOnly,
      searchQuery: searchQuery ?? this.searchQuery,
      averageDurations: averageDurations ?? this.averageDurations,
    );
  }

  @override
  List<Object?> get props => [
    performanceLogs,
    filteredPerformanceLogs,
    selectedLog,
    isLoading,
    error,
    operationTypeFilter,
    showSlowOnly,
    searchQuery,
    averageDurations,
  ];
}
