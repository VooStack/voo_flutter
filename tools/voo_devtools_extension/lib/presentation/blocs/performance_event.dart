import 'package:equatable/equatable.dart';
import 'package:voo_devtools_extension/core/models/log_entry_model.dart';

abstract class PerformanceEvent extends Equatable {
  const PerformanceEvent();

  @override
  List<Object?> get props => [];
}

class LoadPerformanceLogs extends PerformanceEvent {}

class PerformanceLogReceived extends PerformanceEvent {
  final LogEntryModel log;

  const PerformanceLogReceived(this.log);

  @override
  List<Object?> get props => [log];
}

class ClearPerformanceLogs extends PerformanceEvent {}

class FilterPerformanceLogs extends PerformanceEvent {
  final String? operationType;
  final bool? showSlowOnly;
  final String? searchQuery;

  const FilterPerformanceLogs({
    this.operationType,
    this.showSlowOnly,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [operationType, showSlowOnly, searchQuery];
}

class SelectPerformanceLog extends PerformanceEvent {
  final LogEntryModel? log;

  const SelectPerformanceLog(this.log);

  @override
  List<Object?> get props => [log];
}
