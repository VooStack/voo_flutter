import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_logging_devtools_extension/core/models/log_entry_model.dart';
import 'package:voo_logging_devtools_extension/core/models/network_request_model.dart';
import 'package:voo_logging_devtools_extension/domain/repositories/devtools_log_repository.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/network_event.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  final DevToolsLogRepository repository;
  StreamSubscription<LogEntryModel>? _logSubscription;
  final Map<String, NetworkRequestModel> _requestMap = {};

  NetworkBloc({required this.repository}) : super(const NetworkState()) {
    on<LoadNetworkLogs>(_onLoadNetworkLogs);
    on<NetworkLogReceived>(_onNetworkLogReceived);
    on<ClearNetworkLogs>(_onClearNetworkLogs);
    on<FilterNetworkLogs>(_onFilterNetworkLogs);
    on<SelectNetworkRequest>(_onSelectNetworkRequest);
    on<SelectNetworkLog>(_onSelectNetworkLog);
  }

  Future<void> _onLoadNetworkLogs(
    LoadNetworkLogs event,
    Emitter<NetworkState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Clear request map
      _requestMap.clear();

      // Get cached logs that are network-related
      final cachedLogs = repository.getCachedLogs();
      final networkLogs = cachedLogs
          .where((log) => log.category == 'Network')
          .toList();

      // Process logs into network requests
      for (final log in networkLogs) {
        _processNetworkLog(log);
      }

      final requests = _requestMap.values.toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

      emit(
        state.copyWith(
          networkRequests: requests,
          filteredNetworkRequests: _applyFilters(requests),
          isLoading: false,
        ),
      );

      // Subscribe to new logs
      await _logSubscription?.cancel();
      _logSubscription = repository.logStream.listen((log) {
        if (log.category == 'Network') {
          add(NetworkLogReceived(log));
        }
      });
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void _onNetworkLogReceived(
    NetworkLogReceived event,
    Emitter<NetworkState> emit,
  ) {
    // Process the new log
    _processNetworkLog(event.log);

    // Get all requests sorted by timestamp
    final requests = _requestMap.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    final filteredRequests = _applyFilters(requests);

    emit(
      state.copyWith(
        networkRequests: requests,
        filteredNetworkRequests: filteredRequests,
      ),
    );
  }

  void _processNetworkLog(LogEntryModel log) {
    final newRequest = NetworkRequestModel.fromLogEntry(log);

    // Try to find an existing request to merge with
    final existingRequest = _requestMap[newRequest.id];

    if (existingRequest != null) {
      // Merge the requests
      _requestMap[newRequest.id] = existingRequest.merge(newRequest);
    } else {
      // Check if this might be a response for a pending request
      bool merged = false;
      for (final entry in _requestMap.entries) {
        if (entry.value.isSameRequest(newRequest)) {
          _requestMap[entry.key] = entry.value.merge(newRequest);
          merged = true;
          break;
        }
      }

      if (!merged) {
        // Add as new request
        _requestMap[newRequest.id] = newRequest;
      }
    }
  }

  void _onClearNetworkLogs(ClearNetworkLogs event, Emitter<NetworkState> emit) {
    _requestMap.clear();
    emit(
      state.copyWith(
        networkRequests: [],
        filteredNetworkRequests: [],
        selectedRequest: () => null,
      ),
    );
  }

  void _onFilterNetworkLogs(
    FilterNetworkLogs event,
    Emitter<NetworkState> emit,
  ) {
    final filteredRequests = _applyFilters(
      state.networkRequests,
      method: event.method,
      statusFilter: event.statusFilter,
      searchQuery: event.searchQuery,
    );

    emit(
      state.copyWith(
        filteredNetworkRequests: filteredRequests,
        methodFilter: event.method,
        statusFilter: event.statusFilter,
        searchQuery: event.searchQuery,
      ),
    );
  }

  void _onSelectNetworkRequest(
    SelectNetworkRequest event,
    Emitter<NetworkState> emit,
  ) {
    emit(state.copyWith(selectedRequest: () => event.request));
  }

  void _onSelectNetworkLog(SelectNetworkLog event, Emitter<NetworkState> emit) {
    // Convert log to request for backwards compatibility
    if (event.log != null) {
      final request = NetworkRequestModel.fromLogEntry(event.log!);
      emit(state.copyWith(selectedRequest: () => request));
    } else {
      emit(state.copyWith(selectedRequest: () => null));
    }
  }

  List<NetworkRequestModel> _applyFilters(
    List<NetworkRequestModel> requests, {
    String? method,
    String? statusFilter,
    String? searchQuery,
  }) {
    method ??= state.methodFilter;
    statusFilter ??= state.statusFilter;
    searchQuery ??= state.searchQuery;

    var filtered = requests;

    // Filter by method
    if (method != null && method.isNotEmpty) {
      filtered = filtered.where((request) {
        return request.method == method;
      }).toList();
    }

    // Filter by status
    if (statusFilter != null && statusFilter.isNotEmpty) {
      filtered = filtered.where((request) {
        final statusCode = request.statusCode;
        if (statusCode == null && statusFilter != 'pending') return false;

        switch (statusFilter) {
          case 'success':
            return statusCode != null && statusCode >= 200 && statusCode < 300;
          case 'error':
            return statusCode != null && statusCode >= 400;
          case 'redirect':
            return statusCode != null && statusCode >= 300 && statusCode < 400;
          case 'pending':
            return request.isInProgress;
          default:
            return true;
        }
      }).toList();
    }

    // Filter by search query
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered.where((request) {
        return request.url.toLowerCase().contains(query) ||
            request.method.toLowerCase().contains(query) ||
            request.displayStatus.toLowerCase().contains(query);
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
