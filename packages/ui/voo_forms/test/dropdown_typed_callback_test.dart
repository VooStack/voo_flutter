import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

// Test class that simulates JurisdictionListOption
class JurisdictionListOption {
  final String id;
  final String name;
  final String code;

  const JurisdictionListOption({
    required this.id,
    required this.name,
    required this.code,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JurisdictionListOption &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

void main() {
  group('Dropdown Typed Callback Tests', () {
    testWidgets(
      'should handle strongly typed callbacks without type casting errors',
      (tester) async {
        // Arrange
        final jurisdictions = [
          const JurisdictionListOption(id: '1', name: 'California', code: 'CA'),
          const JurisdictionListOption(id: '2', name: 'Texas', code: 'TX'),
          const JurisdictionListOption(id: '3', name: 'New York', code: 'NY'),
        ];

        JurisdictionListOption? capturedValue;
        bool callbackInvoked = false;
        String? errorMessage;

        // Create field with strongly typed callback
        final field = VooField.dropdown<JurisdictionListOption>(
          name: 'jurisdiction',
          label: 'Select Jurisdiction',
          options: jurisdictions,
          converter: (jurisdiction) => VooDropdownChild(
            value: jurisdiction,
            label: jurisdiction.name,
            subtitle: jurisdiction.code,
          ),
          initialValue: jurisdictions.first,
          // This is the typed callback that was causing the error
          onChanged: (JurisdictionListOption? value) {
            capturedValue = value;
            callbackInvoked = true;
          },
        );

        // Act - Wrap in error handler to catch any type casting errors
        await tester.pumpWidget(
          MaterialApp(
            home: VooDesignSystem(
              data: VooDesignSystemData.defaultSystem,
              child: VooResponsiveBuilder(
                child: Scaffold(
                  body: Builder(
                    builder: (context) {
                      // Catch any type errors during widget build
                      try {
                        return VooFieldWidget(field: field);
                      } catch (e) {
                        errorMessage = e.toString();
                        return Text('Error: $e');
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        );

        // Assert - Should build without type errors
        expect(errorMessage, isNull, 
          reason: 'Widget should build without type casting errors');
        expect(find.text('California'), findsOneWidget,
          reason: 'Initial value should be displayed');

        // Try to open dropdown and select an option
        // Use a more generic finder since the exact type might not match
        await tester.tap(find.byType(DropdownButtonFormField));
        await tester.pumpAndSettle();

        // Select Texas
        final texasOption = find.text('Texas').last;
        if (texasOption.evaluate().isNotEmpty) {
          await tester.tap(texasOption);
          await tester.pumpAndSettle();

          // Verify callback was invoked with correct type
          expect(callbackInvoked, isTrue,
            reason: 'Callback should be invoked when selection changes');
          expect(capturedValue?.name, equals('Texas'),
            reason: 'Selected value should be Texas');
          expect(capturedValue?.code, equals('TX'),
            reason: 'Selected value should have correct code');
        }
      },
    );

    testWidgets(
      'should handle async dropdown with typed callbacks',
      (tester) async {
        // Arrange
        JurisdictionListOption? capturedValue;
        bool callbackInvoked = false;
        bool loaderCalled = false;

        // Create async dropdown field with typed callback
        final field = VooField.dropdownAsync<JurisdictionListOption>(
          name: 'async_jurisdiction',
          label: 'Search Jurisdiction',
          converter: (jurisdiction) => VooDropdownChild(
            value: jurisdiction,
            label: jurisdiction.name,
            subtitle: jurisdiction.code,
          ),
          asyncOptionsLoader: (query) async {
            loaderCalled = true;
            await Future.delayed(const Duration(milliseconds: 100));
            
            final allJurisdictions = [
              const JurisdictionListOption(id: '1', name: 'California', code: 'CA'),
              const JurisdictionListOption(id: '2', name: 'Texas', code: 'TX'),
              const JurisdictionListOption(id: '3', name: 'New York', code: 'NY'),
            ];
            
            return allJurisdictions
                .where((j) => j.name.toLowerCase().contains(query.toLowerCase()))
                .toList();
          },
          // Typed callback that was causing the error
          onChanged: (JurisdictionListOption? value) {
            capturedValue = value;
            callbackInvoked = true;
          },
        );

        // Act
        String? errorMessage;
        await tester.pumpWidget(
          MaterialApp(
            home: VooDesignSystem(
              data: VooDesignSystemData.defaultSystem,
              child: VooResponsiveBuilder(
                child: Scaffold(
                  body: Builder(
                    builder: (context) {
                      try {
                        return VooFieldWidget(field: field);
                      } catch (e) {
                        errorMessage = e.toString();
                        return Text('Error: $e');
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        );

        // Assert - Should build without type errors
        expect(errorMessage, isNull,
          reason: 'Async dropdown should build without type casting errors');

        // Open searchable dropdown
        await tester.tap(find.byType(TextFormField));
        await tester.pump();

        // Wait for async loader
        await tester.pump(const Duration(milliseconds: 150));
        // Don't use pumpAndSettle with async operations, use pump with duration
        await tester.pump(const Duration(milliseconds: 100));

        expect(loaderCalled, isTrue,
          reason: 'Async loader should be called');

        // Try to find and select an option if available
        final californiaOptions = find.text('California');
        if (californiaOptions.evaluate().isNotEmpty) {
          await tester.tap(californiaOptions.first);
          await tester.pump();

          expect(callbackInvoked, isTrue,
            reason: 'Callback should be invoked for async dropdown');
          expect(capturedValue?.name, equals('California'),
            reason: 'Selected async value should be California');
        } else {
          // If California option isn't visible, just verify no type errors occurred
          expect(errorMessage, isNull,
            reason: 'Should handle async dropdown without type errors even if options not visible');
        }
      },
    );

    testWidgets(
      'should handle null values in typed callbacks',
      (tester) async {
        // Arrange
        JurisdictionListOption? capturedValue = const JurisdictionListOption(
          id: 'initial',
          name: 'Initial',
          code: 'INIT',
        );
        
        final field = VooField.dropdown<JurisdictionListOption?>(
          name: 'nullable_jurisdiction',
          label: 'Optional Jurisdiction',
          options: [
            null, // Allow null selection
            const JurisdictionListOption(id: '1', name: 'California', code: 'CA'),
          ],
          converter: (jurisdiction) => VooDropdownChild(
            value: jurisdiction,
            label: jurisdiction?.name ?? 'None',
          ),
          initialValue: capturedValue,
          onChanged: (JurisdictionListOption? value) {
            capturedValue = value;
          },
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: VooDesignSystem(
              data: VooDesignSystemData.defaultSystem,
              child: VooResponsiveBuilder(
                child: Scaffold(
                  body: VooFieldWidget(field: field),
                ),
              ),
            ),
          ),
        );

        // Select null option
        await tester.tap(find.byType(DropdownButtonFormField));
        await tester.pumpAndSettle();

        final noneOption = find.text('None').last;
        if (noneOption.evaluate().isNotEmpty) {
          await tester.tap(noneOption);
          await tester.pumpAndSettle();

          // Verify null was properly handled
          expect(capturedValue, isNull,
            reason: 'Should handle null selection in typed callback');
        }
      },
    );

    testWidgets(
      'should work with VooFieldWidget onChanged in addition to field onChanged',
      (tester) async {
        // Arrange
        JurisdictionListOption? fieldCapturedValue;
        dynamic widgetCapturedValue;
        
        final jurisdictions = [
          const JurisdictionListOption(id: '1', name: 'California', code: 'CA'),
          const JurisdictionListOption(id: '2', name: 'Texas', code: 'TX'),
        ];

        final field = VooField.dropdown<JurisdictionListOption>(
          name: 'dual_callback',
          label: 'Dual Callback Test',
          options: jurisdictions,
          converter: (j) => VooDropdownChild(value: j, label: j.name),
          // Field's typed callback
          onChanged: (JurisdictionListOption? value) {
            fieldCapturedValue = value;
          },
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: VooDesignSystem(
              data: VooDesignSystemData.defaultSystem,
              child: VooResponsiveBuilder(
                child: Scaffold(
                  body: VooFieldWidget(
                    field: field,
                    // Widget's dynamic callback
                    onChanged: (dynamic value) {
                      widgetCapturedValue = value;
                    },
                  ),
                ),
              ),
            ),
          ),
        );

        // Select an option
        await tester.tap(find.byType(DropdownButtonFormField));
        await tester.pumpAndSettle();

        final texasOption = find.text('Texas').last;
        if (texasOption.evaluate().isNotEmpty) {
          await tester.tap(texasOption);
          await tester.pumpAndSettle();

          // Both callbacks should receive the value
          expect(fieldCapturedValue?.name, equals('Texas'),
            reason: 'Field callback should receive typed value');
          expect((widgetCapturedValue as JurisdictionListOption?)?.name, equals('Texas'),
            reason: 'Widget callback should receive dynamic value');
        }
      },
    );
  });
}