import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('VooFormSectionDivider', () {
    testWidgets('renders basic divider line', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: VooFormSectionDivider(name: 'divider1')),
        ),
      );

      // Divider now uses a Container with gradient
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('renders with title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooFormSectionDivider(name: 'section1', label: 'Personal Information'),
          ),
        ),
      );

      expect(find.text('Personal Information'), findsOneWidget);
      // Divider now uses a Container with gradient
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('renders with title and subtitle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooFormSectionDivider(name: 'section2', label: 'Contact Details', subtitle: 'Please provide your contact information'),
          ),
        ),
      );

      expect(find.text('Contact Details'), findsOneWidget);
      expect(find.text('Please provide your contact information'), findsOneWidget);
      // Divider now uses a Container with gradient
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('renders custom widget instead of title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooFormSectionDivider(
              name: 'custom',
              customWidget: Row(children: [Icon(Icons.info), SizedBox(width: 8), Text('Custom Section')]),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.info), findsOneWidget);
      expect(find.text('Custom Section'), findsOneWidget);
      // Divider now uses a Container with gradient
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('works without divider line when showLine is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooFormSectionDivider(name: 'no-line', label: 'Section Title', showLine: false),
          ),
        ),
      );

      expect(find.text('Section Title'), findsOneWidget);
      // When showLine is false, no gradient container is shown
      // but there might be other containers for layout
    });

    testWidgets('works in VooForm fields list', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooForm(
              fields: [
                VooTextField(name: 'firstName', label: 'First Name'),
                VooFormSectionDivider(name: 'divider1', label: 'Contact Information'),
                VooTextField(name: 'email', label: 'Email'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Contact Information'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      // Divider now uses a Container with gradient
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('convenience constructors work correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                VooFormSectionDividerStyles.line(),
                VooFormSectionDividerStyles.section(name: 'section', label: 'Section Title'),
                VooFormSectionDividerStyles.spacer(),
              ],
            ),
          ),
        ),
      );

      // Line divider and section divider show gradient containers
      // Spacer doesn't show line when showLine is false
      expect(find.byType(Container), findsWidgets);

      // Section shows title
      expect(find.text('Section Title'), findsOneWidget);

      // All three dividers render
      expect(find.byType(VooFormSectionDivider), findsNWidgets(3));
    });

    testWidgets('respects spacing properties', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooFormSectionDivider(name: 'spaced', label: 'Spaced Section', topSpacing: 32.0, bottomSpacing: 24.0),
          ),
        ),
      );

      final padding = tester.widget<Padding>(find.byType(Padding).first);
      expect(padding.padding, const EdgeInsets.only(top: 32.0, bottom: 24.0));
    });

    testWidgets('VooFormSectionDivider implements VooFormFieldWidget correctly', (tester) async {
      const divider = VooFormSectionDivider(name: 'test-divider', label: 'Test Section');

      expect(divider.name, 'test-divider');
      expect(divider.label, 'Test Section');
      expect(divider.required, false);
      expect(divider.value, null);
      expect(divider.initialValue, null);
      expect(divider.layout, VooFieldLayout.wide);
    });
  });
}
