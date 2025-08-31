import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('VooDataGridResponse', () {
    group('constructor', () {
      test('should create instance with Map data', () {
        // Arrange
        final rows = [
          {'id': 1, 'name': 'Item 1'},
          {'id': 2, 'name': 'Item 2'},
        ];
        const totalRows = 100;
        const page = 1;
        const pageSize = 10;
        
        // Act
        final response = VooDataGridResponse<Map<String, dynamic>>(
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
      
      test('should create instance with typed data', () {
        // Arrange
        final rows = [
          TestData(id: 1, name: 'Item 1'),
          TestData(id: 2, name: 'Item 2'),
        ];
        
        // Act
        final response = VooDataGridResponse<TestData>(
          rows: rows,
          totalRows: 50,
          page: 0,
          pageSize: 20,
        );
        
        // Assert
        expect(response.rows, equals(rows));
        expect(response.totalRows, equals(50));
        expect(response.page, equals(0));
        expect(response.pageSize, equals(20));
      });
      
      test('should create instance with empty rows', () {
        // Arrange & Act
        final response = VooDataGridResponse<Map<String, dynamic>>(
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
        final response = VooDataGridResponse<Map<String, dynamic>>(
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
    
    group('different generic types', () {
      test('should work with List type', () {
        // Arrange
        final rows = [
          [1, 'Item 1', 10.99],
          [2, 'Item 2', 20.99],
        ];
        
        // Act
        final response = VooDataGridResponse<List>(
          rows: rows,
          totalRows: 2,
          page: 0,
          pageSize: 10,
        );
        
        // Assert
        expect(response.rows, equals(rows));
        expect(response.rows.first[0], equals(1));
        expect(response.rows.first[1], equals('Item 1'));
      });
      
      test('should work with String type', () {
        // Arrange
        final rows = ['Row 1', 'Row 2', 'Row 3'];
        
        // Act
        final response = VooDataGridResponse<String>(
          rows: rows,
          totalRows: 3,
          page: 0,
          pageSize: 10,
        );
        
        // Assert
        expect(response.rows, equals(rows));
        expect(response.rows.first, equals('Row 1'));
      });
      
      test('should work with dynamic type', () {
        // Arrange
        final rows = <dynamic>[
          {'id': 1},
          'String row',
          123,
          true,
        ];
        
        // Act
        final response = VooDataGridResponse<dynamic>(
          rows: rows,
          totalRows: 4,
          page: 0,
          pageSize: 10,
        );
        
        // Assert
        expect(response.rows.length, equals(4));
        expect(response.rows[0], isA<Map>());
        expect(response.rows[1], isA<String>());
        expect(response.rows[2], isA<int>());
        expect(response.rows[3], isA<bool>());
      });
    });
    
    group('pagination scenarios', () {
      test('should handle first page', () {
        // Arrange & Act
        final response = VooDataGridResponse<Map<String, dynamic>>(
          rows: List.generate(10, (i) => {'id': i}),
          totalRows: 100,
          page: 0,
          pageSize: 10,
        );
        
        // Assert
        expect(response.page, equals(0));
        expect(response.rows.length, equals(10));
      });
      
      test('should handle middle page', () {
        // Arrange & Act
        final response = VooDataGridResponse<Map<String, dynamic>>(
          rows: List.generate(10, (i) => {'id': i + 50}),
          totalRows: 100,
          page: 5,
          pageSize: 10,
        );
        
        // Assert
        expect(response.page, equals(5));
        expect(response.rows.length, equals(10));
      });
      
      test('should handle last page with partial results', () {
        // Arrange & Act
        final response = VooDataGridResponse<Map<String, dynamic>>(
          rows: List.generate(5, (i) => {'id': i + 95}),
          totalRows: 95,
          page: 9,
          pageSize: 10,
        );
        
        // Assert
        expect(response.page, equals(9));
        expect(response.rows.length, equals(5));
      });
      
      test('should handle single page of results', () {
        // Arrange & Act
        final response = VooDataGridResponse<Map<String, dynamic>>(
          rows: List.generate(3, (i) => {'id': i}),
          totalRows: 3,
          page: 0,
          pageSize: 10,
        );
        
        // Assert
        expect(response.page, equals(0));
        expect(response.rows.length, equals(3));
        expect(response.totalRows, equals(3));
      });
    });
  });
}

// Test data class
class TestData {
  final int id;
  final String name;
  
  TestData({required this.id, required this.name});
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;
  
  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}