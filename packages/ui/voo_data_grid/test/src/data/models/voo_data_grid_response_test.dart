import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('VooDataGridResponse', () {
    group('constructor', () {
      test('should create instance with required parameters', () {
        // Arrange
        final rows = [
          {'id': 1, 'name': 'Item 1'},
          {'id': 2, 'name': 'Item 2'},
        ];
        const totalRows = 100;
        const page = 1;
        const pageSize = 10;
        
        // Act
        final response = VooDataGridResponse(
          rows: rows,
          totalRows: totalRows,
          page: page,
          pageSize: pageSize,
        );
        
        // Assert
        expect(response.rows, equals(rows));
        expect(response.totalRows, equals(totalRows));
        expect(response.page, equals(page));
        expect(response.pageSize, equals(pageSize));
      });
      
      test('should create instance with empty rows', () {
        // Arrange & Act
        const response = VooDataGridResponse(
          rows: [],
          totalRows: 0,
          page: 1,
          pageSize: 10,
        );
        
        // Assert
        expect(response.rows, isEmpty);
        expect(response.totalRows, equals(0));
        expect(response.page, equals(1));
        expect(response.pageSize, equals(10));
      });
      
      test('should handle large datasets', () {
        // Arrange
        final rows = List.generate(1000, (i) => {'id': i});
        
        // Act
        final response = VooDataGridResponse(
          rows: rows,
          totalRows: 10000,
          page: 5,
          pageSize: 1000,
        );
        
        // Assert
        expect(response.rows.length, equals(1000));
        expect(response.totalRows, equals(10000));
        expect(response.page, equals(5));
        expect(response.pageSize, equals(1000));
      });
    });
    
    group('totalPages', () {
      test('should calculate total pages correctly', () {
        // Arrange & Act
        const response = VooDataGridResponse(
          rows: [],
          totalRows: 95,
          page: 1,
          pageSize: 10,
        );
        
        // Assert
        expect(response.totalPages, equals(10)); // ceil(95/10) = 10
      });
      
      test('should return 0 when totalRows is 0', () {
        // Arrange & Act
        const response = VooDataGridResponse(
          rows: [],
          totalRows: 0,
          page: 1,
          pageSize: 10,
        );
        
        // Assert
        expect(response.totalPages, equals(0));
      });
      
      test('should handle exact page boundaries', () {
        // Arrange & Act
        const response = VooDataGridResponse(
          rows: [],
          totalRows: 100,
          page: 1,
          pageSize: 10,
        );
        
        // Assert
        expect(response.totalPages, equals(10));
      });
      
      test('should handle single item', () {
        // Arrange & Act
        const response = VooDataGridResponse(
          rows: [{'id': 1}],
          totalRows: 1,
          page: 1,
          pageSize: 10,
        );
        
        // Assert
        expect(response.totalPages, equals(1));
      });
    });
    
    group('hasNextPage', () {
      test('should return true when more pages exist', () {
        // Arrange & Act
        const response = VooDataGridResponse(
          rows: [],
          totalRows: 100,
          page: 5,
          pageSize: 10,
        );
        
        // Assert
        expect(response.hasNextPage, isTrue);
      });
      
      test('should return false on last page', () {
        // Arrange & Act
        const response = VooDataGridResponse(
          rows: [],
          totalRows: 100,
          page: 10,
          pageSize: 10,
        );
        
        // Assert
        expect(response.hasNextPage, isFalse);
      });
      
      test('should return false when no data', () {
        // Arrange & Act
        const response = VooDataGridResponse(
          rows: [],
          totalRows: 0,
          page: 1,
          pageSize: 10,
        );
        
        // Assert
        expect(response.hasNextPage, isFalse);
      });
    });
    
    group('hasPreviousPage', () {
      test('should return true when not on first page', () {
        // Arrange & Act
        const response = VooDataGridResponse(
          rows: [],
          totalRows: 100,
          page: 5,
          pageSize: 10,
        );
        
        // Assert
        expect(response.hasPreviousPage, isTrue);
      });
      
      test('should return true when page is greater than 0', () {
        // Arrange & Act
        const response = VooDataGridResponse(
          rows: [],
          totalRows: 100,
          page: 1,
          pageSize: 10,
        );
        
        // Assert
        expect(response.hasPreviousPage, isTrue);
      });
      
      test('should return false when page is 0', () {
        // Arrange & Act
        const response = VooDataGridResponse(
          rows: [],
          totalRows: 100,
          page: 0,
          pageSize: 10,
        );
        
        // Assert
        expect(response.hasPreviousPage, isFalse);
      });
    });
    
    group('isEmpty', () {
      test('should return true when rows is empty', () {
        // Arrange & Act
        const response = VooDataGridResponse(
          rows: [],
          totalRows: 0,
          page: 1,
          pageSize: 10,
        );
        
        // Assert
        expect(response.isEmpty, isTrue);
      });
      
      test('should return false when rows exist', () {
        // Arrange & Act
        const response = VooDataGridResponse(
          rows: [{'id': 1}],
          totalRows: 1,
          page: 1,
          pageSize: 10,
        );
        
        // Assert
        expect(response.isEmpty, isFalse);
      });
    });
    
    group('isNotEmpty', () {
      test('should return true when rows exist', () {
        // Arrange & Act
        const response = VooDataGridResponse(
          rows: [{'id': 1}, {'id': 2}],
          totalRows: 2,
          page: 1,
          pageSize: 10,
        );
        
        // Assert
        expect(response.isNotEmpty, isTrue);
      });
      
      test('should return false when rows is empty', () {
        // Arrange & Act
        const response = VooDataGridResponse(
          rows: [],
          totalRows: 0,
          page: 1,
          pageSize: 10,
        );
        
        // Assert
        expect(response.isNotEmpty, isFalse);
      });
    });
    
    group('copyWith', () {
      test('should create copy with updated rows', () {
        // Arrange
        const original = VooDataGridResponse(
          rows: [{'id': 1}],
          totalRows: 10,
          page: 1,
          pageSize: 10,
        );
        final newRows = [{'id': 2}, {'id': 3}];
        
        // Act
        final copy = original.copyWith(rows: newRows);
        
        // Assert
        expect(copy.rows, equals(newRows));
        expect(copy.totalRows, equals(10));
        expect(copy.page, equals(1));
        expect(copy.pageSize, equals(10));
      });
      
      test('should create copy with updated totalRows', () {
        // Arrange
        const original = VooDataGridResponse(
          rows: [],
          totalRows: 10,
          page: 1,
          pageSize: 10,
        );
        
        // Act
        final copy = original.copyWith(totalRows: 50);
        
        // Assert
        expect(copy.rows, isEmpty);
        expect(copy.totalRows, equals(50));
        expect(copy.page, equals(1));
        expect(copy.pageSize, equals(10));
      });
      
      test('should create copy with all parameters updated', () {
        // Arrange
        const original = VooDataGridResponse(
          rows: [{'id': 1}],
          totalRows: 10,
          page: 1,
          pageSize: 10,
        );
        
        // Act
        final copy = original.copyWith(
          rows: [{'id': 2}, {'id': 3}],
          totalRows: 100,
          page: 5,
          pageSize: 20,
        );
        
        // Assert
        expect(copy.rows.length, equals(2));
        expect(copy.totalRows, equals(100));
        expect(copy.page, equals(5));
        expect(copy.pageSize, equals(20));
      });
    });
  });
}