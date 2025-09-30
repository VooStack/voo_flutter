import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
import 'package:voo_data_grid/src/domain/entities/voo_filter_operator.dart';
import 'package:voo_data_grid/src/utils/data_grid_request_builder.dart';

void main() {
  group('OData GUID Handling Tests', () {
    late DataGridRequestBuilder builder;

    setUp(() {
      builder = const DataGridRequestBuilder(standard: ApiFilterStandard.odata);
    });

    group('GUID string formatting', () {
      test('should format GUID strings without quotes', () {
        const guid = '8dd1484c-290c-41b2-918a-0135b8519e1c';

        final filters = {
          'userId': VooDataFilter(
            operator: VooFilterOperator.equals,
            value: guid,
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;

        // GUID should be unquoted for Edm.Guid compatibility
        expect(filterString, contains('userId eq $guid'));
        expect(filterString, isNot(contains("'$guid'")));
      });

      test('should handle uppercase GUID', () {
        const guid = '8DD1484C-290C-41B2-918A-0135B8519E1C';

        final filters = {
          'roleId': VooDataFilter(
            operator: VooFilterOperator.equals,
            value: guid,
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;

        // GUID should be unquoted regardless of case
        expect(filterString, contains('roleId eq $guid'));
        expect(filterString, isNot(contains("'$guid'")));
      });

      test('should handle mixed case GUID', () {
        const guid = '8Dd1484c-290C-41b2-918A-0135B8519e1C';

        final filters = {
          'id': VooDataFilter(
            operator: VooFilterOperator.equals,
            value: guid,
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;

        expect(filterString, contains('id eq $guid'));
        expect(filterString, isNot(contains("'$guid'")));
      });
    });

    group('GUID in different operators', () {
      const guid = '8dd1484c-290c-41b2-918a-0135b8519e1c';

      test('should handle GUID with equals operator', () {
        final filters = {
          'id': VooDataFilter(
            operator: VooFilterOperator.equals,
            value: guid,
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;
        expect(filterString, equals('id eq $guid'));
      });

      test('should handle GUID with notEquals operator', () {
        final filters = {
          'excludeId': VooDataFilter(
            operator: VooFilterOperator.notEquals,
            value: guid,
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;
        expect(filterString, equals('excludeId ne $guid'));
      });

      test('should handle GUID with contains operator', () {
        final filters = {
          'relatedId': VooDataFilter(
            operator: VooFilterOperator.contains,
            value: guid,
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;
        // Contains for GUID should use substringof or contains function
        expect(filterString, contains('relatedId'));
        expect(filterString, contains(guid));
      });
    });

    group('Multiple GUIDs in filters', () {
      test('should handle multiple GUIDs in inList operator', () {
        const guid1 = '8dd1484c-290c-41b2-918a-0135b8519e1c';
        const guid2 = 'a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d';
        const guid3 = 'f9e8d7c6-b5a4-4938-8271-615f4e3d2c1b';

        final filters = {
          'userId': VooDataFilter(
            operator: VooFilterOperator.inList,
            value: [guid1, guid2, guid3],
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;

        // All GUIDs should be unquoted
        expect(filterString, contains(guid1));
        expect(filterString, contains(guid2));
        expect(filterString, contains(guid3));
        // Should not have quotes around GUIDs
        expect(filterString, isNot(contains("'$guid1'")));
        expect(filterString, isNot(contains("'$guid2'")));
        expect(filterString, isNot(contains("'$guid3'")));
      });

      test('should handle GUIDs in collection navigation property', () {
        const roleId1 = '8dd1484c-290c-41b2-918a-0135b8519e1c';
        const roleId2 = 'a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d';

        final filters = {
          'roles': VooDataFilter(
            operator: VooFilterOperator.inList,
            value: [roleId1, roleId2],
            odataCollectionProperty: 'Id',
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;

        // Should generate: roles/any(x: x/Id in (guid1, guid2))
        expect(filterString, contains('roles/any(x: x/Id in ($roleId1, $roleId2))'));
        // GUIDs should not be quoted
        expect(filterString, isNot(contains("'$roleId1'")));
        expect(filterString, isNot(contains("'$roleId2'")));
      });

      test('should handle single GUID in collection navigation property', () {
        const roleId = '8dd1484c-290c-41b2-918a-0135b8519e1c';

        final filters = {
          'roles': VooDataFilter(
            operator: VooFilterOperator.contains,
            value: roleId,
            odataCollectionProperty: 'Id',
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;

        // Should generate: roles/any(x: x/Id eq guid)
        expect(filterString, contains('roles/any(x: x/Id eq $roleId)'));
        expect(filterString, isNot(contains("'$roleId'")));
      });
    });

    group('GUID vs regular string differentiation', () {
      test('should quote regular strings that look similar to GUIDs', () {
        // Missing one character to be a valid GUID
        const invalidGuid = '8dd1484c-290c-41b2-918a-0135b8519e1';

        final filters = {
          'code': VooDataFilter(
            operator: VooFilterOperator.equals,
            value: invalidGuid,
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;

        // Should be quoted because it's not a valid GUID
        expect(filterString, contains("'$invalidGuid'"));
      });

      test('should quote strings with GUID-like format but invalid characters', () {
        const notGuid = '8dd1484c-290c-41b2-918a-0135b8519e1g'; // 'g' is valid hex but wrong position

        final filters = {
          'token': VooDataFilter(
            operator: VooFilterOperator.equals,
            value: notGuid,
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;

        // Should be quoted because it's not a valid GUID format
        expect(filterString, contains("'$notGuid'"));
      });

      test('should not confuse dates with GUIDs', () {
        const dateString = '2024-01-15T10:30:00';

        final filters = {
          'createdAt': VooDataFilter(
            operator: VooFilterOperator.equals,
            value: dateString,
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;

        // Should be formatted as date with Z suffix, not as GUID
        expect(filterString, contains('Z'));
        expect(filterString, isNot(contains("'$dateString'")));
      });
    });

    group('Edge cases', () {
      test('should handle nil UUID (all zeros)', () {
        const nilGuid = '00000000-0000-0000-0000-000000000000';

        final filters = {
          'emptyId': VooDataFilter(
            operator: VooFilterOperator.equals,
            value: nilGuid,
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;

        // Nil GUID should still be unquoted
        expect(filterString, contains('emptyId eq $nilGuid'));
        expect(filterString, isNot(contains("'$nilGuid'")));
      });

      test('should handle GUID with all F characters', () {
        const maxGuid = 'ffffffff-ffff-ffff-ffff-ffffffffffff';

        final filters = {
          'maxId': VooDataFilter(
            operator: VooFilterOperator.equals,
            value: maxGuid,
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;

        expect(filterString, contains('maxId eq $maxGuid'));
        expect(filterString, isNot(contains("'$maxGuid'")));
      });

      test('should handle GUID without hyphens as regular string', () {
        // GUID format requires hyphens in specific positions
        const guidWithoutHyphens = '8dd1484c290c41b2918a0135b8519e1c';

        final filters = {
          'id': VooDataFilter(
            operator: VooFilterOperator.equals,
            value: guidWithoutHyphens,
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;

        // Should be quoted because hyphens are required for GUID format
        expect(filterString, contains("'$guidWithoutHyphens'"));
      });
    });

    group('Integration with other filter types', () {
      test('should handle mix of GUID, string, and date filters', () {
        const guid = '8dd1484c-290c-41b2-918a-0135b8519e1c';
        const userName = 'john.doe';
        final createdAt = DateTime.utc(2024, 1, 15, 10, 0, 0);

        final filters = {
          'userId': VooDataFilter(
            operator: VooFilterOperator.equals,
            value: guid,
          ),
          'userName': VooDataFilter(
            operator: VooFilterOperator.equals,
            value: userName,
          ),
          'createdAt': VooDataFilter(
            operator: VooFilterOperator.greaterThan,
            value: createdAt,
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;

        // GUID should be unquoted
        expect(filterString, contains('userId eq $guid'));
        expect(filterString, isNot(contains("'$guid'")));

        // String should be quoted
        expect(filterString, contains("userName eq '$userName'"));

        // Date should have Z suffix
        expect(filterString, contains('2024-01-15T10:00:00.000Z'));
      });
    });

    group('PostgreSQL Edm.Guid compatibility', () {
      test('should generate GUID format compatible with PostgreSQL/OData', () {
        // This is the exact scenario causing the Edm.Guid vs Edm.String error
        const roleId = '8dd1484c-290c-41b2-918a-0135b8519e1c';

        final filters = {
          'roles': VooDataFilter(
            operator: VooFilterOperator.contains,
            value: roleId,
            odataCollectionProperty: 'Id',
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;

        // Must be unquoted to match Edm.Guid type in OData
        expect(filterString, contains('roles/any(x: x/Id eq $roleId)'));
        // Should not have quotes that would make it Edm.String
        expect(filterString, isNot(contains("'$roleId'")));
      });

      test('should handle multiple role GUIDs for PostgreSQL', () {
        const roleId1 = '8dd1484c-290c-41b2-918a-0135b8519e1c';
        const roleId2 = 'f9e8d7c6-b5a4-4938-8271-615f4e3d2c1b';

        final filters = {
          'roles': VooDataFilter(
            operator: VooFilterOperator.inList,
            value: [roleId1, roleId2],
            odataCollectionProperty: 'Id',
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;

        // Both GUIDs must be unquoted for PostgreSQL Edm.Guid compatibility
        expect(filterString, contains('roles/any(x: x/Id in ($roleId1, $roleId2))'));
        expect(filterString, isNot(contains("'")));
      });
    });
  });
}