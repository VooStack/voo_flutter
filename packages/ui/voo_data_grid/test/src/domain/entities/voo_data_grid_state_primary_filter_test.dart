import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('VooDataGridState Primary Filter Tests', () {
    group('primary filter fields', () {
      test('should default to null for primaryFilterField', () {
        // Arrange & Act
        const state = VooDataGridState<Map<String, dynamic>>();
        
        // Assert
        expect(state.primaryFilterField, isNull);
      });
      
      test('should default to null for primaryFilter', () {
        // Arrange & Act
        const state = VooDataGridState<Map<String, dynamic>>();
        
        // Assert
        expect(state.primaryFilter, isNull);
      });
      
      test('should set primaryFilterField', () {
        // Arrange & Act
        const state = VooDataGridState<Map<String, dynamic>>(
          primaryFilterField: 'status',
        );
        
        // Assert
        expect(state.primaryFilterField, equals('status'));
      });
      
      test('should set primaryFilter', () {
        // Arrange & Act
        const filter = VooDataFilter(
          operator: VooFilterOperator.equals,
          value: 'active',
        );
        const state = VooDataGridState<Map<String, dynamic>>(
          primaryFilter: filter,
        );
        
        // Assert
        expect(state.primaryFilter, equals(filter));
      });
      
      test('should update primaryFilterField via copyWith', () {
        // Arrange
        const initialState = VooDataGridState<Map<String, dynamic>>();
        
        // Act
        final updatedState = initialState.copyWith(
          primaryFilterField: 'category',
        );
        
        // Assert
        expect(updatedState.primaryFilterField, equals('category'));
        expect(initialState.primaryFilterField, isNull);
      });
      
      test('should update primaryFilter via copyWith', () {
        // Arrange
        const initialState = VooDataGridState<Map<String, dynamic>>();
        const filter = VooDataFilter(
          operator: VooFilterOperator.contains,
          value: 'test',
        );
        
        // Act
        final updatedState = initialState.copyWith(
          primaryFilter: filter,
        );
        
        // Assert
        expect(updatedState.primaryFilter, equals(filter));
        expect(initialState.primaryFilter, isNull);
      });
      
      test('should preserve other state when updating primary filter fields', () {
        // Arrange
        const initialState = VooDataGridState<Map<String, dynamic>>(
          currentPage: 2,
          pageSize: 50,
          totalRows: 100,
          isLoading: true,
          filters: {
            'name': VooDataFilter(
              operator: VooFilterOperator.contains,
              value: 'John',
            ),
          },
        );
        
        const primaryFilter = VooDataFilter(
          operator: VooFilterOperator.equals,
          value: 'premium',
        );
        
        // Act
        final updatedState = initialState.copyWith(
          primaryFilterField: 'tier',
          primaryFilter: primaryFilter,
        );
        
        // Assert
        expect(updatedState.primaryFilterField, equals('tier'));
        expect(updatedState.primaryFilter, equals(primaryFilter));
        expect(updatedState.currentPage, equals(2));
        expect(updatedState.pageSize, equals(50));
        expect(updatedState.totalRows, equals(100));
        expect(updatedState.isLoading, isTrue);
        expect(updatedState.filters, equals(initialState.filters));
      });
      
      test('should handle both primary and regular filters independently', () {
        // Arrange
        const regularFilter = VooDataFilter(
          operator: VooFilterOperator.contains,
          value: 'test',
        );
        const primaryFilter = VooDataFilter(
          operator: VooFilterOperator.equals,
          value: 'active',
        );
        
        // Act
        const state = VooDataGridState<Map<String, dynamic>>(
          filters: {
            'name': regularFilter,
          },
          primaryFilterField: 'status',
          primaryFilter: primaryFilter,
        );
        
        // Assert
        expect(state.filters['name'], equals(regularFilter));
        expect(state.primaryFilterField, equals('status'));
        expect(state.primaryFilter, equals(primaryFilter));
      });
      
      test('should clear primary filter via copyWith', () {
        // Arrange
        const filter = VooDataFilter(
          operator: VooFilterOperator.equals,
          value: 'active',
        );
        const initialState = VooDataGridState<Map<String, dynamic>>(
          primaryFilterField: 'status',
          primaryFilter: filter,
        );
        
        // Act
        final clearedState = initialState.copyWith(
          primaryFilterField: null,
          primaryFilter: null,
        );
        
        // Assert
        expect(clearedState.primaryFilterField, isNull);
        expect(clearedState.primaryFilter, isNull);
      });
      
      test('should maintain primary filter when regular filters change', () {
        // Arrange
        const primaryFilter = VooDataFilter(
          operator: VooFilterOperator.equals,
          value: 'premium',
        );
        const initialState = VooDataGridState<Map<String, dynamic>>(
          primaryFilterField: 'tier',
          primaryFilter: primaryFilter,
        );
        
        // Act
        final updatedState = initialState.copyWith(
          filters: {
            'name': const VooDataFilter(
              operator: VooFilterOperator.contains,
              value: 'test',
            ),
          },
        );
        
        // Assert
        expect(updatedState.primaryFilterField, equals('tier'));
        expect(updatedState.primaryFilter, equals(primaryFilter));
        expect(updatedState.filters.length, equals(1));
      });
    });
    
    group('primary filter integration', () {
      test('should handle primary filter in combined mode', () {
        // Arrange
        const primaryFilter = VooDataFilter(
          operator: VooFilterOperator.equals,
          value: 'active',
        );
        
        // Act - Simulating combined mode where primary filter is also added to regular filters
        const state = VooDataGridState<Map<String, dynamic>>(
          filters: {
            'status': primaryFilter, // Primary filter added to regular filters
            'name': VooDataFilter(
              operator: VooFilterOperator.contains,
              value: 'test',
            ),
          },
          primaryFilterField: 'status',
          primaryFilter: primaryFilter,
        );
        
        // Assert
        expect(state.filters['status'], equals(primaryFilter));
        expect(state.primaryFilter, equals(primaryFilter));
        expect(state.filters.length, equals(2));
      });
      
      test('should handle primary filter in separate mode', () {
        // Arrange
        const primaryFilter = VooDataFilter(
          operator: VooFilterOperator.equals,
          value: 'active',
        );
        
        // Act - Simulating separate mode where primary filter is NOT in regular filters
        const state = VooDataGridState<Map<String, dynamic>>(
          filters: {
            'name': VooDataFilter(
              operator: VooFilterOperator.contains,
              value: 'test',
            ),
          },
          primaryFilterField: 'status',
          primaryFilter: primaryFilter,
        );
        
        // Assert
        expect(state.filters.containsKey('status'), isFalse);
        expect(state.primaryFilter, equals(primaryFilter));
        expect(state.filters.length, equals(1));
      });
      
      test('should prevent duplication when same field is updated', () {
        // Arrange
        const oldFilter = VooDataFilter(
          operator: VooFilterOperator.equals,
          value: 'inactive',
        );
        const newFilter = VooDataFilter(
          operator: VooFilterOperator.equals,
          value: 'active',
        );
        
        const initialState = VooDataGridState<Map<String, dynamic>>(
          filters: {
            'status': oldFilter,
          },
          primaryFilterField: 'status',
          primaryFilter: oldFilter,
        );
        
        // Act - Update with new filter for same field
        final updatedState = initialState.copyWith(
          filters: {
            'status': newFilter, // Map automatically replaces old value
          },
          primaryFilter: newFilter,
        );
        
        // Assert - No duplication, just replacement
        expect(updatedState.filters.length, equals(1));
        expect(updatedState.filters['status'], equals(newFilter));
        expect(updatedState.primaryFilter, equals(newFilter));
      });
    });
  });
}