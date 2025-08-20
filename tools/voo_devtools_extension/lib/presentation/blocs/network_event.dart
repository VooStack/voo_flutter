import 'package:equatable/equatable.dart';
import 'package:voo_logging_devtools_extension/core/models/log_entry_model.dart';
import 'package:voo_logging_devtools_extension/core/models/network_request_model.dart';

abstract class NetworkEvent extends Equatable {
  const NetworkEvent();

  @override
  List<Object?> get props => [];
}

class LoadNetworkLogs extends NetworkEvent {}

class NetworkLogReceived extends NetworkEvent {
  final LogEntryModel log;

  const NetworkLogReceived(this.log);

  @override
  List<Object?> get props => [log];
}

class ClearNetworkLogs extends NetworkEvent {}

class FilterNetworkLogs extends NetworkEvent {
  final String? method;
  final String? statusFilter;
  final String? searchQuery;

  const FilterNetworkLogs({
    this.method,
    this.statusFilter,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [method, statusFilter, searchQuery];
}

class SelectNetworkRequest extends NetworkEvent {
  final NetworkRequestModel? request;

  const SelectNetworkRequest(this.request);

  @override
  List<Object?> get props => [request];
}

// Keep old event for compatibility
@Deprecated('Use SelectNetworkRequest instead')
class SelectNetworkLog extends NetworkEvent {
  final LogEntryModel? log;

  const SelectNetworkLog(this.log);

  @override
  List<Object?> get props => [log];
}