import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_toast/src/domain/entities/toast.dart';
import 'package:voo_toast/src/domain/entities/toast_config.dart';
import 'package:voo_toast/src/domain/enums/toast_animation.dart';
import 'package:voo_toast/src/domain/enums/toast_position.dart';
import 'package:voo_toast/src/domain/enums/toast_type.dart';
import 'package:voo_toast/src/presentation/widgets/molecules/voo_toast_card.dart';

void main() {
  const defaultConfig = ToastConfig();

  group('VooToastCard Widget', () {
    testWidgets('displays basic toast message', (WidgetTester tester) async {
      const toast = Toast(id: 'test-1', message: 'Test message', position: ToastPosition.bottom, animation: ToastAnimation.fade);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooToastCard(toast: toast, onDismiss: () {}, config: defaultConfig),
          ),
        ),
      );

      expect(find.text('Test message'), findsOneWidget);
    });

    testWidgets('displays toast with title', (WidgetTester tester) async {
      const toast = Toast(
        id: 'test-1',
        message: 'Test message',
        title: 'Test Title',
        type: ToastType.success,
        position: ToastPosition.bottom,
        animation: ToastAnimation.fade,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooToastCard(toast: toast, onDismiss: () {}, config: defaultConfig),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test message'), findsOneWidget);
    });

    testWidgets('displays close button when enabled', (WidgetTester tester) async {
      const toast = Toast(id: 'test-1', message: 'Test message', position: ToastPosition.bottom, animation: ToastAnimation.fade);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooToastCard(toast: toast, onDismiss: () {}, config: defaultConfig),
          ),
        ),
      );

      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    });

    testWidgets('hides close button when disabled', (WidgetTester tester) async {
      const toast = Toast(id: 'test-1', message: 'Test message', showCloseButton: false, position: ToastPosition.bottom, animation: ToastAnimation.fade);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooToastCard(toast: toast, onDismiss: () {}, config: defaultConfig),
          ),
        ),
      );

      expect(find.byIcon(Icons.close_rounded), findsNothing);
    });

    testWidgets('calls onDismiss when close button tapped', (WidgetTester tester) async {
      var dismissed = false;

      const toast = Toast(id: 'test-1', message: 'Test message', position: ToastPosition.bottom, animation: ToastAnimation.fade);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooToastCard(
              toast: toast,
              config: defaultConfig,
              onDismiss: () {
                dismissed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();

      expect(dismissed, true);
    });

    testWidgets('displays action buttons', (WidgetTester tester) async {
      var actionPressed = false;

      final toast = Toast(
        id: 'test-1',
        message: 'Test message',
        position: ToastPosition.bottom,
        animation: ToastAnimation.fade,
        actions: [
          ToastAction(
            label: 'Action',
            onPressed: () {
              actionPressed = true;
            },
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooToastCard(toast: toast, onDismiss: () {}, config: defaultConfig),
          ),
        ),
      );

      expect(find.text('Action'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);

      await tester.tap(find.text('Action'));
      await tester.pump();

      expect(actionPressed, true);
    });

    testWidgets('displays custom content when provided', (WidgetTester tester) async {
      const customWidget = Text('Custom Widget Content');

      const toast = Toast(
        id: 'test-1',
        message: '',
        type: ToastType.custom,
        position: ToastPosition.bottom,
        animation: ToastAnimation.fade,
        customContent: customWidget,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooToastCard(toast: toast, onDismiss: () {}, config: defaultConfig),
          ),
        ),
      );

      expect(find.text('Custom Widget Content'), findsOneWidget);
    });

    testWidgets('shows progress bar when enabled', (WidgetTester tester) async {
      const toast = Toast(id: 'test-1', message: 'Test message', showProgressBar: true, position: ToastPosition.bottom, animation: ToastAnimation.fade);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooToastCard(toast: toast, onDismiss: () {}, config: defaultConfig),
          ),
        ),
      );

      expect(find.byType(TweenAnimationBuilder<double>), findsWidgets);
    });

    testWidgets('hides progress bar when duration is zero', (WidgetTester tester) async {
      const toast = Toast(
        id: 'test-1',
        message: 'Test message',
        showProgressBar: true,
        duration: Duration.zero,
        position: ToastPosition.bottom,
        animation: ToastAnimation.fade,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooToastCard(toast: toast, onDismiss: () {}, config: defaultConfig),
          ),
        ),
      );

      // Progress bar should not be shown for zero duration
      expect(find.byType(TweenAnimationBuilder<double>), findsNothing);
    });

    testWidgets('applies correct colors for different toast types', (WidgetTester tester) async {
      final testCases = [
        (ToastType.success, 'Success toast'),
        (ToastType.error, 'Error toast'),
        (ToastType.warning, 'Warning toast'),
        (ToastType.info, 'Info toast'),
      ];

      for (final testCase in testCases) {
        final toast = Toast(id: 'test-${testCase.$1}', message: testCase.$2, type: testCase.$1, position: ToastPosition.bottom, animation: ToastAnimation.fade);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VooToastCard(toast: toast, onDismiss: () {}, config: defaultConfig),
            ),
          ),
        );

        expect(find.text(testCase.$2), findsOneWidget);

        // Clean up for next iteration
        await tester.pumpWidget(Container());
      }
    });

    testWidgets('handles onTap callback', (WidgetTester tester) async {
      var tapped = false;

      final toast = Toast(
        id: 'test-1',
        message: 'Tap me',
        position: ToastPosition.bottom,
        animation: ToastAnimation.fade,
        onTap: () {
          tapped = true;
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooToastCard(toast: toast, onDismiss: () {}, config: defaultConfig),
          ),
        ),
      );

      await tester.tap(find.text('Tap me'));
      await tester.pump();

      expect(tapped, true);
    });

    testWidgets('applies custom styling properties', (WidgetTester tester) async {
      final toast = Toast(
        id: 'test-1',
        message: 'Styled toast',
        type: ToastType.custom,
        position: ToastPosition.bottom,
        animation: ToastAnimation.fade,
        backgroundColor: Colors.purple,
        textColor: Colors.yellow,
        borderRadius: BorderRadius.circular(20),
        elevation: 10,
        padding: const EdgeInsets.all(20),
        maxWidth: 300,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooToastCard(toast: toast, onDismiss: () {}, config: defaultConfig),
          ),
        ),
      );

      expect(find.text('Styled toast'), findsOneWidget);

      final material = tester.widget<Material>(find.descendant(of: find.byType(VooToastCard), matching: find.byType(Material)).first);

      expect(material.borderRadius, BorderRadius.circular(20));
    });

    testWidgets('displays icon for toast types', (WidgetTester tester) async {
      const toast = Toast(id: 'test-1', message: 'Test with icon', type: ToastType.success, position: ToastPosition.bottom, animation: ToastAnimation.fade);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooToastCard(toast: toast, onDismiss: () {}, config: defaultConfig),
          ),
        ),
      );

      // Should find an icon widget
      expect(find.byType(Icon), findsWidgets);
    });

    testWidgets('custom icon size is applied', (WidgetTester tester) async {
      const toast = Toast(id: 'test-1', message: 'Test message', position: ToastPosition.bottom, animation: ToastAnimation.fade);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooToastCard(toast: toast, onDismiss: _dummyCallback, iconSize: 32.0, config: ToastConfig()),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byType(Icon).first);

      expect(icon.size, 32.0);
    });
  });
}

void _dummyCallback() {}
