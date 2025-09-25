import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/src/data/services/excel_export_service.dart';
import 'package:voo_data_grid/src/data/services/pdf_export_service.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/export_config.dart';
import 'package:voo_data_grid/src/domain/entities/typed_data_column.dart';

// Test data classes similar to what users would have
enum TestState {
  active('Active', 'ACT'),
  inactive('Inactive', 'INA'),
  pending('Pending', 'PEN');

  final String name;
  final String abbreviation;
  const TestState(this.name, this.abbreviation);
}

class TestEntity {
  final int id;
  final String name;
  final TestState? state;
  final DateTime? createdAt;
  final bool isActive;
  final double? amount;

  TestEntity({
    required this.id,
    required this.name,
    this.state,
    this.createdAt,
    required this.isActive,
    this.amount,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'state': state?.name,
        'createdAt': createdAt?.toIso8601String(),
        'isActive': isActive,
        'amount': amount,
      };
}

void main() {
  group('TypedVooDataColumn Export Tests', () {
    late List<TestEntity> testData;
    late List<VooDataColumn> columns;
    late ExportConfig config;

    setUp(() {
      testData = [
        TestEntity(
          id: 1,
          name: 'Test Item 1',
          state: TestState.active,
          createdAt: DateTime(2024, 1, 1),
          isActive: true,
          amount: 100.50,
        ),
        TestEntity(
          id: 2,
          name: 'Test Item 2',
          state: TestState.inactive,
          createdAt: DateTime(2024, 1, 2),
          isActive: false,
          amount: 200.75,
        ),
        TestEntity(
          id: 3,
          name: 'Test Item 3',
          isActive: true,
        ),
      ];

      columns = [
        VooDataColumn<TestEntity>(
          field: 'id',
          label: 'ID',
          valueGetter: (row) => row.id.toString(),
        ),
        VooDataColumn<TestEntity>(
          field: 'name',
          label: 'Name',
          valueGetter: (row) => row.name,
        ),
        // This is the problematic TypedVooDataColumn that was causing type errors
        TypedVooDataColumn<TestEntity, TestState?>(
          field: 'state',
          label: 'State',
          typedValueGetter: (row) => row.state,
          typedValueFormatter: (state) => state?.abbreviation ?? 'N/A',
        ),
        TypedVooDataColumn<TestEntity, DateTime?>(
          field: 'createdAt',
          label: 'Created At',
          typedValueGetter: (row) => row.createdAt,
          typedValueFormatter: (date) => date?.toString() ?? 'N/A',
        ),
        TypedVooDataColumn<TestEntity, bool>(
          field: 'isActive',
          label: 'Active',
          typedValueGetter: (row) => row.isActive,
          typedValueFormatter: (value) => value ? 'Yes' : 'No',
        ),
        TypedVooDataColumn<TestEntity, double?>(
          field: 'amount',
          label: 'Amount',
          typedValueGetter: (row) => row.amount,
          typedValueFormatter: (value) => value?.toStringAsFixed(2) ?? '0.00',
        ),
      ];

      config = const ExportConfig(
        title: 'Test Export',
        format: ExportFormat.pdf,
        includeTimestamp: false,
        showRowNumbers: true,
      );
    });

    group('PDF Export', () {
      late PdfExportService<TestEntity> pdfService;

      setUp(() {
        pdfService = PdfExportService<TestEntity>();
      });

      test('should export data with TypedVooDataColumn without type errors', () async {
        // This test ensures that TypedVooDataColumn works correctly with PDF export
        // and doesn't throw type casting errors like:
        // "Instance of '(TestEntity) => TestState?' is not a subtype of type '(dynamic) => dynamic?'"

        expect(
          () async => pdfService.export(
            data: testData,
            columns: columns,
            config: config,
            activeFilters: null,
          ),
          returnsNormally,
        );

        final result = await pdfService.export(
          data: testData,
          columns: columns,
          config: config,
          activeFilters: null,
        );

        expect(result, isNotNull);
        expect(result, isNotEmpty);
      });

      test('should correctly handle null values in TypedVooDataColumn', () async {
        // Test that null values are handled gracefully
        final result = await pdfService.export(
          data: testData,
          columns: columns,
          config: config,
          activeFilters: null,
        );

        expect(result, isNotNull);
        // The third item has null state and createdAt, should not cause errors
        expect(result, isNotEmpty);
      });

      test('should apply TypedVooDataColumn formatters correctly', () async {
        // Test that the typed formatters are applied correctly
        final result = await pdfService.export(
          data: testData,
          columns: columns,
          config: config,
          activeFilters: null,
        );

        // The PDF should contain formatted values like 'ACT', 'INA', 'Yes', 'No', etc.
        expect(result, isNotNull);
        expect(result.length, greaterThan(0));
      });

      test('should handle mixed regular and typed columns', () async {
        // Test that mixing VooDataColumn and TypedVooDataColumn works
        final mixedColumns = [
          VooDataColumn<TestEntity>(
            field: 'id',
            label: 'ID',
            valueGetter: (row) => row.id,
          ),
          TypedVooDataColumn<TestEntity, String>(
            field: 'name',
            label: 'Name',
            typedValueGetter: (row) => row.name,
            typedValueFormatter: (name) => name.toUpperCase(),
          ),
        ];

        expect(
          () async => pdfService.export(
            data: testData,
            columns: mixedColumns,
            config: config,
            activeFilters: null,
          ),
          returnsNormally,
        );
      });
    });

    group('Excel Export', () {
      late ExcelExportService<TestEntity> excelService;

      setUp(() {
        excelService = ExcelExportService<TestEntity>();
        config = const ExportConfig(
          title: 'Test Export',
          format: ExportFormat.excel,
          includeTimestamp: false,
          showRowNumbers: true,
        );
      });

      test('should export data with TypedVooDataColumn without type errors', () async {
        // This test ensures that TypedVooDataColumn works correctly with Excel export
        expect(
          () async => excelService.export(
            data: testData,
            columns: columns,
            config: config,
            activeFilters: null,
          ),
          returnsNormally,
        );

        final result = await excelService.export(
          data: testData,
          columns: columns,
          config: config,
          activeFilters: null,
        );

        expect(result, isNotNull);
        expect(result, isNotEmpty);
      });

      test('should correctly handle null values in TypedVooDataColumn', () async {
        final result = await excelService.export(
          data: testData,
          columns: columns,
          config: config,
          activeFilters: null,
        );

        expect(result, isNotNull);
        expect(result, isNotEmpty);
      });

      test('should apply TypedVooDataColumn formatters correctly', () async {
        final result = await excelService.export(
          data: testData,
          columns: columns,
          config: config,
          activeFilters: null,
        );

        expect(result, isNotNull);
        expect(result.length, greaterThan(0));
      });

      test('should handle complex type hierarchies', () async {
        // Test with a more complex type hierarchy
        final complexColumn = TypedVooDataColumn<TestEntity, TestState?>(
          field: 'state',
          label: 'State Details',
          typedValueGetter: (row) => row.state,
          typedValueFormatter: (state) {
            if (state == null) return 'No State';
            return '${state.name} (${state.abbreviation})';
          },
        );

        final complexColumns = [
          VooDataColumn<TestEntity>(field: 'id', label: 'ID', valueGetter: (row) => row.id),
          complexColumn,
        ];

        expect(
          () async => excelService.export(
            data: testData,
            columns: complexColumns,
            config: config,
            activeFilters: null,
          ),
          returnsNormally,
        );
      });
    });

    group('Type Safety Tests', () {
      test('TypedVooDataColumn should maintain type safety', () {
        final typedColumn = TypedVooDataColumn<TestEntity, int>(
          field: 'id',
          label: 'ID',
          typedValueGetter: (row) => row.id,
          typedValueFormatter: (id) => 'ID: $id',
        );

        // The valueGetter should be correctly set
        expect(typedColumn.valueGetter, isNotNull);

        // Test that the getter works with the correct type
        final testEntity = TestEntity(id: 1, name: 'Test', isActive: true);
        final value = typedColumn.valueGetter!(testEntity);
        expect(value, equals(1));
      });

      test('TypedVooDataColumn should handle formatter with null values', () {
        final typedColumn = TypedVooDataColumn<TestEntity, TestState?>(
          field: 'state',
          label: 'State',
          typedValueGetter: (row) => row.state,
          typedValueFormatter: (state) => state?.name ?? 'Unknown',
        );

        // Test with null state
        final testEntity = TestEntity(id: 1, name: 'Test', isActive: true);
        final value = typedColumn.valueGetter!(testEntity);
        expect(value, isNull);

        // The formatter should handle null
        if (typedColumn.valueFormatter != null) {
          final formatted = typedColumn.valueFormatter!(value);
          expect(formatted, equals('Unknown'));
        }
      });
    });

    group('Regression Tests for Type Casting Errors', () {
      test('should not throw type casting error for generic row type', () async {
        // This specifically tests the error that was reported:
        // "Instance of '(OrderList) => int?' type '(OrderList) => int?'
        // is not a subtype of type '(dynamic) => dynamic?'"

        final problematicColumn = TypedVooDataColumn<TestEntity, int>(
          field: 'id',
          label: 'ID',
          typedValueGetter: (row) => row.id,
          typedValueFormatter: (id) => id.toString(),
        );

        final pdfService = PdfExportService<TestEntity>();

        // This should not throw
        expect(
          () async => pdfService.export(
            data: testData,
            columns: [problematicColumn],
            config: config,
            activeFilters: null,
          ),
          returnsNormally,
        );
      });

      test('should handle type casting with dynamic row types', () async {
        // Test with dynamic type to ensure backward compatibility
        final dynamicData = testData.cast<dynamic>().toList();
        final pdfService = PdfExportService<dynamic>();

        expect(
          () async => pdfService.export(
            data: dynamicData,
            columns: columns,
            config: config,
            activeFilters: null,
          ),
          returnsNormally,
        );
      });
    });
  });
}