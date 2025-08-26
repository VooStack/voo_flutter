import '../data_grid_column.dart';
import '../data_grid_source.dart';

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

  /// Custom format (current implementation)
  custom,
}

/// Standard API request builder supporting multiple filtering standards
class StandardApiRequestBuilder {
  final ApiFilterStandard standard;

  const StandardApiRequestBuilder({
    this.standard = ApiFilterStandard.jsonApi,
  });

  /// Build request based on selected standard
  dynamic buildRequest({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
    Map<String, dynamic>? additionalParams,
  }) {
    // Validate filters before building request
    _validateFilters(filters);

    switch (standard) {
      case ApiFilterStandard.simple:
        return _buildSimpleRequest(page, pageSize, filters, sorts);
      case ApiFilterStandard.jsonApi:
        return _buildJsonApiRequest(page, pageSize, filters, sorts);
      case ApiFilterStandard.odata:
        return _buildODataRequest(page, pageSize, filters, sorts);
      case ApiFilterStandard.mongodb:
        return _buildMongoDbRequest(page, pageSize, filters, sorts);
      case ApiFilterStandard.graphql:
        return _buildGraphQLRequest(page, pageSize, filters, sorts);
      case ApiFilterStandard.custom:
        return _buildCustomRequest(page, pageSize, filters, sorts, additionalParams);
    }
  }

  /// Simple REST style query parameters
  Map<String, String> _buildSimpleRequest(
    int page,
    int pageSize,
    Map<String, VooDataFilter> filters,
    List<VooColumnSort> sorts,
  ) {
    final params = <String, String>{
      'page': page.toString(),
      'limit': pageSize.toString(),
    };

    // Add filters using simple format with URL encoding
    filters.forEach((field, filter) {
      switch (filter.operator) {
        case VooFilterOperator.equals:
          params[field] = Uri.encodeQueryComponent(filter.value.toString());
          break;
        case VooFilterOperator.greaterThan:
          params['${field}_gt'] = Uri.encodeQueryComponent(filter.value.toString());
          break;
        case VooFilterOperator.lessThan:
          params['${field}_lt'] = Uri.encodeQueryComponent(filter.value.toString());
          break;
        case VooFilterOperator.greaterThanOrEqual:
          params['${field}_gte'] = Uri.encodeQueryComponent(filter.value.toString());
          break;
        case VooFilterOperator.lessThanOrEqual:
          params['${field}_lte'] = Uri.encodeQueryComponent(filter.value.toString());
          break;
        case VooFilterOperator.contains:
          params['${field}_like'] = Uri.encodeQueryComponent(filter.value.toString());
          break;
        case VooFilterOperator.between:
          params['${field}_from'] = Uri.encodeQueryComponent(filter.value.toString());
          params['${field}_to'] = Uri.encodeQueryComponent(filter.valueTo.toString());
          break;
        default:
          params['${field}_${_getSimpleOperator(filter.operator)}'] = Uri.encodeQueryComponent(filter.value?.toString() ?? '');
      }
    });

    // Add sorts
    if (sorts.isNotEmpty) {
      params['sort'] = sorts.map((s) => s.direction == VooSortDirection.descending ? '-${s.field}' : s.field).join(',');
    }

    return params;
  }

  /// JSON:API standard format
  Map<String, String> _buildJsonApiRequest(
    int page,
    int pageSize,
    Map<String, VooDataFilter> filters,
    List<VooColumnSort> sorts,
  ) {
    final params = <String, String>{
      'page[number]': (page + 1).toString(), // JSON:API uses 1-based pagination
      'page[size]': pageSize.toString(),
    };

    // Add filters in JSON:API format with URL encoding
    filters.forEach((field, filter) {
      if (filter.operator == VooFilterOperator.equals) {
        params['filter[$field]'] = Uri.encodeQueryComponent(filter.value.toString());
      } else {
        final op = _getJsonApiOperator(filter.operator);
        params['filter[$field][$op]'] = Uri.encodeQueryComponent(filter.value.toString());
        if (filter.valueTo != null) {
          params['filter[$field][to]'] = Uri.encodeQueryComponent(filter.valueTo.toString());
        }
      }
    });

    // Add sorts (comma-separated, - prefix for descending)
    if (sorts.isNotEmpty) {
      params['sort'] = sorts.map((s) => s.direction == VooSortDirection.descending ? '-${s.field}' : s.field).join(',');
    }

    return params;
  }

