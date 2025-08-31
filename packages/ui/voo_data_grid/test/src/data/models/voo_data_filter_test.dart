import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('VooDataFilter', () {
    group('constructor', () {
      test('should create instance with required parameters', () {
        // Arrange
        const field = 'name';
        const operator = 'contains';
        const value = 'test';
        
        // Act
        const filter = VooDataFilter(
          field: field,
          operator: operator,
          value: value,
        );
        
        // Assert
        expect(filter.field, equals(field));
        expect(filter.operator, equals(operator));
        expect(filter.value, equals(value));
      });
      
      test('should create instance with null value', () {
        // Arrange & Act
        const filter = VooDataFilter(
          field: 'status',
          operator: 'isNull',
          value: null,
        );
        
        // Assert
        expect(filter.field, equals('status'));
        expect(filter.operator, equals('isNull'));
        expect(filter.value, isNull);
      });
      
      test('should create instance with list value for in operator', () {
        // Arrange
        final values = ['active', 'pending', 'completed'];
        
        // Act
        final filter = VooDataFilter(
          field: 'status',
          operator: 'in',
          value: values,
        );
        
        // Assert
        expect(filter.field, equals('status'));
        expect(filter.operator, equals('in'));
        expect(filter.value, equals(values));
      });
    });
    
    group('toJson', () {
      test('should serialize to JSON correctly', () {
        // Arrange
        const filter = VooDataFilter(
          field: 'price',
          operator: 'greaterThan',
          value: 100,
        );
        
        // Act
        final json = filter.toJson();
        
        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['field'], equals('price'));
        expect(json['operator'], equals('greaterThan'));
        expect(json['value'], equals(100));
      });
      
      test('should serialize null value correctly', () {
        // Arrange
        const filter = VooDataFilter(
          field: 'description',
          operator: 'isNotNull',
          value: null,
        );
        
        // Act
        final json = filter.toJson();
        
        // Assert
        expect(json['field'], equals('description'));
        expect(json['operator'], equals('isNotNull'));
        expect(json['value'], isNull);
      });
    });
    
    group('fromJson', () {
      test('should deserialize from JSON correctly', () {
        // Arrange
        final json = {
          'field': 'category',
          'operator': 'equals',
          'value': 'electronics',
        };
        
        // Act
        final filter = VooDataFilter.fromJson(json);
        
        // Assert
        expect(filter.field, equals('category'));
        expect(filter.operator, equals('equals'));
        expect(filter.value, equals('electronics'));
      });
      
      test('should deserialize list value correctly', () {
        // Arrange
        final json = {
          'field': 'tags',
          'operator': 'containsAny',
          'value': ['tech', 'gadget', 'new'],
        };
        
        // Act
        final filter = VooDataFilter.fromJson(json);
        
        // Assert
        expect(filter.field, equals('tags'));
        expect(filter.operator, equals('containsAny'));
        expect(filter.value, equals(['tech', 'gadget', 'new']));
      });
    });
    
    group('equality', () {
      test('should be equal when all properties match', () {
        // Arrange
        const filter1 = VooDataFilter(
          field: 'name',
          operator: 'startsWith',
          value: 'John',
        );
        const filter2 = VooDataFilter(
          field: 'name',
          operator: 'startsWith',
          value: 'John',
        );
        
        // Assert
        expect(filter1, equals(filter2));
      });
      
      test('should not be equal when field differs', () {
        // Arrange
        const filter1 = VooDataFilter(
          field: 'name',
          operator: 'contains',
          value: 'test',
        );
        const filter2 = VooDataFilter(
          field: 'description',
          operator: 'contains',
          value: 'test',
        );
        
        // Assert
        expect(filter1, isNot(equals(filter2)));
      });
      
      test('should not be equal when operator differs', () {
        // Arrange
        const filter1 = VooDataFilter(
          field: 'price',
          operator: 'greaterThan',
          value: 100,
        );
        const filter2 = VooDataFilter(
          field: 'price',
          operator: 'lessThan',
          value: 100,
        );
        
        // Assert
        expect(filter1, isNot(equals(filter2)));
      });
    });
    
    group('copyWith', () {
      test('should create copy with updated field', () {
        // Arrange
        const original = VooDataFilter(
          field: 'name',
          operator: 'contains',
          value: 'test',
        );
        
        // Act
        final copy = original.copyWith(field: 'description');
        
        // Assert
        expect(copy.field, equals('description'));
        expect(copy.operator, equals('contains'));
        expect(copy.value, equals('test'));
      });
      
      test('should create copy with updated operator', () {
        // Arrange
        const original = VooDataFilter(
          field: 'price',
          operator: 'equals',
          value: 100,
        );
        
        // Act
        final copy = original.copyWith(operator: 'greaterThan');
        
        // Assert
        expect(copy.field, equals('price'));
        expect(copy.operator, equals('greaterThan'));
        expect(copy.value, equals(100));
      });
      
      test('should create copy with updated value', () {
        // Arrange
        const original = VooDataFilter(
          field: 'quantity',
          operator: 'lessThan',
          value: 10,
        );
        
        // Act
        final copy = original.copyWith(value: 20);
        
        // Assert
        expect(copy.field, equals('quantity'));
        expect(copy.operator, equals('lessThan'));
        expect(copy.value, equals(20));
      });
    });
  });
}