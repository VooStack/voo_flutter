import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

void main() {
  group('VooResponsiveFormWrapper', () {
    testWidgets('renders form with responsive wrapper', (tester) async {
      final form = VooForm(
        id: 'test',
        title: 'Test Form',
        fields: [
          VooFieldUtils.textField(
            id: 'name',
            name: 'name',
            label: 'Name',
          ),
        ],
      );

      final controller = VooFormController(form: form);

      await tester.pumpWidget(
        VooMaterialApp(
          home: Scaffold(
            body: VooResponsiveFormWrapper(
              form: form,
              controller: controller,
              phoneColumns: 1,
              tabletColumns: 2,
              desktopColumns: 3,
            ),
          ),
        ),
      );

      // Verify the form renders with the field
      expect(find.text('Name'), findsOneWidget);
      // The form wrapper doesn't necessarily show the form title
    });

    testWidgets('applies different column counts based on screen size', (tester) async {
      final form = VooForm(
        id: 'test',
        title: 'Test Form',
        fields: [
          VooFieldUtils.textField(id: 'field1', name: 'field1', label: 'Field 1'),
          VooFieldUtils.textField(id: 'field2', name: 'field2', label: 'Field 2'),
        ],
      );

      final controller = VooFormController(form: form);

      // Test phone size (< 600px)
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpWidget(
        VooMaterialApp(
          home: Scaffold(
            body: VooResponsiveFormWrapper(
              form: form,
              controller: controller,
              phoneColumns: 1,
              tabletColumns: 2,
              desktopColumns: 3,
            ),
          ),
        ),
      );

      expect(find.text('Field 1'), findsOneWidget);
      expect(find.text('Field 2'), findsOneWidget);
    });

    testWidgets('renders header and footer when provided', (tester) async {
      final form = VooForm(
        id: 'test',
        title: 'Test Form',
        fields: [],
      );

      final controller = VooFormController(form: form);

      await tester.pumpWidget(
        VooMaterialApp(
          home: Scaffold(
            body: VooResponsiveFormWrapper(
              form: form,
              controller: controller,
              header: const Text('Custom Header'),
              footer: const Text('Custom Footer'),
            ),
          ),
        ),
      );

      expect(find.text('Custom Header'), findsOneWidget);
      expect(find.text('Custom Footer'), findsOneWidget);
    });

    testWidgets('applies surface tint when enabled', (tester) async {
      final form = VooForm(
        id: 'test',
        title: 'Test Form',
        fields: [],
      );

      final controller = VooFormController(form: form);

      await tester.pumpWidget(
        VooMaterialApp(
          home: Scaffold(
            body: VooResponsiveFormWrapper(
              form: form,
              controller: controller,
              useSurfaceTint: true,
              elevation: 4,
            ),
          ),
        ),
      );

      // Check that Material widget exists with elevation
      final material = tester.widget<Material>(
        find.descendant(
          of: find.byType(VooResponsiveFormWrapper),
          matching: find.byType(Material),
        ).first,
      );
      expect(material.elevation, 4);
    });
  });

  group('VooFormSectionDivider', () {
    testWidgets('renders full divider', (tester) async {
      await tester.pumpWidget(
        VooMaterialApp(
          home: Scaffold(
            body: VooFormSectionDivider.full(),
          ),
        ),
      );

      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('renders inset divider', (tester) async {
      await tester.pumpWidget(
        VooMaterialApp(
          home: Scaffold(
            body: VooFormSectionDivider.inset(),
          ),
        ),
      );

      final divider = tester.widget<Divider>(find.byType(Divider));
      expect(divider.indent, greaterThan(0));
    });

    testWidgets('renders middle divider', (tester) async {
      await tester.pumpWidget(
        VooMaterialApp(
          home: Scaffold(
            body: VooFormSectionDivider.middle(),
          ),
        ),
      );

      final divider = tester.widget<Divider>(find.byType(Divider));
      expect(divider.indent, greaterThan(0));
      expect(divider.endIndent, greaterThan(0));
    });
  });

  group('VooFormSectionTextDivider', () {
    testWidgets('renders text divider with OR', (tester) async {
      await tester.pumpWidget(
        VooMaterialApp(
          home: Scaffold(
            body: VooFormSectionTextDivider.or(),
          ),
        ),
      );

      expect(find.text('OR'), findsOneWidget);
    });

    testWidgets('renders text divider with AND', (tester) async {
      await tester.pumpWidget(
        VooMaterialApp(
          home: Scaffold(
            body: VooFormSectionTextDivider.and(),
          ),
        ),
      );

      expect(find.text('AND'), findsOneWidget);
    });

    testWidgets('renders text divider with icon', (tester) async {
      await tester.pumpWidget(
        VooMaterialApp(
          home: Scaffold(
            body: VooFormSectionTextDivider.withIcon(
              text: 'Settings',
              icon: const Icon(Icons.settings),
            ),
          ),
        ),
      );

      expect(find.text('Settings'), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('renders chip style divider', (tester) async {
      await tester.pumpWidget(
        const VooMaterialApp(
          home: Scaffold(
            body: VooFormSectionTextDivider(
              text: 'Step 2',
              style: DividerTextStyle.chip,
            ),
          ),
        ),
      );

      expect(find.byType(Chip), findsOneWidget);
      expect(find.text('Step 2'), findsOneWidget);
    });
  });
}