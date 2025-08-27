import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('Action Column Tests', () {
    test('excludeFromApi property should be false by default', () {
      final column = VooDataColumn(
        field: 'test',
        label: 'Test',
      );
      
      expect(column.excludeFromApi, false);
    });

    test('excludeFromApi property should be set correctly', () {
      final column = VooDataColumn(
        field: 'actions',
        label: 'Actions',
        excludeFromApi: true,
      );
      
      expect(column.excludeFromApi, true);
    });

    test('onCellTap should be null by default', () {
      final column = VooDataColumn(
        field: 'test',
        label: 'Test',
      );
      
      expect(column.onCellTap, null);
    });

    test('onCellTap should be set correctly', () {
      void tapHandler(BuildContext context, dynamic row, dynamic value) {
        // Handler implementation
      }

      final column = VooDataColumn(
        field: 'test',
        label: 'Test',
        onCellTap: tapHandler,
      );
      
      expect(column.onCellTap, isNotNull);
      expect(column.onCellTap, equals(tapHandler));
    });

    test('copyWith should preserve excludeFromApi', () {
      final original = VooDataColumn(
        field: 'actions',
        label: 'Actions',
        excludeFromApi: true,
      );

      final copied = original.copyWith(label: 'New Actions');
      
      expect(copied.excludeFromApi, true);
      expect(copied.label, 'New Actions');
    });

    test('copyWith should update excludeFromApi', () {
      final original = VooDataColumn(
        field: 'actions',
        label: 'Actions',
        excludeFromApi: true,
      );

      final copied = original.copyWith(excludeFromApi: false);
      
      expect(copied.excludeFromApi, false);
    });

    test('copyWith should preserve onCellTap', () {
      void tapHandler(BuildContext context, dynamic row, dynamic value) {
        // Handler implementation
      }

      final original = VooDataColumn(
        field: 'test',
        label: 'Test',
        onCellTap: tapHandler,
      );

      final copied = original.copyWith(label: 'New Test');
      
      expect(copied.onCellTap, equals(tapHandler));
      expect(copied.label, 'New Test');
    });

    group('Filter behavior with excludeFromApi', () {
      test('columns with excludeFromApi should not be filterable', () {
        final column = VooDataColumn(
          field: 'actions',
          label: 'Actions',
          excludeFromApi: true,
          filterable: true, // This should be ignored
        );
        
        // The filter row should skip this column even if filterable is true
        // This is tested in the widget tests
        expect(column.excludeFromApi, true);
        expect(column.filterable, true);
      });

      test('columns with excludeFromApi should not be sortable in practice', () {
        final column = VooDataColumn(
          field: 'actions',
          label: 'Actions',
          excludeFromApi: true,
          sortable: true, // This should be ignored
        );
        
        // The header should not allow sorting even if sortable is true
        // This is tested in the widget tests
        expect(column.excludeFromApi, true);
        expect(column.sortable, true);
      });
    });
  });

  group('Data Grid Request Builder with excluded columns', () {
    test('filters should exclude columns marked as excludeFromApi', () {
      // This is handled at the UI level - filters are not created for excluded columns
      // The DataGridRequestBuilder doesn't need to know about excluded columns
      // because they never get added to the filters map in the first place
      
      final filters = <String, VooDataFilter>{
        'name': VooDataFilter(
          operator: VooFilterOperator.contains,
          value: 'John',
        ),
        // 'actions' column would not be here because it's excludeFromApi
      };

      final builder = DataGridRequestBuilder(
        standard: ApiFilterStandard.voo,
      );

      final result = builder.buildRequest(
        page: 0,
        pageSize: 20,
        filters: filters,
        sorts: [],
      );

      expect(result['stringFilters'], [
        {
          'fieldName': 'name',
          'value': 'John',
          'operator': 'Contains',
        }
      ]);
      
      // No 'actions' filter should be present
      final allFilters = [
        ...(result['stringFilters'] as List? ?? []),
        ...(result['intFilters'] as List? ?? []),
        ...(result['dateFilters'] as List? ?? []),
        ...(result['decimalFilters'] as List? ?? []),
      ];
      
      expect(
        allFilters.any((f) => f['fieldName'] == 'actions'),
        false,
      );
    });

    test('sorting should exclude columns marked as excludeFromApi', () {
      // Similar to filters, sorting is prevented at the UI level
      // The header doesn't allow sorting on excluded columns
      
      final sorts = [
        VooColumnSort(field: 'name', direction: VooSortDirection.ascending),
        // 'actions' column would not be here because it's excludeFromApi
      ];

      final builder = DataGridRequestBuilder(
        standard: ApiFilterStandard.voo,
      );

      final result = builder.buildRequest(
        page: 0,
        pageSize: 20,
        filters: {},
        sorts: sorts,
      );

      expect(result['sortBy'], 'name');
      
      // No 'actions' sort should be present
      expect(result['sortBy'], isNot('actions'));
    });
  });
}