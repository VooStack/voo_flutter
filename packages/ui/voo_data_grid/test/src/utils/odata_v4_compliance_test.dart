import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('OData v4 Compliance Tests', () {
    late DataGridRequestBuilder builder;

    setUp(() {
      builder = const DataGridRequestBuilder(standard: ApiFilterStandard.odata);
    });

    group('OData v4 Query Options', () {
      test(r'should support $count parameter', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: [],
          additionalParams: {'includeCount': true},
        );
        final params = result['params'] as Map<String, String>;

        expect(params[r'$count'], 'true');
      });

      test(r'should support $select parameter for field selection', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: [],
          additionalParams: {
            'select': ['id', 'name', 'price'],
          },
        );
        final params = result['params'] as Map<String, String>;

        expect(params[r'$select'], 'id,name,price');
      });

      test(r'should support $expand parameter for related entities', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: [],
          additionalParams: {
            'expand': ['category', 'supplier'],
          },
        );
        final params = result['params'] as Map<String, String>;

        expect(params[r'$expand'], 'category,supplier');
      });

      test(r'should support $search for full-text search', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: [],
          additionalParams: {
            'search': 'laptop computer',
          },
        );
        final params = result['params'] as Map<String, String>;

        expect(params[r'$search'], '"laptop computer"');
      });

      test(r'should support $format parameter', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: [],
          additionalParams: {
            'format': 'json',
          },
        );
        final params = result['params'] as Map<String, String>;

        expect(params[r'$format'], 'json');
      });

      test(r'should support $compute for calculated properties', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: [],
          additionalParams: {
            'compute': 'Price * Quantity as Total',
          },
        );
        final params = result['params'] as Map<String, String>;

        expect(params[r'$compute'], 'Price * Quantity as Total');
      });

      test(r'should support $apply for aggregations', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: [],
          additionalParams: {
            'apply': 'groupby((Category), aggregate(Price with sum as TotalPrice))',
          },
        );
        final params = result['params'] as Map<String, String>;

        expect(
          params[r'$apply'],
          'groupby((Category), aggregate(Price with sum as TotalPrice))',
        );
      });
    });

    group('OData v4 Value Formatting', () {
      test('should properly escape single quotes in string values', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'name': const VooDataFilter(
              operator: VooFilterOperator.equals,
              value: "O'Reilly's Books",
            ),
          },
          sorts: [],
        );
        final params = result['params'] as Map<String, String>;

        expect(params[r'$filter'], "name eq 'O''Reilly''s Books'");
      });

      test('should format DateTime values in ISO 8601', () {
        final testDate = DateTime(2024, 3, 15, 10, 30);
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'createdDate': VooDataFilter(
              operator: VooFilterOperator.greaterThan,
              value: testDate,
            ),
          },
          sorts: [],
        );
        final params = result['params'] as Map<String, String>;

        expect(
          params[r'$filter'],
          contains(testDate.toUtc().toIso8601String()),
        );
      });

      test('should not quote numeric values', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'age': const VooDataFilter(
              operator: VooFilterOperator.equals,
              value: 25,
            ),
            'price': const VooDataFilter(
              operator: VooFilterOperator.greaterThan,
              value: 99.99,
            ),
          },
          sorts: [],
        );
        final params = result['params'] as Map<String, String>;

        expect(params[r'$filter'], 'age eq 25 and price gt 99.99');
      });

      test('should format boolean values correctly', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'isActive': const VooDataFilter(
              operator: VooFilterOperator.equals,
              value: true,
            ),
            'isDeleted': const VooDataFilter(
              operator: VooFilterOperator.equals,
              value: false,
            ),
          },
          sorts: [],
        );
        final params = result['params'] as Map<String, String>;

        expect(params[r'$filter'], 'isActive eq true and isDeleted eq false');
      });

      test('should handle null values correctly', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'deletedDate': const VooDataFilter(
              operator: VooFilterOperator.isNull,
              value: null,
            ),
            'updatedDate': const VooDataFilter(
              operator: VooFilterOperator.isNotNull,
              value: null,
            ),
          },
          sorts: [],
        );
        final params = result['params'] as Map<String, String>;

        expect(
          params[r'$filter'],
          'deletedDate eq null and updatedDate ne null',
        );
      });
    });

    group('OData v4 Advanced Operators', () {
      test('should support in operator for collections', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'status': const VooDataFilter(
              operator: VooFilterOperator.inList,
              value: ['active', 'pending', 'processing'],
            ),
          },
          sorts: [],
        );
        final params = result['params'] as Map<String, String>;

        expect(
          params[r'$filter'],
          "status in ('active','pending','processing')",
        );
      });

      test('should support not in operator with proper negation', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'status': const VooDataFilter(
              operator: VooFilterOperator.notInList,
              value: ['deleted', 'archived'],
            ),
          },
          sorts: [],
        );
        final params = result['params'] as Map<String, String>;

        expect(
          params[r'$filter'],
          "not (status in ('deleted','archived'))",
        );
      });

      test('should support not contains operator', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'description': const VooDataFilter(
              operator: VooFilterOperator.notContains,
              value: 'discontinued',
            ),
          },
          sorts: [],
        );
        final params = result['params'] as Map<String, String>;

        expect(
          params[r'$filter'],
          "not contains(description, 'discontinued')",
        );
      });

      test('should properly group between operator expressions', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'price': const VooDataFilter(
              operator: VooFilterOperator.between,
              value: 10.0,
              valueTo: 100.0,
            ),
          },
          sorts: [],
        );
        final params = result['params'] as Map<String, String>;

        expect(params[r'$filter'], '(price ge 10.0 and price le 100.0)');
      });
    });

    group('OData v4 Logical Operators', () {
      test('should support OR logical operator', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'status': const VooDataFilter(
              operator: VooFilterOperator.equals,
              value: 'active',
            ),
            'priority': const VooDataFilter(
              operator: VooFilterOperator.equals,
              value: 'high',
            ),
          },
          sorts: [],
          additionalParams: {'logicalOperator': 'or'},
        );
        final params = result['params'] as Map<String, String>;

        expect(params[r'$filter'], "status eq 'active' or priority eq 'high'");
      });

      test('should default to AND logical operator', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'status': const VooDataFilter(
              operator: VooFilterOperator.equals,
              value: 'active',
            ),
            'priority': const VooDataFilter(
              operator: VooFilterOperator.equals,
              value: 'high',
            ),
          },
          sorts: [],
        );
        final params = result['params'] as Map<String, String>;

        expect(params[r'$filter'], "status eq 'active' and priority eq 'high'");
      });
    });

    group('OData v4 Response Parsing', () {
      test('should parse standard OData response', () {
        final odataResponse = {
          '@odata.context': r'$metadata#Products',
          '@odata.count': 100,
          'value': [
            {'id': 1, 'name': 'Product 1', 'price': 10.0},
            {'id': 2, 'name': 'Product 2', 'price': 20.0},
          ],
          '@odata.nextLink': r'Products?$skip=20&$top=20',
        };

        final response = DataGridRequestBuilder.parseODataResponse(
          json: odataResponse,
        );

        expect(response.rows.length, 2);
        expect(response.totalRows, 100);
        expect(response.page, 0);
        expect(response.pageSize, 20);
      });

      test('should handle response without count', () {
        final odataResponse = {
          '@odata.context': r'$metadata#Products',
          'value': [
            {'id': 1, 'name': 'Product 1'},
            {'id': 2, 'name': 'Product 2'},
          ],
        };

        final response = DataGridRequestBuilder.parseODataResponse(
          json: odataResponse,
        );

        expect(response.rows.length, 2);
        expect(response.totalRows, 2); // Falls back to array length
      });

      test('should extract OData metadata', () {
        final odataResponse = {
          '@odata.context': r'$metadata#Products',
          '@odata.count': 100,
          '@odata.nextLink': r'Products?$skip=20&$top=20',
          '@odata.deltaLink': 'Products?delta=xyz',
          'value': <Map<String, dynamic>>[],
        };

        final metadata = DataGridRequestBuilder.extractODataMetadata(
          odataResponse,
        );

        expect(metadata['@odata.context'], r'$metadata#Products');
        expect(metadata['@odata.count'], 100);
        expect(metadata['@odata.nextLink'], r'Products?$skip=20&$top=20');
        expect(metadata['@odata.deltaLink'], 'Products?delta=xyz');
        expect(metadata['hasNextPage'], true);
        expect(metadata['hasDeltaLink'], true);
      });

      test('should parse OData error response', () {
        final errorResponse = {
          'error': {
            'code': 'BadRequest',
            'message': 'The request is invalid.',
            'details': [
              {
                'code': 'ValidationError',
                'message': 'The field Price must be greater than 0.',
              },
            ],
          },
        };

        final error = DataGridRequestBuilder.parseODataError(errorResponse);

        expect(error, isNotNull);
        expect(error!['code'], 'BadRequest');
        expect(error['message'], 'The request is invalid.');
        expect(error['details'], isNotNull);
        expect((error['details'] as List).length, 1);
      });

      test('should return null for non-error responses', () {
        final normalResponse = {
          'value': <Map<String, dynamic>>[],
          '@odata.context': r'$metadata#Products',
        };

        final error = DataGridRequestBuilder.parseODataError(normalResponse);

        expect(error, isNull);
      });
    });

    group('OData v4 with Field Prefix', () {
      test('should apply field prefix to filter fields', () {
        const builderWithPrefix = DataGridRequestBuilder(
          standard: ApiFilterStandard.odata,
          fieldPrefix: 'data',
        );

        final result = builderWithPrefix.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'name': const VooDataFilter(
              operator: VooFilterOperator.contains,
              value: 'test',
            ),
          },
          sorts: [],
        );
        final params = result['params'] as Map<String, String>;

        expect(params[r'$filter'], "contains(data.name, 'test')");
      });

      test('should apply field prefix to sort fields', () {
        const builderWithPrefix = DataGridRequestBuilder(
          standard: ApiFilterStandard.odata,
          fieldPrefix: 'data',
        );

        final result = builderWithPrefix.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: [
            const VooColumnSort(
              field: 'price',
              direction: VooSortDirection.descending,
            ),
          ],
        );
        final params = result['params'] as Map<String, String>;

        expect(params[r'$orderby'], 'data.price desc');
      });
    });

    group('OData v4 Complex Scenarios', () {
      test('should handle multiple filters with different types', () {
        final testDate = DateTime(2024);
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'name': const VooDataFilter(
              operator: VooFilterOperator.startsWith,
              value: 'Pro',
            ),
            'price': const VooDataFilter(
              operator: VooFilterOperator.between,
              value: 10.0,
              valueTo: 100.0,
            ),
            'category': const VooDataFilter(
              operator: VooFilterOperator.inList,
              value: ['electronics', 'computers'],
            ),
            'createdDate': VooDataFilter(
              operator: VooFilterOperator.greaterThan,
              value: testDate,
            ),
            'deletedDate': const VooDataFilter(
              operator: VooFilterOperator.isNull,
              value: null,
            ),
          },
          sorts: [
            const VooColumnSort(field: 'price', direction: VooSortDirection.ascending),
            const VooColumnSort(field: 'name', direction: VooSortDirection.descending),
          ],
        );
        final params = result['params'] as Map<String, String>;

        expect(params[r'$filter'], contains("startswith(name, 'Pro')"));
        expect(params[r'$filter'], contains('(price ge 10.0 and price le 100.0)'));
        expect(params[r'$filter'], contains("category in ('electronics','computers')"));
        expect(params[r'$filter'], contains(testDate.toUtc().toIso8601String()));
        expect(params[r'$filter'], contains('deletedDate eq null'));
        expect(params[r'$orderby'], 'price asc,name desc');
      });

      test('should handle all query options together', () {
        final result = builder.buildRequest(
          page: 2,
          pageSize: 50,
          filters: {
            'status': const VooDataFilter(
              operator: VooFilterOperator.equals,
              value: 'active',
            ),
          },
          sorts: [
            const VooColumnSort(
              field: 'createdDate',
              direction: VooSortDirection.descending,
            ),
          ],
          additionalParams: {
            'includeCount': true,
            'select': ['id', 'name', 'status', 'createdDate'],
            'expand': 'category',
            'search': 'product',
            'format': 'json',
          },
        );
        final params = result['params'] as Map<String, String>;

        expect(params[r'$skip'], '100'); // page 2 * pageSize 50
        expect(params[r'$top'], '50');
        expect(params[r'$count'], 'true');
        expect(params[r'$select'], 'id,name,status,createdDate');
        expect(params[r'$expand'], 'category');
        expect(params[r'$search'], '"product"');
        expect(params[r'$format'], 'json');
        expect(params[r'$filter'], "status eq 'active'");
        expect(params[r'$orderby'], 'createdDate desc');
      });
    });
  });
}
