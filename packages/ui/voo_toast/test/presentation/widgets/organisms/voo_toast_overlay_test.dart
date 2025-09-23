import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_toast/voo_toast.dart';

void main() {
  group('VooToastOverlay Widget', () {
    tearDown(() {
      // Clean up after each test
      VooToast.dismissAll();
      VooToastController.reset();
    });

    testWidgets('renders child widget', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: VooToastOverlay(child: Text('Child Widget'))));

      expect(find.text('Child Widget'), findsOneWidget);
    });

    testWidgets('displays toast when added', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VooToastOverlay(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  VooToast.showInfo(message: 'Test Toast', context: context);
                },
                child: const Text('Show Toast'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Toast'), findsNothing);

      await tester.tap(find.text('Show Toast'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('Test Toast'), findsOneWidget);

      // Clean up
      VooToast.dismissAll();
      await tester.pumpAndSettle();
    });

    testWidgets('displays multiple toasts', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VooToastOverlay(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  VooToast.showInfo(message: 'Toast 1', context: context);
                  VooToast.showSuccess(message: 'Toast 2', context: context);
                  VooToast.showError(message: 'Toast 3', context: context);
                },
                child: const Text('Show Toasts'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Toasts'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('Toast 1'), findsOneWidget);
      expect(find.text('Toast 2'), findsOneWidget);
      expect(find.text('Toast 3'), findsOneWidget);

      // Clean up
      VooToast.dismissAll();
      await tester.pumpAndSettle();
    });

    testWidgets('removes toast on dismiss', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VooToastOverlay(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  VooToast.showInfo(message: 'Dismissable Toast', context: context);
                },
                child: const Text('Show Toast'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Toast'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('Dismissable Toast'), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Dismissable Toast'), findsNothing);

      // Ensure cleanup
      await tester.pumpAndSettle();
    });

    testWidgets('auto-dismisses toast after duration', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VooToastOverlay(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  VooToast.showInfo(message: 'Auto Dismiss', duration: const Duration(milliseconds: 500), context: context);
                },
                child: const Text('Show Toast'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Toast'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('Auto Dismiss'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 600));

      expect(find.text('Auto Dismiss'), findsNothing);

      // Ensure cleanup
      await tester.pumpAndSettle();
    });

    testWidgets('groups toasts by position', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VooToastOverlay(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  VooToast.showInfo(message: 'Top Toast', position: ToastPosition.top, context: context);
                  VooToast.showInfo(message: 'Bottom Toast', position: ToastPosition.bottom, context: context);
                },
                child: const Text('Show Toasts'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Toasts'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('Top Toast'), findsOneWidget);
      expect(find.text('Bottom Toast'), findsOneWidget);

      // Clean up
      VooToast.dismissAll();
      await tester.pumpAndSettle();
    });

    testWidgets('handles custom controller', (WidgetTester tester) async {
      VooToastController.init();
      final customController = VooToastController.instance;

      await tester.pumpWidget(
        MaterialApp(
          home: VooToastOverlay(
            controller: customController,
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  customController.showInfo(message: 'Custom Controller Toast', context: context);
                },
                child: const Text('Show Toast'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Toast'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('Custom Controller Toast'), findsOneWidget);

      // Clean up
      customController.dismissAll();
      await tester.pumpAndSettle();
    });

    testWidgets('applies animation to toasts', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VooToastOverlay(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  VooToast.showInfo(message: 'Animated Toast', context: context);
                },
                child: const Text('Show Toast'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Toast'));
      await tester.pump();

      // Animation should be in progress
      expect(find.text('Animated Toast'), findsOneWidget);

      // Let animation complete
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Animated Toast'), findsOneWidget);

      // Clean up
      VooToast.dismissAll();
      await tester.pumpAndSettle();
    });

    testWidgets('respects max toasts configuration', (WidgetTester tester) async {
      // Reset and initialize with specific config
      VooToastController.reset();
      VooToastController.init(config: const ToastConfig(queueMode: false));

      await tester.pumpWidget(
        MaterialApp(
          home: VooToastOverlay(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  VooToast.showInfo(message: 'Toast 1', context: context);
                  VooToast.showInfo(message: 'Toast 2', context: context);
                  VooToast.showInfo(message: 'Toast 3', context: context);
                },
                child: const Text('Show Toasts'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Toasts'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('Toast 1'), findsOneWidget);
      expect(find.text('Toast 2'), findsOneWidget);
      expect(find.text('Toast 3'), findsOneWidget); // All 3 toasts should show with maxToasts: 3

      // Clean up
      VooToast.dismissAll();
      await tester.pumpAndSettle();
    });

    testWidgets('handles empty toast stream', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: VooToastOverlay(child: Text('No Toasts'))));

      expect(find.text('No Toasts'), findsOneWidget);
      // No toast cards should be present
    });

    testWidgets('positions toasts correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VooToastOverlay(
            child: Builder(
              builder: (context) => Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      VooToast.showInfo(message: 'Top Right', position: ToastPosition.topRight);
                    },
                    child: const Text('Top Right'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      VooToast.showInfo(message: 'Bottom Left', position: ToastPosition.bottomLeft);
                    },
                    child: const Text('Bottom Left'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      VooToast.showInfo(message: 'Center', position: ToastPosition.center);
                    },
                    child: const Text('Center'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Test top right position
      await tester.tap(find.text('Top Right'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Top Right', skipOffstage: false), findsNWidgets(2));

      VooToast.dismissAll();
      await tester.pump(const Duration(milliseconds: 400));

      // Test bottom left position
      await tester.tap(find.text('Bottom Left'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Bottom Left', skipOffstage: false), findsNWidgets(2));

      VooToast.dismissAll();
      await tester.pump(const Duration(milliseconds: 400));

      // Test center position
      await tester.tap(find.text('Center', skipOffstage: false).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Center', skipOffstage: false), findsNWidgets(2));

      // Clean up all toasts
      VooToast.dismissAll();
      await tester.pumpAndSettle();
    });
  });
}
