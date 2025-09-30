import 'package:voo_data_grid/voo_data_grid.dart';

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

/// DateTime format options for OData filters
enum ODataDateTimeFormat {
  /// ISO 8601 with Z suffix (UTC): 2024-09-30T15:15:30.000Z
  /// Default format, works with most OData implementations
  utc,

  /// ISO 8601 without Z suffix (local/unspecified): 2024-09-30T15:15:30.000
  /// Use this for .NET backends that don't properly handle UTC strings
  /// or when your DateTime columns don't use 'timestamp with time zone'
  unspecified,
}

/// Utility class for building JSON requests for remote data grid operations
/// Supporting multiple API standards for different backend systems
class DataGridRequestBuilder {
  final ApiFilterStandard standard;
  final String? fieldPrefix;
  final ODataDateTimeFormat odataDateTimeFormat;

  const DataGridRequestBuilder({
    this.standard = ApiFilterStandard.custom,
    this.fieldPrefix,
    this.odataDateTimeFormat = ODataDateTimeFormat.utc,
  });

  /// Apply field prefix to field name if prefix is set
  String _applyFieldPrefix(String field, {bool pascalCaseField = false}) {
    if (fieldPrefix != null && fieldPrefix!.isNotEmpty) {
      if (pascalCaseField && field.isNotEmpty) {
        // Capitalize first letter of field for standards like VooApiStandard
        final capitalizedField = field[0].toUpperCase() + field.substring(1);
        return '$fieldPrefix.$capitalizedField';
      }
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
        return _buildSimpleRequest(page, pageSize, filters, sorts, additionalParams);
      case ApiFilterStandard.jsonApi:
        return _buildJsonApiRequest(page, pageSize, filters, sorts, additionalParams);
      case ApiFilterStandard.odata:
        return _buildODataRequest(page, pageSize, filters, sorts, additionalParams);
      case ApiFilterStandard.mongodb:
        return _buildMongoDbRequest(page, pageSize, filters, sorts, additionalParams);
      case ApiFilterStandard.graphql:
        return _buildGraphQLRequest(page, pageSize, filters, sorts, additionalParams);
      case ApiFilterStandard.voo:
        return _buildVooRequest(page, pageSize, filters, sorts, additionalParams);
      case ApiFilterStandard.custom:
        return _buildCustomRequest(page, pageSize, filters, sorts, additionalParams);
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
      'params': <String, String>{'page': page.toString(), 'limit': pageSize.toString()},
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
          .map((s) => s.direction == VooSortDirection.descending ? '-${_applyFieldPrefix(s.field)}' : _applyFieldPrefix(s.field))
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
        'page[number]': (page + 1).toString(), // JSON:API uses 1-based pagination
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
          .map((s) => s.direction == VooSortDirection.descending ? '-${_applyFieldPrefix(s.field)}' : _applyFieldPrefix(s.field))
          .join(',');
    }

    if (additionalParams != null) {
      params.addAll(additionalParams);
    }

    return params;
  }

