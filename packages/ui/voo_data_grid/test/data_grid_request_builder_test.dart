import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('DataGridRequestBuilder', () {
    group('buildRequestBody', () {
      test('should build basic request with pagination', () {
        final result = DataGridRequestBuilder.buildRequestBody(
          page: 2,
          pageSize: 25,
          filters: {},
          sorts: [],
        );

        expect(result, {
          'pagination': {
            'page': 2,
            'pageSize': 25,
            'offset': 50,
            'limit': 25,
          },
        });
      });

      test('should include filters when provided', () {
        final filters = {
          'name': VooDataFilter(
            operator: VooFilterOperator.contains,
            value: 'John',
          ),
          'age': VooDataFilter(
            operator: VooFilterOperator.greaterThan,
            value: 18,
          ),
        };

        final result = DataGridRequestBuilder.buildRequestBody(
          page: 0,
          pageSize: 10,
          filters: filters,
          sorts: [],
        );

        expect(result['filters'], isNotNull);
        expect(result['filters'], isList);
        expect((result['filters'] as List).length, 2);
        
        final filtersList = result['filters'] as List;
        expect(filtersList.any((f) => f['field'] == 'name'), isTrue);
        expect(filtersList.any((f) => f['field'] == 'age'), isTrue);
      });

      test('should include sorts when provided', () {
        final sorts = [
          VooColumnSort(field: 'name', direction: VooSortDirection.ascending),
          VooColumnSort(field: 'date', direction: VooSortDirection.descending),
        ];

        final result = DataGridRequestBuilder.buildRequestBody(
          page: 0,
          pageSize: 10,
          filters: {},
          sorts: sorts,
        );

        expect(result['sorts'], isNotNull);
        expect(result['sorts'], isList);
        expect((result['sorts'] as List).length, 2);
        
        final sortsList = result['sorts'] as List;
        expect(sortsList[0], {
          'field': 'name',
          'direction': 'asc',
        });
        expect(sortsList[1], {
          'field': 'date',
          'direction': 'desc',
        });
      });

      test('should include additional params as metadata', () {
        final additionalParams = {
          'userId': '123',
          'context': 'admin',
        };

        final result = DataGridRequestBuilder.buildRequestBody(
          page: 0,
          pageSize: 10,
          filters: {},
          sorts: [],
          additionalParams: additionalParams,
        );

        expect(result['metadata'], additionalParams);
      });

      test('should handle between operator with valueTo', () {
        final filters = {
          'price': VooDataFilter(
            operator: VooFilterOperator.between,
            value: 100,
            valueTo: 500,
          ),
        };

        final result = DataGridRequestBuilder.buildRequestBody(
          page: 0,
          pageSize: 10,
          filters: filters,
          sorts: [],
        );

        final filtersList = result['filters'] as List;
        expect(filtersList[0]['field'], 'price');
        expect(filtersList[0]['operator'], 'between');
        expect(filtersList[0]['value'], 100);
        expect(filtersList[0]['valueTo'], 500);
      });

      test('should handle null operators without values', () {
        final filters = {
          'deletedAt': VooDataFilter(
            operator: VooFilterOperator.isNull,
            value: null,
          ),
          'createdAt': VooDataFilter(
            operator: VooFilterOperator.isNotNull,
            value: null,
          ),
        };

        final result = DataGridRequestBuilder.buildRequestBody(
          page: 0,
          pageSize: 10,
          filters: filters,
          sorts: [],
        );

        final filtersList = result['filters'] as List;
        for (final filter in filtersList) {
          expect(filter.containsKey('value'), isFalse);
          expect(filter.containsKey('valueTo'), isFalse);
        }
      });

      test('should handle list operators', () {
        final filters = {
          'status': VooDataFilter(
            operator: VooFilterOperator.inList,
            value: ['active', 'pending', 'draft'],
          ),
          'type': VooDataFilter(
            operator: VooFilterOperator.notInList,
            value: 'archived',
          ),
        };

        final result = DataGridRequestBuilder.buildRequestBody(
          page: 0,
          pageSize: 10,
          filters: filters,
          sorts: [],
        );

        final filtersList = result['filters'] as List;
        final statusFilter = filtersList.firstWhere((f) => f['field'] == 'status');
        expect(statusFilter['values'], ['active', 'pending', 'draft']);
        
        final typeFilter = filtersList.firstWhere((f) => f['field'] == 'type');
        expect(typeFilter['values'], ['archived']);
      });

      test('should filter out sorts with none direction', () {
        final sorts = [
          VooColumnSort(field: 'name', direction: VooSortDirection.ascending),
          VooColumnSort(field: 'date', direction: VooSortDirection.none),
          VooColumnSort(field: 'price', direction: VooSortDirection.descending),
        ];

        final result = DataGridRequestBuilder.buildRequestBody(
          page: 0,
          pageSize: 10,
          filters: {},
          sorts: sorts,
        );

        final sortsList = result['sorts'] as List;
        expect(sortsList.length, 2);
        expect(sortsList.any((s) => s['field'] == 'date'), isFalse);
      });
    });

    group('buildQueryParams', () {
      test('should build basic query params', () {
        final params = DataGridRequestBuilder.buildQueryParams(
          page: 1,
          pageSize: 20,
          filters: {},
          sorts: [],
        );

        expect(params['page'], '1');
        expect(params['pageSize'], '20');
        expect(params.length, 2);
      });

      test('should build filter query params with indexed format', () {
        final filters = {
          'name': VooDataFilter(
            operator: VooFilterOperator.contains,
            value: 'John',
          ),
          'status': VooDataFilter(
            operator: VooFilterOperator.equals,
            value: 'active',
          ),
        };

        final params = DataGridRequestBuilder.buildQueryParams(
          page: 0,
          pageSize: 10,
          filters: filters,
          sorts: [],
        );

        expect(params['filters[0].field'], isNotNull);
        expect(params['filters[0].operator'], isNotNull);
        expect(params['filters[0].value'], isNotNull);
        expect(params['filters[1].field'], isNotNull);
        expect(params['filters[1].operator'], isNotNull);
        expect(params['filters[1].value'], isNotNull);
      });

      test('should build sort query params with indexed format', () {
        final sorts = [
          VooColumnSort(field: 'name', direction: VooSortDirection.ascending),
          VooColumnSort(field: 'date', direction: VooSortDirection.descending),
        ];

        final params = DataGridRequestBuilder.buildQueryParams(
          page: 0,
          pageSize: 10,
          filters: {},
          sorts: sorts,
        );

        expect(params['sorts[0].field'], 'name');
        expect(params['sorts[0].direction'], 'asc');
        expect(params['sorts[1].field'], 'date');
        expect(params['sorts[1].direction'], 'desc');
      });

      test('should handle list values as comma-separated string', () {
        final filters = {
          'status': VooDataFilter(
            operator: VooFilterOperator.inList,
            value: ['active', 'pending', 'draft'],
          ),
        };

        final params = DataGridRequestBuilder.buildQueryParams(
          page: 0,
          pageSize: 10,
          filters: filters,
          sorts: [],
        );

        expect(params['filters[0].values'], 'active,pending,draft');
      });

      test('should skip value for null operators', () {
        final filters = {
          'deletedAt': VooDataFilter(
            operator: VooFilterOperator.isNull,
            value: null,
          ),
        };

        final params = DataGridRequestBuilder.buildQueryParams(
          page: 0,
          pageSize: 10,
          filters: filters,
          sorts: [],
        );

        expect(params['filters[0].field'], 'deletedAt');
        expect(params['filters[0].operator'], 'is_null');
        expect(params.containsKey('filters[0].value'), isFalse);
      });

      test('should include valueTo for between operator', () {
        final filters = {
          'price': VooDataFilter(
            operator: VooFilterOperator.between,
            value: 100,
            valueTo: 500,
          ),
        };

        final params = DataGridRequestBuilder.buildQueryParams(
          page: 0,
          pageSize: 10,
          filters: filters,
          sorts: [],
        );

        expect(params['filters[0].value'], '100');
        expect(params['filters[0].valueTo'], '500');
      });

      test('should include all sorts maintaining index but skip direction for none', () {
        final sorts = [
          VooColumnSort(field: 'name', direction: VooSortDirection.ascending),
          VooColumnSort(field: 'skip', direction: VooSortDirection.none),
          VooColumnSort(field: 'date', direction: VooSortDirection.descending),
        ];

        final params = DataGridRequestBuilder.buildQueryParams(
          page: 0,
          pageSize: 10,
          filters: {},
          sorts: sorts,
        );

        // All sort fields should be included with their original indexes
        expect(params['sorts[0].field'], 'name');
        expect(params['sorts[0].direction'], 'asc');
        // The 'skip' field with none direction won't have a direction param
        expect(params.containsKey('sorts[1].field'), isFalse);
        expect(params.containsKey('sorts[1].direction'), isFalse);
        expect(params['sorts[2].field'], 'date');
        expect(params['sorts[2].direction'], 'desc');
      });
    });

    group('parseResponse', () {
      test('should parse basic response', () {
        final json = {
          'data': [
            {'id': 1, 'name': 'Item 1'},
            {'id': 2, 'name': 'Item 2'},
          ],
          'total': 100,
          'page': 2,
          'pageSize': 10,
        };

        final response = DataGridRequestBuilder.parseResponse(json: json);

        expect(response.rows.length, 2);
        expect(response.totalRows, 100);
        expect(response.page, 2);
        expect(response.pageSize, 10);
      });

      test('should handle custom keys', () {
        final json = {
          'items': [
            {'id': 1, 'name': 'Item 1'},
          ],
          'totalCount': 50,
          'currentPage': 1,
          'perPage': 25,
        };

        final response = DataGridRequestBuilder.parseResponse(
          json: json,
          dataKey: 'items',
          totalKey: 'totalCount',
          pageKey: 'currentPage',
          pageSizeKey: 'perPage',
        );

        expect(response.rows.length, 1);
        expect(response.totalRows, 50);
        expect(response.page, 1);
        expect(response.pageSize, 25);
      });

      test('should handle missing data gracefully', () {
        final json = <String, dynamic>{};

        final response = DataGridRequestBuilder.parseResponse(json: json);

        expect(response.rows, isEmpty);
        expect(response.totalRows, 0);
        expect(response.page, 0);
        expect(response.pageSize, 20);
      });

      test('should handle null page and pageSize keys', () {
        final json = {
          'data': [{'id': 1}],
          'total': 10,
        };

        final response = DataGridRequestBuilder.parseResponse(
          json: json,
          pageKey: null,
          pageSizeKey: null,
        );

        expect(response.page, 0);
        expect(response.pageSize, 20);
      });
    });

    group('operator conversions', () {
      test('should convert all operators correctly', () {
        final testCases = {
          VooFilterOperator.equals: 'eq',
          VooFilterOperator.notEquals: 'ne',
          VooFilterOperator.contains: 'contains',
          VooFilterOperator.notContains: 'not_contains',
          VooFilterOperator.startsWith: 'starts_with',
          VooFilterOperator.endsWith: 'ends_with',
          VooFilterOperator.greaterThan: 'gt',
          VooFilterOperator.greaterThanOrEqual: 'gte',
          VooFilterOperator.lessThan: 'lt',
          VooFilterOperator.lessThanOrEqual: 'lte',
          VooFilterOperator.between: 'between',
          VooFilterOperator.inList: 'in',
          VooFilterOperator.notInList: 'not_in',
          VooFilterOperator.isNull: 'is_null',
          VooFilterOperator.isNotNull: 'is_not_null',
        };

        testCases.forEach((operator, expected) {
          final filters = {
            'field': VooDataFilter(
              operator: operator,
              value: operator == VooFilterOperator.between ? 1 : 'test',
              valueTo: operator == VooFilterOperator.between ? 10 : null,
            ),
          };

          final result = DataGridRequestBuilder.buildRequestBody(
            page: 0,
            pageSize: 10,
            filters: filters,
            sorts: [],
          );

          final filtersList = result['filters'] as List;
          expect(filtersList[0]['operator'], expected);
        });
      });
    });

    group('sort direction conversions', () {
      test('should convert sort directions correctly', () {
        final sorts = [
          VooColumnSort(field: 'asc_field', direction: VooSortDirection.ascending),
          VooColumnSort(field: 'desc_field', direction: VooSortDirection.descending),
        ];

        final result = DataGridRequestBuilder.buildRequestBody(
          page: 0,
          pageSize: 10,
          filters: {},
          sorts: sorts,
        );

        final sortsList = result['sorts'] as List;
        expect(sortsList[0]['direction'], 'asc');
        expect(sortsList[1]['direction'], 'desc');
      });
    });
  });
}