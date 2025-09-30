import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
import 'package:voo_data_grid/src/domain/entities/voo_filter_operator.dart';
import 'package:voo_data_grid/src/utils/data_grid_request_builder.dart';

void main() {
  group('OData Collection Navigation Property Tests', () {
    late DataGridRequestBuilder builder;

    setUp(() {
      builder = const DataGridRequestBuilder(standard: ApiFilterStandard.odata);
    });

    group('Single value collection filters', () {
      test('should generate any() with single value using eq operator', () {
        final filters = {
          'roles': const VooDataFilter(
            operator: VooFilterOperator.contains,
            value: 'admin-guid',
            odataCollectionProperty: 'id',
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;
        expect(
          filterString,
          equals("roles/any(x: x/id eq 'admin-guid')"),
        );
      });

      test('should generate any() with equals operator', () {
        final filters = {
          'roles': const VooDataFilter(
            operator: VooFilterOperator.equals,
            value: 'admin-guid',
            odataCollectionProperty: 'id',
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;
        expect(
          filterString,
          equals("roles/any(x: x/id eq 'admin-guid')"),
        );
      });
    });

    group('Multiple value collection filters', () {
      test('should generate any() with in operator for multiple values', () {
        final filters = {
          'roles': VooDataFilter(
            operator: VooFilterOperator.inList,
            value: ['8dd1484c-290c-41b2-918a-0135b8519e1c', '8673e1a6-2e66-4248-a50b-6e265e1a7a3a', 'e1a6a7a3-8673-4248-a50b-6e265e1a7a3a'],
            odataCollectionProperty: 'id',
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;
        expect(
          filterString,
          contains("roles/any(x: x/id in ("),
        );
        expect(filterString, contains("'8dd1484c-290c-41b2-918a-0135b8519e1c'"));
        expect(filterString, contains("'8673e1a6-2e66-4248-a50b-6e265e1a7a3a'"));
        expect(filterString, contains("'e1a6a7a3-8673-4248-a50b-6e265e1a7a3a'"));
      });

      test('should generate any() with contains operator for multiple values', () {
        final filters = {
          'roles': VooDataFilter(
            operator: VooFilterOperator.contains,
            value: ['admin-guid', 'user-guid', 'editor-guid'],
            odataCollectionProperty: 'id',
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;
        expect(
          filterString,
          contains("roles/any(x: x/id in ("),
        );
        expect(filterString, contains("'admin-guid'"));
        expect(filterString, contains("'user-guid'"));
        expect(filterString, contains("'editor-guid'"));
      });
    });

    group('Negation collection filters', () {
      test('should generate not any() for notContains operator', () {
        final filters = {
          'roles': const VooDataFilter(
            operator: VooFilterOperator.notContains,
            value: 'admin-guid',
            odataCollectionProperty: 'id',
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;
        expect(
          filterString,
          equals("not roles/any(x: x/id eq 'admin-guid')"),
        );
      });

      test('should generate not any() for notInList with multiple values', () {
        final filters = {
          'roles': VooDataFilter(
            operator: VooFilterOperator.notInList,
            value: ['admin-guid', 'superadmin-guid'],
            odataCollectionProperty: 'id',
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;
        expect(
          filterString,
          contains("not roles/any(x: x/id in ("),
        );
        expect(filterString, contains("'admin-guid'"));
        expect(filterString, contains("'superadmin-guid'"));
      });

      test('should generate not any() for notEquals operator', () {
        final filters = {
          'roles': const VooDataFilter(
            operator: VooFilterOperator.notEquals,
            value: 'guest-guid',
            odataCollectionProperty: 'id',
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;
        expect(
          filterString,
          equals("not roles/any(x: x/id eq 'guest-guid')"),
        );
      });
    });

    group('Null check collection filters', () {
      test('should generate not any() for isNull operator (empty collection)', () {
        final filters = {
          'roles': const VooDataFilter(
            operator: VooFilterOperator.isNull,
            value: null,
            odataCollectionProperty: 'id',
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;
        expect(
          filterString,
          equals("not roles/any()"),
        );
      });

      test('should generate any() for isNotNull operator (non-empty collection)', () {
        final filters = {
          'roles': const VooDataFilter(
            operator: VooFilterOperator.isNotNull,
            value: null,
            odataCollectionProperty: 'id',
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;
        expect(
          filterString,
          equals("roles/any()"),
        );
      });
    });

    group('Complex collection property names', () {
      test('should handle nested property names', () {
        final filters = {
          'userRoles': const VooDataFilter(
            operator: VooFilterOperator.contains,
            value: 'admin-guid',
            odataCollectionProperty: 'role.id',
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;
        expect(
          filterString,
          equals("userRoles/any(x: x/role.id eq 'admin-guid')"),
        );
      });

      test('should handle property names with special characters', () {
        final filters = {
          'user_roles': VooDataFilter(
            operator: VooFilterOperator.inList,
            value: ['id1', 'id2'],
            odataCollectionProperty: 'role_id',
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;
        expect(
          filterString,
          contains("user_roles/any(x: x/role_id in ("),
        );
      });
    });

    group('Comparison operators on collections', () {
      test('should support greaterThan on collection property', () {
        final filters = {
          'scores': const VooDataFilter(
            operator: VooFilterOperator.greaterThan,
            value: 90,
            odataCollectionProperty: 'value',
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;
        expect(
          filterString,
          equals("scores/any(x: x/value gt 90)"),
        );
      });

      test('should support lessThan on collection property', () {
        final filters = {
          'prices': const VooDataFilter(
            operator: VooFilterOperator.lessThan,
            value: 100.50,
            odataCollectionProperty: 'amount',
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;
        expect(
          filterString,
          equals("prices/any(x: x/amount lt 100.5)"),
        );
      });
    });

    group('Mixed collection and non-collection filters', () {
      test('should combine collection and regular filters with and', () {
        final filters = {
          'roles': VooDataFilter(
            operator: VooFilterOperator.inList,
            value: ['admin-guid', 'user-guid'],
            odataCollectionProperty: 'id',
          ),
          'status': const VooDataFilter(
            operator: VooFilterOperator.equals,
            value: 'active',
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;
        expect(filterString, contains("roles/any(x: x/id in ("));
        expect(filterString, contains("status eq 'active'"));
        expect(filterString, contains(" and "));
      });

      test('should handle multiple collection filters', () {
        final filters = {
          'roles': VooDataFilter(
            operator: VooFilterOperator.inList,
            value: ['admin-guid', 'user-guid'],
            odataCollectionProperty: 'id',
          ),
          'permissions': VooDataFilter(
            operator: VooFilterOperator.contains,
            value: 'write-guid',
            odataCollectionProperty: 'permissionId',
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;
        expect(filterString, contains("roles/any(x: x/id in ("));
        expect(filterString, contains("permissions/any(x: x/permissionId eq 'write-guid')"));
        expect(filterString, contains(" and "));
      });
    });

    group('Empty and edge cases', () {
      test('should handle empty list gracefully', () {
        final filters = {
          'roles': const VooDataFilter(
            operator: VooFilterOperator.inList,
            value: [],
            odataCollectionProperty: 'id',
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        // Should not include filter when empty
        expect(result['params'].containsKey('\$filter'), isFalse);
      });

      test('should handle null value without odataCollectionProperty', () {
        final filters = {
          'roles': const VooDataFilter(
            operator: VooFilterOperator.contains,
            value: 'test',
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;
        // Should use regular contains, not any()
        expect(filterString, equals("contains(roles, 'test')"));
        expect(filterString, isNot(contains("any(")));
      });
    });
  });
}