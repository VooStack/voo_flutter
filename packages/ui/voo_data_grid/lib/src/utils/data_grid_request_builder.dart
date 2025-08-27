import '../data_grid_column.dart';
import '../data_grid_source.dart';
import '../models/advanced_filters.dart';

/// Enum for different API filtering standards
enum ApiFilterStandard {
  /// Simple REST style: ?status=active&age_gt=25
  simple,

  /// JSON:API style: ?filter[status]=active&filter[age][gt]=25
  jsonApi,

  /// OData style: ?$filter=status eq 'active' and age gt 25
  odata,

  /// MongoDB/Elasticsearch style (POST body)
  mongodb,

  /// GraphQL variables format
  graphql,

  /// Voo API Standard with typed filters and secondary filters
  voo,

  /// Custom format (default VooDataGrid format)
  custom,
}

/// Utility class for building JSON requests for remote data grid operations
/// Supporting multiple API standards for different backend systems
class DataGridRequestBuilder {
  final ApiFilterStandard standard;
  final String? fieldPrefix;

  const DataGridRequestBuilder({
    this.standard = ApiFilterStandard.custom,
    this.fieldPrefix,
  });

  /// Apply field prefix to field name if prefix is set
  String _applyFieldPrefix(String field) {
    if (fieldPrefix != null && fieldPrefix!.isNotEmpty) {
      return '$fieldPrefix.$field';
    }
    return field;
  }

  /// Build request based on selected API standard
  Map<String, dynamic> buildRequest({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
    Map<String, dynamic>? additionalParams,
  }) {
    switch (standard) {
      case ApiFilterStandard.simple:
        return _buildSimpleRequest(
            page, pageSize, filters, sorts, additionalParams);
      case ApiFilterStandard.jsonApi:
        return _buildJsonApiRequest(
            page, pageSize, filters, sorts, additionalParams);
      case ApiFilterStandard.odata:
        return _buildODataRequest(
            page, pageSize, filters, sorts, additionalParams);
      case ApiFilterStandard.mongodb:
        return _buildMongoDbRequest(
            page, pageSize, filters, sorts, additionalParams);
      case ApiFilterStandard.graphql:
        return _buildGraphQLRequest(
            page, pageSize, filters, sorts, additionalParams);
      case ApiFilterStandard.voo:
        return _buildVooRequest(
            page, pageSize, filters, sorts, additionalParams);
      case ApiFilterStandard.custom:
        return _buildCustomRequest(
            page, pageSize, filters, sorts, additionalParams);
    }
  }

  /// Simple REST style query parameters
  Map<String, dynamic> _buildSimpleRequest(
    int page,
    int pageSize,
    Map<String, VooDataFilter> filters,
    List<VooColumnSort> sorts,
    Map<String, dynamic>? additionalParams,
  ) {
    final params = <String, dynamic>{
      'params': <String, String>{
        'page': page.toString(),
        'limit': pageSize.toString(),
      },
    };

    final queryParams = params['params'] as Map<String, String>;

    // Add filters using simple format
    filters.forEach((field, filter) {
      final prefixedField = _applyFieldPrefix(field);
      switch (filter.operator) {
        case VooFilterOperator.equals:
          queryParams[prefixedField] = filter.value.toString();
          break;
        case VooFilterOperator.greaterThan:
          queryParams['${prefixedField}_gt'] = filter.value.toString();
          break;
        case VooFilterOperator.lessThan:
          queryParams['${prefixedField}_lt'] = filter.value.toString();
          break;
        case VooFilterOperator.greaterThanOrEqual:
          queryParams['${prefixedField}_gte'] = filter.value.toString();
          break;
        case VooFilterOperator.lessThanOrEqual:
          queryParams['${prefixedField}_lte'] = filter.value.toString();
          break;
        case VooFilterOperator.contains:
          queryParams['${prefixedField}_like'] = filter.value.toString();
          break;
        case VooFilterOperator.between:
          queryParams['${prefixedField}_from'] = filter.value.toString();
          queryParams['${prefixedField}_to'] = filter.valueTo.toString();
          break;
        default:
          queryParams[prefixedField] = filter.value?.toString() ?? '';
      }
    });

    // Add sorts in simple format
    if (sorts.isNotEmpty) {
      queryParams['sort'] = sorts
          .map((s) => s.direction == VooSortDirection.descending
              ? '-${_applyFieldPrefix(s.field)}'
              : _applyFieldPrefix(s.field))
          .join(',');
    }

    if (additionalParams != null) {
      params.addAll(additionalParams);
    }

    return params;
  }

