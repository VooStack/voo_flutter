import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';
import '../test_helpers.dart';

/// Comprehensive tests for dropdown field callbacks
/// Tests both simple and searchable dropdowns with various data types
void main() {
  group('Dropdown Field Callbacks - Comprehensive Testing', () {
    group('Simple Dropdown - String Type', () {
      testWidgets(
        'should invoke onChanged with selected String value',
        (tester) async {
          // Arrange
          String? capturedValue;
          bool callbackInvoked = false;
          final options = ['Option A', 'Option B', 'Option C'];
          
          final field = VooField.dropdown<String>(
            name: 'simple_dropdown',
            label: 'Select Option',
            options: options,
            converter: (value) => VooDropdownChild(
              value: value,
              label: value,
            ),
            onChanged: (String? value) {
              capturedValue = value;
              callbackInvoked = true;
            },
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          // Open dropdown
          await tapDropdown(tester, reason: 'Opening simple dropdown');
          await tester.pumpAndSettle();
          
          // Select option
          final optionB = find.text('Option B').last;
          expect(
            optionB,
            findsOneWidget,
            reason: 'Option B should be visible in dropdown menu',
          );
          
          await tester.tap(optionB);
          await tester.pumpAndSettle();
          
          // Assert
          expectCallbackInvoked(
            wasInvoked: callbackInvoked,
            callbackName: 'onChanged',
            context: 'simple dropdown selection',
          );
          expectFieldValue(
            actual: capturedValue,
            expected: 'Option B',
            fieldName: 'simple_dropdown',
            context: 'after selecting Option B',
          );
        },
      );
      
      testWidgets(
        'should handle initial value correctly',
        (tester) async {
          // Arrange
          String? capturedValue;
          final options = ['Red', 'Green', 'Blue'];
          
          final field = VooField.dropdown<String>(
            name: 'color_dropdown',
            label: 'Select Color',
            initialValue: 'Green',
            options: options,
            converter: (value) => VooDropdownChild(
              value: value,
              label: value,
            ),
            onChanged: (String? value) => capturedValue = value,
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          await tester.pumpAndSettle();
          
          // Assert - Initial value should be displayed
          expect(
            find.text('Green'),
            findsOneWidget,
            reason: 'Initial value "Green" should be displayed',
          );
          
          // Change selection
          await tapDropdown(tester, reason: 'Changing initial selection');
          await tester.pumpAndSettle();
          
          await tester.tap(find.text('Blue').last);
          await tester.pumpAndSettle();
          
          expectFieldValue(
            actual: capturedValue,
            expected: 'Blue',
            fieldName: 'color_dropdown',
            context: 'after changing from initial value',
          );
        },
      );
    });
    
    group('Complex Type Dropdown - Custom Objects', () {
      testWidgets(
        'should handle custom object types correctly',
        (tester) async {
          // Arrange
          User? capturedValue;
          bool callbackInvoked = false;
          
          final users = [
            User(id: 1, name: 'John Doe', email: 'john@example.com'),
            User(id: 2, name: 'Jane Smith', email: 'jane@example.com'),
            User(id: 3, name: 'Bob Johnson', email: 'bob@example.com'),
          ];
          
          final field = VooField.dropdown<User>(
            name: 'user_dropdown',
            label: 'Select User',
            options: users,
            converter: (user) => VooDropdownChild(
              value: user,
              label: user.name,
              subtitle: user.email,
            ),
            onChanged: (User? value) {
              capturedValue = value;
              callbackInvoked = true;
            },
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          await tapDropdown(tester, reason: 'Opening user dropdown');
          await tester.pumpAndSettle();
          
          // Select Jane Smith
          final janeOption = find.text('Jane Smith').last;
          expect(
            janeOption,
            findsOneWidget,
            reason: 'Jane Smith should be in dropdown options',
          );
          
          await tester.tap(janeOption);
          await tester.pumpAndSettle();
          
          // Assert
          expectCallbackInvoked(
            wasInvoked: callbackInvoked,
            callbackName: 'onChanged',
            context: 'custom object dropdown',
          );
          
          expect(
            capturedValue?.id,
            equals(2),
            reason: 'Selected user should have correct ID',
          );
          expect(
            capturedValue?.name,
            equals('Jane Smith'),
            reason: 'Selected user should have correct name',
          );
          expect(
            capturedValue?.email,
            equals('jane@example.com'),
            reason: 'Selected user should have correct email',
          );
        },
      );
    });
    
    group('Searchable Dropdown', () {
      testWidgets(
        'should filter options based on search query',
        (tester) async {
          // Arrange
          String? capturedValue;
          final countries = [
            'United States',
            'United Kingdom',
            'Canada',
            'Australia',
            'Germany',
            'France',
            'Japan',
            'Brazil',
          ];
          
          final field = VooField.dropdown<String>(
            name: 'country_dropdown',
            label: 'Select Country',
            options: countries,
            enableSearch: true,
            searchHint: 'Search countries...',
            converter: (value) => VooDropdownChild(
              value: value,
              label: value,
            ),
            onChanged: (String? value) => capturedValue = value,
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          // Open searchable dropdown
          await tapDropdown(tester, reason: 'Opening searchable dropdown');
          await tester.pumpAndSettle();
          
          // Enter search query
          final searchField = find.byType(TextField).last;
          expect(
            searchField,
            findsOneWidget,
            reason: 'Search field should be visible in searchable dropdown',
          );
          
          await tester.enterText(searchField, 'united');
          await tester.pumpAndSettle();
          
          // Verify filtered results
          expect(
            find.text('United States'),
            findsOneWidget,
            reason: 'United States should be visible after search',
          );
          expect(
            find.text('United Kingdom'),
            findsOneWidget,
            reason: 'United Kingdom should be visible after search',
          );
          expect(
            find.text('Canada'),
            findsNothing,
            reason: 'Canada should be filtered out',
          );
          
          // Select filtered option
          await tester.tap(find.text('United Kingdom').last);
          await tester.pumpAndSettle();
          
          // Assert
          expectFieldValue(
            actual: capturedValue,
            expected: 'United Kingdom',
            fieldName: 'country_dropdown',
            context: 'after searching and selecting',
          );
        },
      );
    });
    
    group('Async Dropdown - Dynamic Loading', () {
      testWidgets(
        'should load options asynchronously',
        (tester) async {
          // Arrange
          String? capturedValue;
          bool loaderCalled = false;
          
          final field = VooField.dropdownAsync<String>(
            name: 'async_dropdown',
            label: 'Async Options',
            asyncOptionsLoader: (query) async {
              loaderCalled = true;
              // Simulate API call
              await Future.delayed(const Duration(milliseconds: 100));
              
              final allOptions = ['Async 1', 'Async 2', 'Async 3'];
              return allOptions
                  .where((opt) => opt.toLowerCase().contains(query.toLowerCase()))
                  .toList();
            },
            converter: (value) => VooDropdownChild(
              value: value,
              label: value,
            ),
            onChanged: (String? value) => capturedValue = value,
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          // Open async dropdown
          await tapDropdown(tester, reason: 'Opening async dropdown');
          await tester.pump(); // Start loading
          
          // Verify loader was called
          expect(
            loaderCalled,
            isTrue,
            reason: 'Async loader should be called when dropdown opens',
          );
          
          // Wait for options to load
          await tester.pump(const Duration(milliseconds: 150));
          await tester.pumpAndSettle();
          
          // Verify options loaded
          expect(
            find.text('Async 1'),
            findsOneWidget,
            reason: 'Async option 1 should be loaded',
          );
          
          // Select option
          await tester.tap(find.text('Async 2').last);
          await tester.pumpAndSettle();
          
          // Assert
          expectFieldValue(
            actual: capturedValue,
            expected: 'Async 2',
            fieldName: 'async_dropdown',
            context: 'after async loading',
          );
        },
      );
    });
    
    group('Dropdown with Icons and Subtitles', () {
      testWidgets(
        'should display icons and subtitles correctly',
        (tester) async {
          // Arrange
          String? capturedValue;
          
          final statusOptions = [
            {'value': 'active', 'label': 'Active', 'subtitle': 'Currently running', 'icon': Icons.play_arrow},
            {'value': 'paused', 'label': 'Paused', 'subtitle': 'Temporarily stopped', 'icon': Icons.pause},
            {'value': 'stopped', 'label': 'Stopped', 'subtitle': 'Completely halted', 'icon': Icons.stop},
          ];
          
          final field = VooField.dropdown<String>(
            name: 'icon_dropdown',
            label: 'Select Status',
            enableSearch: true, // Icons/subtitles only show in searchable
            options: statusOptions.map((opt) => opt['value'] as String).toList(),
            converter: (value) {
              final option = statusOptions.firstWhere((opt) => opt['value'] == value);
              return VooDropdownChild(
                value: value,
                label: option['label'] as String,
                subtitle: option['subtitle'] as String,
                icon: option['icon'] as IconData,
              );
            },
            onChanged: (String? value) => capturedValue = value,
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          await tapDropdown(tester, reason: 'Opening dropdown with icons');
          await tester.pumpAndSettle();
          
          // Verify icons are displayed
          expect(
            find.byIcon(Icons.play_arrow),
            findsOneWidget,
            reason: 'Active status icon should be visible',
          );
          expect(
            find.byIcon(Icons.pause),
            findsOneWidget,
            reason: 'Paused status icon should be visible',
          );
          
          // Verify subtitles are displayed
          expect(
            find.text('Currently running'),
            findsOneWidget,
            reason: 'Active status subtitle should be visible',
          );
          
          // Select option
          await tester.tap(find.text('Paused').last);
          await tester.pumpAndSettle();
          
          // Assert
          expectFieldValue(
            actual: capturedValue,
            expected: 'paused',
            fieldName: 'icon_dropdown',
            context: 'dropdown with icons and subtitles',
          );
        },
      );
    });
    
    group('Edge Cases and Error Scenarios', () {
      testWidgets(
        'should handle empty options list gracefully',
        (tester) async {
          // Arrange
          final field = VooField.dropdown<String>(
            name: 'empty_dropdown',
            label: 'Empty Dropdown',
            options: [],
            converter: (value) => VooDropdownChild(value: value, label: value),
          );
          
          // Act & Assert - Should render without errors
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          await tapDropdown(tester, reason: 'Opening empty dropdown');
          await tester.pumpAndSettle();
          
          // Should show empty state
          expect(
            find.byType(DropdownButtonFormField),
            findsOneWidget,
            reason: 'Empty dropdown should still render',
          );
        },
      );
      
      testWidgets(
        'should handle null selection correctly',
        (tester) async {
          // Arrange
          String? capturedValue = 'option1';
          
          final field = VooField.dropdown<String?>(
            name: 'nullable_dropdown',
            label: 'Nullable Dropdown',
            initialValue: 'option1',
            options: [null, 'option1'],
            converter: (value) => VooDropdownChild(
              value: value,
              label: value == null ? 'None' : 'Option 1',
            ),
            onChanged: (String? value) => capturedValue = value,
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          await tapDropdown(tester, reason: 'Opening nullable dropdown');
          await tester.pumpAndSettle();
          
          // Select null option
          await tester.tap(find.text('None').last);
          await tester.pumpAndSettle();
          
          // Assert
          expect(
            capturedValue,
            isNull,
            reason: 'Should handle null selection correctly',
          );
        },
      );
    });
  });
}

// Test helper class
class User {
  final int id;
  final String name;
  final String email;
  
  const User({
    required this.id,
    required this.name,
    required this.email,
  });
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id;
  
  @override
  int get hashCode => id.hashCode;
}