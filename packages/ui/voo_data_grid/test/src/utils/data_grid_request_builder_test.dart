// ignore_for_file: inference_failure_on_collection_literal

import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('DataGridRequestBuilder', () {
    // ============================================================
    // SIMPLE REST API FORMAT
    // ============================================================
    group('Simple REST Format', () {
      const builder = DataGridRequestBuilder(standard: ApiFilterStandard.simple);

      test('should build basic pagination params', () {
        final result = builder.buildRequest(page: 0, pageSize: 20, filters: {}, sorts: []);

        final params = result['params'] as Map<String, String>;
        expect(params['page'], '0');
        expect(params['limit'], '20');
      });

      test('should build equals filter', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'status': const VooDataFilter(operator: VooFilterOperator.equals, value: 'active')},
          sorts: [],
        );

        final params = result['params'] as Map<String, String>;
        expect(params['status'], 'active');
      });

      test('should build greater than filter', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'age': const VooDataFilter(operator: VooFilterOperator.greaterThan, value: 25)},
          sorts: [],
        );

        final params = result['params'] as Map<String, String>;
        expect(params['age_gt'], '25');
      });

      test('should build less than filter', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'price': const VooDataFilter(operator: VooFilterOperator.lessThan, value: 100)},
          sorts: [],
        );

        final params = result['params'] as Map<String, String>;
        expect(params['price_lt'], '100');
      });

      test('should build greater than or equal filter', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'quantity': const VooDataFilter(operator: VooFilterOperator.greaterThanOrEqual, value: 10)},
          sorts: [],
        );

        final params = result['params'] as Map<String, String>;
        expect(params['quantity_gte'], '10');
      });

      test('should build less than or equal filter', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'rating': const VooDataFilter(operator: VooFilterOperator.lessThanOrEqual, value: 5)},
          sorts: [],
        );

        final params = result['params'] as Map<String, String>;
        expect(params['rating_lte'], '5');
      });

      test('should build contains filter', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'name': const VooDataFilter(operator: VooFilterOperator.contains, value: 'john')},
          sorts: [],
        );

        final params = result['params'] as Map<String, String>;
        expect(params['name_like'], 'john');
      });

      test('should build between filter', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'price': const VooDataFilter(operator: VooFilterOperator.between, value: 10, valueTo: 100)},
          sorts: [],
        );

        final params = result['params'] as Map<String, String>;
        expect(params['price_from'], '10');
        expect(params['price_to'], '100');
      });

      test('should build ascending sort', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: [const VooColumnSort(field: 'name', direction: VooSortDirection.ascending)],
        );

        final params = result['params'] as Map<String, String>;
        expect(params['sort'], 'name');
      });

      test('should build descending sort', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: [const VooColumnSort(field: 'createdAt', direction: VooSortDirection.descending)],
        );

        final params = result['params'] as Map<String, String>;
        expect(params['sort'], '-createdAt');
      });

      test('should build multiple sorts', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: [
            const VooColumnSort(field: 'name', direction: VooSortDirection.ascending),
            const VooColumnSort(field: 'createdAt', direction: VooSortDirection.descending),
          ],
        );

        final params = result['params'] as Map<String, String>;
        expect(params['sort'], 'name,-createdAt');
      });

      test('should apply field prefix', () {
        const builderWithPrefix = DataGridRequestBuilder(standard: ApiFilterStandard.simple, fieldPrefix: 'entity');

        final result = builderWithPrefix.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'name': const VooDataFilter(operator: VooFilterOperator.equals, value: 'test')},
          sorts: [const VooColumnSort(field: 'name', direction: VooSortDirection.ascending)],
        );

        final params = result['params'] as Map<String, String>;
        expect(params['entity.name'], 'test');
        expect(params['sort'], 'entity.name');
      });

      test('should include additional params', () {
        final result = builder.buildRequest(page: 0, pageSize: 20, filters: {}, sorts: [], additionalParams: {'customParam': 'value'});

        expect(result['customParam'], 'value');
      });
    });

    // ============================================================
    // JSON:API FORMAT
    // ============================================================
    group('JSON:API Format', () {
      const builder = DataGridRequestBuilder(standard: ApiFilterStandard.jsonApi);

      test('should use 1-based pagination', () {
        final result = builder.buildRequest(page: 0, pageSize: 20, filters: {}, sorts: []);

        final params = result['params'] as Map<String, String>;
        expect(params['page[number]'], '1'); // 0-based page 0 = 1-based page 1
        expect(params['page[size]'], '20');
      });

      test('should format equals filter', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'status': const VooDataFilter(operator: VooFilterOperator.equals, value: 'active')},
          sorts: [],
        );

        final params = result['params'] as Map<String, String>;
        expect(params['filter[status]'], 'active');
      });

      test('should format greater than filter with operator key', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'age': const VooDataFilter(operator: VooFilterOperator.greaterThan, value: 25)},
          sorts: [],
        );

        final params = result['params'] as Map<String, String>;
        expect(params['filter[age][gt]'], '25');
      });

      test('should format contains filter', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'name': const VooDataFilter(operator: VooFilterOperator.contains, value: 'john')},
          sorts: [],
        );

        final params = result['params'] as Map<String, String>;
        expect(params['filter[name][contains]'], 'john');
      });

      test('should format between filter with valueTo', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'price': const VooDataFilter(operator: VooFilterOperator.between, value: 10, valueTo: 100)},
          sorts: [],
        );

        final params = result['params'] as Map<String, String>;
        expect(params['filter[price][between]'], '10');
        expect(params['filter[price][to]'], '100');
      });

      test('should format sort with prefix for descending', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: [
            const VooColumnSort(field: 'name', direction: VooSortDirection.ascending),
            const VooColumnSort(field: 'createdAt', direction: VooSortDirection.descending),
          ],
        );

        final params = result['params'] as Map<String, String>;
        expect(params['sort'], 'name,-createdAt');
      });
    });

    // ============================================================
    // ODATA V4 FORMAT (COMPREHENSIVE)
    // ============================================================
    group('OData v4 Format', () {
      const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

      group('Pagination', () {
        test('should use \$skip and \$top for pagination', () {
          final result = builder.buildRequest(page: 2, pageSize: 25, filters: {}, sorts: []);

          final params = result['params'] as Map<String, String>;
          expect(params[r'$skip'], '50'); // page 2 * pageSize 25 = 50
          expect(params[r'$top'], '25');
        });
      });

      group('Query Options', () {
        test('should include \$count when specified', () {
          final result = builder.buildRequest(page: 0, pageSize: 20, filters: {}, sorts: [], additionalParams: {'includeCount': true});

          final params = result['params'] as Map<String, String>;
          expect(params[r'$count'], 'true');
        });

        test('should include \$select from list', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {},
            sorts: [],
            additionalParams: {
              'select': ['id', 'name', 'email'],
            },
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$select'], 'id,name,email');
        });

        test('should include \$select from string', () {
          final result = builder.buildRequest(page: 0, pageSize: 20, filters: {}, sorts: [], additionalParams: {'select': 'id,name,email'});

          final params = result['params'] as Map<String, String>;
          expect(params[r'$select'], 'id,name,email');
        });

        test('should include \$expand from list', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {},
            sorts: [],
            additionalParams: {
              'expand': ['Orders', 'Addresses'],
            },
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$expand'], 'Orders,Addresses');
        });

        test('should include \$expand from string', () {
          final result = builder.buildRequest(page: 0, pageSize: 20, filters: {}, sorts: [], additionalParams: {'expand': 'Orders'});

          final params = result['params'] as Map<String, String>;
          expect(params[r'$expand'], 'Orders');
        });

        test('should include \$search with quotes', () {
          final result = builder.buildRequest(page: 0, pageSize: 20, filters: {}, sorts: [], additionalParams: {'search': 'laptop computer'});

          final params = result['params'] as Map<String, String>;
          expect(params[r'$search'], '"laptop computer"');
        });

        test('should include \$format when specified', () {
          final result = builder.buildRequest(page: 0, pageSize: 20, filters: {}, sorts: [], additionalParams: {'format': 'json'});

          final params = result['params'] as Map<String, String>;
          expect(params[r'$format'], 'json');
        });

        test('should include \$compute when specified', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {},
            sorts: [],
            additionalParams: {'compute': 'TotalPrice mul Quantity as LineTotal'},
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$compute'], 'TotalPrice mul Quantity as LineTotal');
        });

        test('should include \$apply when specified', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {},
            sorts: [],
            additionalParams: {'apply': 'groupby((Category),aggregate(Price with sum as TotalPrice))'},
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$apply'], 'groupby((Category),aggregate(Price with sum as TotalPrice))');
        });
      });

      group('Filter Operators', () {
        test('should build equals filter', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'status': const VooDataFilter(operator: VooFilterOperator.equals, value: 'active')},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], "status eq 'active'");
        });

        test('should build not equals filter', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'status': const VooDataFilter(operator: VooFilterOperator.notEquals, value: 'deleted')},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], "status ne 'deleted'");
        });

        test('should build greater than filter', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'age': const VooDataFilter(operator: VooFilterOperator.greaterThan, value: 25)},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], 'age gt 25');
        });

        test('should build less than filter', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'price': const VooDataFilter(operator: VooFilterOperator.lessThan, value: 100.5)},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], 'price lt 100.5');
        });

        test('should build greater than or equal filter', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'quantity': const VooDataFilter(operator: VooFilterOperator.greaterThanOrEqual, value: 10)},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], 'quantity ge 10');
        });

        test('should build less than or equal filter', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'rating': const VooDataFilter(operator: VooFilterOperator.lessThanOrEqual, value: 5)},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], 'rating le 5');
        });

        test('should build contains filter', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'name': const VooDataFilter(operator: VooFilterOperator.contains, value: 'john')},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], "contains(name, 'john')");
        });

        test('should build not contains filter', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'name': const VooDataFilter(operator: VooFilterOperator.notContains, value: 'spam')},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], "not contains(name, 'spam')");
        });

        test('should build startsWith filter', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'email': const VooDataFilter(operator: VooFilterOperator.startsWith, value: 'admin')},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], "startswith(email, 'admin')");
        });

        test('should build endsWith filter', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'email': const VooDataFilter(operator: VooFilterOperator.endsWith, value: '.com')},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], "endswith(email, '.com')");
        });

        test('should build between filter with both values', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'price': const VooDataFilter(operator: VooFilterOperator.between, value: 10, valueTo: 100)},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], '(price ge 10 and price le 100)');
        });

        test('should build between filter with only min value', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'price': const VooDataFilter(operator: VooFilterOperator.between, value: 10)},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], 'price ge 10');
        });

        test('should build between filter with only max value', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'price': const VooDataFilter(operator: VooFilterOperator.between, value: null, valueTo: 100)},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], 'price le 100');
        });

        test('should not include between filter with neither value', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'price': const VooDataFilter(operator: VooFilterOperator.between, value: null)},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], isNull);
        });

        test('should build in list filter', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {
              'status': const VooDataFilter(operator: VooFilterOperator.inList, value: ['active', 'pending']),
            },
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], "status in ('active','pending')");
        });

        test('should build not in list filter', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {
              'status': const VooDataFilter(operator: VooFilterOperator.notInList, value: ['deleted', 'archived']),
            },
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], "not (status in ('deleted','archived'))");
        });

        test('should build isNull filter', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'deletedAt': const VooDataFilter(operator: VooFilterOperator.isNull, value: null)},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], 'deletedAt eq null');
        });

        test('should build isNotNull filter', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'assignedTo': const VooDataFilter(operator: VooFilterOperator.isNotNull, value: null)},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], 'assignedTo ne null');
        });
      });

      group('Value Formatting', () {
        test('should format string values with single quotes', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'name': const VooDataFilter(operator: VooFilterOperator.equals, value: 'John')},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], "name eq 'John'");
        });

        test('should escape single quotes in string values', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'name': const VooDataFilter(operator: VooFilterOperator.equals, value: "O'Brien")},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], "name eq 'O''Brien'");
        });

        test('should not quote numeric values', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {
              'age': const VooDataFilter(operator: VooFilterOperator.equals, value: 25),
              'price': const VooDataFilter(operator: VooFilterOperator.equals, value: 99.99),
            },
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], contains('age eq 25'));
          expect(params[r'$filter'], contains('price eq 99.99'));
        });

        test('should format boolean values lowercase', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'isActive': const VooDataFilter(operator: VooFilterOperator.equals, value: true)},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], 'isActive eq true');
        });

        test('should format null values', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'deletedAt': const VooDataFilter(operator: VooFilterOperator.equals, value: null)},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], 'deletedAt eq null');
        });

        test('should not quote GUID values', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'userId': const VooDataFilter(operator: VooFilterOperator.equals, value: '8dd1484c-290c-41b2-918a-0135b8519e1c')},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], 'userId eq 8dd1484c-290c-41b2-918a-0135b8519e1c');
        });
      });

      group('DateTime Formatting', () {
        test('should format DateTime with UTC format (default)', () {
          final dateTime = DateTime.utc(2024, 9, 30, 15, 15, 30);
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'createdAt': VooDataFilter(operator: VooFilterOperator.equals, value: dateTime)},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], contains('2024-09-30T15:15:30.000Z'));
        });

        test('should format DateTime with unspecified format', () {
          const builderUnspecified = DataGridRequestBuilder(standard: ApiFilterStandard.odata, odataDateTimeFormat: ODataDateTimeFormat.unspecified);

          final dateTime = DateTime.utc(2024, 9, 30, 15, 15, 30);
          final result = builderUnspecified.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'createdAt': VooDataFilter(operator: VooFilterOperator.equals, value: dateTime)},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], contains('2024-09-30T15:15:30.000'));
          expect(params[r'$filter'], isNot(contains('Z')));
        });

        test('should format DateTime with UTC offset format', () {
          const builderOffset = DataGridRequestBuilder(standard: ApiFilterStandard.odata, odataDateTimeFormat: ODataDateTimeFormat.utcOffset);

          final dateTime = DateTime.utc(2024, 9, 30, 15, 15, 30);
          final result = builderOffset.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'createdAt': VooDataFilter(operator: VooFilterOperator.equals, value: dateTime)},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], contains('2024-09-30T15:15:30.000+00:00'));
        });

        test('should parse date string and format correctly', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'createdAt': const VooDataFilter(operator: VooFilterOperator.equals, value: '2024-01-15')},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          // Date-only string should be parsed and formatted as DateTime
          expect(params[r'$filter'], contains('2024-01-15'));
        });
      });

      group('Collection/Navigation Properties', () {
        test('should build any() expression for inList on collection', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {
              'roles': const VooDataFilter(operator: VooFilterOperator.inList, value: ['admin', 'editor'], odataCollectionProperty: 'name'),
            },
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], "roles/any(x: x/name in ('admin', 'editor'))");
        });

        test('should build not any() expression for notInList on collection', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {
              'roles': const VooDataFilter(operator: VooFilterOperator.notInList, value: ['guest'], odataCollectionProperty: 'name'),
            },
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], "not roles/any(x: x/name eq 'guest')");
        });

        test('should build any() with GUID for collection property', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {
              'roles': const VooDataFilter(operator: VooFilterOperator.inList, value: ['8dd1484c-290c-41b2-918a-0135b8519e1c'], odataCollectionProperty: 'id'),
            },
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], 'roles/any(x: x/id eq 8dd1484c-290c-41b2-918a-0135b8519e1c)');
        });

        test('should build isNull for empty collection', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'orders': const VooDataFilter(operator: VooFilterOperator.isNull, value: null, odataCollectionProperty: 'id')},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], 'not orders/any()');
        });

        test('should build isNotNull for non-empty collection', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'orders': const VooDataFilter(operator: VooFilterOperator.isNotNull, value: null, odataCollectionProperty: 'id')},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], 'orders/any()');
        });
      });

      group('Logical Operators', () {
        test('should combine multiple filters with AND (default)', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {
              'status': const VooDataFilter(operator: VooFilterOperator.equals, value: 'active'),
              'age': const VooDataFilter(operator: VooFilterOperator.greaterThan, value: 18),
            },
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], contains(' and '));
        });

        test('should combine multiple filters with OR when specified', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {
              'status': const VooDataFilter(operator: VooFilterOperator.equals, value: 'active'),
              'status2': const VooDataFilter(operator: VooFilterOperator.equals, value: 'pending'),
            },
            sorts: [],
            additionalParams: {'logicalOperator': 'or'},
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], contains(' or '));
        });
      });

      group('Sorting', () {
        test('should build \$orderby for ascending sort', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {},
            sorts: [const VooColumnSort(field: 'name', direction: VooSortDirection.ascending)],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$orderby'], 'name asc');
        });

        test('should build \$orderby for descending sort', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {},
            sorts: [const VooColumnSort(field: 'createdAt', direction: VooSortDirection.descending)],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$orderby'], 'createdAt desc');
        });

        test('should build \$orderby for multiple sorts', () {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {},
            sorts: [
              const VooColumnSort(field: 'priority', direction: VooSortDirection.descending),
              const VooColumnSort(field: 'name', direction: VooSortDirection.ascending),
            ],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$orderby'], 'priority desc,name asc');
        });
      });

      group('Field Prefix', () {
        test('should apply field prefix to filter fields', () {
          const builderWithPrefix = DataGridRequestBuilder(standard: ApiFilterStandard.odata, fieldPrefix: 'entity');

          final result = builderWithPrefix.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {'name': const VooDataFilter(operator: VooFilterOperator.equals, value: 'test')},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$filter'], "entity.name eq 'test'");
        });

        test('should apply field prefix to sort fields', () {
          const builderWithPrefix = DataGridRequestBuilder(standard: ApiFilterStandard.odata, fieldPrefix: 'entity');

          final result = builderWithPrefix.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {},
            sorts: [const VooColumnSort(field: 'name', direction: VooSortDirection.ascending)],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$orderby'], 'entity.name asc');
        });
      });

      group('Response Structure', () {
        test('should include queryParameters for direct use', () {
          final result = builder.buildRequest(page: 0, pageSize: 20, filters: {}, sorts: []);

          expect(result['queryParameters'], isNotNull);
          expect(result['method'], 'GET');
          expect(result['standard'], 'odata');
        });
      });
    });

    // ============================================================
    // MONGODB FORMAT
    // ============================================================
    group('MongoDB Format', () {
      const builder = DataGridRequestBuilder(standard: ApiFilterStandard.mongodb);

      test('should build skip and limit', () {
        final result = builder.buildRequest(page: 2, pageSize: 25, filters: {}, sorts: []);

        final body = result['body'] as Map<String, dynamic>;
        expect(body['skip'], 50);
        expect(body['limit'], 25);
      });

      test('should build equals filter as direct value', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'status': const VooDataFilter(operator: VooFilterOperator.equals, value: 'active')},
          sorts: [],
        );

        final body = result['body'] as Map<String, dynamic>;
        final query = body['query'] as Map<String, dynamic>;
        expect(query['status'], 'active');
      });

      test('should build greater than filter with \$gt', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'age': const VooDataFilter(operator: VooFilterOperator.greaterThan, value: 25)},
          sorts: [],
        );

        final body = result['body'] as Map<String, dynamic>;
        final query = body['query'] as Map<String, dynamic>;
        expect(query['age'], {r'$gt': 25});
      });

      test('should build contains filter with \$regex', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'name': const VooDataFilter(operator: VooFilterOperator.contains, value: 'john')},
          sorts: [],
        );

        final body = result['body'] as Map<String, dynamic>;
        final query = body['query'] as Map<String, dynamic>;
        expect(query['name'], {r'$regex': 'john', r'$options': 'i'});
      });

      test('should build inList filter with \$in', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'status': const VooDataFilter(operator: VooFilterOperator.inList, value: ['active', 'pending']),
          },
          sorts: [],
        );

        final body = result['body'] as Map<String, dynamic>;
        final query = body['query'] as Map<String, dynamic>;
        expect(query['status'], {
          r'$in': ['active', 'pending'],
        });
      });

      test('should build sort with 1 for ascending', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: [const VooColumnSort(field: 'name', direction: VooSortDirection.ascending)],
        );

        final body = result['body'] as Map<String, dynamic>;
        final sort = body['sort'] as Map<String, dynamic>;
        expect(sort['name'], 1);
      });

      test('should build sort with -1 for descending', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: [const VooColumnSort(field: 'createdAt', direction: VooSortDirection.descending)],
        );

        final body = result['body'] as Map<String, dynamic>;
        final sort = body['sort'] as Map<String, dynamic>;
        expect(sort['createdAt'], -1);
      });
    });

    // ============================================================
    // GRAPHQL FORMAT
    // ============================================================
    group('GraphQL Format', () {
      const builder = DataGridRequestBuilder(standard: ApiFilterStandard.graphql);

      test('should build variables with page and pageSize', () {
        final result = builder.buildRequest(page: 0, pageSize: 20, filters: {}, sorts: []);

        final variables = result['variables'] as Map<String, dynamic>;
        expect(variables['page'], 0);
        expect(variables['pageSize'], 20);
      });

      test('should include query template', () {
        final result = builder.buildRequest(page: 0, pageSize: 20, filters: {}, sorts: []);

        expect(result['query'], isNotNull);
        expect(result['query'], contains('query GetData'));
      });

      test('should build where clause for filters', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'status': const VooDataFilter(operator: VooFilterOperator.equals, value: 'active')},
          sorts: [],
        );

        final variables = result['variables'] as Map<String, dynamic>;
        final where = variables['where'] as Map<String, dynamic>;
        expect(where['status'], {'eq': 'active'});
      });

      test('should build orderBy for sorts', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: [const VooColumnSort(field: 'name', direction: VooSortDirection.ascending)],
        );

        final variables = result['variables'] as Map<String, dynamic>;
        final orderBy = variables['orderBy'] as List;
        expect(orderBy.first, {'field': 'name', 'direction': 'ASC'});
      });
    });

    // ============================================================
    // VOO API FORMAT
    // ============================================================
    group('Voo API Format', () {
      const builder = DataGridRequestBuilder(standard: ApiFilterStandard.voo);

      test('should build pageNumber and pageSize', () {
        final result = builder.buildRequest(page: 0, pageSize: 20, filters: {}, sorts: []);

        expect(result['pageNumber'], 0);
        expect(result['pageSize'], 20);
        expect(result['logic'], 'And');
      });

      test('should categorize string filters', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'name': const VooDataFilter(operator: VooFilterOperator.equals, value: 'John')},
          sorts: [],
        );

        final stringFilters = result['stringFilters'] as List;
        expect(stringFilters.length, 1);
        expect(stringFilters.first['fieldName'], 'name');
        expect(stringFilters.first['value'], 'John');
        expect(stringFilters.first['operator'], 'Equals');
      });

      test('should categorize int filters', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'age': const VooDataFilter(operator: VooFilterOperator.greaterThan, value: 25)},
          sorts: [],
        );

        final intFilters = result['intFilters'] as List;
        expect(intFilters.length, 1);
        expect(intFilters.first['fieldName'], 'age');
        expect(intFilters.first['value'], 25);
        expect(intFilters.first['operator'], 'GreaterThan');
      });

      test('should categorize decimal filters', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'price': const VooDataFilter(operator: VooFilterOperator.lessThan, value: 99.99)},
          sorts: [],
        );

        final decimalFilters = result['decimalFilters'] as List;
        expect(decimalFilters.length, 1);
        expect(decimalFilters.first['fieldName'], 'price');
        expect(decimalFilters.first['value'], 99.99);
        expect(decimalFilters.first['operator'], 'LessThan');
      });

      test('should handle between operator with two filters', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'quantity': const VooDataFilter(operator: VooFilterOperator.between, value: 10, valueTo: 100)},
          sorts: [],
        );

        final intFilters = result['intFilters'] as List;
        expect(intFilters.length, 2);
        expect(intFilters[0]['operator'], 'GreaterThanOrEqual');
        expect(intFilters[0]['value'], 10);
        expect(intFilters[1]['operator'], 'LessThanOrEqual');
        expect(intFilters[1]['value'], 100);
      });

      test('should apply field prefix with pascal case', () {
        const builderWithPrefix = DataGridRequestBuilder(standard: ApiFilterStandard.voo, fieldPrefix: 'Entity');

        final result = builderWithPrefix.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'name': const VooDataFilter(operator: VooFilterOperator.equals, value: 'test')},
          sorts: [],
        );

        final stringFilters = result['stringFilters'] as List;
        expect(stringFilters.first['fieldName'], 'Entity.Name');
      });

      test('should build sortBy and sortDescending', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: [const VooColumnSort(field: 'name', direction: VooSortDirection.descending)],
        );

        expect(result['sortBy'], 'name');
        expect(result['sortDescending'], true);
      });
    });

    // ============================================================
    // CUSTOM FORMAT
    // ============================================================
    group('Custom Format', () {
      const builder = DataGridRequestBuilder();

      test('should build pagination object', () {
        final result = builder.buildRequest(page: 2, pageSize: 25, filters: {}, sorts: []);

        final pagination = result['pagination'] as Map<String, dynamic>;
        expect(pagination['page'], 2);
        expect(pagination['pageSize'], 25);
        expect(pagination['offset'], 50);
        expect(pagination['limit'], 25);
      });

      test('should build filters array', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {'status': const VooDataFilter(operator: VooFilterOperator.equals, value: 'active')},
          sorts: [],
        );

        final filters = result['filters'] as List;
        expect(filters.length, 1);
        expect(filters.first['field'], 'status');
        expect(filters.first['operator'], 'eq');
        expect(filters.first['value'], 'active');
      });

      test('should build sorts array', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: [const VooColumnSort(field: 'name', direction: VooSortDirection.ascending)],
        );

        final sorts = result['sorts'] as List;
        expect(sorts.length, 1);
        expect(sorts.first['field'], 'name');
        expect(sorts.first['direction'], 'asc');
      });

      test('should include metadata for additional params', () {
        final result = builder.buildRequest(page: 0, pageSize: 20, filters: {}, sorts: [], additionalParams: {'customKey': 'customValue'});

        expect(result['metadata'], {'customKey': 'customValue'});
      });
    });

    // ============================================================
    // STATIC METHODS
    // ============================================================
    group('Static Methods', () {
      group('buildQueryParams', () {
        test('should build query params for GET requests', () {
          final params = DataGridRequestBuilder.buildQueryParams(
            page: 1,
            pageSize: 20,
            filters: {'status': const VooDataFilter(operator: VooFilterOperator.equals, value: 'active')},
            sorts: [const VooColumnSort(field: 'name', direction: VooSortDirection.ascending)],
          );

          expect(params['page'], '1');
          expect(params['pageSize'], '20');
          expect(params['filters[0].field'], 'status');
          expect(params['filters[0].operator'], 'eq');
          expect(params['filters[0].value'], 'active');
          expect(params['sorts[0].field'], 'name');
          expect(params['sorts[0].direction'], 'asc');
        });

        test('should handle list values in filters', () {
          final params = DataGridRequestBuilder.buildQueryParams(
            page: 0,
            pageSize: 20,
            filters: {
              'status': const VooDataFilter(operator: VooFilterOperator.inList, value: ['a', 'b', 'c']),
            },
            sorts: [],
          );

          expect(params['filters[0].values'], 'a,b,c');
        });
      });

      group('parseResponse', () {
        test('should parse standard response', () {
          final response = DataGridRequestBuilder.parseResponse(
            json: {
              'data': [
                {'id': 1},
                {'id': 2},
              ],
              'total': 100,
              'page': 1,
              'pageSize': 20,
            },
          );

          expect(response.rows.length, 2);
          expect(response.totalRows, 100);
          expect(response.page, 1);
          expect(response.pageSize, 20);
        });

        test('should handle custom keys', () {
          final response = DataGridRequestBuilder.parseResponse(
            json: {
              'items': [
                {'id': 1},
              ],
              'count': 50,
            },
            dataKey: 'items',
            totalKey: 'count',
          );

          expect(response.rows.length, 1);
          expect(response.totalRows, 50);
        });
      });

      group('parseODataResponse', () {
        test('should parse OData v4 response', () {
          final response = DataGridRequestBuilder.parseODataResponse(
            json: {
              '@odata.context': r'$metadata#Products',
              '@odata.count': 100,
              'value': [
                {'id': 1, 'name': 'Product 1'},
                {'id': 2, 'name': 'Product 2'},
              ],
            },
          );

          expect(response.rows.length, 2);
          expect(response.totalRows, 100);
        });

        test('should use data length when count is missing', () {
          final response = DataGridRequestBuilder.parseODataResponse(
            json: {
              'value': [
                {'id': 1},
                {'id': 2},
                {'id': 3},
              ],
            },
          );

          expect(response.totalRows, 3);
        });
      });

      group('extractODataMetadata', () {
        test('should extract OData annotations', () {
          final metadata = DataGridRequestBuilder.extractODataMetadata({
            '@odata.context': r'$metadata#Products',
            '@odata.count': 100,
            '@odata.nextLink': 'Products?\$skip=20',
            // ignore: inference_failure_on_collection_literal
            'value': [],
          });

          expect(metadata['@odata.context'], r'$metadata#Products');
          expect(metadata['@odata.count'], 100);
          expect(metadata['@odata.nextLink'], 'Products?\$skip=20');
          expect(metadata['hasNextPage'], true);
        });

        test('should detect hasNextPage correctly', () {
          final metadataWithNext = DataGridRequestBuilder.extractODataMetadata({'@odata.nextLink': 'someUrl', 'value': []});
          expect(metadataWithNext['hasNextPage'], true);

          final metadataWithoutNext = DataGridRequestBuilder.extractODataMetadata({'value': []});
          expect(metadataWithoutNext['hasNextPage'], false);
        });
      });

      group('parseODataError', () {
        test('should parse OData error response', () {
          final error = DataGridRequestBuilder.parseODataError({
            'error': {
              'code': 'BadRequest',
              'message': 'The request is invalid.',
              'details': [
                {'code': 'ValidationError', 'message': 'Price must be greater than 0.'},
              ],
            },
          });

          expect(error, isNotNull);
          expect(error!['code'], 'BadRequest');
          expect(error['message'], 'The request is invalid.');
          expect(error['details'], isNotEmpty);
        });

        test('should return null for non-error response', () {
          final error = DataGridRequestBuilder.parseODataError({'value': []});

          expect(error, isNull);
        });
      });
    });

    // ============================================================
    // LEGACY COMPATIBILITY
    // ============================================================
    group('Legacy Compatibility', () {
      test('buildRequestBody static method should work', () {
        final result = DataGridRequestBuilder.buildRequestBody(page: 0, pageSize: 20, filters: {}, sorts: []);

        expect(result['pagination'], isNotNull);
      });
    });
  });
}
