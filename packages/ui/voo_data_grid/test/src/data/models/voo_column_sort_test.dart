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
    
    group('direction', () {
      test('should return asc for ascending sort', () {
        // Arrange
        const sort = VooColumnSort(
          field: 'date',
          ascending: true,
        );
        
        // Act & Assert
        expect(sort.direction, equals('asc'));
      });
      
      test('should return desc for descending sort', () {
        // Arrange
        const sort = VooColumnSort(
          field: 'date',
          ascending: false,
        );
        
        // Act & Assert
        expect(sort.direction, equals('desc'));
      });
    });
    
    group('toJson', () {
      test('should serialize ascending sort to JSON', () {
        // Arrange
        const sort = VooColumnSort(
          field: 'id',
          ascending: true,
        );
        
        // Act
        final json = sort.toJson();
        
        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['field'], equals('id'));
        expect(json['ascending'], isTrue);
        expect(json['direction'], equals('asc'));
      });
      
      test('should serialize descending sort to JSON', () {
        // Arrange
        const sort = VooColumnSort(
          field: 'createdAt',
          ascending: false,
        );
        
        // Act
        final json = sort.toJson();
        
        // Assert
        expect(json['field'], equals('createdAt'));
        expect(json['ascending'], isFalse);
        expect(json['direction'], equals('desc'));
      });
    });
    
    group('fromJson', () {
      test('should deserialize from JSON with ascending', () {
        // Arrange
        final json = {
          'field': 'username',
          'ascending': true,
        };
        
        // Act
        final sort = VooColumnSort.fromJson(json);
        
        // Assert
        expect(sort.field, equals('username'));
        expect(sort.ascending, isTrue);
      });
      
      test('should deserialize from JSON with direction', () {
        // Arrange
        final json = {
          'field': 'score',
          'direction': 'desc',
        };
        
        // Act
        final sort = VooColumnSort.fromJson(json);
        
        // Assert
        expect(sort.field, equals('score'));
        expect(sort.ascending, isFalse);
      });
      
      test('should handle both ascending and direction in JSON', () {
        // Arrange
        final json = {
          'field': 'rank',
          'ascending': false,
          'direction': 'desc', // Should prioritize ascending
        };
        
        // Act
        final sort = VooColumnSort.fromJson(json);
        
        // Assert
        expect(sort.field, equals('rank'));
        expect(sort.ascending, isFalse);
      });
      
      test('should default to ascending when neither provided', () {
        // Arrange
        final json = {
          'field': 'title',
        };
        
        // Act
        final sort = VooColumnSort.fromJson(json);
        
        // Assert
        expect(sort.field, equals('title'));
        expect(sort.ascending, isTrue);
      });
    });
    
    group('equality', () {
      test('should be equal when field and ascending match', () {
        // Arrange
        const sort1 = VooColumnSort(
          field: 'name',
          ascending: true,
        );
        const sort2 = VooColumnSort(
          field: 'name',
          ascending: true,
        );
        
        // Assert
        expect(sort1, equals(sort2));
      });
      
      test('should not be equal when field differs', () {
        // Arrange
        const sort1 = VooColumnSort(
          field: 'name',
          ascending: true,
        );
        const sort2 = VooColumnSort(
          field: 'email',
          ascending: true,
        );
        
        // Assert
        expect(sort1, isNot(equals(sort2)));
      });
      
      test('should not be equal when ascending differs', () {
        // Arrange
        const sort1 = VooColumnSort(
          field: 'price',
          ascending: true,
        );
        const sort2 = VooColumnSort(
          field: 'price',
          ascending: false,
        );
        
        // Assert
        expect(sort1, isNot(equals(sort2)));
      });
    });
    
    group('copyWith', () {
      test('should create copy with updated field', () {
        // Arrange
        const original = VooColumnSort(
          field: 'name',
          ascending: true,
        );
        
        // Act
        final copy = original.copyWith(field: 'email');
        
        // Assert
        expect(copy.field, equals('email'));
        expect(copy.ascending, isTrue);
      });
      
      test('should create copy with updated ascending', () {
        // Arrange
        const original = VooColumnSort(
          field: 'date',
          ascending: true,
        );
        
        // Act
        final copy = original.copyWith(ascending: false);
        
        // Assert
        expect(copy.field, equals('date'));
        expect(copy.ascending, isFalse);
      });
      
      test('should create copy with all parameters updated', () {
        // Arrange
        const original = VooColumnSort(
          field: 'id',
          ascending: false,
        );
        
        // Act
        final copy = original.copyWith(
          field: 'timestamp',
          ascending: true,
        );
        
        // Assert
        expect(copy.field, equals('timestamp'));
        expect(copy.ascending, isTrue);
      });
    });
    
    group('toggle', () {
      test('should toggle ascending to descending', () {
        // Arrange
        const original = VooColumnSort(
          field: 'name',
          ascending: true,
        );
        
        // Act
        final toggled = original.toggle();
        
        // Assert
        expect(toggled.field, equals('name'));
        expect(toggled.ascending, isFalse);
      });
      
      test('should toggle descending to ascending', () {
        // Arrange
        const original = VooColumnSort(
          field: 'price',
          ascending: false,
        );
        
        // Act
        final toggled = original.toggle();
        
        // Assert
        expect(toggled.field, equals('price'));
        expect(toggled.ascending, isTrue);
      });
    });
    
    group('toString', () {
      test('should return readable string for ascending', () {
        // Arrange
        const sort = VooColumnSort(
          field: 'username',
          ascending: true,
        );
        
        // Act
        final str = sort.toString();
        
        // Assert
        expect(str, contains('username'));
        expect(str, contains('asc'));
      });
      
      test('should return readable string for descending', () {
        // Arrange
        const sort = VooColumnSort(
          field: 'score',
          ascending: false,
        );
        
        // Act
        final str = sort.toString();
        
        // Assert
        expect(str, contains('score'));
        expect(str, contains('desc'));
      });
    });
  });
}