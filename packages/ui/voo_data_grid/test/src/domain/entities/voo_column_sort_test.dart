import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('VooColumnSort', () {
    group('constructor', () {
      test('should create instance with ascending direction', () {
        // Arrange & Act
        const sort = VooColumnSort(
          field: 'name',
          direction: VooSortDirection.ascending,
        );
        
        // Assert
        expect(sort.field, equals('name'));
        expect(sort.direction, equals(VooSortDirection.ascending));
      });
      
      test('should create instance with descending direction', () {
        // Arrange & Act
        const sort = VooColumnSort(
          field: 'price',
          direction: VooSortDirection.descending,
        );
        
        // Assert
        expect(sort.field, equals('price'));
        expect(sort.direction, equals(VooSortDirection.descending));
      });
      
      test('should create instance with none direction', () {
        // Arrange & Act
        const sort = VooColumnSort(
          field: 'status',
          direction: VooSortDirection.none,
        );
        
        // Assert
        expect(sort.field, equals('status'));
        expect(sort.direction, equals(VooSortDirection.none));
      });
    });
    
    group('equality', () {
      test('should be equal when field and direction match', () {
        // Arrange
        const sort1 = VooColumnSort(
          field: 'name',
          direction: VooSortDirection.ascending,
        );
        const sort2 = VooColumnSort(
          field: 'name',
          direction: VooSortDirection.ascending,
        );
        
        // Assert
        expect(sort1.field, equals(sort2.field));
        expect(sort1.direction, equals(sort2.direction));
      });
      
      test('should have different fields', () {
        // Arrange
        const sort1 = VooColumnSort(
          field: 'name',
          direction: VooSortDirection.ascending,
        );
        const sort2 = VooColumnSort(
          field: 'email',
          direction: VooSortDirection.ascending,
        );
        
        // Assert
        expect(sort1.field, isNot(equals(sort2.field)));
        expect(sort1.direction, equals(sort2.direction));
      });
      
      test('should have different directions', () {
        // Arrange
        const sort1 = VooColumnSort(
          field: 'price',
          direction: VooSortDirection.ascending,
        );
        const sort2 = VooColumnSort(
          field: 'price',
          direction: VooSortDirection.descending,
        );
        
        // Assert
        expect(sort1.field, equals(sort2.field));
        expect(sort1.direction, isNot(equals(sort2.direction)));
      });
    });
  });
}