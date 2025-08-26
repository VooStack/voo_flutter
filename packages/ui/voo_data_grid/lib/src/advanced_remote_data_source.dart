import 'dart:async';
import 'data_grid_source.dart';
import 'data_grid_column.dart';
import 'models/advanced_filters.dart';
import 'utils/data_grid_request_builder.dart';

/// Advanced remote data source with support for complex filtering
class AdvancedRemoteDataSource extends VooDataGridSource {
  final String apiEndpoint;
  final Map<String, String>? headers;
  final Future<Map<String, dynamic>> Function(
    String url,
    Map<String, dynamic> body,
    Map<String, String>? headers,
  )? httpClient;

  /// Whether to use advanced filter format
  bool useAdvancedFilters;

  /// Custom advanced filter request for direct API calls
  AdvancedFilterRequest? _customFilterRequest;

  AdvancedRemoteDataSource({
    required this.apiEndpoint,
    this.headers,
    this.httpClient,
    this.useAdvancedFilters = true,
  }) : super(mode: VooDataGridMode.remote);

  /// Set a custom advanced filter request
  void setAdvancedFilterRequest(AdvancedFilterRequest request) {
    _customFilterRequest = request;
    loadData();
  }

  /// Clear custom filter request and use standard filters
  void clearAdvancedFilterRequest() {
    _customFilterRequest = null;
  }

  @override
  Future<VooDataGridResponse> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    if (httpClient == null) {
      throw UnimplementedError(
        'Please provide an httpClient function to make API calls. '
        'Example: httpClient: (url, body, headers) async => await dio.post(url, data: body, options: Options(headers: headers)).then((r) => r.data)',
      );
    }

    Map<String, dynamic> requestBody;

    // Use custom advanced filter request if provided
    if (_customFilterRequest != null) {
      requestBody = DataGridRequestBuilder.buildAdvancedRequestBody(
        request: _customFilterRequest!,
      );
    }
    // Use advanced filter format if enabled
    else if (useAdvancedFilters) {
      final advancedRequest = DataGridRequestBuilder.convertToAdvancedRequest(
        filters: filters,
        sorts: sorts,
        page: page,
        pageSize: pageSize,
      );
      requestBody = DataGridRequestBuilder.buildAdvancedRequestBody(
        request: advancedRequest,
      );
    }
    // Fall back to standard format
    else {
      requestBody = DataGridRequestBuilder.buildRequestBody(
        page: page,
        pageSize: pageSize,
        filters: filters,
        sorts: sorts,
      );
    }

    final response = await httpClient!(apiEndpoint, requestBody, headers);

    // Parse response
    return DataGridRequestBuilder.parseResponse(json: response);
  }

  /// Apply an advanced filter with secondary filter support
  void applyAdvancedFilter({
    required String fieldName,
    required dynamic value,
    required String operator,
    SecondaryFilter? secondaryFilter,
    FilterType? filterType,
  }) {
    // Determine filter type if not provided
    filterType ??= _detectFilterType(value);

    // Create appropriate filter based on type
    BaseFilter filter;
    switch (filterType) {
      case FilterType.string:
        filter = StringFilter(
          fieldName: fieldName,
          value: value.toString(),
          operator: operator,
          secondaryFilter: secondaryFilter,
        );
        break;
      case FilterType.int:
        filter = IntFilter(
          fieldName: fieldName,
          value: value is int ? value : int.parse(value.toString()),
          operator: operator,
          secondaryFilter: secondaryFilter,
        );
        break;
      case FilterType.decimal:
        filter = DecimalFilter(
          fieldName: fieldName,
          value: value is double ? value : double.parse(value.toString()),
          operator: operator,
          secondaryFilter: secondaryFilter,
        );
        break;
      case FilterType.date:
      case FilterType.dateTime:
        filter = DateFilter(
          fieldName: fieldName,
          value: value is DateTime ? value : DateTime.parse(value.toString()),
          operator: operator,
          secondaryFilter: secondaryFilter,
        );
        break;
      case FilterType.bool:
        filter = BoolFilter(
          fieldName: fieldName,
          value: value is bool ? value : value.toString().toLowerCase() == 'true',
          operator: operator,
          secondaryFilter: secondaryFilter,
        );
        break;
    }

    // Update or create custom filter request
    _customFilterRequest ??= AdvancedFilterRequest();

    // Add filter to appropriate list
    final newRequest = _addFilterToRequest(_customFilterRequest!, filter);
    _customFilterRequest = newRequest;

    // Reload data with new filters
    loadData();
  }

  /// Helper to detect filter type from value
  FilterType _detectFilterType(dynamic value) {
    if (value is bool) return FilterType.bool;
    if (value is int) return FilterType.int;
    if (value is double) return FilterType.decimal;
    if (value is DateTime) return FilterType.date;
    if (value is String) return FilterType.string;
    // Default to string for unknown types
    return FilterType.string;
  }

  /// Helper to add a filter to the request
  AdvancedFilterRequest _addFilterToRequest(
      AdvancedFilterRequest request, BaseFilter filter) {
    final stringFilters = List<StringFilter>.from(request.stringFilters);
    final intFilters = List<IntFilter>.from(request.intFilters);
    final decimalFilters = List<DecimalFilter>.from(request.decimalFilters);
    final dateFilters = List<DateFilter>.from(request.dateFilters);
    final boolFilters = List<BoolFilter>.from(request.boolFilters);

    // Remove existing filter for the same field
    stringFilters.removeWhere((f) => f.fieldName == filter.fieldName);
    intFilters.removeWhere((f) => f.fieldName == filter.fieldName);
    decimalFilters.removeWhere((f) => f.fieldName == filter.fieldName);
    dateFilters.removeWhere((f) => f.fieldName == filter.fieldName);
    boolFilters.removeWhere((f) => f.fieldName == filter.fieldName);

    // Add new filter
    if (filter is StringFilter) {
      stringFilters.add(filter);
    } else if (filter is IntFilter) {
      intFilters.add(filter);
    } else if (filter is DecimalFilter) {
      decimalFilters.add(filter);
    } else if (filter is DateFilter) {
      dateFilters.add(filter);
    } else if (filter is BoolFilter) {
      boolFilters.add(filter);
    }

    return AdvancedFilterRequest(
      stringFilters: stringFilters,
      intFilters: intFilters,
      decimalFilters: decimalFilters,
      dateFilters: dateFilters,
      boolFilters: boolFilters,
      logic: request.logic,
      pageNumber: request.pageNumber,
      pageSize: request.pageSize,
      sortBy: request.sortBy,
      sortDescending: request.sortDescending,
    );
  }

  /// Clear all advanced filters
  void clearAdvancedFilters() {
    _customFilterRequest = null;
    clearFilters();
  }
}

/// Filter type enumeration
enum FilterType {
  string,
  int,
  decimal,
  date,
  dateTime,
  bool,
}
