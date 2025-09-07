import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('VooFileField', () {
    Widget wrapInApp(Widget child) => MaterialApp(
          home: Scaffold(
            body: child,
          ),
        );

    testWidgets('respects readOnly property', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        wrapInApp(
          VooFileField(
            name: 'file',
            readOnly: true,
            onFileSelected: (file) {
              tapped = true;
            },
          ),
        ),
      );

      // Try to tap the file selection area
      await tester.tap(find.text('Click to select file'));
      await tester.pumpAndSettle();

      // Should not trigger file selection
      expect(tapped, isFalse);
    });

    testWidgets('respects form-level readOnly', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        wrapInApp(
          VooFormScope(
            isReadOnly: true,
            isLoading: false,
            child: VooFileField(
              name: 'file',
              onFileSelected: (file) {
                tapped = true;
              },
            ),
          ),
        ),
      );

      // Try to tap the file selection area
      await tester.tap(find.text('Click to select file'));
      await tester.pumpAndSettle();

      // Should not trigger file selection
      expect(tapped, isFalse);
    });

    testWidgets('action buttons hidden when readOnly', (tester) async {
      final file = VooFile.fromPlatformFile(
        PlatformFile(
          name: 'test.pdf',
          size: 1024,
          path: '/test.pdf',
        ),
      );

      await tester.pumpWidget(
        wrapInApp(
          VooFileField(
            name: 'file',
            initialValue: file,
            readOnly: true,
          ),
        ),
      );

      // File should be displayed
      expect(find.text('test.pdf'), findsOneWidget);

      // Action buttons should not be visible
      expect(find.text('Remove'), findsNothing);
      expect(find.text('Change'), findsNothing);
    });

    testWidgets('displays initial file', (tester) async {
      final file = VooFile.fromPlatformFile(
        PlatformFile(
          name: 'document.docx',
          size: 2048,
          path: '/path/to/document.docx',
        ),
      );

      await tester.pumpWidget(
        wrapInApp(
          VooFileField(
            name: 'file',
            initialValue: file,
          ),
        ),
      );

      // File name should be displayed
      expect(find.text('document.docx'), findsOneWidget);
    });

    testWidgets('displays placeholder when no initial file', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          VooFileField(
            name: 'file',
            buttonText: 'Upload Document',
          ),
        ),
      );

      expect(find.text('Upload Document'), findsOneWidget);
    });

    testWidgets('shows action buttons when file is selected and not readonly', (tester) async {
      final file = VooFile.fromPlatformFile(
        PlatformFile(
          name: 'image.png',
          size: 5120,
          path: '/path/to/image.png',
        ),
      );

      await tester.pumpWidget(
        wrapInApp(
          VooFileField(
            name: 'file',
            initialValue: file,
            readOnly: false,
          ),
        ),
      );

      // File should be displayed
      expect(find.text('image.png'), findsOneWidget);

      // Action buttons should be visible
      expect(find.text('Remove'), findsOneWidget);
      expect(find.text('Change'), findsOneWidget);
    });

    testWidgets('shows allowed extensions when specified', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          VooFileField(
            name: 'file',
            allowedExtensions: const ['pdf', 'doc', 'docx'],
          ),
        ),
      );

      expect(find.text('Allowed: pdf, doc, docx'), findsOneWidget);
    });

    testWidgets('shows custom button icon when provided', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          VooFileField(
            name: 'file',
            buttonIcon: const Icon(Icons.attach_file),
          ),
        ),
      );

      expect(find.byIcon(Icons.attach_file), findsOneWidget);
    });

    testWidgets('applies label when provided', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          VooFileField(
            name: 'file',
            label: 'Upload Resume',
          ),
        ),
      );

      expect(find.text('Upload Resume'), findsOneWidget);
    });

    testWidgets('shows helper text when provided', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          VooFileField(
            name: 'file',
            helper: 'PDF files only, max 5MB',
          ),
        ),
      );

      expect(find.text('PDF files only, max 5MB'), findsOneWidget);
    });

    testWidgets('shows error text when provided', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          VooFileField(
            name: 'file',
            error: 'File is required',
          ),
        ),
      );

      expect(find.text('File is required'), findsOneWidget);
    });

    testWidgets('respects enabled property', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        wrapInApp(
          VooFileField(
            name: 'file',
            enabled: false,
            onFileSelected: (file) {
              tapped = true;
            },
          ),
        ),
      );

      // Try to tap the disabled file field
      await tester.tap(find.text('Click to select file'));
      await tester.pumpAndSettle();

      // Should not trigger file selection
      expect(tapped, isFalse);
    });

  });
}