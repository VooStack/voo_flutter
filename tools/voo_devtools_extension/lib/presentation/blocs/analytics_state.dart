import 'package:equatable/equatable.dart';
import 'package:voo_logging/features/logging/data/models/log_entry_model.dart';

class AnalyticsState extends Equatable {
  final List<LogEntryModel> allEvents;
  final List<LogEntryModel> filteredEvents;
  final LogEntryModel? selectedEvent;
  final bool isLoading;
  final String? error;
  final String searchQuery;

  const AnalyticsState({
    this.allEvents = const [],
    this.filteredEvents = const [],
    this.selectedEvent,
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  AnalyticsState copyWith({
    List<LogEntryModel>? allEvents,
    List<LogEntryModel>? filteredEvents,
    LogEntryModel? selectedEvent,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return AnalyticsState(
      allEvents: allEvents ?? this.allEvents,
      filteredEvents: filteredEvents ?? this.filteredEvents,
      selectedEvent: selectedEvent,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        allEvents,
        filteredEvents,
        selectedEvent,
        isLoading,
        error,
        searchQuery,
      ];
}