  /// JSON:API format
  Map<String, dynamic> _buildJsonApiRequest(
    int page,
    int pageSize,
    Map<String, VooDataFilter> filters,
    List<VooColumnSort> sorts,
    Map<String, dynamic>? additionalParams,
  ) {
    final params = <String, dynamic>{
      'params': <String, String>{
        'page[number]': (page + 1).toString(),  // JSON:API uses 1-based pagination
        'page[size]': pageSize.toString(),
      },
    };

    final queryParams = params['params'] as Map<String, String>;

    // Add filters in JSON:API format
    filters.forEach((field, filter) {
      final prefixedField = _applyFieldPrefix(field);
      final op = _getJsonApiOperator(filter.operator);
      if (op == 'eq') {
        queryParams['filter[$prefixedField]'] = filter.value.toString();
      } else {
        queryParams['filter[$prefixedField][$op]'] = filter.value.toString();
      }
      if (filter.valueTo != null) {
        queryParams['filter[$prefixedField][to]'] = filter.valueTo.toString();
      }
    });

    // Add sorts in JSON:API format
    if (sorts.isNotEmpty) {
      queryParams['sort'] = sorts
          .map((s) => s.direction == VooSortDirection.descending
              ? '-${_applyFieldPrefix(s.field)}'
              : _applyFieldPrefix(s.field))
          .join(',');
    }

    if (additionalParams != null) {
      params.addAll(additionalParams);
    }

    return params;
  }

  /// OData format
  Map<String, dynamic> _buildODataRequest(
    int page,
    int pageSize,
    Map<String, VooDataFilter> filters,
    List<VooColumnSort> sorts,
    Map<String, dynamic>? additionalParams,
  ) {
    final params = <String, dynamic>{
      'params': <String, String>{
        '\$skip': (page * pageSize).toString(),
        '\$top': pageSize.toString(),
      },
    };

    final queryParams = params['params'] as Map<String, String>;

    // Build OData filter expression
    if (filters.isNotEmpty) {
      final filterExpressions = <String>[];
      filters.forEach((field, filter) {
        final prefixedField = _applyFieldPrefix(field);
        final expression = _buildODataFilterExpression(prefixedField, filter);
        if (expression.isNotEmpty) {
          filterExpressions.add(expression);
        }
      });
      if (filterExpressions.isNotEmpty) {
        queryParams['\$filter'] = filterExpressions.join(' and ');
      }
    }

    // Add sorts in OData format
    if (sorts.isNotEmpty) {
      final orderBy = sorts
          .map((s) =>
              '${_applyFieldPrefix(s.field)} ${s.direction == VooSortDirection.ascending ? 'asc' : 'desc'}')
          .join(',');
      queryParams['\$orderby'] = orderBy;
    }

    if (additionalParams != null) {
      params.addAll(additionalParams);
    }

    return params;
  }

  /// MongoDB/Elasticsearch format
  Map<String, dynamic> _buildMongoDbRequest(
    int page,
    int pageSize,
    Map<String, VooDataFilter> filters,
    List<VooColumnSort> sorts,
    Map<String, dynamic>? additionalParams,
  ) {
    final body = <String, dynamic>{
      'skip': page * pageSize,
      'limit': pageSize,
    };

    // Build MongoDB query
    if (filters.isNotEmpty) {
      final query = <String, dynamic>{};
      filters.forEach((field, filter) {
        query[_applyFieldPrefix(field)] = _buildMongoDbOperator(filter);
      });
      body['query'] = query;
    }

    // Add sorts in MongoDB format
    if (sorts.isNotEmpty) {
      final sort = <String, dynamic>{};
      for (var s in sorts) {
        sort[_applyFieldPrefix(s.field)] = s.direction == VooSortDirection.ascending ? 1 : -1;
      }
      body['sort'] = sort;
    }

    if (additionalParams != null) {
      body.addAll(additionalParams);
    }

    return {'body': body};
  }