  /// OData v4 format - Industry standard for .NET/EF Core APIs
  Map<String, dynamic> _buildODataRequest(
    int page,
    int pageSize,
    Map<String, VooDataFilter> filters,
    List<VooColumnSort> sorts,
    Map<String, dynamic>? additionalParams,
  ) {
    // For OData, return query parameters directly without wrapper
    // This allows them to be used directly in the URL query string
    final queryParams = <String, String>{'\$skip': (page * pageSize).toString(), '\$top': pageSize.toString()};

    // Add $count for total count (OData v4 standard)
    if (additionalParams?['includeCount'] == true) {
      queryParams['\$count'] = 'true';
    }

    // Add $select for field selection
    if (additionalParams?['select'] != null) {
      final selectFields = additionalParams!['select'];
      if (selectFields is List) {
        queryParams['\$select'] = selectFields.join(',');
      } else if (selectFields is String) {
        queryParams['\$select'] = selectFields;
      }
    }

    // Add $expand for related entities (navigation properties)
    if (additionalParams?['expand'] != null) {
      final expandFields = additionalParams!['expand'];
      if (expandFields is List) {
        queryParams['\$expand'] = expandFields.join(',');
      } else if (expandFields is String) {
        queryParams['\$expand'] = expandFields;
      }
    }

    // Add $search for full-text search
    if (additionalParams?['search'] != null) {
      queryParams['\$search'] = '"${additionalParams!['search']}"';
    }

    // Build OData filter expression with proper logical grouping
    if (filters.isNotEmpty) {
      final filterExpressions = <String>[];
      final logicalOperator = additionalParams?['logicalOperator'] ?? 'and';

      filters.forEach((field, filter) {
        final prefixedField = _applyFieldPrefix(field);
        final expression = _buildODataFilterExpression(prefixedField, filter);
        if (expression.isNotEmpty) {
          filterExpressions.add(expression);
        }
      });

      if (filterExpressions.isNotEmpty) {
        // Group expressions properly if there are multiple
        if (filterExpressions.length > 1 && logicalOperator == 'or') {
          queryParams['\$filter'] = filterExpressions.join(' or ');
        } else {
          queryParams['\$filter'] = filterExpressions.join(' and ');
        }
      }
    }

    // Add sorts in OData format
    if (sorts.isNotEmpty) {
      final orderBy = sorts.map((s) => '${_applyFieldPrefix(s.field)} ${s.direction == VooSortDirection.ascending ? 'asc' : 'desc'}').join(',');
      queryParams['\$orderby'] = orderBy;
    }

    // Add $format if specified (json is default)
    if (additionalParams?['format'] != null) {
      queryParams['\$format'] = additionalParams!['format'] as String;
    }

    // Add $compute for calculated properties (OData v4)
    if (additionalParams?['compute'] != null) {
      queryParams['\$compute'] = additionalParams!['compute'] as String;
    }

    // Add $apply for aggregations (OData v4)
    if (additionalParams?['apply'] != null) {
      queryParams['\$apply'] = additionalParams!['apply'] as String;
    }

    // For OData, return query parameters in a way that can be used directly
    // Most HTTP clients expect OData params at the root level of query string
    final result = <String, dynamic>{
      // Return params directly for OData - these should be used as root-level query params
      // NOT nested under 'params' in the actual HTTP request
      'queryParameters': queryParams, // Use this with your HTTP client directly
      'method': 'GET', // OData typically uses GET requests
      'standard': 'odata', // Indicate this is OData format
    };

    // For backward compatibility, also include in params format
    // But HTTP client should use 'queryParameters' for OData
    result['params'] = queryParams;

    if (additionalParams != null) {
      // Remove OData-specific params from additionalParams to avoid duplication
      final cleanedParams = Map<String, dynamic>.from(additionalParams);
      cleanedParams.remove('includeCount');
      cleanedParams.remove('select');
      cleanedParams.remove('expand');
      cleanedParams.remove('search');
      cleanedParams.remove('logicalOperator');
      cleanedParams.remove('format');
      cleanedParams.remove('compute');
      cleanedParams.remove('apply');

      // Add any remaining additional params to metadata
      if (cleanedParams.isNotEmpty) {
        result['metadata'] = cleanedParams;
      }
    }

    return result;
  }

