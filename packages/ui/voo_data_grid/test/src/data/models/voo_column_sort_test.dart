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
    
    group('field types', () {
      test('should handle various field names', () {
        // Test different field name patterns
        const sorts = [
          VooColumnSort(field: 'id', direction: VooSortDirection.ascending),
          VooColumnSort(field: 'user_name', direction: VooSortDirection.descending),
          VooColumnSort(field: 'createdAt', direction: VooSortDirection.ascending),
          VooColumnSort(field: 'total_price', direction: VooSortDirection.none),
        ];
        
        for (final sort in sorts) {
          expect(sort.field, isA<String>());
          expect(sort.field.isNotEmpty, isTrue);
        }
      });
    });
    
    group('direction states', () {
      test('should support all sort directions', () {
        // Test all available sort directions
        const directions = [
          VooSortDirection.ascending,
          VooSortDirection.descending,
          VooSortDirection.none,
        ];
        
        for (final direction in directions) {
          final sort = VooColumnSort(
            field: 'testField',
            direction: direction,
          );
          expect(sort.direction, equals(direction));
        }
      });
    });
    
    group('multiple column sorting scenarios', () {
      test('should support creating multiple sort instances', () {
        // Arrange
        final sorts = [
          const VooColumnSort(field: 'category', direction: VooSortDirection.ascending),
          const VooColumnSort(field: 'price', direction: VooSortDirection.descending),
          const VooColumnSort(field: 'name', direction: VooSortDirection.ascending),
        ];
        
        // Assert
        expect(sorts.length, equals(3));
        expect(sorts[0].field, equals('category'));
        expect(sorts[0].direction, equals(VooSortDirection.ascending));
        expect(sorts[1].field, equals('price'));
        expect(sorts[1].direction, equals(VooSortDirection.descending));
        expect(sorts[2].field, equals('name'));
        expect(sorts[2].direction, equals(VooSortDirection.ascending));
      });
      
      test('should handle clearing sorts with none direction', () {
        // Arrange
        const clearedSort = VooColumnSort(
          field: 'name',
          direction: VooSortDirection.none,
        );
        
        // Assert
        expect(clearedSort.direction, equals(VooSortDirection.none));
      });
    });
    
    group('sorting use cases', () {
      test('should represent text column sorting', () {
        const sorts = [
          VooColumnSort(field: 'name', direction: VooSortDirection.ascending),
          VooColumnSort(field: 'email', direction: VooSortDirection.descending),
          VooColumnSort(field: 'description', direction: VooSortDirection.none),
        ];
        
        expect(sorts[0].direction, equals(VooSortDirection.ascending));
        expect(sorts[1].direction, equals(VooSortDirection.descending));
        expect(sorts[2].direction, equals(VooSortDirection.none));
      });
      
      test('should represent numeric column sorting', () {
        const sorts = [
          VooColumnSort(field: 'id', direction: VooSortDirection.ascending),
          VooColumnSort(field: 'price', direction: VooSortDirection.descending),
          VooColumnSort(field: 'quantity', direction: VooSortDirection.ascending),
        ];
        
        for (final sort in sorts) {
          expect(sort.field, isA<String>());
          expect(sort.direction, isA<VooSortDirection>());
        }
      });
      
      test('should represent date column sorting', () {
        const sorts = [
          VooColumnSort(field: 'createdAt', direction: VooSortDirection.descending),
          VooColumnSort(field: 'updatedAt', direction: VooSortDirection.ascending),
          VooColumnSort(field: 'publishedDate', direction: VooSortDirection.none),
        ];
        
        expect(sorts[0].direction, equals(VooSortDirection.descending));
        expect(sorts[1].direction, equals(VooSortDirection.ascending));
        expect(sorts[2].direction, equals(VooSortDirection.none));
      });
    });
    
    group('equality', () {
      test('should compare field values', () {
        // Arrange
        const sort1 = VooColumnSort(field: 'name', direction: VooSortDirection.ascending);
        const sort2 = VooColumnSort(field: 'email', direction: VooSortDirection.ascending);
        
        // Assert
        expect(sort1.field, isNot(equals(sort2.field)));
      });
      
      test('should compare direction values', () {
        // Arrange
        const sort1 = VooColumnSort(field: 'name', direction: VooSortDirection.ascending);
        const sort2 = VooColumnSort(field: 'name', direction: VooSortDirection.descending);
        
        // Assert
        expect(sort1.direction, isNot(equals(sort2.direction)));
      });
      
      test('should identify matching sorts', () {
        // Arrange
        const sort1 = VooColumnSort(field: 'price', direction: VooSortDirection.descending);
        const sort2 = VooColumnSort(field: 'price', direction: VooSortDirection.descending);
        
        // Assert
        expect(sort1.field, equals(sort2.field));
        expect(sort1.direction, equals(sort2.direction));
      });
    });
  });
}