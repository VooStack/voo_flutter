// ignore: depend_on_referenced_packages
import 'package:equatable/equatable.dart';
import 'package:voo_logging_devtools_extension/core/models/log_level.dart';
import 'package:voo_logging_devtools_extension/core/models/log_entry_model.dart';

abstract class LogEvent extends Equatable {
  const LogEvent();

  @override
  List<Object?> get props => [];
}

class LoadLogs extends LogEvent {}

class FilterLogsChanged extends LogEvent {
  final List<LogLevel>? levels;
  final String? category;

  const FilterLogsChanged({this.levels, this.category});

  @override
  List<Object?> get props => [levels, category];
}

class LogReceived extends LogEvent {
  final LogEntryModel log;

  const LogReceived(this.log);

  @override
  List<Object?> get props => [log];
}

class SelectLog extends LogEvent {
  final LogEntryModel? log;

  const SelectLog(this.log);

  @override
  List<Object?> get props => [log];
}

class ClearLogs extends LogEvent {}

class ToggleAutoScroll extends LogEvent {}

class SearchQueryChanged extends LogEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class StreamChanged extends LogEvent {
  final Stream<LogEntryModel> stream;

  const StreamChanged(this.stream);

  @override
  List<Object?> get props => [stream];
}