  /// GraphQL variables format
  Map<String, dynamic> _buildGraphQLRequest(
    int page,
    int pageSize,
    Map<String, VooDataFilter> filters,
    List<VooColumnSort> sorts,
    Map<String, dynamic>? additionalParams,
  ) {
    final variables = <String, dynamic>{
      'page': page,
      'pageSize': pageSize,
    };

    // Add filters as GraphQL variables
    if (filters.isNotEmpty) {
      final where = <String, dynamic>{};
      filters.forEach((field, filter) {
        where[_applyFieldPrefix(field)] = _buildGraphQLFilter(filter);
      });
      variables['where'] = where;
    }

    // Add sorts as GraphQL variables
    if (sorts.isNotEmpty) {
      variables['orderBy'] = sorts
          .map((s) => {
                'field': _applyFieldPrefix(s.field),
                'direction':
                    s.direction == VooSortDirection.ascending ? 'ASC' : 'DESC',
              })
          .toList();
    }

    if (additionalParams != null) {
      variables.addAll(additionalParams);
    }

    return {
      'variables': variables,
      'query': '''
        query GetData(\$page: Int!, \$pageSize: Int!, \$where: DataFilter, \$orderBy: [SortInput!]) {
          data(page: \$page, pageSize: \$pageSize, where: \$where, orderBy: \$orderBy) {
            items { ... }
            totalCount
          }
        }
      ''',
    };
  }

  /// Voo API Standard with typed filters and secondary filters
  Map<String, dynamic> _buildVooRequest(
    int page,
    int pageSize,
    Map<String, VooDataFilter> filters,
    List<VooColumnSort> sorts,
    Map<String, dynamic>? additionalParams,
  ) {
    final request = <String, dynamic>{
      'pageNumber': page,
      'pageSize': pageSize,
      'logic': 'And', // Default logic
    };

    // Organize filters by type
    final stringFilters = <Map<String, dynamic>>[];
    final intFilters = <Map<String, dynamic>>[];
    final dateFilters = <Map<String, dynamic>>[];
    final decimalFilters = <Map<String, dynamic>>[];

    filters.forEach((field, filter) {
      // Special handling for Between operator in Voo API standard
      // Voo API doesn't support Between directly - we need to create two separate filters
      if (filter.operator == VooFilterOperator.between && filter.valueTo != null) {
        // Create GreaterThanOrEqual filter for the lower bound
        final lowerFilter = <String, dynamic>{
          'fieldName': _applyFieldPrefix(field),
          'value': filter.value,
          'operator': 'GreaterThanOrEqual',
        };
        
        // Create LessThanOrEqual filter for the upper bound
        final upperFilter = <String, dynamic>{
          'fieldName': _applyFieldPrefix(field),
          'value': filter.valueTo,
          'operator': 'LessThanOrEqual',
        };
        
        // Add both filters to the appropriate type array
        if (filter.value is String) {
          stringFilters.add(lowerFilter);
          stringFilters.add(upperFilter);
        } else if (filter.value is int) {
          intFilters.add(lowerFilter);
          intFilters.add(upperFilter);
        } else if (filter.value is DateTime) {
          lowerFilter['value'] = (filter.value as DateTime).toIso8601String();
          upperFilter['value'] = (filter.valueTo as DateTime).toIso8601String();
          dateFilters.add(lowerFilter);
          dateFilters.add(upperFilter);
        } else if (filter.value is double) {
          decimalFilters.add(lowerFilter);
          decimalFilters.add(upperFilter);
        } else {
          // Default to string filter for unknown types
          stringFilters.add(lowerFilter);
          stringFilters.add(upperFilter);
        }
      } else {
        // Normal filter handling for non-between operators
        final filterMap = <String, dynamic>{
          'fieldName': _applyFieldPrefix(field),
          'value': filter.value,
          'operator': _vooOperatorToString(filter.operator),
        };

        // Categorize by value type
        if (filter.value is String) {
          stringFilters.add(filterMap);
        } else if (filter.value is int) {
          intFilters.add(filterMap);
        } else if (filter.value is DateTime) {
          filterMap['value'] = (filter.value as DateTime).toIso8601String();
          dateFilters.add(filterMap);
        } else if (filter.value is double) {
          decimalFilters.add(filterMap);
        } else {
          // Default to string filter for unknown types
          stringFilters.add(filterMap);
        }
      }
    });

    // Add filter arrays if not empty
    if (stringFilters.isNotEmpty) request['stringFilters'] = stringFilters;
    if (intFilters.isNotEmpty) request['intFilters'] = intFilters;
    if (dateFilters.isNotEmpty) request['dateFilters'] = dateFilters;
    if (decimalFilters.isNotEmpty) request['decimalFilters'] = decimalFilters;

    // Add sorting
    if (sorts.isNotEmpty) {
      final primarySort = sorts.first;
      request['sortBy'] = _applyFieldPrefix(primarySort.field);
      request['sortDescending'] = primarySort.direction == VooSortDirection.descending;
    }

    // Merge additional params
    if (additionalParams != null) {
      request.addAll(additionalParams);
    }

    return request;
  }

