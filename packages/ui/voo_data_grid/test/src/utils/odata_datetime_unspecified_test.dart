import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
import 'package:voo_data_grid/src/domain/entities/voo_filter_operator.dart';
import 'package:voo_data_grid/src/utils/data_grid_request_builder.dart';

void main() {
  group('OData DateTime Unspecified Format Tests', () {
    late DataGridRequestBuilder builder;

    setUp(() {
      builder = const DataGridRequestBuilder(
        standard: ApiFilterStandard.odata,
        odataDateTimeFormat: ODataDateTimeFormat.unspecified,
      );
    });

    group('DateTime objects without Z suffix', () {
      test('should format DateTime without Z suffix', () {
        final localDateTime = DateTime(2024, 9, 30, 10, 15, 30);

        final filters = {
          'createdDate': VooDataFilter(
            operator: VooFilterOperator.greaterThanOrEqual,
            value: localDateTime,
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;

        // Should NOT have Z suffix
        expect(filterString, isNot(contains('Z')));
        // Should still be in ISO 8601 format but without timezone
        expect(filterString, contains('T'));
        expect(filterString, contains('createdDate ge'));
      });

      test('should maintain UTC conversion but remove Z suffix', () {
        // Create a local DateTime
        final localDateTime = DateTime(2024, 1, 15, 10, 30, 0);

        final filters = {
          'timestamp': VooDataFilter(
            operator: VooFilterOperator.equals,
            value: localDateTime,
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;

        // Should convert to UTC time but without Z suffix
        expect(filterString, isNot(contains('Z')));
        // Should still have ISO 8601 datetime format
        final dateTimePattern = RegExp(r'\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}');
        expect(dateTimePattern.hasMatch(filterString), isTrue);
      });

      test('should handle DateTime at midnight without Z', () {
        final midnight = DateTime.utc(2024, 1, 15);

        final filters = {
          'date': VooDataFilter(
            operator: VooFilterOperator.equals,
            value: midnight,
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;

        expect(filterString, contains('2024-01-15T00:00:00.000'));
        expect(filterString, isNot(contains('Z')));
      });

      test('should handle DateTime with milliseconds without Z', () {
        final dateTimeWithMillis = DateTime.utc(2024, 1, 15, 10, 30, 45, 123);

        final filters = {
          'timestamp': VooDataFilter(
            operator: VooFilterOperator.lessThan,
            value: dateTimeWithMillis,
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;

        expect(filterString, contains('2024-01-15T10:30:45.123'));
        expect(filterString, isNot(contains('Z')));
      });
    });

    group('String date values without Z suffix', () {
      test('should parse date-only string and format without Z', () {
        final filters = {
          'birthDate': const VooDataFilter(
            operator: VooFilterOperator.equals,
            value: '2024-01-15',
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;

        // Should parse date and add time component but WITHOUT Z suffix
        expect(filterString, contains('2024-01-15T00:00:00.000'));
        expect(filterString, isNot(contains('Z')));
      });

      test('should parse datetime string and format without Z', () {
        final filters = {
          'appointmentTime': const VooDataFilter(
            operator: VooFilterOperator.greaterThanOrEqual,
            value: '2024-01-15T14:30:00',
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;

        // Should parse datetime but remove Z suffix
        expect(filterString, contains('T14:30:00.000'));
        expect(filterString, isNot(contains('Z')));
      });

      test('should strip Z suffix from string with Z', () {
        final filters = {
          'timestamp': const VooDataFilter(
            operator: VooFilterOperator.equals,
            value: '2024-01-15T14:30:00.000Z',
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;

        // Should remove the Z suffix
        expect(filterString, contains('2024-01-15T14:30:00.000'));
        expect(filterString, isNot(contains('Z')));
      });

      test('should handle datetime string with timezone offset and remove Z', () {
        final filters = {
          'scheduledAt': const VooDataFilter(
            operator: VooFilterOperator.equals,
            value: '2024-01-15T14:30:00+05:00',
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;

        // Should convert timezone offset to UTC but without Z
        expect(filterString, isNot(contains('Z')));
        // 14:30 +05:00 should convert to 09:30 UTC (without Z)
        expect(filterString, contains('T09:30:00.000'));
      });
    });

    group('Between operator with dates without Z', () {
      test('should format both date values without Z in between filter', () {
        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTime(2024, 1, 31, 23, 59, 59);

        final filters = {
          'createdDate': VooDataFilter(
            operator: VooFilterOperator.between,
            value: startDate,
            valueTo: endDate,
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;

        // Should NOT have any Z suffix
        expect(filterString, isNot(contains('Z')));
        // Should contain both dates
        expect(filterString, contains('createdDate ge'));
        expect(filterString, contains('createdDate le'));
      });

      test('should handle string date ranges without Z', () {
        final filters = {
          'eventDate': const VooDataFilter(
            operator: VooFilterOperator.between,
            value: '2024-01-01',
            valueTo: '2024-12-31',
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;

        expect(filterString, contains('2024-01-01T00:00:00.000'));
        expect(filterString, contains('2024-12-31T00:00:00.000'));
        expect(filterString, isNot(contains('Z')));
      });
    });

    group('Comparison with UTC format', () {
      test('should show difference between UTC and unspecified format', () {
        final dateTime = DateTime.utc(2024, 1, 15, 10, 30, 0);

        // UTC format builder
        const utcBuilder = DataGridRequestBuilder(
          standard: ApiFilterStandard.odata,
          odataDateTimeFormat: ODataDateTimeFormat.utc,
        );

        // Unspecified format builder
        const unspecifiedBuilder = DataGridRequestBuilder(
          standard: ApiFilterStandard.odata,
          odataDateTimeFormat: ODataDateTimeFormat.unspecified,
        );

        final filters = {
          'timestamp': VooDataFilter(
            operator: VooFilterOperator.equals,
            value: dateTime,
          ),
        };

        final utcResult = utcBuilder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final unspecifiedResult = unspecifiedBuilder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final utcFilter = utcResult['params']['\$filter'] as String;
        final unspecifiedFilter = unspecifiedResult['params']['\$filter'] as String;

        // UTC should have Z
        expect(utcFilter, contains('2024-01-15T10:30:00.000Z'));
        // Unspecified should NOT have Z
        expect(unspecifiedFilter, contains('2024-01-15T10:30:00.000'));
        expect(unspecifiedFilter, isNot(contains('Z')));
      });
    });

    group('.NET DateTime compatibility', () {
      test('should generate format compatible with .NET DateTime.Kind=Unspecified', () {
        // This is the format that works with .NET OData when it creates
        // DateTime with Kind=Unspecified
        final userCreatedDate = DateTime(2024, 9, 30, 10, 15, 30);

        final filters = {
          'createdAt': VooDataFilter(
            operator: VooFilterOperator.greaterThan,
            value: userCreatedDate,
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;

        // Should NOT have Z suffix (compatible with DateTime.Kind=Unspecified)
        expect(filterString, isNot(contains('Z')));
        // Should still be valid ISO 8601 datetime
        final dateTimePattern = RegExp(r'\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}');
        expect(dateTimePattern.hasMatch(filterString), isTrue);
      });

      test('should work with .NET DateTime columns without timezone', () {
        final filters = {
          'lastLogin': const VooDataFilter(
            operator: VooFilterOperator.lessThanOrEqual,
            value: '2024-12-31T23:59:59',
          ),
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );

        final filterString = result['params']['\$filter'] as String;

        // Format should work with .NET DateTime (not DateTimeOffset)
        expect(filterString, contains('2024-12-31T23:59:59.000'));
        expect(filterString, isNot(contains('Z')));
      });
    });
  });
}