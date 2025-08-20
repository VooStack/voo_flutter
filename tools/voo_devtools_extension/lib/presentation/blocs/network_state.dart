import 'package:equatable/equatable.dart';
import 'package:voo_logging_devtools_extension/core/models/network_request_model.dart';

class NetworkState extends Equatable {
  final List<NetworkRequestModel> networkRequests;
  final List<NetworkRequestModel> filteredNetworkRequests;
  final NetworkRequestModel? selectedRequest;
  final bool isLoading;
  final String? error;
  final String? methodFilter;
  final String? statusFilter;
  final String? searchQuery;

  const NetworkState({
    this.networkRequests = const [],
    this.filteredNetworkRequests = const [],
    this.selectedRequest,
    this.isLoading = false,
    this.error,
    this.methodFilter,
    this.statusFilter,
    this.searchQuery,
  });

  NetworkState copyWith({
    List<NetworkRequestModel>? networkRequests,
    List<NetworkRequestModel>? filteredNetworkRequests,
    NetworkRequestModel? Function()? selectedRequest,
    bool? isLoading,
    String? error,
    String? methodFilter,
    String? statusFilter,
    String? searchQuery,
  }) {
    return NetworkState(
      networkRequests: networkRequests ?? this.networkRequests,
      filteredNetworkRequests:
          filteredNetworkRequests ?? this.filteredNetworkRequests,
      selectedRequest: selectedRequest != null
          ? selectedRequest()
          : this.selectedRequest,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      methodFilter: methodFilter ?? this.methodFilter,
      statusFilter: statusFilter ?? this.statusFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    networkRequests,
    filteredNetworkRequests,
    selectedRequest,
    isLoading,
    error,
    methodFilter,
    statusFilter,
    searchQuery,
  ];
}