  /// OData standard format
  String _buildODataRequest(
    int page,
    int pageSize,
    Map<String, VooDataFilter> filters,
    List<VooColumnSort> sorts,
  ) {
    final parts = <String>[];

    // Pagination
    parts.add('\$top=$pageSize');
    parts.add('\$skip=${page * pageSize}');

    // Filters
    if (filters.isNotEmpty) {
      final filterExpressions = <String>[];
      filters.forEach((field, filter) {
        filterExpressions.add(_buildODataFilter(field, filter));
      });
      parts.add('\$filter=${filterExpressions.join(' and ')}');
    }

    // Sorts
    if (sorts.isNotEmpty) {
      final orderBy = sorts.map((s) => '${s.field} ${s.direction == VooSortDirection.ascending ? 'asc' : 'desc'}').join(',');
      parts.add('\$orderby=$orderBy');
    }

    return parts.join('&');
  }

  /// MongoDB/Elasticsearch style format (POST body)
  Map<String, dynamic> _buildMongoDbRequest(
    int page,
    int pageSize,
    Map<String, VooDataFilter> filters,
    List<VooColumnSort> sorts,
  ) {
    final request = <String, dynamic>{
      'from': page * pageSize,
      'size': pageSize,
    };

    // Build filter query
    if (filters.isNotEmpty) {
      final must = <Map<String, dynamic>>[];

      filters.forEach((field, filter) {
        must.add(_buildMongoDbFilter(field, filter));
      });

      request['query'] = {
        'bool': {
          'must': must,
        },
      };
    }

    // Build sort
    if (sorts.isNotEmpty) {
      request['sort'] = sorts
          .map((s) => {
                s.field: {
                  'order': s.direction == VooSortDirection.ascending ? 'asc' : 'desc',
                },
              })
          .toList();
    }

    return request;
  }

  /// Current custom format (backward compatible)
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

    if (filters.isNotEmpty) {
      request['filters'] = filters.entries
          .map((e) => {
                'field': e.key,
                'operator': _getCustomOperator(e.value.operator),
                if (e.value.value != null) 'value': e.value.value,
                if (e.value.valueTo != null) 'valueTo': e.value.valueTo,
              })
          .toList();
    }

    if (sorts.isNotEmpty) {
      request['sorts'] = sorts
          .map((s) => {
                'field': s.field,
                'direction': s.direction == VooSortDirection.ascending ? 'asc' : 'desc',
              })
          .toList();
    }

    if (additionalParams != null) {
      request['metadata'] = additionalParams;
    }

