import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('VooDataGridState', () {
    group('loading state', () {
      test('should default to false for isLoading', () {
        // Arrange & Act
        const state = VooDataGridState<Map<String, dynamic>>();
        
        // Assert
        expect(state.isLoading, isFalse);
      });
      
      test('should set isLoading to true', () {
        // Arrange & Act
        const state = VooDataGridState<Map<String, dynamic>>(
          isLoading: true,
        );
        
        // Assert
        expect(state.isLoading, isTrue);
      });
    });
    
    group('error handling', () {
      test('should default to null error', () {
        // Arrange & Act
        const state = VooDataGridState<Map<String, dynamic>>();
        
        // Assert
        expect(state.error, isNull);
      });
      
      test('should set error message', () {
        // Arrange & Act
        const state = VooDataGridState<Map<String, dynamic>>(
          error: 'Something went wrong',
        );
        
        // Assert
        expect(state.error, equals('Something went wrong'));
      });
      
      test('should clear error via copyWith', () {
        // Arrange
        const initialState = VooDataGridState<Map<String, dynamic>>(
          error: 'Previous error',
        );
        
        // Act
        final updatedState = initialState.copyWith(error: null);
        
        // Assert
        expect(updatedState.error, isNull);
      });
    });
    
    group('pagination', () {
      test('should calculate totalPages correctly', () {
        // Arrange & Act
        const state = VooDataGridState<Map<String, dynamic>>(
          totalRows: 100,
        );
        
        // Assert
        expect(state.totalPages, equals(5));
      });
      
      test('should handle zero pageSize', () {
        // Arrange & Act
        const state = VooDataGridState<Map<String, dynamic>>(
          totalRows: 100,
          pageSize: 0,
        );
        
        // Assert - Should not throw and return 0
        expect(state.totalPages, equals(0));
      });
      
      test('should round up for partial pages', () {
        // Arrange & Act
        const state = VooDataGridState<Map<String, dynamic>>(
          totalRows: 95,
        );
        
        // Assert
        expect(state.totalPages, equals(5)); // ceil(95/20) = 5
      });
    });
    
    group('selection', () {
      test('should default to empty selectedRows', () {
        // Arrange & Act
        const state = VooDataGridState<Map<String, dynamic>>();
        
        // Assert
        expect(state.selectedRows, isEmpty);
      });
      
      test('should default to none selection mode', () {
        // Arrange & Act
        const state = VooDataGridState<Map<String, dynamic>>();
        
        // Assert
        expect(state.selectionMode, equals(VooSelectionMode.none));
      });
      
      test('should update selectedRows via copyWith', () {
        // Arrange
        const initialState = VooDataGridState<Map<String, dynamic>>();
        final selectedRows = {
          {'id': 1, 'name': 'Item 1'},
          {'id': 2, 'name': 'Item 2'},
        };
        
        // Act
        final updatedState = initialState.copyWith(
          selectedRows: selectedRows,
        );
        
        // Assert
        expect(updatedState.selectedRows, equals(selectedRows));
        expect(initialState.selectedRows, isEmpty);
      });
    });
    
    group('filters', () {
      test('should default to empty filters', () {
        // Arrange & Act
        const state = VooDataGridState<Map<String, dynamic>>();
        
        // Assert
        expect(state.filters, isEmpty);
      });
      
      test('should default to filtersVisible false', () {
        // Arrange & Act
        const state = VooDataGridState<Map<String, dynamic>>();
        
        // Assert
        expect(state.filtersVisible, isFalse);
      });
      
      test('should update filters via copyWith', () {
        // Arrange
        const initialState = VooDataGridState<Map<String, dynamic>>();
        final filters = {
          'name': const VooDataFilter(
            operator: VooFilterOperator.contains,
            value: 'test',
          ),
        };
        
        // Act
        final updatedState = initialState.copyWith(filters: filters);
        
        // Assert
        expect(updatedState.filters, equals(filters));
        expect(initialState.filters, isEmpty);
      });
    });
    
    group('sorts', () {
      test('should default to empty sorts', () {
        // Arrange & Act
        const state = VooDataGridState<Map<String, dynamic>>();
        
        // Assert
        expect(state.sorts, isEmpty);
      });
      
      test('should update sorts via copyWith', () {
        // Arrange
        const initialState = VooDataGridState<Map<String, dynamic>>();
        const sorts = [
          VooColumnSort(
            field: 'name',
            direction: VooSortDirection.ascending,
          ),
        ];
        
        // Act
        final updatedState = initialState.copyWith(sorts: sorts);
        
        // Assert
        expect(updatedState.sorts, equals(sorts));
        expect(initialState.sorts, isEmpty);
      });
    });
    
    group('mode', () {
      test('should default to remote mode', () {
        // Arrange & Act
        const state = VooDataGridState<Map<String, dynamic>>();
        
        // Assert
        expect(state.mode, equals(VooDataGridMode.remote));
      });
      
      test('should support local mode', () {
        // Arrange & Act
        const state = VooDataGridState<Map<String, dynamic>>(
          mode: VooDataGridMode.local,
        );
        
        // Assert
        expect(state.mode, equals(VooDataGridMode.local));
      });
      
      test('should support mixed mode', () {
        // Arrange & Act
        const state = VooDataGridState<Map<String, dynamic>>(
          mode: VooDataGridMode.mixed,
        );
        
        // Assert
        expect(state.mode, equals(VooDataGridMode.mixed));
      });
    });
    
    group('data', () {
      test('should default to empty rows', () {
        // Arrange & Act
        const state = VooDataGridState<Map<String, dynamic>>();
        
        // Assert
        expect(state.rows, isEmpty);
        expect(state.allRows, isEmpty);
      });
      
      test('should set rows', () {
        // Arrange
        final rows = [
          {'id': 1, 'name': 'Item 1'},
          {'id': 2, 'name': 'Item 2'},
        ];
        
        // Act
        final state = VooDataGridState<Map<String, dynamic>>(
          rows: rows,
        );
        
        // Assert
        expect(state.rows, equals(rows));
      });
      
      test('should set allRows for local mode', () {
        // Arrange
        final allRows = [
          {'id': 1, 'name': 'Item 1'},
          {'id': 2, 'name': 'Item 2'},
          {'id': 3, 'name': 'Item 3'},
        ];
        
        // Act
        final state = VooDataGridState<Map<String, dynamic>>(
          mode: VooDataGridMode.local,
          allRows: allRows,
        );
        
        // Assert
        expect(state.allRows, equals(allRows));
      });
    });
  });
}