  /// MongoDB/Elasticsearch format
  Map<String, dynamic> _buildMongoDbRequest(
    int page,
    int pageSize,
    Map<String, VooDataFilter> filters,
    List<VooColumnSort> sorts,
    Map<String, dynamic>? additionalParams,
  ) {
    final body = <String, dynamic>{'skip': page * pageSize, 'limit': pageSize};

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
      for (final s in sorts) {
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
    final variables = <String, dynamic>{'page': page, 'pageSize': pageSize};

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
          .map((s) => {'field': _applyFieldPrefix(s.field), 'direction': s.direction == VooSortDirection.ascending ? 'ASC' : 'DESC'})
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
      if (filter.operator == VooFilterOperator.between) {
        // Create GreaterThanOrEqual filter for the lower bound if value exists
        if (filter.value != null) {
          final lowerFilter = <String, dynamic>{
            'fieldName': _applyFieldPrefix(field, pascalCaseField: true),
            'value': filter.value,
            'operator': 'GreaterThanOrEqual',
          };

          // Add lower bound filter to the appropriate type array
          if (filter.value is String) {
            stringFilters.add(lowerFilter);
          } else if (filter.value is int) {
            intFilters.add(lowerFilter);
          } else if (filter.value is DateTime) {
            lowerFilter['value'] = (filter.value as DateTime).toIso8601String();
            dateFilters.add(lowerFilter);
          } else if (filter.value is double) {
            decimalFilters.add(lowerFilter);
          } else {
            // Default to string filter for unknown types
            stringFilters.add(lowerFilter);
          }
        }

        // Create LessThanOrEqual filter for the upper bound if valueTo exists
        if (filter.valueTo != null) {
          final upperFilter = <String, dynamic>{
            'fieldName': _applyFieldPrefix(field, pascalCaseField: true),
            'value': filter.valueTo,
            'operator': 'LessThanOrEqual',
          };

          // Add upper bound filter to the appropriate type array
          if (filter.valueTo is String) {
            stringFilters.add(upperFilter);
          } else if (filter.valueTo is int) {
            intFilters.add(upperFilter);
          } else if (filter.valueTo is DateTime) {
            upperFilter['value'] = (filter.valueTo as DateTime).toIso8601String();
            dateFilters.add(upperFilter);
          } else if (filter.valueTo is double) {
            decimalFilters.add(upperFilter);
          } else {
            // Default to string filter for unknown types
            stringFilters.add(upperFilter);
          }
        }
      } else {
        // Normal filter handling for non-between operators
        final filterMap = <String, dynamic>{
          'fieldName': _applyFieldPrefix(field, pascalCaseField: true),
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
      request['sortBy'] = _applyFieldPrefix(primarySort.field, pascalCaseField: true);
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
      'pagination': {'page': page, 'pageSize': pageSize, 'offset': page * pageSize, 'limit': pageSize},
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

  /// Format values for OData v4 compliance
  String _formatODataValue(dynamic value) {
    if (value == null) {
      return 'null';
    } else if (value is num) {
      return value.toString();
    } else if (value is bool) {
      return value.toString();
    } else if (value is DateTime) {
      // OData v4 uses ISO 8601 format for dates
      final utcDateTime = value.toUtc();
      final isoString = utcDateTime.toIso8601String();

      // Handle different DateTime format requirements based on backend
      if (odataDateTimeFormat == ODataDateTimeFormat.utc) {
        // UTC format with Z suffix (default): 2024-09-30T15:15:30.000Z
        // Works with PostgreSQL 'timestamp with time zone' and most OData implementations
        if (!isoString.endsWith('Z')) {
          return '${isoString}Z';
        }
        return isoString;
      } else {
        // Unspecified format without Z suffix: 2024-09-30T15:15:30.000
        // For .NET backends that don't properly handle UTC strings
        // or DateTime columns without timezone support
        return isoString.replaceAll('Z', '');
      }
    } else if (value is String) {
      // Check if the string is a GUID (unquoted in OData)
      // Format: 8-4-4-4-12 hexadecimal digits
      // Example: 8dd1484c-290c-41b2-918a-0135b8519e1c
      if (_isGuidString(value)) {
        return value; // GUIDs are unquoted in OData
      }

      // Check if the string looks like a date/datetime (ISO 8601 format)
      // Examples: "2024-01-15", "2024-01-15T10:30:00", "2024-01-15T10:30:00.000"
      if (_isDateTimeString(value)) {
        try {
          // Parse as UTC to ensure consistent timezone handling
          // Check if string has timezone info (Z suffix or +/- offset after T)
          final hasTimezone = value.endsWith('Z') ||
              (value.contains('T') && (value.indexOf('+') > value.indexOf('T') ||
               value.lastIndexOf('-') > value.indexOf('T')));

          String dateString = value;
          if (!hasTimezone) {
            // No timezone info - treat as UTC
            if (!value.contains('T')) {
              // Date-only format (e.g., "2024-01-15") - add time component and Z
              dateString = '${value}T00:00:00Z';
            } else {
              // Datetime without timezone (e.g., "2024-01-15T14:30:00") - append Z
              dateString = '${value}Z';
            }
          }

          final dateTime = DateTime.parse(dateString).toUtc();
          final isoString = dateTime.toIso8601String();

          // Apply the same DateTime format configuration as DateTime objects
          if (odataDateTimeFormat == ODataDateTimeFormat.utc) {
            // Ensure 'Z' suffix for UTC
            if (!isoString.endsWith('Z')) {
              return '${isoString}Z';
            }
            return isoString;
          } else {
            // Remove 'Z' suffix for unspecified format
            return isoString.replaceAll('Z', '');
          }
        } catch (e) {
          // If parsing fails, treat as regular string
          final escaped = value.replaceAll("'", "''");
          return "'$escaped'";
        }
      }

      // Escape single quotes by doubling them (OData v4 standard)
      final escaped = value.replaceAll("'", "''");
      return "'$escaped'";
    } else {
      // Default to string representation with escaping
      final escaped = value.toString().replaceAll("'", "''");
      return "'$escaped'";
    }
  }

  /// Check if a string looks like a date/datetime in ISO 8601 format
  bool _isDateTimeString(String value) {
    // Match ISO 8601 date/datetime patterns
    // Examples: 2024-01-15, 2024-01-15T10:30:00, 2024-01-15T10:30:00.000Z
    final dateTimePattern = RegExp(
      r'^\d{4}-\d{2}-\d{2}(T\d{2}:\d{2}:\d{2}(\.\d{1,9})?(Z|[+-]\d{2}:\d{2})?)?$',
    );
    return dateTimePattern.hasMatch(value);
  }

  /// Check if a string is a GUID (UUID) in standard format
  /// GUIDs are unquoted in OData to maintain Edm.Guid type compatibility
  bool _isGuidString(String value) {
    // GUID format: 8-4-4-4-12 hexadecimal digits
    // Example: 8dd1484c-290c-41b2-918a-0135b8519e1c
    final guidPattern = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    );
    return guidPattern.hasMatch(value);
  }

  /// Build OData lambda expression for collection navigation properties
  /// Example: roles/any(r: r/id in ('guid1', 'guid2'))
  String _buildODataCollectionExpression(String field, VooDataFilter filter) {
    final collectionProperty = filter.odataCollectionProperty!;
    final values = filter.value is List ? filter.value as List : [filter.value];

    switch (filter.operator) {
      case VooFilterOperator.contains:
      case VooFilterOperator.inList:
        // Generate: field/any(x: x/property in ('value1', 'value2', ...))
        if (values.isEmpty) {
          return '';
        }
        if (values.length == 1) {
          // For single value: field/any(x: x/property eq 'value')
          return '$field/any(x: x/$collectionProperty eq ${_formatODataValue(values.first)})';
        }
        // For multiple values: field/any(x: x/property in ('value1', 'value2', ...))
        final formattedValues = values.map(_formatODataValue).join(', ');
        return '$field/any(x: x/$collectionProperty in ($formattedValues))';

      case VooFilterOperator.notContains:
      case VooFilterOperator.notInList:
        // Generate: not field/any(x: x/property in ('value1', 'value2', ...))
        if (values.isEmpty) {
          return '';
        }
        if (values.length == 1) {
          return 'not $field/any(x: x/$collectionProperty eq ${_formatODataValue(values.first)})';
        }
        final formattedValues = values.map(_formatODataValue).join(', ');
        return 'not $field/any(x: x/$collectionProperty in ($formattedValues))';

      case VooFilterOperator.equals:
        // For equals on collection: field/any(x: x/property eq 'value')
        return '$field/any(x: x/$collectionProperty eq ${_formatODataValue(filter.value)})';

      case VooFilterOperator.notEquals:
        // For not equals on collection: not field/any(x: x/property eq 'value')
        return 'not $field/any(x: x/$collectionProperty eq ${_formatODataValue(filter.value)})';

      case VooFilterOperator.isNull:
        // Check if collection has no items
        return 'not $field/any()';

      case VooFilterOperator.isNotNull:
        // Check if collection has items
        return '$field/any()';

      default:
        // For other operators, use standard logic with any()
        final op = _getODataOperator(filter.operator);
        return '$field/any(x: x/$collectionProperty $op ${_formatODataValue(filter.value)})';
    }
  }

  /// Get OData operator string from VooFilterOperator
  String _getODataOperator(VooFilterOperator operator) {
    switch (operator) {
      case VooFilterOperator.equals:
        return 'eq';
      case VooFilterOperator.notEquals:
        return 'ne';
      case VooFilterOperator.greaterThan:
        return 'gt';
      case VooFilterOperator.lessThan:
        return 'lt';
      case VooFilterOperator.greaterThanOrEqual:
        return 'ge';
      case VooFilterOperator.lessThanOrEqual:
        return 'le';
      default:
        return 'eq';
    }
  }

  String _buildODataFilterExpression(String field, VooDataFilter filter) {
    // Handle OData collection navigation properties
    if (filter.odataCollectionProperty != null) {
      return _buildODataCollectionExpression(field, filter);
    }

    switch (filter.operator) {
      case VooFilterOperator.equals:
        return '$field eq ${_formatODataValue(filter.value)}';
      case VooFilterOperator.notEquals:
        return '$field ne ${_formatODataValue(filter.value)}';
      case VooFilterOperator.greaterThan:
        return '$field gt ${_formatODataValue(filter.value)}';
      case VooFilterOperator.lessThan:
        return '$field lt ${_formatODataValue(filter.value)}';
      case VooFilterOperator.greaterThanOrEqual:
        return '$field ge ${_formatODataValue(filter.value)}';
      case VooFilterOperator.lessThanOrEqual:
        return '$field le ${_formatODataValue(filter.value)}';
      case VooFilterOperator.contains:
        return 'contains($field, ${_formatODataValue(filter.value)})';
      case VooFilterOperator.notContains:
        // OData v4: use 'not contains()' for negation
        return 'not contains($field, ${_formatODataValue(filter.value)})';
      case VooFilterOperator.startsWith:
        return 'startswith($field, ${_formatODataValue(filter.value)})';
      case VooFilterOperator.endsWith:
        return 'endswith($field, ${_formatODataValue(filter.value)})';
      case VooFilterOperator.between:
        // Build expression parts based on available values
        final expressions = <String>[];
        if (filter.value != null) {
          expressions.add('$field ge ${_formatODataValue(filter.value)}');
        }
        if (filter.valueTo != null) {
          expressions.add('$field le ${_formatODataValue(filter.valueTo)}');
        }
        // Return combined expression or single expression or empty
        if (expressions.length == 2) {
          return '(${expressions.join(' and ')})';
        } else if (expressions.length == 1) {
          return expressions.first;
        } else {
          return '';
        }
      case VooFilterOperator.inList:
        // OData v4 'in' operator for collections
        if (filter.value is List) {
          final values = (filter.value as List).map(_formatODataValue).join(',');
          return '$field in ($values)';
        } else {
          return '$field in (${_formatODataValue(filter.value)})';
        }
      case VooFilterOperator.notInList:
        // OData v4: use 'not (field in (...))' for not in list
        if (filter.value is List) {
          final values = (filter.value as List).map(_formatODataValue).join(',');
          return 'not ($field in ($values))';
        } else {
          return 'not ($field in (${_formatODataValue(filter.value)}))';
        }
      case VooFilterOperator.isNull:
        return '$field eq null';
      case VooFilterOperator.isNotNull:
        return '$field ne null';
    }
  }

  dynamic _buildMongoDbOperator(VooDataFilter filter) {
    switch (filter.operator) {
      case VooFilterOperator.equals:
        return filter.value; // MongoDB uses direct value for equality
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
          '\$in': filter.value is List ? filter.value : [filter.value],
        };
      case VooFilterOperator.notInList:
        return {
          '\$nin': filter.value is List ? filter.value : [filter.value],
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
          'between': [filter.value, filter.valueTo],
        };
      case VooFilterOperator.inList:
        return {
          'in': filter.value is List ? filter.value : [filter.value],
        };
      case VooFilterOperator.notInList:
        return {
          'notIn': filter.value is List ? filter.value : [filter.value],
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
    const builder = DataGridRequestBuilder();
    return builder.buildRequest(page: page, pageSize: pageSize, filters: filters, sorts: sorts, additionalParams: additionalParams);
  }

  /// Build filters array for the request
  List<Map<String, dynamic>> _buildFilters(Map<String, VooDataFilter> filters) => filters.entries.map((entry) {
    final filter = entry.value;
    final filterMap = <String, dynamic>{'field': _applyFieldPrefix(entry.key), 'operator': _operatorToString(filter.operator)};

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

  /// Build sorts array for the request
  List<Map<String, dynamic>> _buildSorts(List<VooColumnSort> sorts) => sorts
      .where((sort) => sort.direction != VooSortDirection.none)
      .map((sort) => {'field': _applyFieldPrefix(sort.field), 'direction': _sortDirectionToString(sort.direction)})
      .toList();

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
    final params = <String, String>{'page': page.toString(), 'pageSize': pageSize.toString()};

    // Add filters as query params
    int filterIndex = 0;
    filters.forEach((field, filter) {
      final prefix = 'filters[$filterIndex]';
      params['$prefix.field'] = field;
      params['$prefix.operator'] = _operatorToString(filter.operator);

      if (filter.operator != VooFilterOperator.isNull && filter.operator != VooFilterOperator.isNotNull) {
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

    return VooDataGridResponse(rows: data, totalRows: total, page: page, pageSize: pageSize);
  }

  /// Parse OData v4 response format
  static VooDataGridResponse parseODataResponse({required Map<String, dynamic> json, int page = 0, int pageSize = 20}) {
    // OData v4 standard response structure
    // {
    //   "@odata.context": "$metadata#Products",
    //   "@odata.count": 100,  // Total count when $count=true
    //   "value": [             // Array of entities
    //     { "id": 1, "name": "Product 1" },
    //     { "id": 2, "name": "Product 2" }
    //   ],
    //   "@odata.nextLink": "Products?$skip=20&$top=20"  // Next page URL
    // }

    // Extract data from 'value' array (OData standard)
    final data = json['value'] as List<dynamic>? ?? [];

    // Extract total count from '@odata.count' if present
    // This is only available when $count=true is included in the request
    final total = json['@odata.count'] as int? ?? data.length;

    return VooDataGridResponse(rows: data, totalRows: total, page: page, pageSize: pageSize);
  }

  /// Extract OData metadata from response
  static Map<String, dynamic> extractODataMetadata(Map<String, dynamic> json) {
    final metadata = <String, dynamic>{};

    // Extract all OData annotations (properties starting with @odata)
    json.forEach((key, value) {
      if (key.startsWith('@odata')) {
        metadata[key] = value;
      }
    });

    // Add computed properties
    metadata['hasNextPage'] = json.containsKey('@odata.nextLink');
    metadata['hasDeltaLink'] = json.containsKey('@odata.deltaLink');

    return metadata;
  }

  /// Parse OData v4 error response
  static Map<String, dynamic>? parseODataError(Map<String, dynamic> json) {
    // OData v4 error format:
    // {
    //   "error": {
    //     "code": "BadRequest",
    //     "message": "The request is invalid.",
    //     "details": [
    //       {
    //         "code": "ValidationError",
    //         "message": "The field 'Price' must be greater than 0."
    //       }
    //     ]
    //   }
    // }

    if (json.containsKey('error')) {
      final error = json['error'] as Map<String, dynamic>;
      return {'code': error['code'], 'message': error['message'], 'details': error['details']};
    }
    return null;
  }

  /// Build an advanced filter request body with support for secondary filters
  static Map<String, dynamic> buildAdvancedRequestBody({required AdvancedFilterRequest request, Map<String, dynamic>? additionalParams}) {
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
        secondaryFilter = SecondaryFilter(logic: FilterLogic.and, value: filter.valueTo, operator: 'LessThanOrEqual');
      }

      // Determine filter type based on value type
      if (value is String) {
        stringFilters.add(StringFilter(fieldName: field, value: value, operator: operator, secondaryFilter: secondaryFilter));
      } else if (value is int) {
        intFilters.add(IntFilter(fieldName: field, value: value, operator: operator, secondaryFilter: secondaryFilter));
      } else if (value is double) {
        decimalFilters.add(DecimalFilter(fieldName: field, value: value, operator: operator, secondaryFilter: secondaryFilter));
      } else if (value is DateTime) {
        dateFilters.add(DateFilter(fieldName: field, value: value, operator: operator, secondaryFilter: secondaryFilter));
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
  final Future<Map<String, dynamic>> Function(String url, Map<String, dynamic> requestData, Map<String, String>? headers)? httpClient;

  RemoteDataGridSource({required this.apiEndpoint, this.headers, this.apiStandard = ApiFilterStandard.custom, this.fieldPrefix, this.httpClient})
    : requestBuilder = DataGridRequestBuilder(standard: apiStandard, fieldPrefix: fieldPrefix),
      super(mode: VooDataGridMode.remote);

  @override
  Future<VooDataGridResponse> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // Build request based on API standard
    final requestData = requestBuilder.buildRequest(page: page, pageSize: pageSize, filters: filters, sorts: sorts);

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
