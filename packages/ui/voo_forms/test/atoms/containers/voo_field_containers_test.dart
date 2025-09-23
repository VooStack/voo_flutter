import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('VooFieldColumn', () {
    testWidgets('arranges fields vertically', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooFieldColumn(
              name: 'column1',
              fields: [
                VooTextField(name: 'field1', label: 'Field 1'),
                VooTextField(name: 'field2', label: 'Field 2'),
                VooTextField(name: 'field3', label: 'Field 3'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Field 1'), findsOneWidget);
      expect(find.text('Field 2'), findsOneWidget);
      expect(find.text('Field 3'), findsOneWidget);

      // Verify vertical arrangement
      final field1 = tester.getTopLeft(find.text('Field 1'));
      final field2 = tester.getTopLeft(find.text('Field 2'));
      final field3 = tester.getTopLeft(find.text('Field 3'));

      expect(field2.dy > field1.dy, isTrue);
      expect(field3.dy > field2.dy, isTrue);
    });

    testWidgets('shows title when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooFieldColumn(
              name: 'column2',
              label: 'Personal Details',
              fields: [
                VooTextField(name: 'firstName', label: 'First Name'),
                VooTextField(name: 'lastName', label: 'Last Name'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Personal Details'), findsOneWidget);
      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);
    });

    testWidgets('works in VooForm', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooForm(
              fields: [
                VooFieldColumn(
                  name: 'personalInfo',
                  label: 'Personal Information',
                  fields: [
                    VooTextField(name: 'firstName', label: 'First Name'),
                    VooTextField(name: 'lastName', label: 'Last Name'),
                  ],
                ),
                VooFormSectionDivider(name: 'divider'),
                VooFieldColumn(
                  name: 'contactInfo',
                  label: 'Contact Information',
                  fields: [
                    VooEmailField(name: 'email', label: 'Email'),
                    VooPhoneField(name: 'phone', label: 'Phone'),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Personal Information'), findsOneWidget);
      expect(find.text('Contact Information'), findsOneWidget);
      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
    });
  });

  group('VooFieldRow', () {
    testWidgets('arranges fields horizontally', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooFieldRow(
              name: 'row1',
              fields: [
                VooTextField(name: 'field1', label: 'Field 1'),
                VooTextField(name: 'field2', label: 'Field 2'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Field 1'), findsOneWidget);
      expect(find.text('Field 2'), findsOneWidget);

      // Verify horizontal arrangement
      final field1 = tester.getTopLeft(find.text('Field 1'));
      final field2 = tester.getTopLeft(find.text('Field 2'));

      expect(field2.dx > field1.dx, isTrue);
      expect((field2.dy - field1.dy).abs() < 5, isTrue); // Same vertical position
    });

    testWidgets('shows title when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooFieldRow(
              name: 'row2',
              label: 'Name Fields',
              fields: [
                VooTextField(name: 'firstName', label: 'First'),
                VooTextField(name: 'lastName', label: 'Last'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Name Fields'), findsOneWidget);
      expect(find.text('First'), findsOneWidget);
      expect(find.text('Last'), findsOneWidget);
    });

    testWidgets('expands fields when expandFields is true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 600,
              child: VooFieldRow(
                name: 'row3',
                expandFields: true,
                fields: [
                  VooTextField(name: 'field1', label: 'Field 1'),
                  VooTextField(name: 'field2', label: 'Field 2'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Field 1'), findsOneWidget);
      expect(find.text('Field 2'), findsOneWidget);
    });

    testWidgets('uses custom flex values', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 600,
              child: VooFieldRow(
                name: 'row4',
                expandFields: true,
                fieldFlex: [2, 1],
                fields: [
                  VooTextField(name: 'field1', label: 'Field 1'),
                  VooTextField(name: 'field2', label: 'Field 2'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Field 1'), findsOneWidget);
      expect(find.text('Field 2'), findsOneWidget);
    });

    testWidgets('works in VooForm with nested structure', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooForm(
              fields: [
                VooFieldRow(
                  name: 'nameRow',
                  label: 'Full Name',
                  expandFields: true,
                  fields: [
                    VooTextField(name: 'firstName', label: 'First Name'),
                    VooTextField(name: 'lastName', label: 'Last Name'),
                  ],
                ),
                VooFormSectionDivider(name: 'divider'),
                VooFieldRow(
                  name: 'contactRow',
                  label: 'Contact',
                  expandFields: true,
                  fields: [
                    VooEmailField(name: 'email', label: 'Email'),
                    VooPhoneField(name: 'phone', label: 'Phone'),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Contact'), findsOneWidget);
      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
    });
  });

  group('Combined layouts', () {
    testWidgets('VooFieldColumn can contain VooFieldRow', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooForm(
              fields: [
                VooFieldColumn(
                  name: 'mainColumn',
                  label: 'User Information',
                  fields: [
                    VooFieldRow(
                      name: 'nameRow',
                      expandFields: true,
                      fields: [
                        VooTextField(name: 'firstName', label: 'First'),
                        VooTextField(name: 'lastName', label: 'Last'),
                      ],
                    ),
                    VooEmailField(name: 'email', label: 'Email'),
                    VooFieldRow(
                      name: 'addressRow',
                      expandFields: true,
                      fields: [
                        VooTextField(name: 'city', label: 'City'),
                        VooTextField(name: 'state', label: 'State'),
                        VooTextField(name: 'zip', label: 'ZIP'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('User Information'), findsOneWidget);
      expect(find.text('First'), findsOneWidget);
      expect(find.text('Last'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('City'), findsOneWidget);
      expect(find.text('State'), findsOneWidget);
      expect(find.text('ZIP'), findsOneWidget);
    });
  });
}
