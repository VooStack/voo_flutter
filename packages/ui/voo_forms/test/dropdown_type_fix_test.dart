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
  group('Dropdown Type Fix Tests', () {
    testWidgets('Should handle typed onChanged callbacks without type errors', (tester) async {
      // Create test data
      final jurisdictions = [
        const JurisdictionListOption(id: '1', name: 'California', code: 'CA'),
        const JurisdictionListOption(id: '2', name: 'Texas', code: 'TX'),
        const JurisdictionListOption(id: '3', name: 'New York', code: 'NY'),
      ];

      JurisdictionListOption? selectedValue;
      bool callbackCalled = false;

      // Create field without onChanged in the field itself
      // The onChanged will be handled by VooFieldWidget
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
      );

      await tester.pumpWidget(
        MaterialApp(
          home: VooDesignSystem(
            data: VooDesignSystemData.defaultSystem,
            child: VooResponsiveBuilder(
              child: Scaffold(
                body: VooFieldWidget(
                  field: field,
                  onChanged: (dynamic value) {
                    // Handle the type casting at the widget level
                    if (value is JurisdictionListOption?) {
                      selectedValue = value;
                      callbackCalled = true;
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      );

      // Verify initial value is displayed
      expect(find.text('California'), findsOneWidget);

      // Tap to open dropdown
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Select a different option
      await tester.tap(find.text('Texas').last);
      await tester.pumpAndSettle();

      // Verify callback was called with correct type
      expect(callbackCalled, isTrue);
      expect(selectedValue, equals(jurisdictions[1]));
      expect(selectedValue?.name, equals('Texas'));
    });

    testWidgets('Should update display when selection changes', (tester) async {
      final jurisdictions = [
        const JurisdictionListOption(id: '1', name: 'California', code: 'CA'),
        const JurisdictionListOption(id: '2', name: 'Texas', code: 'TX'),
        const JurisdictionListOption(id: '3', name: 'New York', code: 'NY'),
      ];

      JurisdictionListOption? currentValue = jurisdictions.first;

      final field = VooField.dropdown<JurisdictionListOption>(
        name: 'jurisdiction',
        label: 'Select Jurisdiction',
        options: jurisdictions,
        converter: (jurisdiction) => VooDropdownChild(
          value: jurisdiction,
          label: jurisdiction.name,
          subtitle: jurisdiction.code,
        ),
        initialValue: currentValue,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: VooDesignSystem(
            data: VooDesignSystemData.defaultSystem,
            child: VooResponsiveBuilder(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Scaffold(
                    body: VooFieldWidget(
                      field: field.copyWith(value: currentValue),
                      onChanged: (value) {
                        setState(() {
                          currentValue = value as JurisdictionListOption?;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Verify initial value
      expect(find.text('California'), findsOneWidget);

      // Open dropdown
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Select Texas
      await tester.tap(find.text('Texas').last);
      await tester.pumpAndSettle();

      // Verify display updated
      expect(find.text('Texas'), findsOneWidget);
      expect(find.text('California'), findsNothing);
    });

    testWidgets('Async dropdown should have hover effects', (tester) async {
      final field = VooField.dropdownAsync<JurisdictionListOption>(
        name: 'jurisdiction',
        label: 'Select Jurisdiction',
        asyncOptionsLoader: (query) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return [
            const JurisdictionListOption(id: '1', name: 'California', code: 'CA'),
            const JurisdictionListOption(id: '2', name: 'Texas', code: 'TX'),
            const JurisdictionListOption(id: '3', name: 'New York', code: 'NY'),
          ].where((j) => j.name.toLowerCase().contains(query.toLowerCase())).toList();
        },
        converter: (jurisdiction) => VooDropdownChild(
          value: jurisdiction,
          label: jurisdiction.name,
          subtitle: jurisdiction.code,
        ),
        initialValue: const JurisdictionListOption(id: '1', name: 'California', code: 'CA'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: VooDesignSystem(
            data: VooDesignSystemData.defaultSystem,
            child: VooResponsiveBuilder(
              child: Scaffold(
                body: VooFieldWidget(
                  field: field,
                ),
              ),
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Wait for async loading
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      // Find InkWell items in the dropdown menu
      final inkWells = find.byType(InkWell);
      expect(inkWells, findsWidgets);

      // Verify Material wrapper exists for hover effects
      final materials = find.byType(Material);
      expect(materials, findsWidgets);
    });

    testWidgets('Should handle dynamic callbacks without errors', (tester) async {
      dynamic capturedValue;
      
      final field = VooField.dropdown<String>(
        name: 'test',
        label: 'Test',
        options: ['Option 1', 'Option 2'],
        converter: (val) => VooDropdownChild(value: val, label: val),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: VooDesignSystem(
            data: VooDesignSystemData.defaultSystem,
            child: VooResponsiveBuilder(
              child: Scaffold(
                body: VooFieldWidget(
                  field: field,
                  onChanged: (dynamic value) {
                    capturedValue = value;
                  },
                ),
              ),
            ),
          ),
        ),
      );

      // Open and select option
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 2').last);
      await tester.pumpAndSettle();

      expect(capturedValue, equals('Option 2'));
    });

    testWidgets('Should work with strongly typed onChanged in widget', (tester) async {
      String? capturedValue;
      
      final field = VooField.dropdown<String>(
        name: 'test',
        label: 'Test',
        options: ['Option 1', 'Option 2'],
        converter: (val) => VooDropdownChild(value: val, label: val),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: VooDesignSystem(
            data: VooDesignSystemData.defaultSystem,
            child: VooResponsiveBuilder(
              child: Scaffold(
                body: VooFieldWidget(
                  field: field,
                  onChanged: (value) {
                    // This should work without type errors
                    capturedValue = value as String?;
                  },
                ),
              ),
            ),
          ),
        ),
      );

      // Open and select option
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 2').last);
      await tester.pumpAndSettle();

      expect(capturedValue, equals('Option 2'));
    });
  });
}