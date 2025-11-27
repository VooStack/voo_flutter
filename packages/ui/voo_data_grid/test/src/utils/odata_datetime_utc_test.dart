import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
import 'package:voo_data_grid/src/domain/entities/voo_filter_operator.dart';
import 'package:voo_data_grid/src/utils/data_grid_request_builder.dart';

void main() {
  group('OData DateTime UTC Conversion Tests', () {
    late DataGridRequestBuilder builder;

    setUp(() {
      builder = const DataGridRequestBuilder(standard: ApiFilterStandard.odata);
    });

    group('DateTime objects to UTC', () {
      test('should convert local DateTime to UTC with Z suffix', () {
        // Create a local DateTime
        final localDateTime = DateTime(2024, 1, 15, 10, 30);

        final filters = {'createdAt': VooDataFilter(operator: VooFilterOperator.greaterThan, value: localDateTime)};

        final result = builder.buildRequest(page: 0, pageSize: 20, filters: filters, sorts: []);

        final filterString = result['params']['\$filter'] as String;

        // Should contain UTC timestamp with Z suffix
        expect(filterString, contains('createdAt gt '));
        expect(filterString, contains('Z'));

        // Extract the datetime part
        final dateTimeMatch = RegExp(r'\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z').firstMatch(filterString);
        expect(dateTimeMatch, isNotNull, reason: 'Should contain valid ISO 8601 UTC timestamp');
      });

      test('should maintain UTC for already UTC DateTime', () {
        // Create a UTC DateTime
        final utcDateTime = DateTime.utc(2024, 1, 15, 10, 30);

        final filters = {'updatedAt': VooDataFilter(operator: VooFilterOperator.equals, value: utcDateTime)};

        final result = builder.buildRequest(page: 0, pageSize: 20, filters: filters, sorts: []);

        final filterString = result['params']['\$filter'] as String;

        // Should contain the exact UTC time with Z suffix
        expect(filterString, contains('2024-01-15T10:30:00.000Z'));
      });

      test('should handle DateTime with milliseconds', () {
        final dateTimeWithMillis = DateTime.utc(2024, 1, 15, 10, 30, 45, 123);

        final filters = {'timestamp': VooDataFilter(operator: VooFilterOperator.lessThan, value: dateTimeWithMillis)};

        final result = builder.buildRequest(page: 0, pageSize: 20, filters: filters, sorts: []);

        final filterString = result['params']['\$filter'] as String;

        // Should preserve milliseconds and include Z suffix
        expect(filterString, contains('2024-01-15T10:30:45.123Z'));
      });

      test('should handle DateTime at midnight', () {
        final midnight = DateTime.utc(2024, 1, 15);

        final filters = {'date': VooDataFilter(operator: VooFilterOperator.equals, value: midnight)};

        final result = builder.buildRequest(page: 0, pageSize: 20, filters: filters, sorts: []);

        final filterString = result['params']['\$filter'] as String;

        expect(filterString, contains('2024-01-15T00:00:00.000Z'));
      });
    });

    group('String date values to UTC', () {
      test('should parse and convert date-only string to UTC', () {
        final filters = {'birthDate': const VooDataFilter(operator: VooFilterOperator.equals, value: '2024-01-15')};

        final result = builder.buildRequest(page: 0, pageSize: 20, filters: filters, sorts: []);

        final filterString = result['params']['\$filter'] as String;

        // Should parse date and add time component with Z suffix
        expect(filterString, contains('2024-01-15T00:00:00.000Z'));
        expect(filterString, isNot(contains("'2024-01-15'")), reason: 'Should not be treated as string');
      });

      test('should parse and convert datetime string to UTC', () {
        final filters = {'appointmentTime': const VooDataFilter(operator: VooFilterOperator.greaterThanOrEqual, value: '2024-01-15T14:30:00')};

        final result = builder.buildRequest(page: 0, pageSize: 20, filters: filters, sorts: []);

        final filterString = result['params']['\$filter'] as String;

        // Should parse datetime and ensure Z suffix
        expect(filterString, contains('T14:30:00.000Z'));
        expect(filterString, contains('appointmentTime ge 2024-01-15T14:30:00.000Z'));
      });

      test('should handle datetime string with milliseconds', () {
        final filters = {'exactTime': const VooDataFilter(operator: VooFilterOperator.equals, value: '2024-01-15T14:30:45.500')};

        final result = builder.buildRequest(page: 0, pageSize: 20, filters: filters, sorts: []);

        final filterString = result['params']['\$filter'] as String;

        expect(filterString, contains('2024-01-15T14:30:45.500Z'));
      });

      test('should maintain Z suffix if already present in string', () {
        final filters = {'timestamp': const VooDataFilter(operator: VooFilterOperator.equals, value: '2024-01-15T14:30:00.000Z')};

        final result = builder.buildRequest(page: 0, pageSize: 20, filters: filters, sorts: []);

        final filterString = result['params']['\$filter'] as String;

        expect(filterString, contains('2024-01-15T14:30:00.000Z'));
        // Should not have double Z
        expect(filterString, isNot(contains('ZZ')));
      });

      test('should handle datetime string with timezone offset', () {
        final filters = {'scheduledAt': const VooDataFilter(operator: VooFilterOperator.equals, value: '2024-01-15T14:30:00+05:00')};

        final result = builder.buildRequest(page: 0, pageSize: 20, filters: filters, sorts: []);

        final filterString = result['params']['\$filter'] as String;

        // Should convert timezone offset to UTC
        expect(filterString, contains('Z'));
        // 14:30 +05:00 should convert to 09:30 UTC
        expect(filterString, contains('T09:30:00.000Z'));
      });
    });

    group('Between operator with dates', () {
      test('should convert both date values to UTC in between filter', () {
        final startDate = DateTime(2024);
        final endDate = DateTime(2024, 1, 31, 23, 59, 59);

        final filters = {'createdDate': VooDataFilter(operator: VooFilterOperator.between, value: startDate, valueTo: endDate)};

        final result = builder.buildRequest(page: 0, pageSize: 20, filters: filters, sorts: []);

        final filterString = result['params']['\$filter'] as String;

        // Both dates should have Z suffix
        final zCount = 'Z'.allMatches(filterString).length;
        expect(zCount, equals(2), reason: 'Both start and end dates should have Z suffix');

        // Should contain both dates in UTC
        expect(filterString, contains('createdDate ge'));
        expect(filterString, contains('createdDate le'));
      });

      test('should handle string date ranges', () {
        final filters = {'eventDate': const VooDataFilter(operator: VooFilterOperator.between, value: '2024-01-01', valueTo: '2024-12-31')};

        final result = builder.buildRequest(page: 0, pageSize: 20, filters: filters, sorts: []);

        final filterString = result['params']['\$filter'] as String;

        expect(filterString, contains('2024-01-01T00:00:00.000Z'));
        expect(filterString, contains('2024-12-31T00:00:00.000Z'));
      });
    });

    group('Edge cases and special scenarios', () {
      test('should handle leap year dates', () {
        // Feb 29, 2024 (leap year)
        final leapDate = DateTime.utc(2024, 2, 29, 12);

        final filters = {'specialDate': VooDataFilter(operator: VooFilterOperator.equals, value: leapDate)};

        final result = builder.buildRequest(page: 0, pageSize: 20, filters: filters, sorts: []);

        final filterString = result['params']['\$filter'] as String;

        expect(filterString, contains('2024-02-29T12:00:00.000Z'));
      });

      test('should handle end of year datetime', () {
        final newYearEve = DateTime.utc(2024, 12, 31, 23, 59, 59, 999);

        final filters = {'yearEnd': VooDataFilter(operator: VooFilterOperator.lessThanOrEqual, value: newYearEve)};

        final result = builder.buildRequest(page: 0, pageSize: 20, filters: filters, sorts: []);

        final filterString = result['params']['\$filter'] as String;

        expect(filterString, contains('2024-12-31T23:59:59.999Z'));
      });

      test('should handle minimum representable datetime', () {
        // Minimum DateTime that can be represented
        final minDate = DateTime.utc(1970);

        final filters = {'epochStart': VooDataFilter(operator: VooFilterOperator.greaterThanOrEqual, value: minDate)};

        final result = builder.buildRequest(page: 0, pageSize: 20, filters: filters, sorts: []);

        final filterString = result['params']['\$filter'] as String;

        expect(filterString, contains('1970-01-01T00:00:00.000Z'));
      });

      test('should not treat regular strings as dates', () {
        final filters = {'description': const VooDataFilter(operator: VooFilterOperator.equals, value: 'Meeting scheduled for 2024-01-15')};

        final result = builder.buildRequest(page: 0, pageSize: 20, filters: filters, sorts: []);

        final filterString = result['params']['\$filter'] as String;

        // Should be treated as string, not parsed as date
        expect(filterString, contains("'Meeting scheduled for 2024-01-15'"));
        expect(filterString, isNot(contains('Z')));
      });

      test('should handle overflow date string by parsing (Dart allows overflow)', () {
        final filters = {
          'overflowDate': const VooDataFilter(
            operator: VooFilterOperator.equals,
            value: '2024-13-45', // Month 13 and day 45 overflow to valid date
          ),
        };

        final result = builder.buildRequest(page: 0, pageSize: 20, filters: filters, sorts: []);

        final filterString = result['params']['\$filter'] as String;

        // Dart's DateTime.parse() handles overflow, so this gets parsed
        // Month 13 becomes January, day 45 overflows into February
        expect(filterString, contains('Z'));
        expect(filterString, contains('2025-02-14T00:00:00.000Z'));
      });
    });

    group('Mixed date formats in filters', () {
      test('should handle DateTime objects and string dates together', () {
        final dateTimeObj = DateTime.utc(2024, 1, 15, 10);

        final filters = {
          'startDate': VooDataFilter(operator: VooFilterOperator.greaterThanOrEqual, value: dateTimeObj),
          'endDate': const VooDataFilter(operator: VooFilterOperator.lessThanOrEqual, value: '2024-12-31T23:59:59'),
        };

        final result = builder.buildRequest(page: 0, pageSize: 20, filters: filters, sorts: []);

        final filterString = result['params']['\$filter'] as String;

        // Both should have Z suffix
        expect(filterString, contains('2024-01-15T10:00:00.000Z'));
        expect(filterString, contains('2024-12-31T23:59:59.000Z'));
        expect('Z'.allMatches(filterString).length, equals(2));
      });
    });

    group('PostgreSQL compatibility', () {
      test('should generate timestamps compatible with PostgreSQL timestamptz', () {
        // This is the exact scenario that was failing
        final userCreatedDate = DateTime(2024, 9, 30, 10, 15, 30);

        final filters = {'createdAt': VooDataFilter(operator: VooFilterOperator.greaterThan, value: userCreatedDate)};

        final result = builder.buildRequest(page: 0, pageSize: 20, filters: filters, sorts: []);

        final filterString = result['params']['\$filter'] as String;

        // Must have Z suffix for PostgreSQL to recognize it as UTC
        expect(filterString, contains('Z'));

        // Should not have Kind=Unspecified issue (Z ensures it's recognized as UTC)
        final dateTimePattern = RegExp(r'\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z');
        expect(dateTimePattern.hasMatch(filterString), isTrue);
      });

      test('should handle date-only filters for PostgreSQL date columns', () {
        final filters = {'birthDate': const VooDataFilter(operator: VooFilterOperator.equals, value: '1990-05-15')};

        final result = builder.buildRequest(page: 0, pageSize: 20, filters: filters, sorts: []);

        final filterString = result['params']['\$filter'] as String;

        // Even date-only should have time component for PostgreSQL compatibility
        expect(filterString, contains('1990-05-15T00:00:00.000Z'));
      });
    });

    group('Timezone conversion accuracy', () {
      test('should correctly convert different local times to UTC', () {
        // Create a local time at midnight
        final localMidnight = DateTime(2024, 6, 15);

        final filters = {'localTime': VooDataFilter(operator: VooFilterOperator.equals, value: localMidnight)};

        final result = builder.buildRequest(page: 0, pageSize: 20, filters: filters, sorts: []);

        final filterString = result['params']['\$filter'] as String;

        // Should have converted to UTC (exact time depends on system timezone)
        // But must have Z suffix
        expect(filterString, contains('Z'));
        expect(filterString, contains('2024-06'));
      });

      test('should handle DST transitions correctly', () {
        // March 10, 2024 is during DST transition in many timezones
        final dstDate = DateTime.utc(2024, 3, 10, 2);

        final filters = {'dstTransition': VooDataFilter(operator: VooFilterOperator.equals, value: dstDate)};

        final result = builder.buildRequest(page: 0, pageSize: 20, filters: filters, sorts: []);

        final filterString = result['params']['\$filter'] as String;

        expect(filterString, contains('2024-03-10T02:00:00.000Z'));
      });
    });
  });
}
