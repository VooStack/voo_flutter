import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/actions/voo_form_actions.dart';

void main() {
  group('VooFormActions', () {
    testWidgets('shows submit button by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooFormActions(),
          ),
        ),
      );

      expect(find.text('Submit'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('shows cancel button when configured', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormActions(
              showCancel: true,
              onCancel: () {},
            ),
          ),
        ),
      );

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('uses custom button text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormActions(
              submitText: 'Save',
              cancelText: 'Discard',
              showCancel: true,
              onCancel: () {},
            ),
          ),
        ),
      );

      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Discard'), findsOneWidget);
    });

    testWidgets('calls onSubmit when submit button is tapped', (WidgetTester tester) async {
      bool submitCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormActions(
              onSubmit: () {
                submitCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Submit'));
      await tester.pump();

      expect(submitCalled, true);
    });

    testWidgets('calls onCancel when cancel button is tapped', (WidgetTester tester) async {
      bool cancelCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormActions(
              showCancel: true,
              onCancel: () {
                cancelCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Cancel'));
      await tester.pump();

      expect(cancelCalled, true);
    });

    testWidgets('disables buttons when not enabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormActions(
              submitEnabled: false,
              cancelEnabled: false,
              showCancel: true,
              onSubmit: () {},
              onCancel: () {},
            ),
          ),
        ),
      );

      final submitButton = tester.widget<FilledButton>(find.byType(FilledButton));
      final cancelButton = tester.widget<TextButton>(find.byType(TextButton));

      expect(submitButton.onPressed, isNull);
      expect(cancelButton.onPressed, isNull);
    });

    testWidgets('shows loading indicator when isLoading is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooFormActions(
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Submit'), findsNothing);
    });

    testWidgets('respects button alignment', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooFormActions(
              alignment: MainAxisAlignment.center,
            ),
          ),
        ),
      );

      final row = tester.widget<Row>(find.byType(Row));
      expect(row.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('respects button spacing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormActions(
              showCancel: true,
              onCancel: () {},
              spacing: 16.0,
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.byType(SizedBox).where((widget) {
          final box = widget as SizedBox;
          return box.width == 16.0;
        }),
      );
      expect(sizedBox.width, 16.0);
    });

    testWidgets('uses different button types', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormActions(
              submitButtonType: ButtonType.outlined,
              cancelButtonType: ButtonType.filled,
              showCancel: true,
              onCancel: () {},
            ),
          ),
        ),
      );

      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('returns empty widget when no buttons shown', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooFormActions(
              showSubmit: false,
              showCancel: false,
            ),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.text('Submit'), findsNothing);
      expect(find.text('Cancel'), findsNothing);
    });

    testWidgets('disables cancel when loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormActions(
              isLoading: true,
              showCancel: true,
              onCancel: () {},
            ),
          ),
        ),
      );

      final cancelButton = tester.widget<TextButton>(find.byType(TextButton));
      expect(cancelButton.onPressed, isNull);
    });
  });
}