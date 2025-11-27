import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// Integration tests for OData v4 support with .NET backends
///
/// These tests verify:
/// 1. OData query string generation
/// 2. Filter expression building
/// 3. DateTime format handling for different .NET configurations
/// 4. Response parsing for .NET OData services
/// 5. Collection/navigation property filtering
void main() {
  group('OData Request Builder Tests', () {
    group('Basic Query Parameters', () {
      test('should build correct pagination parameters', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        final result = builder.buildRequest(page: 0, pageSize: 20, filters: {}, sorts: []);

        final params = result['queryParameters'] as Map<String, String>;
        expect(params['\$skip'], '0');
        expect(params['\$top'], '20');
      });

      test('should calculate skip correctly for page 2', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        final result = builder.buildRequest(page: 2, pageSize: 25, filters: {}, sorts: []);

        final params = result['queryParameters'] as Map<String, String>;
        expect(params['\$skip'], '50'); // 2 * 25
        expect(params['\$top'], '25');
      });

      test('should include \$count when requested', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        final result = builder.buildRequest(page: 0, pageSize: 20, filters: {}, sorts: [], additionalParams: {'includeCount': true});

        final params = result['queryParameters'] as Map<String, String>;
        expect(params[r'$count'], 'true');
      });

      test('should include \$select for field selection', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: [],
          additionalParams: {
            'select': ['id', 'name', 'price'],
          },
        );

        final params = result['queryParameters'] as Map<String, String>;
        expect(params[r'$select'], 'id,name,price');
      });

      test('should include \$expand for navigation properties', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: [],
          additionalParams: {
            'expand': ['category', 'supplier'],
          },
        );

        final params = result['queryParameters'] as Map<String, String>;
        expect(params[r'$expand'], 'category,supplier');
      });
    });

    group('Filter Expression Building', () {
      test('should build equals filter', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'status': const VooDataFilter(operator: VooFilterOperator.equals, value: 'active')},
          sorts: [],
        );

        final params = result['queryParameters'] as Map<String, String>;
        expect(params['\$filter'], "status eq 'active'");
      });

      test('should build not equals filter', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'status': const VooDataFilter(operator: VooFilterOperator.notEquals, value: 'deleted')},
          sorts: [],
        );

        final params = result['queryParameters'] as Map<String, String>;
        expect(params['\$filter'], "status ne 'deleted'");
      });

      test('should build contains filter', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'name': const VooDataFilter(operator: VooFilterOperator.contains, value: 'widget')},
          sorts: [],
        );

        final params = result['queryParameters'] as Map<String, String>;
        expect(params['\$filter'], "contains(name, 'widget')");
      });

      test('should build startsWith filter', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'code': const VooDataFilter(operator: VooFilterOperator.startsWith, value: 'PRD')},
          sorts: [],
        );

        final params = result['queryParameters'] as Map<String, String>;
        expect(params['\$filter'], "startswith(code, 'PRD')");
      });

      test('should build numeric comparison filters', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'price': const VooDataFilter(operator: VooFilterOperator.greaterThan, value: 100),
            'stock': const VooDataFilter(operator: VooFilterOperator.lessThanOrEqual, value: 50),
          },
          sorts: [],
        );

        final params = result['queryParameters'] as Map<String, String>;
        expect(params['\$filter'], contains('price gt 100'));
        expect(params['\$filter'], contains('stock le 50'));
        expect(params['\$filter'], contains(' and '));
      });

      test('should build between filter', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'price': const VooDataFilter(operator: VooFilterOperator.between, value: 10, valueTo: 100)},
          sorts: [],
        );

        final params = result['queryParameters'] as Map<String, String>;
        expect(params['\$filter'], '(price ge 10 and price le 100)');
      });

      test('should build in list filter', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'category': const VooDataFilter(operator: VooFilterOperator.inList, value: ['electronics', 'furniture', 'clothing']),
          },
          sorts: [],
        );

        final params = result['queryParameters'] as Map<String, String>;
        expect(params['\$filter'], "category in ('electronics','furniture','clothing')");
      });

      test('should build is null filter', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'deletedAt': const VooDataFilter(operator: VooFilterOperator.isNull, value: null)},
          sorts: [],
        );

        final params = result['queryParameters'] as Map<String, String>;
        expect(params['\$filter'], 'deletedAt eq null');
      });

      test('should escape single quotes in string values', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'name': const VooDataFilter(operator: VooFilterOperator.equals, value: "O'Brien")},
          sorts: [],
        );

        final params = result['queryParameters'] as Map<String, String>;
        expect(params['\$filter'], "name eq 'O''Brien'");
      });

      test('should handle GUID values without quotes', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'id': const VooDataFilter(operator: VooFilterOperator.equals, value: '8dd1484c-290c-41b2-918a-0135b8519e1c')},
          sorts: [],
        );

        final params = result['queryParameters'] as Map<String, String>;
        // GUIDs should not be quoted in OData
        expect(params['\$filter'], 'id eq 8dd1484c-290c-41b2-918a-0135b8519e1c');
      });
    });

    group('DateTime Format Handling for .NET', () {
      test('should format DateTime with UTC suffix (default)', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        final date = DateTime.utc(2024, 9, 30, 15, 15, 30);
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'createdAt': VooDataFilter(operator: VooFilterOperator.equals, value: date)},
          sorts: [],
        );

        final params = result['queryParameters'] as Map<String, String>;
        expect(params['\$filter'], contains('2024-09-30T15:15:30.000Z'));
      });

      test('should format DateTime without Z suffix (unspecified)', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata, odataDateTimeFormat: ODataDateTimeFormat.unspecified);

        final date = DateTime.utc(2024, 9, 30, 15, 15, 30);
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'createdAt': VooDataFilter(operator: VooFilterOperator.equals, value: date)},
          sorts: [],
        );

        final params = result['queryParameters'] as Map<String, String>;
        expect(params['\$filter'], contains('2024-09-30T15:15:30.000'));
        expect(params['\$filter'], isNot(contains('Z')));
      });

      test('should format DateTime with UTC offset', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata, odataDateTimeFormat: ODataDateTimeFormat.utcOffset);

        final date = DateTime.utc(2024, 9, 30, 15, 15, 30);
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'createdAt': VooDataFilter(operator: VooFilterOperator.equals, value: date)},
          sorts: [],
        );

        final params = result['queryParameters'] as Map<String, String>;
        expect(params['\$filter'], contains('+00:00'));
      });

      test('should parse date strings from form input', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'orderDate': const VooDataFilter(operator: VooFilterOperator.greaterThanOrEqual, value: '2024-01-15')},
          sorts: [],
        );

        final params = result['queryParameters'] as Map<String, String>;
        // Should be parsed as a date and formatted
        expect(params['\$filter'], contains('orderDate ge'));
        expect(params['\$filter'], contains('2024-01-15'));
      });
    });

    group('Sorting', () {
      test('should build single sort ascending', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: [const VooColumnSort(field: 'name', direction: VooSortDirection.ascending)],
        );

        final params = result['queryParameters'] as Map<String, String>;
        expect(params['\$orderby'], 'name asc');
      });

      test('should build single sort descending', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: [const VooColumnSort(field: 'createdAt', direction: VooSortDirection.descending)],
        );

        final params = result['queryParameters'] as Map<String, String>;
        expect(params['\$orderby'], 'createdAt desc');
      });

      test('should build multiple sorts', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: [
            const VooColumnSort(field: 'category', direction: VooSortDirection.ascending),
            const VooColumnSort(field: 'price', direction: VooSortDirection.descending),
          ],
        );

        final params = result['queryParameters'] as Map<String, String>;
        expect(params['\$orderby'], 'category asc,price desc');
      });
    });

    group('Collection/Navigation Property Filtering', () {
      test('should build any() filter for single value in collection', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'roles': const VooDataFilter(operator: VooFilterOperator.contains, value: 'admin', odataCollectionProperty: 'name')},
          sorts: [],
        );

        final params = result['queryParameters'] as Map<String, String>;
        expect(params['\$filter'], "roles/any(x: x/name eq 'admin')");
      });

      test('should build any() filter with in() for multiple values', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'roles': const VooDataFilter(operator: VooFilterOperator.inList, value: ['admin', 'manager'], odataCollectionProperty: 'id'),
          },
          sorts: [],
        );

        final params = result['queryParameters'] as Map<String, String>;
        expect(params['\$filter'], "roles/any(x: x/id in ('admin', 'manager'))");
      });

      test('should build not any() filter for exclusion', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'tags': const VooDataFilter(operator: VooFilterOperator.notContains, value: 'deprecated', odataCollectionProperty: 'name')},
          sorts: [],
        );

        final params = result['queryParameters'] as Map<String, String>;
        expect(params['\$filter'], "not tags/any(x: x/name eq 'deprecated')");
      });
    });

    group('Field Prefix Support', () {
      test('should apply field prefix to filter fields', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata, fieldPrefix: 'Entity');

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'name': const VooDataFilter(operator: VooFilterOperator.equals, value: 'Test')},
          sorts: [],
        );

        final params = result['queryParameters'] as Map<String, String>;
        expect(params['\$filter'], "Entity.name eq 'Test'");
      });

      test('should apply field prefix to sort fields', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata, fieldPrefix: 'Product');

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: [const VooColumnSort(field: 'price', direction: VooSortDirection.ascending)],
        );

        final params = result['queryParameters'] as Map<String, String>;
        expect(params['\$orderby'], 'Product.price asc');
      });
    });
  });

  group('OData Response Parsing', () {
    test('should parse standard OData v4 response', () {
      final json = {
        '@odata.context': '\$metadata#Products',
        '@odata.count': 100,
        'value': [
          {'id': 1, 'name': 'Product 1', 'price': 10.0},
          {'id': 2, 'name': 'Product 2', 'price': 20.0},
        ],
      };

      final response = DataGridRequestBuilder.parseODataResponse(json: json);

      expect(response.rows.length, 2);
      expect(response.totalRows, 100);
      expect(response.page, 0);
      expect(response.pageSize, 20);
    });

    test('should handle response without @odata.count', () {
      final json = {
        'value': [
          {'id': 1, 'name': 'Product 1'},
        ],
      };

      final response = DataGridRequestBuilder.parseODataResponse(json: json);

      expect(response.rows.length, 1);
      expect(response.totalRows, 1); // Falls back to value length
    });

    test('should extract OData metadata', () {
      // ignore: inference_failure_on_collection_literal
      final json = {'@odata.context': '\$metadata#Products', '@odata.count': 100, '@odata.nextLink': 'Products?\$skip=20&\$top=20', 'value': []};

      final metadata = DataGridRequestBuilder.extractODataMetadata(json);

      expect(metadata['@odata.context'], '\$metadata#Products');
      expect(metadata['@odata.count'], 100);
      expect(metadata['@odata.nextLink'], 'Products?\$skip=20&\$top=20');
      expect(metadata['hasNextPage'], true);
    });

    test('should parse OData error response', () {
      final json = {
        'error': {
          'code': 'BadRequest',
          'message': 'The request is invalid.',
          'details': [
            {'code': 'ValidationError', 'message': "The field 'Price' must be greater than 0."},
          ],
        },
      };

      final error = DataGridRequestBuilder.parseODataError(json);

      expect(error, isNotNull);
      expect(error!['code'], 'BadRequest');
      expect(error['message'], 'The request is invalid.');
      expect(error['details'], isNotNull);
    });
  });

  group('.NET OData Integration Scenarios', () {
    test('should build complete query for ASP.NET Core OData', () {
      const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

      final result = builder.buildRequest(
        page: 1,
        pageSize: 25,
        filters: {
          'isActive': const VooDataFilter(operator: VooFilterOperator.equals, value: true),
          'name': const VooDataFilter(operator: VooFilterOperator.contains, value: 'widget'),
          'price': const VooDataFilter(operator: VooFilterOperator.between, value: 10.0, valueTo: 100.0),
        },
        sorts: [const VooColumnSort(field: 'name', direction: VooSortDirection.ascending)],
        additionalParams: {
          'includeCount': true,
          'expand': ['category'],
        },
      );

      final params = result['queryParameters'] as Map<String, String>;

      // Verify pagination
      expect(params['\$skip'], '25');
      expect(params['\$top'], '25');
      expect(params[r'$count'], 'true');

      // Verify expand
      expect(params[r'$expand'], 'category');

      // Verify sort
      expect(params['\$orderby'], 'name asc');

      // Verify filters
      expect(params['\$filter'], contains('isActive eq true'));
      expect(params['\$filter'], contains("contains(name, 'widget')"));
      expect(params['\$filter'], contains('price ge 10'));
      expect(params['\$filter'], contains('price le 100'));
    });

    test('should work with Entity Framework date comparison', () {
      const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata, odataDateTimeFormat: ODataDateTimeFormat.unspecified);

      final startDate = DateTime(2024);
      final endDate = DateTime(2024, 12, 31);

      final result = builder.buildRequest(
        page: 0,
        pageSize: 20,
        filters: {'orderDate': VooDataFilter(operator: VooFilterOperator.between, value: startDate, valueTo: endDate)},
        sorts: [],
      );

      final params = result['queryParameters'] as Map<String, String>;
      final filter = params['\$filter']!;

      // Should use unspecified format for EF Core DateTime
      expect(filter, contains('orderDate ge'));
      expect(filter, contains('orderDate le'));
      expect(filter, isNot(contains('Z'))); // No Z suffix for unspecified
    });
  });
}
