import '../data_grid_column.dart';
import '../data_grid_source.dart';
import '../models/advanced_filters.dart';

/// Utility class for building JSON requests for remote data grid operations
/// Following REST API best practices
class DataGridRequestBuilder {
  /// Build a complete request body for data grid operations
  /// Returns a Map that can be converted to JSON
  static Map<String, dynamic> buildRequestBody({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
    Map<String, dynamic>? additionalParams,
  }) {
    final request = <String, dynamic>{
      'pagination': {
        'page': page,
        'pageSize': pageSize,
        'offset': page * pageSize,
        'limit': pageSize,
      },
    };

    // Add filters if present
    if (filters.isNotEmpty) {
      request['filters'] = _buildFilters(filters);
    }

    // Add sorts if present
    if (sorts.isNotEmpty) {
      request['sorts'] = _buildSorts(sorts);
    }

    // Add any additional parameters
    if (additionalParams != null) {
      request['metadata'] = additionalParams;
    }

    return request;
  }

  /// Build filters array for the request
  static List<Map<String, dynamic>> _buildFilters(Map<String, VooDataFilter> filters) {
    return filters.entries.map((entry) {
      final filter = entry.value;
      final filterMap = <String, dynamic>{
        'field': entry.key,
        'operator': _operatorToString(filter.operator),
      };

      // Add value based on operator
      switch (filter.operator) {
        case VooFilterOperator.isNull:
        case VooFilterOperator.isNotNull:
          // No value needed
          break;
        case VooFilterOperator.between:
          filterMap['value'] = filter.value;
          filterMap['valueTo'] = filter.valueTo;
          break;
        case VooFilterOperator.inList:
        case VooFilterOperator.notInList:
          filterMap['values'] = filter.value is List ? filter.value : [filter.value];
          break;
        default:
          filterMap['value'] = filter.value;
      }

      return filterMap;
    }).toList();
  }

  /// Build sorts array for the request
  static List<Map<String, dynamic>> _buildSorts(List<VooColumnSort> sorts) {
    return sorts
        .where((sort) => sort.direction != VooSortDirection.none)
        .map((sort) => {
              'field': sort.field,
              'direction': _sortDirectionToString(sort.direction),
            })
        .toList();
  }

  /// Convert filter operator to API string
  static String _operatorToString(VooFilterOperator operator) {
    switch (operator) {
      case VooFilterOperator.equals:
        return 'eq';
      case VooFilterOperator.notEquals:
        return 'ne';
      case VooFilterOperator.contains:
        return 'contains';
      case VooFilterOperator.notContains:
        return 'not_contains';
      case VooFilterOperator.startsWith:
        return 'starts_with';
      case VooFilterOperator.endsWith:
        return 'ends_with';
      case VooFilterOperator.greaterThan:
        return 'gt';
      case VooFilterOperator.greaterThanOrEqual:
        return 'gte';
      case VooFilterOperator.lessThan:
        return 'lt';
      case VooFilterOperator.lessThanOrEqual:
        return 'lte';
      case VooFilterOperator.between:
        return 'between';
      case VooFilterOperator.inList:
        return 'in';
      case VooFilterOperator.notInList:
        return 'not_in';
      case VooFilterOperator.isNull:
        return 'is_null';
      case VooFilterOperator.isNotNull:
        return 'is_not_null';
    }
  }

  /// Convert sort direction to API string
  static String _sortDirectionToString(VooSortDirection direction) {
    switch (direction) {
      case VooSortDirection.ascending:
        return 'asc';
      case VooSortDirection.descending:
        return 'desc';
      case VooSortDirection.none:
        return '';
    }
  }

