import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('OData DateTime Format Tests', () {
    group('DateTime Object Formatting', () {
      test('should format DateTime with UTC format (Z suffix)', () {
        const builder = DataGridRequestBuilder(
          standard: ApiFilterStandard.odata,
          odataDateTimeFormat: ODataDateTimeFormat.utc,
        );

        final dateTime = DateTime(2024, 9, 30, 15, 15, 30);
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'createdDate': VooDataFilter(
              operator: VooFilterOperator.equals,
              value: dateTime,
            ),
          },
          sorts: const [],
        );

        final params = result['params'] as Map<String, String>;
        final filter = params[r'$filter']!;

        // Should have Z suffix
        expect(filter, contains('Z'));
        expect(filter.contains('+00:00'), isFalse);
      });

      test('should format DateTime with unspecified format (no timezone)', () {
        const builder = DataGridRequestBuilder(
          standard: ApiFilterStandard.odata,
          odataDateTimeFormat: ODataDateTimeFormat.unspecified,
        );

        final dateTime = DateTime(2024, 9, 30, 15, 15, 30);
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'createdDate': VooDataFilter(
              operator: VooFilterOperator.equals,
              value: dateTime,
            ),
          },
          sorts: const [],
        );

        final params = result['params'] as Map<String, String>;
        final filter = params[r'$filter']!;

        // Should not have Z suffix or timezone
        expect(filter.contains('Z'), isFalse);
        expect(filter.contains('+00:00'), isFalse);
        expect(filter, contains('2024-09-30T'));
      });

      test('should format DateTime with utcOffset format (+00:00 suffix)', () {
        const builder = DataGridRequestBuilder(
          standard: ApiFilterStandard.odata,
          odataDateTimeFormat: ODataDateTimeFormat.utcOffset,
        );

        final dateTime = DateTime(2024, 9, 30, 15, 15, 30);
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'createdDate': VooDataFilter(
              operator: VooFilterOperator.equals,
              value: dateTime,
            ),
          },
          sorts: const [],
        );

        final params = result['params'] as Map<String, String>;
        final filter = params[r'$filter']!;

        // Should have +00:00 suffix, not Z
        expect(filter, contains('+00:00'));
        expect(filter.contains('Z'), isFalse);
        expect(filter, contains('2024-09-30T'));
      });
    });

    group('String Date Formatting', () {
      test('should format string date with UTC format (Z suffix)', () {
        const builder = DataGridRequestBuilder(
          standard: ApiFilterStandard.odata,
          odataDateTimeFormat: ODataDateTimeFormat.utc,
        );

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'createdDate': const VooDataFilter(
              operator: VooFilterOperator.equals,
              value: '2024-09-30T15:15:30',
            ),
          },
          sorts: const [],
        );

        final params = result['params'] as Map<String, String>;
        final filter = params[r'$filter']!;

        // Should have Z suffix
        expect(filter, contains('Z'));
        expect(filter.contains('+00:00'), isFalse);
      });

      test('should format string date with unspecified format (no timezone)', () {
        const builder = DataGridRequestBuilder(
          standard: ApiFilterStandard.odata,
          odataDateTimeFormat: ODataDateTimeFormat.unspecified,
        );

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'createdDate': const VooDataFilter(
              operator: VooFilterOperator.equals,
              value: '2024-09-30T15:15:30',
            ),
          },
          sorts: const [],
        );

        final params = result['params'] as Map<String, String>;
        final filter = params[r'$filter']!;

        // Should not have Z suffix or timezone
        expect(filter.contains('Z'), isFalse);
        expect(filter.contains('+00:00'), isFalse);
        expect(filter, contains('2024-09-30T'));
      });

      test('should format string date with utcOffset format (+00:00 suffix)', () {
        const builder = DataGridRequestBuilder(
          standard: ApiFilterStandard.odata,
          odataDateTimeFormat: ODataDateTimeFormat.utcOffset,
        );

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'createdDate': const VooDataFilter(
              operator: VooFilterOperator.equals,
              value: '2024-09-30T15:15:30',
            ),
          },
          sorts: const [],
        );

        final params = result['params'] as Map<String, String>;
        final filter = params[r'$filter']!;

        // Should have +00:00 suffix, not Z
        expect(filter, contains('+00:00'));
        expect(filter.contains('Z'), isFalse);
        expect(filter, contains('2024-09-30T'));
      });

      test('should handle string date with existing Z suffix', () {
        const builder = DataGridRequestBuilder(
          standard: ApiFilterStandard.odata,
          odataDateTimeFormat: ODataDateTimeFormat.utcOffset,
        );

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'createdDate': const VooDataFilter(
              operator: VooFilterOperator.equals,
              value: '2024-09-30T15:15:30Z',
            ),
          },
          sorts: const [],
        );

        final params = result['params'] as Map<String, String>;
        final filter = params[r'$filter']!;

        // Z should be replaced with +00:00
        expect(filter, contains('+00:00'));
        expect(filter.contains('Z'), isFalse);
      });

      test('should handle date-only string', () {
        const builder = DataGridRequestBuilder(
          standard: ApiFilterStandard.odata,
          odataDateTimeFormat: ODataDateTimeFormat.utcOffset,
        );

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'createdDate': const VooDataFilter(
              operator: VooFilterOperator.equals,
              value: '2024-09-30',
            ),
          },
          sorts: const [],
        );

        final params = result['params'] as Map<String, String>;
        final filter = params[r'$filter']!;

        // Should add time and +00:00
        expect(filter, contains('2024-09-30T'));
        expect(filter, contains('+00:00'));
      });
    });

    group('Between Filter DateTime Formatting', () {
      test('should format between dates with utcOffset format', () {
        const builder = DataGridRequestBuilder(
          standard: ApiFilterStandard.odata,
          odataDateTimeFormat: ODataDateTimeFormat.utcOffset,
        );

        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTime(2024, 12, 31);

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'createdDate': VooDataFilter(
              operator: VooFilterOperator.between,
              value: startDate,
              valueTo: endDate,
            ),
          },
          sorts: const [],
        );

        final params = result['params'] as Map<String, String>;
        final filter = params[r'$filter']!;

        // Both dates should have +00:00
        final matches = '+00:00'.allMatches(filter);
        expect(matches.length, 2);
        expect(filter.contains('Z'), isFalse);
      });

      test('should format between dates with UTC format', () {
        const builder = DataGridRequestBuilder(
          standard: ApiFilterStandard.odata,
          odataDateTimeFormat: ODataDateTimeFormat.utc,
        );

        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTime(2024, 12, 31);

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'createdDate': VooDataFilter(
              operator: VooFilterOperator.between,
              value: startDate,
              valueTo: endDate,
            ),
          },
          sorts: const [],
        );

        final params = result['params'] as Map<String, String>;
        final filter = params[r'$filter']!;

        // Both dates should have Z
        final matches = 'Z'.allMatches(filter);
        expect(matches.length, greaterThanOrEqualTo(2));
        expect(filter.contains('+00:00'), isFalse);
      });
    });

    group('Complex Scenario with Multiple DateTime Filters', () {
      test('should handle multiple DateTime filters with utcOffset format', () {
        const builder = DataGridRequestBuilder(
          standard: ApiFilterStandard.odata,
          odataDateTimeFormat: ODataDateTimeFormat.utcOffset,
        );

        final startDate = DateTime(2024, 1, 1);
        final createdDate = DateTime(2024, 6, 15);

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'createdDate': VooDataFilter(
              operator: VooFilterOperator.greaterThanOrEqual,
              value: startDate,
            ),
            'updatedDate': VooDataFilter(
              operator: VooFilterOperator.lessThan,
              value: createdDate,
            ),
          },
          sorts: const [],
        );

        final params = result['params'] as Map<String, String>;
        final filter = params[r'$filter']!;

        // All dates should have +00:00
        final matches = '+00:00'.allMatches(filter);
        expect(matches.length, 2);
        expect(filter.contains('Z'), isFalse);
      });
    });

    group('Default DateTime Format', () {
      test('should default to UTC format when not specified', () {
        const builder = DataGridRequestBuilder(
          standard: ApiFilterStandard.odata,
        );

        final dateTime = DateTime(2024, 9, 30);
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'createdDate': VooDataFilter(
              operator: VooFilterOperator.equals,
              value: dateTime,
            ),
          },
          sorts: const [],
        );

        final params = result['params'] as Map<String, String>;
        final filter = params[r'$filter']!;

        // Should have Z suffix by default
        expect(filter, contains('Z'));
      });
    });

    group('Real-world .NET OData + PostgreSQL Scenarios', () {
      test('should format for .NET DateTimeOffset with PostgreSQL timestamptz', () {
        // This is the format that works with .NET OData DateTimeOffset + PostgreSQL
        const builder = DataGridRequestBuilder(
          standard: ApiFilterStandard.odata,
          odataDateTimeFormat: ODataDateTimeFormat.utcOffset,
        );

        final dateTime = DateTime(2024, 9, 30, 15, 15, 30);
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'createdAt': VooDataFilter(
              operator: VooFilterOperator.equals,
              value: dateTime,
            ),
          },
          sorts: const [],
        );

        final params = result['params'] as Map<String, String>;
        final filter = params[r'$filter']!;

        // Should be in format: 2024-09-30T15:15:30.000+00:00
        expect(filter, contains('+00:00'));
        expect(filter, contains('2024-09-30T'));
        expect(filter.contains('Z'), isFalse);
      });

      test('should handle mixed DateTime and string dates consistently', () {
        const builder = DataGridRequestBuilder(
          standard: ApiFilterStandard.odata,
          odataDateTimeFormat: ODataDateTimeFormat.utcOffset,
        );

        final dateTimeObj = DateTime(2024, 1, 1);
        const dateTimeStr = '2024-12-31T23:59:59';

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'startDate': VooDataFilter(
              operator: VooFilterOperator.greaterThanOrEqual,
              value: dateTimeObj,
            ),
            'endDate': const VooDataFilter(
              operator: VooFilterOperator.lessThanOrEqual,
              value: dateTimeStr,
            ),
          },
          sorts: const [],
        );

        final params = result['params'] as Map<String, String>;
        final filter = params[r'$filter']!;

        // Both should be formatted consistently with +00:00
        final matches = '+00:00'.allMatches(filter);
        expect(matches.length, 2);
        expect(filter.contains('Z'), isFalse);
      });
    });
  });
}
