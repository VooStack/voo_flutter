import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_logging/features/logging/data/models/log_entry_model.dart';
import 'package:voo_logging/features/logging/data/models/log_entry_model_extensions.dart';
import 'package:voo_logging/features/logging/domain/entities/log_statistics_extensions.dart';
import 'package:voo_logging_devtools_extension/domain/repositories/devtools_log_repository.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/log_event.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/log_state.dart';

class LogBloc extends Bloc<LogEvent, LogState> {
  final DevToolsLogRepository repository;

  late final StreamSubscription<LogEntryModel>? logStreamSubscription;

  LogBloc({required this.repository}) : super(const LogState()) {
    on<LoadLogs>(_onLoadLogs);
    on<FilterLogsChanged>(_onFilterLogsChanged);
    on<LogReceived>(_onLogReceived);
    on<SelectLog>(_onSelectLog);
    on<ClearLogs>(_onClearLogs);
    on<ToggleAutoScroll>(_onToggleAutoScroll);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<StreamChanged>(_onStreamChanged);

    add(LoadLogs());
    logStreamSubscription = repository.logStream.listen(
      (log) => add(LogReceived(log)),
      onError: (Object error) {
        log('Error receiving log: $error', name: 'LogBloc', level: 1000);
      },
    );
  }

  void _onStreamChanged(StreamChanged event, Emitter<LogState> emit) {
    logStreamSubscription = event.stream.listen((log) {
      final category = log.category ?? 'Uncategorized';
      if (!state.categories.contains(category)) {
        emit(state.copyWith(categories: [...state.categories, category]));
      }
      add(LogReceived(log));
    }, onError: (Object error) => emit(state.copyWith(error: error.toString())));
  }

  Future<void> _onLoadLogs(LoadLogs event, Emitter<LogState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));

      final cachedLogs = repository.getCachedLogs();

      log('LoadLogs - Found ${cachedLogs.length} cached logs', name: 'LogBloc', level: 800);

      final filteredLogs = _applyFilters(cachedLogs, state);
      final statistics = LogStatisticsExtensions.fromLogs(cachedLogs.map((log) => log.toEntity()).toList());
      final uniqueCategories = cachedLogs.where((log) => log.category != null && log.category != 'All').map((log) => log.category!).toSet().toList()..sort();
      final categories = ['All', ...uniqueCategories];

      emit(state.copyWith(logs: cachedLogs, isLoading: false, filteredLogs: filteredLogs, statistics: statistics, categories: categories));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onFilterLogsChanged(FilterLogsChanged event, Emitter<LogState> emit) async {
    final newState = state.copyWith(selectedLevels: event.levels, selectedCategory: event.category);
    final filteredLogs = _applyFilters(state.logs, newState);

    emit(newState.copyWith(filteredLogs: filteredLogs));
  }

  void _onLogReceived(LogReceived event, Emitter<LogState> emit) {
    log('Log received: ${event.log.id} - ${event.log.message}', name: 'LogBloc', level: 800);

    final updatedLogs = [...state.logs, event.log];
    final filtered = _applyFilters(updatedLogs, state);

    log('Total logs: ${updatedLogs.length}, Filtered: ${filtered.length}', name: 'LogBloc', level: 800);

    final statistics = LogStatisticsExtensions.fromLogs(updatedLogs.map((log) => log.toEntity()).toList());

    // Update categories if a new category is found
    var updatedCategories = state.categories;
    if (event.log.category != null && event.log.category != 'All' && !state.categories.contains(event.log.category)) {
      // Extract all unique categories from all logs (excluding 'All') and keep 'All' at the beginning
      final allCategories = updatedLogs.where((log) => log.category != null && log.category != 'All').map((log) => log.category!).toSet().toList()..sort();
      updatedCategories = ['All', ...allCategories];
    }

    emit(state.copyWith(logs: updatedLogs, filteredLogs: filtered, statistics: statistics, categories: updatedCategories));
  }

  void _onSelectLog(SelectLog event, Emitter<LogState> emit) {
    if (event.log == null) {
      emit(state.copyWith(clearSelectedLog: true));
    } else {
      emit(state.copyWith(selectedLog: event.log));
    }
  }

  Future<void> _onClearLogs(ClearLogs event, Emitter<LogState> emit) async {
    repository.clearLogs();
    emit(state.copyWith(logs: [], filteredLogs: [], statistics: LogStatisticsExtensions.fromLogs([]), clearSelectedLog: true));
  }

  void _onToggleAutoScroll(ToggleAutoScroll event, Emitter<LogState> emit) {
    emit(state.copyWith(autoScroll: !state.autoScroll));
  }

  void _onSearchQueryChanged(SearchQueryChanged event, Emitter<LogState> emit) {
    emit(
      state.copyWith(
        searchQuery: event.query,
        filteredLogs: _applyFilters(state.logs, state.copyWith(searchQuery: event.query)),
      ),
    );
  }

  List<LogEntryModel> _applyFilters(List<LogEntryModel> logs, LogState state) {
    var filtered = logs;

    // Apply level filter
    if (state.selectedLevels != null && state.selectedLevels!.isNotEmpty) {
      filtered = filtered.where((log) => state.selectedLevels!.contains(log.level)).toList();
    }

    // Apply category filter (skip if "All" is selected)
    if (state.selectedCategory != null && state.selectedCategory!.isNotEmpty && state.selectedCategory != 'All') {
      filtered = filtered.where((log) => log.category == state.selectedCategory).toList();
    }

    // Apply search filter
    if (state.searchQuery.isNotEmpty) {
      // Check if query is a regex pattern (starts and ends with /)
      if (state.searchQuery.startsWith('/') && state.searchQuery.endsWith('/') && state.searchQuery.length > 2) {
        try {
          final pattern = state.searchQuery.substring(1, state.searchQuery.length - 1);
          final regex = RegExp(pattern, caseSensitive: false);
          filtered = filtered
              .where(
                (log) =>
                    regex.hasMatch(log.message) ||
                    (log.category != null && regex.hasMatch(log.category!)) ||
                    (log.tag != null && regex.hasMatch(log.tag!)) ||
                    (log.error != null && regex.hasMatch(log.error.toString())),
              )
              .toList();
        } catch (e) {
          // If regex is invalid, fall back to regular search
          final query = state.searchQuery.toLowerCase();
          filtered = filtered
              .where(
                (log) =>
                    log.message.toLowerCase().contains(query) ||
                    (log.category?.toLowerCase().contains(query) ?? false) ||
                    (log.tag?.toLowerCase().contains(query) ?? false) ||
                    (log.error?.toString().toLowerCase().contains(query) ?? false),
              )
              .toList();
        }
      } else {
        // Regular text search
        final query = state.searchQuery.toLowerCase();
        filtered = filtered
            .where(
              (log) =>
                  log.message.toLowerCase().contains(query) ||
                  (log.category?.toLowerCase().contains(query) ?? false) ||
                  (log.tag?.toLowerCase().contains(query) ?? false) ||
                  (log.error?.toString().toLowerCase().contains(query) ?? false),
            )
            .toList();
      }
    }

    return filtered;
  }

  @override
  Future<void> close() {
    logStreamSubscription?.cancel();
    return super.close();
  }
}
