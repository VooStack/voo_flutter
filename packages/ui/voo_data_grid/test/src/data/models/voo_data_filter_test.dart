import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('VooDataFilter', () {
    group('constructor', () {
      test('should create instance with required parameters', () {
        // Arrange
        const operator = VooFilterOperator.contains;
        const value = 'test';

        // Act
        const filter = VooDataFilter(operator: operator, value: value);

        // Assert
        expect(filter.operator, equals(operator));
        expect(filter.value, equals(value));
        expect(filter.valueTo, isNull);
      });

      test('should create instance with null value', () {
        // Arrange & Act
        const filter = VooDataFilter(operator: VooFilterOperator.isNull, value: null);

        // Assert
        expect(filter.operator, equals(VooFilterOperator.isNull));
        expect(filter.value, isNull);
      });

      test('should create instance with list value for in operator', () {
        // Arrange
        final values = ['active', 'pending', 'completed'];

        // Act
        final filter = VooDataFilter(operator: VooFilterOperator.inList, value: values);

        // Assert
        expect(filter.operator, equals(VooFilterOperator.inList));
        expect(filter.value, equals(values));
      });

      test('should create instance with valueTo for between operator', () {
        // Arrange
        const valueFrom = 10;
        const valueTo = 100;

        // Act
        const filter = VooDataFilter(operator: VooFilterOperator.between, value: valueFrom, valueTo: valueTo);

        // Assert
        expect(filter.operator, equals(VooFilterOperator.between));
        expect(filter.value, equals(valueFrom));
        expect(filter.valueTo, equals(valueTo));
      });
    });

    group('operator types', () {
      test('should support text operators', () {
        // Test various text operators
        const operators = [
          VooFilterOperator.contains,
          VooFilterOperator.startsWith,
          VooFilterOperator.endsWith,
          VooFilterOperator.equals,
          VooFilterOperator.notEquals,
        ];

        for (final op in operators) {
          final filter = VooDataFilter(operator: op, value: 'test');
          expect(filter.operator, equals(op));
        }
      });

      test('should support numeric operators', () {
        // Test various numeric operators
        const operators = [
          VooFilterOperator.equals,
          VooFilterOperator.notEquals,
          VooFilterOperator.greaterThan,
          VooFilterOperator.greaterThanOrEqual,
          VooFilterOperator.lessThan,
          VooFilterOperator.lessThanOrEqual,
          VooFilterOperator.between,
        ];

        for (final op in operators) {
          final filter = VooDataFilter(operator: op, value: 42, valueTo: op == VooFilterOperator.between ? 100 : null);
          expect(filter.operator, equals(op));
        }
      });

      test('should support date operators', () {
        // Test date operators (dates can use comparison operators)
        final now = DateTime.now();
        final tomorrow = now.add(const Duration(days: 1));

        const dateOperators = [VooFilterOperator.equals, VooFilterOperator.lessThan, VooFilterOperator.greaterThan, VooFilterOperator.between];

        for (final op in dateOperators) {
          final filter = VooDataFilter(operator: op, value: now, valueTo: op == VooFilterOperator.between ? tomorrow : null);
          expect(filter.operator, equals(op));
          expect(filter.value, equals(now));
          if (op == VooFilterOperator.between) {
            expect(filter.valueTo, equals(tomorrow));
          }
        }
      });

      test('should support boolean operators', () {
        // Test boolean operators
        const filter = VooDataFilter(operator: VooFilterOperator.equals, value: true);

        expect(filter.operator, equals(VooFilterOperator.equals));
        expect(filter.value, isTrue);
      });

      test('should support null checking operators', () {
        // Test null operators
        const isNullFilter = VooDataFilter(operator: VooFilterOperator.isNull, value: null);

        const isNotNullFilter = VooDataFilter(operator: VooFilterOperator.isNotNull, value: null);

        expect(isNullFilter.operator, equals(VooFilterOperator.isNull));
        expect(isNotNullFilter.operator, equals(VooFilterOperator.isNotNull));
      });
    });

    group('value types', () {
      test('should accept string values', () {
        const filter = VooDataFilter(operator: VooFilterOperator.contains, value: 'test string');

        expect(filter.value, isA<String>());
        expect(filter.value, equals('test string'));
      });

      test('should accept numeric values', () {
        const intFilter = VooDataFilter(operator: VooFilterOperator.equals, value: 42);

        const doubleFilter = VooDataFilter(operator: VooFilterOperator.greaterThan, value: 3.14);

        expect(intFilter.value, isA<int>());
        expect(intFilter.value, equals(42));
        expect(doubleFilter.value, isA<double>());
        expect(doubleFilter.value, equals(3.14));
      });

      test('should accept DateTime values', () {
        final date = DateTime(2024);
        final filter = VooDataFilter(operator: VooFilterOperator.greaterThan, value: date);

        expect(filter.value, isA<DateTime>());
        expect(filter.value, equals(date));
      });

      test('should accept List values for in/not in operators', () {
        final values = ['option1', 'option2', 'option3'];
        final filter = VooDataFilter(operator: VooFilterOperator.inList, value: values);

        expect(filter.value, isA<List>());
        expect(filter.value, equals(values));
      });

      test('should accept bool values', () {
        const filter = VooDataFilter(operator: VooFilterOperator.equals, value: true);

        expect(filter.value, isA<bool>());
        expect(filter.value, isTrue);
      });
    });

    group('range filters', () {
      test('should handle between with two numeric values', () {
        const filter = VooDataFilter(operator: VooFilterOperator.between, value: 10, valueTo: 100);

        expect(filter.operator, equals(VooFilterOperator.between));
        expect(filter.value, equals(10));
        expect(filter.valueTo, equals(100));
      });

      test('should handle between with two date values', () {
        final startDate = DateTime(2024);
        final endDate = DateTime(2024, 12, 31);

        final filter = VooDataFilter(operator: VooFilterOperator.between, value: startDate, valueTo: endDate);

        expect(filter.operator, equals(VooFilterOperator.between));
        expect(filter.value, equals(startDate));
        expect(filter.valueTo, equals(endDate));
      });
    });
  });
}
