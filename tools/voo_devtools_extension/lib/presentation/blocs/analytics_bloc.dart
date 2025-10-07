import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_devtools_extension/domain/repositories/devtools_log_repository.dart';
import 'package:voo_devtools_extension/presentation/blocs/analytics_event.dart';
import 'package:voo_devtools_extension/presentation/blocs/analytics_state.dart';
import 'package:voo_devtools_extension/core/models/log_entry_model.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final DevToolsLogRepository repository;
  StreamSubscription? _logsSubscription;

  AnalyticsBloc({required this.repository}) : super(const AnalyticsState()) {
    on<LoadAnalyticsEvents>(_onLoadAnalyticsEvents);
    on<FilterAnalyticsEvents>(_onFilterAnalyticsEvents);
    on<SelectAnalyticsEvent>(_onSelectAnalyticsEvent);
    on<ClearAnalyticsEvents>(_onClearAnalyticsEvents);
    on<SearchAnalyticsEvents>(_onSearchAnalyticsEvents);
  }

  Future<void> _onLoadAnalyticsEvents(
    LoadAnalyticsEvents event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      await _logsSubscription?.cancel();

      // Get initial cached logs
      final cachedLogs = repository.getCachedLogs();
      final analyticsLogs = cachedLogs
          .where(
            (log) =>
                log.category?.toLowerCase() == 'analytics' ||
                log.tag == 'VooAnalytics' ||
                (log.metadata?['type'] == 'touch_event') ||
                (log.metadata?['type'] == 'analytics_event') ||
                (log.metadata?['type'] == 'route_screenshot') ||
                log.message.contains('Touch event') ||
                log.message.contains('Analytics event'),
          )
          .toList();

      add(FilterAnalyticsEvents(analyticsLogs));

      // Listen to new logs
      _logsSubscription = repository.logStream.listen((log) {
        if (log.category?.toLowerCase() == 'analytics' ||
            log.tag == 'VooAnalytics' ||
            (log.metadata?['type'] == 'touch_event') ||
            (log.metadata?['type'] == 'analytics_event') ||
            (log.metadata?['type'] == 'route_screenshot') ||
            log.message.contains('Touch event') ||
            log.message.contains('Analytics event')) {
          final updatedLogs = [...state.allEvents, log];
          add(FilterAnalyticsEvents(updatedLogs));
        }
      });
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onFilterAnalyticsEvents(
    FilterAnalyticsEvents event,
    Emitter<AnalyticsState> emit,
  ) {
    final filtered = _applyFilters(event.events);
    emit(
      state.copyWith(
        allEvents: event.events,
        filteredEvents: filtered,
        isLoading: false,
      ),
    );
  }

  void _onSelectAnalyticsEvent(
    SelectAnalyticsEvent event,
    Emitter<AnalyticsState> emit,
  ) {
    emit(state.copyWith(selectedEvent: event.event));
  }

  void _onClearAnalyticsEvents(
    ClearAnalyticsEvents event,
    Emitter<AnalyticsState> emit,
  ) {
    emit(const AnalyticsState());
    repository.clearLogs();
  }

  void _onSearchAnalyticsEvents(
    SearchAnalyticsEvents event,
    Emitter<AnalyticsState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
    final filtered = _applyFilters(state.allEvents);
    emit(state.copyWith(filteredEvents: filtered));
  }

  List<LogEntryModel> _applyFilters(List<LogEntryModel> events) {
    var filtered = events;

    if (state.searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (e) =>
                e.message.toLowerCase().contains(
                  state.searchQuery.toLowerCase(),
                ) ||
                e.category?.toLowerCase().contains(
                      state.searchQuery.toLowerCase(),
                    ) ==
                    true ||
                e.metadata?.toString().toLowerCase().contains(
                      state.searchQuery.toLowerCase(),
                    ) ==
                    true,
          )
          .toList();
    }

    return filtered;
  }

  @override
  Future<void> close() {
    _logsSubscription?.cancel();
    return super.close();
  }
}
