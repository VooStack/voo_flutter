import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/src/data/services/pdf_export_service.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/export_config.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
import 'package:voo_data_grid/src/domain/entities/voo_filter_operator.dart';

void main() {
  group('PdfExportService', () {
    late PdfExportService<Map<String, dynamic>> service;
    late List<VooDataColumn> columns;
    late List<Map<String, dynamic>> testData;

    setUp(() {
      service = PdfExportService<Map<String, dynamic>>();

      columns = [
        const VooDataColumn(
          field: 'id',
          label: 'ID',
        ),
        const VooDataColumn(
          field: 'name',
          label: 'Name',
        ),
        const VooDataColumn(
          field: 'email',
          label: 'Email',
        ),
        const VooDataColumn(
          field: 'age',
          label: 'Age',
        ),
        const VooDataColumn(
          field: 'active',
          label: 'Active',
        ),
      ];

      testData = [
        {'id': 1, 'name': 'John Doe', 'email': 'john@example.com', 'age': 30, 'active': true},
        {'id': 2, 'name': 'Jane Smith', 'email': 'jane@example.com', 'age': 25, 'active': false},
        {'id': 3, 'name': 'Bob Johnson', 'email': 'bob@example.com', 'age': 35, 'active': true},
      ];
    });

    test('should export data to PDF bytes', () async {
      const config = ExportConfig(
        format: ExportFormat.pdf,
        title: 'Test Export',
      );

      final result = await service.export(
        data: testData,
        columns: columns,
        config: config,
        activeFilters: null,
      );

      expect(result, isNotNull);
      expect(result, isA<Uint8List>());
      expect(result.isNotEmpty, isTrue);
    });

    test('should include title and subtitle in PDF', () async {
      const config = ExportConfig(
        format: ExportFormat.pdf,
        title: 'Sales Report',
        subtitle: 'Q4 2024',
      );

      final result = await service.export(
        data: testData,
        columns: columns,
        config: config,
        activeFilters: null,
      );

      expect(result, isNotNull);
      expect(result, isA<Uint8List>());
    });

    test('should handle filters in export', () async {
      const config = ExportConfig(
        format: ExportFormat.pdf,
        title: 'Filtered Data',
      );

      final filters = {
        'age': const VooDataFilter(
          operator: VooFilterOperator.greaterThan,
          value: 25,
        ),
      };

      final result = await service.export(
        data: testData,
        columns: columns,
        config: config,
        activeFilters: filters,
      );

      expect(result, isNotNull);
      expect(result, isA<Uint8List>());
    });

    test('should respect maxRows configuration', () async {
      const config = ExportConfig(
        format: ExportFormat.pdf,
        title: 'Limited Export',
        maxRows: 2,
      );

      final result = await service.export(
        data: testData,
        columns: columns,
        config: config,
        activeFilters: null,
      );

      expect(result, isNotNull);
      expect(result, isA<Uint8List>());
    });

    test('should show row numbers when configured', () async {
      const config = ExportConfig(
        format: ExportFormat.pdf,
        title: 'Numbered Rows',
        showRowNumbers: true,
      );

      final result = await service.export(
        data: testData,
        columns: columns,
        config: config,
        activeFilters: null,
      );

      expect(result, isNotNull);
      expect(result, isA<Uint8List>());
    });

    test('should handle landscape orientation', () async {
      const config = ExportConfig(
        format: ExportFormat.pdf,
        title: 'Landscape Report',
      );

      final result = await service.export(
        data: testData,
        columns: columns,
        config: config,
        activeFilters: null,
      );

      expect(result, isNotNull);
      expect(result, isA<Uint8List>());
    });

    test('should handle portrait orientation', () async {
      const config = ExportConfig(
        format: ExportFormat.pdf,
        title: 'Portrait Report',
        isLandscape: false,
      );

      final result = await service.export(
        data: testData,
        columns: columns,
        config: config,
        activeFilters: null,
      );

      expect(result, isNotNull);
      expect(result, isA<Uint8List>());
    });

    test('should include timestamp when configured', () async {
      const config = ExportConfig(
        format: ExportFormat.pdf,
        title: 'Timestamped Report',
      );

      final result = await service.export(
        data: testData,
        columns: columns,
        config: config,
        activeFilters: null,
      );

      expect(result, isNotNull);
      expect(result, isA<Uint8List>());
    });

    test('should exclude specified columns', () async {
      const config = ExportConfig(
        format: ExportFormat.pdf,
        title: 'Selective Export',
        excludeColumns: ['email', 'active'],
      );

      final result = await service.export(
        data: testData,
        columns: columns,
        config: config,
        activeFilters: null,
      );

      expect(result, isNotNull);
      expect(result, isA<Uint8List>());
    });

    test('should handle custom header and footer text', () async {
      const config = ExportConfig(
        format: ExportFormat.pdf,
        title: 'Custom Header/Footer',
        headerText: 'Custom Header',
        footerText: 'Custom Footer',
      );

      final result = await service.export(
        data: testData,
        columns: columns,
        config: config,
        activeFilters: null,
      );

      expect(result, isNotNull);
      expect(result, isA<Uint8List>());
    });

    test('should handle primary color configuration', () async {
      final config = ExportConfig(
        format: ExportFormat.pdf,
        title: 'Colored Report',
        primaryColor: Colors.blue[700],
      );

      final result = await service.export(
        data: testData,
        columns: columns,
        config: config,
        activeFilters: null,
      );

      expect(result, isNotNull);
      expect(result, isA<Uint8List>());
    });

    test('should handle empty data', () async {
      const config = ExportConfig(
        format: ExportFormat.pdf,
        title: 'Empty Report',
      );

      final result = await service.export(
        data: [],
        columns: columns,
        config: config,
        activeFilters: null,
      );

      expect(result, isNotNull);
      expect(result, isA<Uint8List>());
    });

    test('should handle null values in data', () async {
      final dataWithNulls = [
        {'id': 1, 'name': null, 'email': 'john@example.com', 'age': 30, 'active': true},
        {'id': 2, 'name': 'Jane Smith', 'email': null, 'age': null, 'active': false},
      ];

      const config = ExportConfig(
        format: ExportFormat.pdf,
        title: 'Report with Nulls',
      );

      final result = await service.export(
        data: dataWithNulls,
        columns: columns,
        config: config,
        activeFilters: null,
      );

      expect(result, isNotNull);
      expect(result, isA<Uint8List>());
    });

    test('should use value formatter when available', () async {
      final columnsWithFormatter = [
        const VooDataColumn<Map<String, dynamic>>(
          field: 'id',
          label: 'ID',
        ),
        VooDataColumn<Map<String, dynamic>>(
          field: 'age',
          label: 'Age',
          valueFormatter: (value) => '$value years',
        ),
      ];

      const config = ExportConfig(
        format: ExportFormat.pdf,
        title: 'Formatted Export',
      );

      final result = await service.export(
        data: testData,
        columns: columnsWithFormatter,
        config: config,
        activeFilters: null,
      );

      expect(result, isNotNull);
      expect(result, isA<Uint8List>());
    });

    test('should generate suggested filename', () {
      const config = ExportConfig(
        format: ExportFormat.pdf,
        title: 'Test Report',
      );

      final filename = service.getSuggestedFilename(config);

      expect(filename, isNotNull);
      expect(filename, contains('Test_Report'));
      expect(filename, endsWith('.pdf'));
    });

    test('should generate suggested filename with custom name', () {
      const config = ExportConfig(
        format: ExportFormat.pdf,
        filename: 'custom_report',
      );

      final filename = service.getSuggestedFilename(config);

      expect(filename, isNotNull);
      expect(filename, contains('custom_report'));
      expect(filename, endsWith('.pdf'));
    });

    test('should indicate export is available', () {
      final isAvailable = service.isExportAvailable();

      expect(isAvailable, isTrue);
    });

    test('should handle company information', () async {
      const config = ExportConfig(
        format: ExportFormat.pdf,
        title: 'Company Report',
        companyName: 'Test Company',
        author: 'John Doe',
        subject: 'Monthly Sales',
        keywords: 'sales,report,monthly',
      );

      final result = await service.export(
        data: testData,
        columns: columns,
        config: config,
        activeFilters: null,
      );

      expect(result, isNotNull);
      expect(result, isA<Uint8List>());
    });
  });
}