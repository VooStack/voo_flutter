import 'package:equatable/equatable.dart';
import 'package:voo_logging_devtools_extension/core/models/log_entry_model.dart';

abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAnalyticsEvents extends AnalyticsEvent {}

class FilterAnalyticsEvents extends AnalyticsEvent {
  final List<LogEntryModel> events;

  const FilterAnalyticsEvents(this.events);

  @override
  List<Object?> get props => [events];
}

class SelectAnalyticsEvent extends AnalyticsEvent {
  final LogEntryModel event;

  const SelectAnalyticsEvent(this.event);

  @override
  List<Object?> get props => [event];
}

class ClearAnalyticsEvents extends AnalyticsEvent {}

class SearchAnalyticsEvents extends AnalyticsEvent {
  final String query;

  const SearchAnalyticsEvents(this.query);

  @override
  List<Object?> get props => [query];
}