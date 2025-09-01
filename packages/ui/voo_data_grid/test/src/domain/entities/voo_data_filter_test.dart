import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('VooDataFilter', () {
    group('constructor', () {
      test('should create instance with required parameters', () {
        // Arrange & Act
        const filter = VooDataFilter(
          operator: VooFilterOperator.equals,
          value: 'test',
        );
        
        // Assert
        expect(filter.operator, equals(VooFilterOperator.equals));
        expect(filter.value, equals('test'));
        expect(filter.valueTo, isNull);
      });
      
      test('should create instance with null value', () {
        // Arrange & Act
        const filter = VooDataFilter(
          operator: VooFilterOperator.isNull,
          value: null,
        );
        
        // Assert
        expect(filter.operator, equals(VooFilterOperator.isNull));
        expect(filter.value, isNull);
        expect(filter.valueTo, isNull);
      });
      
      test('should create instance with valueTo for range operators', () {
        // Arrange & Act
        const filter = VooDataFilter(
          operator: VooFilterOperator.between,
          value: 10,
          valueTo: 100,
        );
        
        // Assert
        expect(filter.operator, equals(VooFilterOperator.between));
        expect(filter.value, equals(10));
        expect(filter.valueTo, equals(100));
      });
      
      test('should create instance with list value for inList operator', () {
        // Arrange
        final values = ['active', 'pending', 'completed'];
        
        // Act
        final filter = VooDataFilter(
          operator: VooFilterOperator.inList,
          value: values,
        );
        
        // Assert
        expect(filter.operator, equals(VooFilterOperator.inList));
        expect(filter.value, equals(values));
        expect(filter.valueTo, isNull);
      });
    });
    
    group('different operator types', () {
      test('should create contains filter', () {
        // Arrange & Act
        const filter = VooDataFilter(
          operator: VooFilterOperator.contains,
          value: 'search term',
        );
        
        // Assert
        expect(filter.operator, equals(VooFilterOperator.contains));
        expect(filter.value, equals('search term'));
      });
      
      test('should create greaterThan filter', () {
        // Arrange & Act
        const filter = VooDataFilter(
          operator: VooFilterOperator.greaterThan,
          value: 50,
        );
        
        // Assert
        expect(filter.operator, equals(VooFilterOperator.greaterThan));
        expect(filter.value, equals(50));
      });
      
      test('should create lessThan filter', () {
        // Arrange & Act
        const filter = VooDataFilter(
          operator: VooFilterOperator.lessThan,
          value: 100,
        );
        
        // Assert
        expect(filter.operator, equals(VooFilterOperator.lessThan));
        expect(filter.value, equals(100));
      });
      
      test('should create startsWith filter', () {
        // Arrange & Act
        const filter = VooDataFilter(
          operator: VooFilterOperator.startsWith,
          value: 'prefix',
        );
        
        // Assert
        expect(filter.operator, equals(VooFilterOperator.startsWith));
        expect(filter.value, equals('prefix'));
      });
      
      test('should create endsWith filter', () {
        // Arrange & Act
        const filter = VooDataFilter(
          operator: VooFilterOperator.endsWith,
          value: 'suffix',
        );
        
        // Assert
        expect(filter.operator, equals(VooFilterOperator.endsWith));
        expect(filter.value, equals('suffix'));
      });
    });
    
    group('range operations', () {
      test('should create between filter with valueTo', () {
        // Arrange & Act
        final filter = VooDataFilter(
          operator: VooFilterOperator.between,
          value: DateTime(2024),
          valueTo: DateTime(2024, 12, 31),
        );
        
        // Assert
        expect(filter.operator, equals(VooFilterOperator.between));
        expect(filter.value, equals(DateTime(2024)));
        expect(filter.valueTo, equals(DateTime(2024, 12, 31)));
      });
      
      test('should create numeric between filter', () {
        // Arrange & Act
        const filter = VooDataFilter(
          operator: VooFilterOperator.between,
          value: 0.0,
          valueTo: 99.99,
        );
        
        // Assert
        expect(filter.operator, equals(VooFilterOperator.between));
        expect(filter.value, equals(0.0));
        expect(filter.valueTo, equals(99.99));
      });
    });
    
    group('null checks', () {
      test('should create isNull filter', () {
        // Arrange & Act
        const filter = VooDataFilter(
          operator: VooFilterOperator.isNull,
          value: null,
        );
        
        // Assert
        expect(filter.operator, equals(VooFilterOperator.isNull));
        expect(filter.value, isNull);
      });
      
      test('should create isNotNull filter', () {
        // Arrange & Act
        const filter = VooDataFilter(
          operator: VooFilterOperator.isNotNull,
          value: null,
        );
        
        // Assert
        expect(filter.operator, equals(VooFilterOperator.isNotNull));
        expect(filter.value, isNull);
      });
    });
  });
}