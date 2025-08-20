import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_logging_devtools_extension/core/models/log_entry_model.dart';
import 'package:voo_logging_devtools_extension/domain/repositories/devtools_log_repository.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/performance_event.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/performance_state.dart';

class PerformanceBloc extends Bloc<PerformanceEvent, PerformanceState> {
  final DevToolsLogRepository repository;
  StreamSubscription<LogEntryModel>? _logSubscription;

  PerformanceBloc({required this.repository}) : super(const PerformanceState()) {
    on<LoadPerformanceLogs>(_onLoadPerformanceLogs);
    on<PerformanceLogReceived>(_onPerformanceLogReceived);
    on<ClearPerformanceLogs>(_onClearPerformanceLogs);
    on<FilterPerformanceLogs>(_onFilterPerformanceLogs);
    on<SelectPerformanceLog>(_onSelectPerformanceLog);
  }

  Future<void> _onLoadPerformanceLogs(LoadPerformanceLogs event, Emitter<PerformanceState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Get cached logs that are performance-related
      final cachedLogs = repository.getCachedLogs();
      final performanceLogs = cachedLogs.where((log) => log.category == 'Performance').toList();

      final averages = _calculateAverageDurations(performanceLogs);

      emit(state.copyWith(
        performanceLogs: performanceLogs,
        filteredPerformanceLogs: performanceLogs,
        averageDurations: averages,
        isLoading: false,
      ));

      // Subscribe to new logs
      await _logSubscription?.cancel();
      _logSubscription = repository.logStream.listen((log) {
        if (log.category == 'Performance') {
          add(PerformanceLogReceived(log));
        }
      });
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }

  void _onPerformanceLogReceived(PerformanceLogReceived event, Emitter<PerformanceState> emit) {
    final updatedLogs = [...state.performanceLogs, event.log];
    final filteredLogs = _applyFilters(updatedLogs);
    final averages = _calculateAverageDurations(updatedLogs);
    
    emit(state.copyWith(
      performanceLogs: updatedLogs,
      filteredPerformanceLogs: filteredLogs,
      averageDurations: averages,
    ));
  }

  void _onClearPerformanceLogs(ClearPerformanceLogs event, Emitter<PerformanceState> emit) {
    emit(state.copyWith(
      performanceLogs: [],
      filteredPerformanceLogs: [],
      selectedLog: null,
      averageDurations: {},
    ));
  }

  void _onFilterPerformanceLogs(FilterPerformanceLogs event, Emitter<PerformanceState> emit) {
    final filteredLogs = _applyFilters(
      state.performanceLogs,
      operationType: event.operationType,
      showSlowOnly: event.showSlowOnly,
      searchQuery: event.searchQuery,
    );

    emit(state.copyWith(
      filteredPerformanceLogs: filteredLogs,
      operationTypeFilter: event.operationType,
      showSlowOnly: event.showSlowOnly ?? state.showSlowOnly,
      searchQuery: event.searchQuery,
    ));
  }

  void _onSelectPerformanceLog(SelectPerformanceLog event, Emitter<PerformanceState> emit) {
    emit(state.copyWith(selectedLog: event.log));
  }

  List<LogEntryModel> _applyFilters(
    List<LogEntryModel> logs, {
    String? operationType,
    bool? showSlowOnly,
    String? searchQuery,
  }) {
    operationType ??= state.operationTypeFilter;
    showSlowOnly ??= state.showSlowOnly;
    searchQuery ??= state.searchQuery;

    var filtered = logs;

    // Filter by operation type
    if (operationType != null && operationType.isNotEmpty) {
      filtered = filtered.where((log) {
        final metadata = log.metadata;
        return metadata?['operationType'] == operationType;
      }).toList();
    }

    // Filter slow operations only
    if (showSlowOnly) {
      filtered = filtered.where((log) {
        final metadata = log.metadata;
        final duration = metadata?['duration'] as int?;
        return duration != null && duration > 1000;
      }).toList();
    }

    // Filter by search query
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered.where((log) {
        return log.message.toLowerCase().contains(query) ||
            (log.metadata?['operation']?.toString().toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return filtered;
  }

  Map<String, double> _calculateAverageDurations(List<LogEntryModel> logs) {
    final operationDurations = <String, List<int>>{};

    for (final log in logs) {
      final operation = log.metadata?['operation'] as String? ?? 'Unknown';
      final duration = log.metadata?['duration'] as int?;
      
      if (duration != null) {
        operationDurations.putIfAbsent(operation, () => []).add(duration);
      }
    }

    final averages = <String, double>{};
    operationDurations.forEach((operation, durations) {
      if (durations.isNotEmpty) {
        averages[operation] = durations.reduce((a, b) => a + b) / durations.length;
      }
    });

    return averages;
  }

  @override
  Future<void> close() {
    _logSubscription?.cancel();
    return super.close();
  }
}