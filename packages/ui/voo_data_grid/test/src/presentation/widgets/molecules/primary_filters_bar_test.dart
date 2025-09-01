import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
import 'package:voo_data_grid/src/domain/entities/voo_filter_operator.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/primary_filter_button.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/primary_filter.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/primary_filters_bar.dart';

void main() {
  group('PrimaryFiltersBar', () {
    late List<PrimaryFilter> testFilters;
    
    setUp(() {
      testFilters = [
        const PrimaryFilter(
          field: 'status',
          label: 'Active',
          filter: VooDataFilter(
            operator: VooFilterOperator.equals,
            value: 'active',
          ),
        ),
        const PrimaryFilter(
          field: 'status',
          label: 'Inactive',
          filter: VooDataFilter(
            operator: VooFilterOperator.equals,
            value: 'inactive',
          ),
        ),
        const PrimaryFilter(
          field: 'status',
          label: 'Pending',
          filter: VooDataFilter(
            operator: VooFilterOperator.equals,
            value: 'pending',
          ),
        ),
      ];
    });
    
    testWidgets('displays all filter buttons', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryFiltersBar(
              filters: testFilters,
            ),
          ),
        ),
      );
      
      // Assert
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Inactive'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
    });
    
    testWidgets('highlights selected filter', (WidgetTester tester) async {
      // Arrange
      const selectedFilter = VooDataFilter(
        operator: VooFilterOperator.equals,
        value: 'active',
      );
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryFiltersBar(
              filters: testFilters,
              selectedFilter: selectedFilter,
            ),
          ),
        ),
      );
      
      // Assert
      final activeButton = find.byWidgetPredicate(
        (widget) => widget is PrimaryFilterButton && 
                     widget.label == 'Active' && 
                     widget.isSelected == true,
      );
      expect(activeButton, findsOneWidget);
    });
    
    testWidgets('calls onFilterChanged when filter is selected', (WidgetTester tester) async {
      // Arrange
      String? capturedField;
      VooDataFilter? capturedFilter;
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryFiltersBar(
              filters: testFilters,
              onFilterChanged: (field, filter) {
                capturedField = field;
                capturedFilter = filter;
              },
            ),
          ),
        ),
      );
      
      await tester.tap(find.text('Active'));
      await tester.pumpAndSettle();
      
      // Assert
      expect(capturedField, equals('status'));
      expect(capturedFilter, equals(testFilters[0].filter));
    });
    
    testWidgets('calls onFilterChanged with null when All is selected', (WidgetTester tester) async {
      // Arrange
      String? capturedField;
      VooDataFilter? capturedFilter;
      bool callbackCalled = false;
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryFiltersBar(
              filters: testFilters,
              selectedFilter: testFilters[0].filter,
              onFilterChanged: (field, filter) {
                capturedField = field;
                capturedFilter = filter;
                callbackCalled = true;
              },
            ),
          ),
        ),
      );
      
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      
      // Assert
      expect(callbackCalled, isTrue);
      expect(capturedField, equals('status'));
      expect(capturedFilter, isNull);
    });
    
    testWidgets('does not duplicate when same filter is selected multiple times', (WidgetTester tester) async {
      // Arrange
      final List<String> callbackFields = [];
      final List<VooDataFilter?> callbackFilters = [];
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryFiltersBar(
              filters: testFilters,
              onFilterChanged: (field, filter) {
                callbackFields.add(field);
                callbackFilters.add(filter);
              },
            ),
          ),
        ),
      );
      
      // Select Active twice
      await tester.tap(find.text('Active'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Active'));
      await tester.pumpAndSettle();
      
      // Assert - Should have two callbacks but same field/filter
      expect(callbackFields.length, equals(2));
      expect(callbackFields[0], equals('status'));
      expect(callbackFields[1], equals('status'));
      expect(callbackFilters[0], equals(testFilters[0].filter));
      expect(callbackFilters[1], equals(testFilters[0].filter));
    });
    
    testWidgets('switches between different filters correctly', (WidgetTester tester) async {
      // Arrange
      final List<String> callbackFields = [];
      final List<VooDataFilter?> callbackFilters = [];
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryFiltersBar(
              filters: testFilters,
              onFilterChanged: (field, filter) {
                callbackFields.add(field);
                callbackFilters.add(filter);
              },
            ),
          ),
        ),
      );
      
      // Select different filters
      await tester.tap(find.text('Active'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Inactive'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pending'));
      await tester.pumpAndSettle();
      
      // Assert - All should be for same field but different values
      expect(callbackFields.length, equals(3));
      expect(callbackFields.every((field) => field == 'status'), isTrue);
      expect(callbackFilters[0]?.value, equals('active'));
      expect(callbackFilters[1]?.value, equals('inactive'));
      expect(callbackFilters[2]?.value, equals('pending'));
    });
    
    testWidgets('hides All option when showAllOption is false', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryFiltersBar(
              filters: testFilters,
              showAllOption: false,
            ),
          ),
        ),
      );
      
      // Assert
      expect(find.text('All'), findsNothing);
      expect(find.text('Active'), findsOneWidget);
    });
    
    testWidgets('uses custom All option label', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryFiltersBar(
              filters: testFilters,
              allOptionLabel: 'Show Everything',
            ),
          ),
        ),
      );
      
      // Assert
      expect(find.text('Show Everything'), findsOneWidget);
      expect(find.text('All'), findsNothing);
    });
    
    testWidgets('handles empty filters list gracefully', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PrimaryFiltersBar(
              filters: [],
            ),
          ),
        ),
      );
      
      // Assert
      expect(find.text('All'), findsOneWidget);
    });
    
    testWidgets('scrolls horizontally when filters overflow', (WidgetTester tester) async {
      // Arrange
      final manyFilters = List.generate(
        20,
        (index) => PrimaryFilter(
          field: 'status',
          label: 'Filter $index',
          filter: VooDataFilter(
            operator: VooFilterOperator.equals,
            value: 'value_$index',
          ),
        ),
      );
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryFiltersBar(
              filters: manyFilters,
            ),
          ),
        ),
      );
      
      // Assert - Check that SingleChildScrollView is present and horizontal
      final scrollView = find.byType(SingleChildScrollView);
      expect(scrollView, findsOneWidget);
      
      final SingleChildScrollView widget = tester.widget(scrollView);
      expect(widget.scrollDirection, equals(Axis.horizontal));
    });
  });
}