import 'package:equatable/equatable.dart';
import 'package:voo_logging/features/logging/data/models/log_entry_model.dart';

class NetworkState extends Equatable {
  final List<LogEntryModel> networkLogs;
  final List<LogEntryModel> filteredNetworkLogs;
  final LogEntryModel? selectedLog;
  final bool isLoading;
  final String? error;
  final String? methodFilter;
  final String? statusFilter;
  final String? searchQuery;

  const NetworkState({
    this.networkLogs = const [],
    this.filteredNetworkLogs = const [],
    this.selectedLog,
    this.isLoading = false,
    this.error,
    this.methodFilter,
    this.statusFilter,
    this.searchQuery,
  });

  NetworkState copyWith({
    List<LogEntryModel>? networkLogs,
    List<LogEntryModel>? filteredNetworkLogs,
    LogEntryModel? selectedLog,
    bool? isLoading,
    String? error,
    String? methodFilter,
    String? statusFilter,
    String? searchQuery,
  }) {
    return NetworkState(
      networkLogs: networkLogs ?? this.networkLogs,
      filteredNetworkLogs: filteredNetworkLogs ?? this.filteredNetworkLogs,
      selectedLog: selectedLog,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      methodFilter: methodFilter ?? this.methodFilter,
      statusFilter: statusFilter ?? this.statusFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        networkLogs,
        filteredNetworkLogs,
        selectedLog,
        isLoading,
        error,
        methodFilter,
        statusFilter,
        searchQuery,
      ];
}