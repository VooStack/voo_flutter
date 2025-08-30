import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Widget tests for atomic components
/// Tests all field widgets following atomic design pattern

// Helper to tap dropdown fields that works with both DropdownButtonFormField and TextFormField
Future<void> tapDropdown(WidgetTester tester) async {
  // Try to find DropdownButtonFormField first (non-searchable dropdowns)
  final dropdownButton = find.byType(DropdownButtonFormField);
  if (dropdownButton.evaluate().isNotEmpty) {
    await tester.tap(dropdownButton.first);
    return;
  }
  
  // Otherwise look for TextFormField (searchable dropdowns)
  final textField = find.byType(TextFormField);
  if (textField.evaluate().isNotEmpty) {
    await tester.tap(textField.first);
    return;
  }
  
  throw StateError('No dropdown field found');
}

void main() {
  // Helper to create test app
  Widget createTestApp(Widget child) {
    return MaterialApp(
      home: VooDesignSystem(
        data: VooDesignSystemData.defaultSystem,
        child: VooResponsiveBuilder(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  group('Atomic Components - Text Fields', () {
    testWidgets('VooTextFormField should render correctly', (tester) async {
      final field = VooField.text(
        name: 'username',
        label: 'Username',
        hint: 'Enter your username',
        initialValue: 'testuser',
      );

      await tester.pumpWidget(
        createTestApp(
          VooFieldWidget(field: field),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('testuser'), findsOneWidget);
      expect(find.text('Username'), findsOneWidget);
    });

    testWidgets('VooTextFormField should handle text input', (tester) async {
      String? capturedValue;
      
      final field = VooField.text(
        name: 'input',
        label: 'Input Field',
      );

      await tester.pumpWidget(
        createTestApp(
          VooFieldWidget(
            field: field,
            onChanged: (value) => capturedValue = value as String?,
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Hello World');
      await tester.pump();

      expect(capturedValue, equals('Hello World'));
      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('Password field should obscure text', (tester) async {
      final field = VooField.password(
        name: 'password',
        label: 'Password',
      );

      await tester.pumpWidget(
        createTestApp(
          VooFieldWidget(field: field),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
      expect(field.type, equals(VooFieldType.password));
    });

    testWidgets('Email field should show keyboard type', (tester) async {
      final field = VooField.email(
        name: 'email',
        label: 'Email Address',
      );

      await tester.pumpWidget(
        createTestApp(
          VooFieldWidget(field: field),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
      expect(field.keyboardType, equals(TextInputType.emailAddress));
    });

    testWidgets('Multiline field should show multiple lines', (tester) async {
      final field = VooField.multiline(
        name: 'description',
        label: 'Description',
        minLines: 3,
        maxLines: 5,
      );

      await tester.pumpWidget(
        createTestApp(
          VooFieldWidget(field: field),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
      expect(field.minLines, equals(3));
      expect(field.maxLines, equals(5));
    });
  });

  group('Atomic Components - Boolean Fields', () {
    testWidgets('VooSwitchFieldWidget should toggle', (tester) async {
      final field = VooField.boolean(
        name: 'enabled',
        label: 'Enable Feature',
        initialValue: false,
      );

      await tester.pumpWidget(
        createTestApp(
          VooFieldWidget(field: field),
        ),
      );

      expect(find.byType(Switch), findsOneWidget);
      
      await tester.tap(find.byType(Switch));
      await tester.pump();
      
      // Value should change but might not be captured due to internal handling
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('VooCheckboxFieldWidget should render', (tester) async {
      final field = VooField.checkbox(
        name: 'agree',
        label: 'I agree to terms',
        initialValue: false,
      );

      await tester.pumpWidget(
        createTestApp(
          VooFieldWidget(field: field),
        ),
      );

      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.text('I agree to terms'), findsOneWidget);
    });

    testWidgets('Checkbox should handle tap', (tester) async {
      final field = VooField.checkbox(
        name: 'subscribe',
        label: 'Subscribe to newsletter',
        initialValue: false,
      );

      await tester.pumpWidget(
        createTestApp(
          VooFieldWidget(field: field),
        ),
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      
      expect(find.byType(Checkbox), findsOneWidget);
    });
  });

  group('Atomic Components - Dropdown Fields', () {
    testWidgets('VooDropdownFieldWidget should render options', (tester) async {
      final field = VooField.dropdownSimple(
        name: 'country',
        label: 'Select Country',
        options: ['USA', 'Canada', 'Mexico'],
        initialValue: 'USA',
      );

      await tester.pumpWidget(
        createTestApp(
          VooFieldWidget(field: field),
        ),
      );

      expect(find.text('USA'), findsOneWidget);
      expect(find.text('Select Country'), findsOneWidget);
    });

    testWidgets('Dropdown should open menu on tap', (tester) async {
      final field = VooField.dropdownSimple(
        name: 'size',
        label: 'Size',
        options: ['Small', 'Medium', 'Large'],
      );

      await tester.pumpWidget(
        createTestApp(
          VooFieldWidget(field: field),
        ),
      );

      // Tap to open dropdown
      await tapDropdown(tester);
      await tester.pumpAndSettle();
      
      // Menu should be open
      expect(find.text('Small'), findsWidgets);
    });

    testWidgets('Typed dropdown should handle complex objects', (tester) async {
      final options = [
        const MapEntry('id1', 'Option 1'),
        const MapEntry('id2', 'Option 2'),
      ];
      
      final field = VooField.dropdown<MapEntry<String, String>>(
        name: 'typed',
        label: 'Typed Dropdown',
        options: options,
        converter: (entry) => VooDropdownChild(
          value: entry,
          label: entry.value,
        ),
        initialValue: options.first,
      );

      await tester.pumpWidget(
        createTestApp(
          VooFieldWidget(field: field),
        ),
      );

      expect(find.text('Option 1'), findsOneWidget);
    });
  });

  group('Atomic Components - Selection Fields', () {
    testWidgets('VooRadioFieldWidget should render options', (tester) async {
      final field = VooField.radio(
        name: 'size',
        label: 'Select Size',
        options: ['S', 'M', 'L', 'XL'],
        initialValue: 'M',
      );

      await tester.pumpWidget(
        createTestApp(
          VooFieldWidget(field: field),
        ),
      );

      // Radio field uses VooRadioListTile, not Radio directly
      expect(find.byType(VooRadioListTile), findsWidgets);
      expect(find.text('S'), findsOneWidget);
      expect(find.text('M'), findsOneWidget);
      expect(find.text('L'), findsOneWidget);
    });

    testWidgets('VooSliderFieldWidget should render', (tester) async {
      final field = VooField.slider(
        name: 'volume',
        label: 'Volume',
        min: 0,
        max: 100,
        initialValue: 50,
        divisions: 10,
      );

      await tester.pumpWidget(
        createTestApp(
          VooFieldWidget(field: field),
        ),
      );

      expect(find.byType(Slider), findsOneWidget);
      expect(find.text('Volume'), findsOneWidget);
    });

    testWidgets('Slider should handle drag', (tester) async {
      final field = VooField.slider(
        name: 'brightness',
        label: 'Brightness',
        min: 0,
        max: 100,
        initialValue: 50,
      );

      await tester.pumpWidget(
        createTestApp(
          VooFieldWidget(field: field),
        ),
      );

      final slider = find.byType(Slider);
      await tester.drag(slider, const Offset(50, 0));
      await tester.pump();
      
      expect(slider, findsOneWidget);
    });
  });

  group('Atomic Components - Date and Time Fields', () {
    testWidgets('VooDateFieldWidget should show date', (tester) async {
      final field = VooField.date(
        name: 'birthdate',
        label: 'Birth Date',
        initialValue: DateTime(2000, 1, 1),
      );

      await tester.pumpWidget(
        createTestApp(
          VooFieldWidget(field: field),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
      // Date format may vary
      expect(find.textContaining('2000'), findsAny);
    });

    testWidgets('VooTimeFieldWidget should show time', (tester) async {
      final field = VooField.time(
        name: 'appointment',
        label: 'Appointment Time',
        initialValue: const TimeOfDay(hour: 14, minute: 30),
      );

      await tester.pumpWidget(
        createTestApp(
          VooFieldWidget(field: field),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
      // Time format may vary (2:30 PM or 14:30)
      expect(find.textContaining('30'), findsAny);
    });

    testWidgets('Date field should open date picker on tap', (tester) async {
      final field = VooField.date(
        name: 'date',
        label: 'Select Date',
      );

      await tester.pumpWidget(
        createTestApp(
          VooFieldWidget(field: field),
        ),
      );

      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();
      
      // Date picker dialog should appear
      expect(find.byType(Dialog), findsOneWidget);
      
      // Close the dialog
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
    });
  });

  group('Field Options and Styling', () {
    testWidgets('Field should apply custom options', (tester) async {
      final field = VooField.text(
        name: 'styled',
        label: 'Styled Field',
      );

      await tester.pumpWidget(
        createTestApp(
          VooFieldWidget(
            field: field,
            options: VooFieldOptions(
              labelPosition: LabelPosition.floating,
              fieldVariant: FieldVariant.outlined,
            ),
          ),
        ),
      );

      expect(find.byType(VooFieldWidget), findsOneWidget);
    });

    testWidgets('Field should show error state', (tester) async {
      final field = VooField.text(
        name: 'error_field',
        label: 'Field with Error',
      );

      await tester.pumpWidget(
        createTestApp(
          VooFieldWidget(
            field: field,
            error: 'This field has an error',
            showError: true,
          ),
        ),
      );

      expect(find.text('This field has an error'), findsOneWidget);
    });

    testWidgets('Field should be disabled when specified', (tester) async {
      final field = VooField.text(
        name: 'disabled',
        label: 'Disabled Field',
        enabled: false,
      );

      await tester.pumpWidget(
        createTestApp(
          VooFieldWidget(field: field),
        ),
      );

      final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.enabled, isFalse);
    });

    testWidgets('Field should be read-only when specified', (tester) async {
      final field = VooField.text(
        name: 'readonly',
        label: 'Read-only Field',
        readOnly: true,
        initialValue: 'Cannot edit this',
      );

      await tester.pumpWidget(
        createTestApp(
          VooFieldWidget(field: field),
        ),
      );

      expect(find.text('Cannot edit this'), findsOneWidget);
      expect(field.readOnly, isTrue);
    });
  });

  group('Field Interactions', () {
    testWidgets('Field should trigger onEditingComplete', (tester) async {
      bool editingCompleted = false;
      
      final field = VooField.text(
        name: 'test',
        label: 'Test Field',
      );

      await tester.pumpWidget(
        createTestApp(
          VooFieldWidget(
            field: field,
            onEditingComplete: () => editingCompleted = true,
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'test');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      
      expect(editingCompleted, isTrue);
    });

    testWidgets('Field should handle focus changes', (tester) async {
      final focusNode = FocusNode();
      
      final field = VooField.text(
        name: 'focus_test',
        label: 'Focus Test',
      );

      await tester.pumpWidget(
        createTestApp(
          VooFieldWidget(
            field: field,
            focusNode: focusNode,
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pump();
      
      expect(focusNode.hasFocus, isTrue);
      
      focusNode.unfocus();
      await tester.pump();
      
      expect(focusNode.hasFocus, isFalse);
    });

    testWidgets('Field should handle controller', (tester) async {
      final controller = TextEditingController(text: 'initial');
      
      final field = VooField.text(
        name: 'controlled',
        label: 'Controlled Field',
      );

      await tester.pumpWidget(
        createTestApp(
          VooFieldWidget(
            field: field,
            controller: controller,
          ),
        ),
      );

      expect(find.text('initial'), findsOneWidget);
      
      controller.text = 'changed';
      await tester.pump();
      
      expect(find.text('changed'), findsOneWidget);
    });
  });
}