import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_logging/features/logging/data/models/log_entry_model.dart';
import 'package:voo_logging_devtools_extension/domain/repositories/devtools_log_repository.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/network_event.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  final DevToolsLogRepository repository;
  StreamSubscription<LogEntryModel>? _logSubscription;

  NetworkBloc({required this.repository}) : super(const NetworkState()) {
    on<LoadNetworkLogs>(_onLoadNetworkLogs);
    on<NetworkLogReceived>(_onNetworkLogReceived);
    on<ClearNetworkLogs>(_onClearNetworkLogs);
    on<FilterNetworkLogs>(_onFilterNetworkLogs);
    on<SelectNetworkLog>(_onSelectNetworkLog);
  }

  Future<void> _onLoadNetworkLogs(LoadNetworkLogs event, Emitter<NetworkState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Get cached logs that are network-related
      final cachedLogs = repository.getCachedLogs();
      final networkLogs = cachedLogs.where((log) => log.category == 'Network').toList();

      emit(state.copyWith(
        networkLogs: networkLogs,
        filteredNetworkLogs: networkLogs,
        isLoading: false,
      ));

      // Subscribe to new logs
      await _logSubscription?.cancel();
      _logSubscription = repository.logStream.listen((log) {
        if (log.category == 'Network') {
          add(NetworkLogReceived(log));
        }
      });
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }

  void _onNetworkLogReceived(NetworkLogReceived event, Emitter<NetworkState> emit) {
    final updatedLogs = [...state.networkLogs, event.log];
    final filteredLogs = _applyFilters(updatedLogs);
    
    emit(state.copyWith(
      networkLogs: updatedLogs,
      filteredNetworkLogs: filteredLogs,
    ));
  }

  void _onClearNetworkLogs(ClearNetworkLogs event, Emitter<NetworkState> emit) {
    emit(state.copyWith(
      networkLogs: [],
      filteredNetworkLogs: [],
      selectedLog: null,
    ));
  }

  void _onFilterNetworkLogs(FilterNetworkLogs event, Emitter<NetworkState> emit) {
    final filteredLogs = _applyFilters(
      state.networkLogs,
      method: event.method,
      statusFilter: event.statusFilter,
      searchQuery: event.searchQuery,
    );

    emit(state.copyWith(
      filteredNetworkLogs: filteredLogs,
      methodFilter: event.method,
      statusFilter: event.statusFilter,
      searchQuery: event.searchQuery,
    ));
  }

  void _onSelectNetworkLog(SelectNetworkLog event, Emitter<NetworkState> emit) {
    emit(state.copyWith(selectedLog: event.log));
  }

  List<LogEntryModel> _applyFilters(
    List<LogEntryModel> logs, {
    String? method,
    String? statusFilter,
    String? searchQuery,
  }) {
    method ??= state.methodFilter;
    statusFilter ??= state.statusFilter;
    searchQuery ??= state.searchQuery;

    var filtered = logs;

    // Filter by method
    if (method != null && method.isNotEmpty) {
      filtered = filtered.where((log) {
        final metadata = log.metadata;
        return metadata?['method'] == method;
      }).toList();
    }

    // Filter by status
    if (statusFilter != null && statusFilter.isNotEmpty) {
      filtered = filtered.where((log) {
        final metadata = log.metadata;
        final statusCode = metadata?['statusCode'] as int?;
        if (statusCode == null) return false;
        
        switch (statusFilter) {
          case 'success':
            return statusCode >= 200 && statusCode < 300;
          case 'error':
            return statusCode >= 400;
          case 'redirect':
            return statusCode >= 300 && statusCode < 400;
          default:
            return true;
        }
      }).toList();
    }

    // Filter by search query
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered.where((log) {
        return log.message.toLowerCase().contains(query) ||
            (log.metadata?['url']?.toString().toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return filtered;
  }

  @override
  Future<void> close() {
    _logSubscription?.cancel();
    return super.close();
  }
}