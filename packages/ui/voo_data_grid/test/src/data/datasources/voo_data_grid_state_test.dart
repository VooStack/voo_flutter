import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('VooDataGridState copyWith Tests', () {
    test('copyWith should preserve error when not specified', () {
      const initialState = VooDataGridState<String>(
        error: 'Initial error',
      );

      final newState = initialState.copyWith(isLoading: true);

      expect(newState.error, equals('Initial error'));
      expect(newState.isLoading, isTrue);
    });

    test('copyWith should clear error when explicitly set to null', () {
      const initialState = VooDataGridState<String>(
        error: 'Initial error',
      );

      final newState = initialState.copyWith(error: null);

      expect(newState.error, isNull);
    });

    test('copyWith should set new error value', () {
      const initialState = VooDataGridState<String>();

      final newState = initialState.copyWith(error: 'New error');

      expect(newState.error, equals('New error'));
    });

    test('clearError should remove error', () {
      const initialState = VooDataGridState<String>(
        error: 'Some error',
        isLoading: true,
      );

      final newState = initialState.clearError();

      expect(newState.error, isNull);
      expect(newState.isLoading, isTrue); // Other fields preserved
    });

    test('clearError on state without error should work', () {
      const initialState = VooDataGridState<String>();

      final newState = initialState.clearError();

      expect(newState.error, isNull);
    });

    test('copyWith should handle primaryFilterField correctly', () {
      const initialState = VooDataGridState<String>(
        primaryFilterField: 'status',
      );

      // Not specifying should keep current value
      final state1 = initialState.copyWith(isLoading: true);
      expect(state1.primaryFilterField, equals('status'));

      // Explicitly setting to null should clear it
      final state2 = initialState.copyWith(primaryFilterField: null);
      expect(state2.primaryFilterField, isNull);

      // Setting new value should work
      final state3 = initialState.copyWith(primaryFilterField: 'category');
      expect(state3.primaryFilterField, equals('category'));
    });

    test('copyWith should handle primaryFilter correctly', () {
      const initialFilter = VooDataFilter(
        operator: VooFilterOperator.equals,
        value: 'active',
      );

      const initialState = VooDataGridState<String>(
        primaryFilter: initialFilter,
      );

      // Not specifying should keep current value
      final state1 = initialState.copyWith(isLoading: true);
      expect(state1.primaryFilter, equals(initialFilter));

      // Explicitly setting to null should clear it
      final state2 = initialState.copyWith(primaryFilter: null);
      expect(state2.primaryFilter, isNull);

      // Setting new value should work
      const newFilter = VooDataFilter(
        operator: VooFilterOperator.equals,
        value: 'inactive',
      );
      final state3 = initialState.copyWith(primaryFilter: newFilter);
      expect(state3.primaryFilter, equals(newFilter));
    });

    test('copyWith should handle multiple changes at once', () {
      const initialState = VooDataGridState<String>(
        error: 'Error message',
        isLoading: true,
        currentPage: 0,
      );

      final newState = initialState.copyWith(
        error: null,
        isLoading: false,
        currentPage: 1,
      );

      expect(newState.error, isNull);
      expect(newState.isLoading, isFalse);
      expect(newState.currentPage, equals(1));
    });
  });

  group('VooDataGridState with BLoC pattern', () {
    test('typical error handling flow', () {
      // Initial state
      const initialState = VooDataGridState<String>();
      expect(initialState.error, isNull);
      expect(initialState.isLoading, isFalse);

      // Start loading
      final loadingState = initialState.copyWith(isLoading: true);
      expect(loadingState.isLoading, isTrue);
      expect(loadingState.error, isNull);

      // Error occurs
      final errorState = loadingState.copyWith(
        isLoading: false,
        error: 'Network error',
      );
      expect(errorState.isLoading, isFalse);
      expect(errorState.error, equals('Network error'));

      // Retry - clear error and start loading
      final retryState = errorState.clearError().copyWith(isLoading: true);
      expect(retryState.error, isNull);
      expect(retryState.isLoading, isTrue);

      // Success
      final successState = retryState.copyWith(
        isLoading: false,
        rows: ['item1', 'item2'],
        totalRows: 2,
      );
      expect(successState.error, isNull);
      expect(successState.isLoading, isFalse);
      expect(successState.rows, equals(['item1', 'item2']));
    });
  });
}