  /// Convert operator to Voo API format
  String _vooOperatorToString(VooFilterOperator operator) {
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

  /// Custom format (default VooDataGrid format)
  Map<String, dynamic> _buildCustomRequest(
    int page,
    int pageSize,
    Map<String, VooDataFilter> filters,
    List<VooColumnSort> sorts,
    Map<String, dynamic>? additionalParams,
  ) {
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

  /// Helper methods for different formats
  String _getJsonApiOperator(VooFilterOperator operator) {
    switch (operator) {
      case VooFilterOperator.equals:
        return 'eq';
      case VooFilterOperator.greaterThan:
        return 'gt';
      case VooFilterOperator.lessThan:
        return 'lt';
      case VooFilterOperator.greaterThanOrEqual:
        return 'gte';
      case VooFilterOperator.lessThanOrEqual:
        return 'lte';
      case VooFilterOperator.contains:
        return 'contains';
      case VooFilterOperator.between:
        return 'between';
      default:
        return 'eq';
    }
  }

  String _buildODataFilterExpression(String field, VooDataFilter filter) {
    switch (filter.operator) {
      case VooFilterOperator.equals:
        // Don't quote numeric values
        if (filter.value is num) {
          return "$field eq ${filter.value}";
        }
        return "$field eq '${filter.value}'";
      case VooFilterOperator.notEquals:
        if (filter.value is num) {
          return "$field ne ${filter.value}";
        }
        return "$field ne '${filter.value}'";
      case VooFilterOperator.greaterThan:
        return "$field gt ${filter.value}";
      case VooFilterOperator.lessThan:
        return "$field lt ${filter.value}";
      case VooFilterOperator.greaterThanOrEqual:
        return "$field ge ${filter.value}";
      case VooFilterOperator.lessThanOrEqual:
        return "$field le ${filter.value}";
      case VooFilterOperator.contains:
        return "contains($field, '${filter.value}')";
      case VooFilterOperator.startsWith:
        return "startswith($field, '${filter.value}')";
      case VooFilterOperator.endsWith:
        return "endswith($field, '${filter.value}')";
      case VooFilterOperator.between:
        return "($field ge ${filter.value} and $field le ${filter.valueTo})";
      case VooFilterOperator.isNull:
        return "$field eq null";
      case VooFilterOperator.isNotNull:
        return "$field ne null";
      default:
        return '';
    }
  }

  dynamic _buildMongoDbOperator(VooDataFilter filter) {
    switch (filter.operator) {
      case VooFilterOperator.equals:
        return filter.value;  // MongoDB uses direct value for equality
      case VooFilterOperator.notEquals:
        return {'\$ne': filter.value};
      case VooFilterOperator.greaterThan:
        return {'\$gt': filter.value};
      case VooFilterOperator.lessThan:
        return {'\$lt': filter.value};
      case VooFilterOperator.greaterThanOrEqual:
        return {'\$gte': filter.value};
      case VooFilterOperator.lessThanOrEqual:
        return {'\$lte': filter.value};
      case VooFilterOperator.contains:
        return {'\$regex': filter.value, '\$options': 'i'};
      case VooFilterOperator.between:
        return {'\$gte': filter.value, '\$lte': filter.valueTo};
      case VooFilterOperator.inList:
        return {
          '\$in': filter.value is List ? filter.value : [filter.value]
        };
      case VooFilterOperator.notInList:
        return {
          '\$nin': filter.value is List ? filter.value : [filter.value]
        };
      case VooFilterOperator.isNull:
        return {'\$eq': null};
      case VooFilterOperator.isNotNull:
        return {'\$ne': null};
      default:
        return filter.value;
    }
  }

  Map<String, dynamic> _buildGraphQLFilter(VooDataFilter filter) {
    switch (filter.operator) {
      case VooFilterOperator.equals:
        return {'eq': filter.value};
      case VooFilterOperator.notEquals:
        return {'neq': filter.value};
      case VooFilterOperator.greaterThan:
        return {'gt': filter.value};
      case VooFilterOperator.lessThan:
        return {'lt': filter.value};
      case VooFilterOperator.greaterThanOrEqual:
        return {'gte': filter.value};
      case VooFilterOperator.lessThanOrEqual:
        return {'lte': filter.value};
      case VooFilterOperator.contains:
        return {'contains': filter.value};
      case VooFilterOperator.startsWith:
        return {'startsWith': filter.value};
      case VooFilterOperator.endsWith:
        return {'endsWith': filter.value};
      case VooFilterOperator.between:
        return {
          'between': [filter.value, filter.valueTo]
        };
      case VooFilterOperator.inList:
        return {
          'in': filter.value is List ? filter.value : [filter.value]
        };
      case VooFilterOperator.notInList:
        return {
          'notIn': filter.value is List ? filter.value : [filter.value]
        };
      case VooFilterOperator.isNull:
        return {'isNull': true};
      case VooFilterOperator.isNotNull:
        return {'isNotNull': true};
      default:
        return {'eq': filter.value}; // Default to equals for unsupported operators
    }
  }

  /// Legacy static method for backward compatibility
  static Map<String, dynamic> buildRequestBody({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
    Map<String, dynamic>? additionalParams,
  }) {
    final builder = DataGridRequestBuilder();
    return builder.buildRequest(
      page: page,
      pageSize: pageSize,
      filters: filters,
      sorts: sorts,
      additionalParams: additionalParams,
    );
  }

  /// Build filters array for the request
  List<Map<String, dynamic>> _buildFilters(Map<String, VooDataFilter> filters) {
    return filters.entries.map((entry) {
      final filter = entry.value;
      final filterMap = <String, dynamic>{
        'field': _applyFieldPrefix(entry.key),
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
          filterMap['values'] =
              filter.value is List ? filter.value : [filter.value];
          break;
        default:
          filterMap['value'] = filter.value;
      }

      return filterMap;
    }).toList();
  }

  /// Build sorts array for the request
  List<Map<String, dynamic>> _buildSorts(List<VooColumnSort> sorts) {
    return sorts
        .where((sort) => sort.direction != VooSortDirection.none)
        .map((sort) => {
              'field': _applyFieldPrefix(sort.field),
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
        params['sorts[$i].direction'] =
            _sortDirectionToString(sorts[i].direction);
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
    final pageSize =
        pageSizeKey != null ? (json[pageSizeKey] as int? ?? 20) : 20;

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
      if (filter.valueTo != null &&
          filter.operator == VooFilterOperator.between) {
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
          value: value,
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

/// Example of a remote data source implementation with API standards
class RemoteDataGridSource extends VooDataGridSource {
  final String apiEndpoint;
  final Map<String, String>? headers;
  final ApiFilterStandard apiStandard;
  final String? fieldPrefix;
  final DataGridRequestBuilder requestBuilder;
  final Future<Map<String, dynamic>> Function(
    String url,
    Map<String, dynamic> requestData,
    Map<String, String>? headers,
  )? httpClient;

  RemoteDataGridSource({
    required this.apiEndpoint,
    this.headers,
    this.apiStandard = ApiFilterStandard.custom,
    this.fieldPrefix,
    this.httpClient,
  })  : requestBuilder = DataGridRequestBuilder(
          standard: apiStandard, 
          fieldPrefix: fieldPrefix,
        ),
        super(mode: VooDataGridMode.remote);

  @override
  Future<VooDataGridResponse> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // Build request based on API standard
    final requestData = requestBuilder.buildRequest(
      page: page,
      pageSize: pageSize,
      filters: filters,
      sorts: sorts,
    );

    // Make API call (using provided httpClient or throw error)
    if (httpClient == null) {
      throw UnimplementedError(
        'Please provide an httpClient function to make API calls. '
        'Example: httpClient: (url, requestData, headers) async => '
        'await dio.post(url, data: requestData, options: Options(headers: headers)).then((r) => r.data)',
      );
    }

    // For GET requests (simple, jsonApi, odata), pass params as query parameters
    // For POST requests (mongodb, graphql, custom), pass as body
    final response = await httpClient!(apiEndpoint, requestData, headers);

    // Parse response
    return DataGridRequestBuilder.parseResponse(json: response);
  }
}