    return request;
  }

  // Helper methods for building filters in different formats

  String _buildODataFilter(String field, VooDataFilter filter) {
    // Helper function to escape OData string values
    String escapeODataString(dynamic value) {
      if (value == null) return 'null';
      final str = value.toString();
      // Escape single quotes by doubling them
      return "'${str.replaceAll("'", "''")}'";
    }

    switch (filter.operator) {
      case VooFilterOperator.equals:
        if (_isNumericValue(filter.value)) {
          return "$field eq ${filter.value}";
        }
        return "$field eq ${escapeODataString(filter.value)}";
      case VooFilterOperator.notEquals:
        if (_isNumericValue(filter.value)) {
          return "$field ne ${filter.value}";
        }
        return "$field ne ${escapeODataString(filter.value)}";
      case VooFilterOperator.greaterThan:
        return "$field gt ${filter.value}";
      case VooFilterOperator.greaterThanOrEqual:
        return "$field ge ${filter.value}";
      case VooFilterOperator.lessThan:
        return "$field lt ${filter.value}";
      case VooFilterOperator.lessThanOrEqual:
        return "$field le ${filter.value}";
      case VooFilterOperator.contains:
        return "contains($field, ${escapeODataString(filter.value)})";
      case VooFilterOperator.startsWith:
        return "startswith($field, ${escapeODataString(filter.value)})";
      case VooFilterOperator.endsWith:
        return "endswith($field, ${escapeODataString(filter.value)})";
      case VooFilterOperator.between:
        return "($field ge ${filter.value} and $field le ${filter.valueTo})";
      case VooFilterOperator.isNull:
        return "$field eq null";
      case VooFilterOperator.isNotNull:
        return "$field ne null";
      default:
        if (_isNumericValue(filter.value)) {
          return "$field eq ${filter.value}";
        }
        return "$field eq ${escapeODataString(filter.value)}";
    }
  }

  Map<String, dynamic> _buildMongoDbFilter(String field, VooDataFilter filter) {
    switch (filter.operator) {
      case VooFilterOperator.equals:
        return {
          'term': {field: filter.value}
        };
      case VooFilterOperator.notEquals:
        return {
          'bool': {
            'must_not': {
              'term': {field: filter.value}
            }
          }
        };
      case VooFilterOperator.greaterThan:
        return {
          'range': {
            field: {'gt': filter.value}
          }
        };
      case VooFilterOperator.greaterThanOrEqual:
        return {
          'range': {
            field: {'gte': filter.value}
          }
        };
      case VooFilterOperator.lessThan:
        return {
          'range': {
            field: {'lt': filter.value}
          }
        };
      case VooFilterOperator.lessThanOrEqual:
        return {
          'range': {
            field: {'lte': filter.value}
          }
        };
      case VooFilterOperator.between:
        return {
          'range': {
            field: {'gte': filter.value, 'lte': filter.valueTo}
          }
        };
      case VooFilterOperator.contains:
        return {
          'match': {field: filter.value}
        };
      case VooFilterOperator.startsWith:
        return {
          'prefix': {field: filter.value}
        };
      case VooFilterOperator.inList:
        return {
          'terms': {field: filter.value}
        };
      case VooFilterOperator.isNull:
        return {
          'bool': {
            'must_not': {
              'exists': {'field': field}
            }
          }
        };
      case VooFilterOperator.isNotNull:
        return {
          'exists': {'field': field}
        };
      default:
        return {
          'term': {field: filter.value}
        };
    }
  }

  String _getSimpleOperator(VooFilterOperator op) {
    switch (op) {
      case VooFilterOperator.notEquals:
        return 'ne';
      case VooFilterOperator.contains:
        return 'like';
      case VooFilterOperator.notContains:
        return 'nlike';
      case VooFilterOperator.startsWith:
        return 'sw';
      case VooFilterOperator.endsWith:
        return 'ew';
      case VooFilterOperator.inList:
        return 'in';
      case VooFilterOperator.notInList:
        return 'nin';
      case VooFilterOperator.isNull:
        return 'null';
      case VooFilterOperator.isNotNull:
        return 'nnull';
      default:
        return 'eq';
    }
  }

  String _getJsonApiOperator(VooFilterOperator op) {
    switch (op) {
      case VooFilterOperator.greaterThan:
        return 'gt';
      case VooFilterOperator.greaterThanOrEqual:
        return 'gte';
      case VooFilterOperator.lessThan:
        return 'lt';
      case VooFilterOperator.lessThanOrEqual:
        return 'lte';
      case VooFilterOperator.notEquals:
        return 'ne';
      case VooFilterOperator.contains:
        return 'like';
      case VooFilterOperator.between:
        return 'between';
      default:
        return 'eq';
    }
  }

  String _getCustomOperator(VooFilterOperator op) {
    switch (op) {
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

  /// Build GraphQL request variables
  Map<String, dynamic> _buildGraphQLRequest(
    int page,
    int pageSize,
    Map<String, VooDataFilter> filters,
    List<VooColumnSort> sorts,
  ) {
    final variables = <String, dynamic>{
      'first': pageSize,
      'offset': page * pageSize,
    };

    // Build filter input object
    if (filters.isNotEmpty) {
      final where = <String, dynamic>{};

      filters.forEach((field, filter) {
        where[field] = _buildGraphQLFilterValue(filter);
      });

      variables['where'] = where;
    }

    // Build orderBy array
    if (sorts.isNotEmpty) {
      variables['orderBy'] = sorts
          .map((s) => {
                'field': s.field.toUpperCase(),
                'direction': s.direction == VooSortDirection.ascending ? 'ASC' : 'DESC',
              })
          .toList();
    }

    return variables;
  }

  /// Build GraphQL filter value based on operator
  Map<String, dynamic> _buildGraphQLFilterValue(VooDataFilter filter) {
    switch (filter.operator) {
      case VooFilterOperator.equals:
        return {'_eq': filter.value};
      case VooFilterOperator.notEquals:
        return {'_neq': filter.value};
      case VooFilterOperator.greaterThan:
        return {'_gt': filter.value};
      case VooFilterOperator.greaterThanOrEqual:
        return {'_gte': filter.value};
      case VooFilterOperator.lessThan:
        return {'_lt': filter.value};
      case VooFilterOperator.lessThanOrEqual:
        return {'_lte': filter.value};
      case VooFilterOperator.contains:
        return {'_ilike': '%${filter.value}%'};
      case VooFilterOperator.startsWith:
        return {'_ilike': '${filter.value}%'};
      case VooFilterOperator.endsWith:
        return {'_ilike': '%${filter.value}'};
      case VooFilterOperator.between:
        return {
          '_gte': filter.value,
          '_lte': filter.valueTo,
        };
      case VooFilterOperator.inList:
        return {'_in': filter.value};
      case VooFilterOperator.notInList:
        return {'_nin': filter.value};
      case VooFilterOperator.isNull:
        return {'_is_null': true};
      case VooFilterOperator.isNotNull:
        return {'_is_null': false};
      default:
        return {'_eq': filter.value};
    }
  }

  /// Check if a value is numeric
  bool _isNumericValue(dynamic value) {
    if (value == null) return false;
    return value is num || (value is String && num.tryParse(value) != null);
  }

  /// Validate filters to ensure operators match expected data types
  void _validateFilters(Map<String, VooDataFilter> filters) {
    filters.forEach((field, filter) {
      // Validate that numeric operators are used with numeric values
      if (_isNumericOperator(filter.operator)) {
        if (filter.value != null && !_isNumericValue(filter.value)) {
          throw ArgumentError(
            'Operator ${filter.operator} requires numeric value for field "$field", got ${filter.value.runtimeType}',
          );
        }
        if (filter.operator == VooFilterOperator.between && filter.valueTo != null && !_isNumericValue(filter.valueTo)) {
          throw ArgumentError(
            'Operator between requires numeric valueTo for field "$field", got ${filter.valueTo.runtimeType}',
          );
        }
      }

      // Validate list operators have list values
      if (filter.operator == VooFilterOperator.inList || filter.operator == VooFilterOperator.notInList) {
        if (filter.value != null && filter.value is! List) {
          throw ArgumentError(
            'Operator ${filter.operator} requires List value for field "$field", got ${filter.value.runtimeType}',
          );
        }
      }

      // Validate between operator has both values
      if (filter.operator == VooFilterOperator.between) {
        if (filter.value == null || filter.valueTo == null) {
          throw ArgumentError(
            'Operator between requires both value and valueTo for field "$field"',
          );
        }
      }
    });
  }

  /// Check if operator is numeric
  bool _isNumericOperator(VooFilterOperator op) {
    return op == VooFilterOperator.greaterThan ||
        op == VooFilterOperator.greaterThanOrEqual ||
        op == VooFilterOperator.lessThan ||
        op == VooFilterOperator.lessThanOrEqual ||
        op == VooFilterOperator.between;
  }
}

/// Example usage of StandardApiRequestBuilder with different standards:
///
/// Simple REST:
/// ```dart
/// final builder = StandardApiRequestBuilder(standard: ApiFilterStandard.simple);
/// final params = builder.buildRequest(page: 0, pageSize: 20, filters: filters, sorts: sorts);
/// // Result: ?page=0&limit=20&status=active&age_gt=25&sort=name
/// ```
///
/// JSON:API:
/// ```dart
/// final builder = StandardApiRequestBuilder(standard: ApiFilterStandard.jsonApi);
/// final params = builder.buildRequest(page: 0, pageSize: 20, filters: filters, sorts: sorts);
/// // Result: ?page[number]=1&page[size]=20&filter[status]=active&filter[age][gt]=25&sort=name
/// ```
///
/// OData:
/// ```dart
/// final builder = StandardApiRequestBuilder(standard: ApiFilterStandard.odata);
/// final query = builder.buildRequest(page: 0, pageSize: 20, filters: filters, sorts: sorts);
/// // Result: ?$top=20&$skip=0&$filter=status eq 'active' and age gt 25&$orderby=name asc
/// ```
///
/// GraphQL:
/// ```dart
/// final builder = StandardApiRequestBuilder(standard: ApiFilterStandard.graphql);
/// final variables = builder.buildRequest(page: 0, pageSize: 20, filters: filters, sorts: sorts);
/// // Result: GraphQL variables object with where clause and orderBy
/// ```
///
/// MongoDB/Elasticsearch:
/// ```dart
/// final builder = StandardApiRequestBuilder(standard: ApiFilterStandard.mongodb);
/// final body = builder.buildRequest(page: 0, pageSize: 20, filters: filters, sorts: sorts);
/// // Result: POST body with MongoDB query format
/// ```