  /// Build query parameters for GET requests
  static Map<String, String> buildQueryParams({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) {
    final params = <String, String>{
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    };

    // Add filters as query params
    int filterIndex = 0;
    filters.forEach((field, filter) {
      final prefix = 'filters[$filterIndex]';
      params['$prefix.field'] = field;
      params['$prefix.operator'] = _operatorToString(filter.operator);
      
      if (filter.operator != VooFilterOperator.isNull && 
          filter.operator != VooFilterOperator.isNotNull) {
        if (filter.value != null) {
          if (filter.value is List) {
            params['$prefix.values'] = (filter.value as List).join(',');
          } else {
            params['$prefix.value'] = filter.value.toString();
          }
        }
        if (filter.valueTo != null) {
          params['$prefix.valueTo'] = filter.valueTo.toString();
        }
      }
      filterIndex++;
    });

    // Add sorts as query params
    for (int i = 0; i < sorts.length; i++) {
      if (sorts[i].direction != VooSortDirection.none) {
        params['sorts[$i].field'] = sorts[i].field;
        params['sorts[$i].direction'] = _sortDirectionToString(sorts[i].direction);
      }
    }

    return params;
  }

  /// Parse API response into VooDataGridResponse
  static VooDataGridResponse parseResponse({
    required Map<String, dynamic> json,
    String dataKey = 'data',
    String totalKey = 'total',
    String? pageKey = 'page',
    String? pageSizeKey = 'pageSize',
  }) {
    final data = json[dataKey] as List<dynamic>? ?? [];
    final total = json[totalKey] as int? ?? 0;
    final page = pageKey != null ? (json[pageKey] as int? ?? 0) : 0;
    final pageSize = pageSizeKey != null ? (json[pageSizeKey] as int? ?? 20) : 20;

    return VooDataGridResponse(
      rows: data,
      totalRows: total,
      page: page,
      pageSize: pageSize,
    );
  }

  /// Build an advanced filter request body with support for secondary filters
  static Map<String, dynamic> buildAdvancedRequestBody({
    required AdvancedFilterRequest request,
    Map<String, dynamic>? additionalParams,
  }) {
    final body = request.toJson();
    
    // Add any additional parameters
    if (additionalParams != null) {
      body['metadata'] = additionalParams;
    }
    
    return body;
  }

  /// Convert VooDataFilter map to AdvancedFilterRequest for compatibility
  static AdvancedFilterRequest convertToAdvancedRequest({
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
    required int page,
    required int pageSize,
  }) {
    final stringFilters = <StringFilter>[];
    final intFilters = <IntFilter>[];
    final dateFilters = <DateFilter>[];
    final decimalFilters = <DecimalFilter>[];
    
    filters.forEach((field, filter) {
      final value = filter.value;
      final operator = _operatorToApiString(filter.operator);
      
      SecondaryFilter? secondaryFilter;
      if (filter.valueTo != null && filter.operator == VooFilterOperator.between) {
        secondaryFilter = SecondaryFilter(
          logic: FilterLogic.and,
          value: filter.valueTo,
          operator: 'LessThanOrEqual',
        );
      }
      
      // Determine filter type based on value type
      if (value is String) {
        stringFilters.add(StringFilter(
          fieldName: field,
          value: value,
          operator: operator,
          secondaryFilter: secondaryFilter,
        ));
      } else if (value is int) {
        intFilters.add(IntFilter(
          fieldName: field,
          value: value,
          operator: operator,
          secondaryFilter: secondaryFilter,
        ));
      } else if (value is double) {
        decimalFilters.add(DecimalFilter(
          fieldName: field,
          value: value,
          operator: operator,
          secondaryFilter: secondaryFilter,
        ));
      } else if (value is DateTime) {
        dateFilters.add(DateFilter(
          fieldName: field,
          value: value.toIso8601String(),
          operator: operator,
          secondaryFilter: secondaryFilter,
        ));
      }
    });
    
    // Get primary sort
    final primarySort = sorts.isNotEmpty ? sorts.first : null;
    
    return AdvancedFilterRequest(
      stringFilters: stringFilters,
      intFilters: intFilters,
      dateFilters: dateFilters,
      decimalFilters: decimalFilters,
      pageNumber: page + 1, // Convert from 0-based to 1-based
      pageSize: pageSize,
      sortBy: primarySort?.field,
      sortDescending: primarySort?.direction == VooSortDirection.descending,
    );
  }

  /// Convert filter operator to API string format
  static String _operatorToApiString(VooFilterOperator operator) {
    switch (operator) {
      case VooFilterOperator.equals:
        return 'Equals';
      case VooFilterOperator.notEquals:
        return 'NotEquals';
      case VooFilterOperator.contains:
        return 'Contains';
      case VooFilterOperator.notContains:
        return 'NotContains';
      case VooFilterOperator.startsWith:
        return 'StartsWith';
      case VooFilterOperator.endsWith:
        return 'EndsWith';
      case VooFilterOperator.greaterThan:
        return 'GreaterThan';
      case VooFilterOperator.greaterThanOrEqual:
        return 'GreaterThanOrEqual';
      case VooFilterOperator.lessThan:
        return 'LessThan';
      case VooFilterOperator.lessThanOrEqual:
        return 'LessThanOrEqual';
      case VooFilterOperator.between:
        return 'Between';
      case VooFilterOperator.inList:
        return 'In';
      case VooFilterOperator.notInList:
        return 'NotIn';
      case VooFilterOperator.isNull:
        return 'IsNull';
      case VooFilterOperator.isNotNull:
        return 'IsNotNull';
    }
  }
}

/// Example of a remote data source implementation
class RemoteDataGridSource extends VooDataGridSource {
  final String apiEndpoint;
  final Map<String, String>? headers;
  final Future<Map<String, dynamic>> Function(
    String url,
    Map<String, dynamic> body,
    Map<String, String>? headers,
  )? httpClient;

  RemoteDataGridSource({
    required this.apiEndpoint,
    this.headers,
    this.httpClient,
  }) : super(mode: VooDataGridMode.remote);

  @override
  Future<VooDataGridResponse> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // Build request body
    final requestBody = DataGridRequestBuilder.buildRequestBody(
      page: page,
      pageSize: pageSize,
      filters: filters,
      sorts: sorts,
    );

    // Make API call (using provided httpClient or throw error)
    if (httpClient == null) {
      throw UnimplementedError(
        'Please provide an httpClient function to make API calls. '
        'Example: httpClient: (url, body, headers) async => await dio.post(url, data: body, options: Options(headers: headers)).then((r) => r.data)',
      );
    }

    final response = await httpClient!(apiEndpoint, requestBody, headers);
    
    // Parse response
    return DataGridRequestBuilder.parseResponse(json: response);
  }
}