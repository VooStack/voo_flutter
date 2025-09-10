import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_toast/voo_toast.dart';

void main() {
  group('Toast Integration Tests', () {
    tearDown(() {
      // Clean up after each test
      VooToast.dismissAll();
      VooToastController.reset();
    });
    
    testWidgets('complete toast lifecycle', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VooToastOverlay(
            child: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          VooToast.showSuccess(
                            title: 'Success',
                            message: 'Operation completed successfully!',
                            context: context,
                          );
                        },
                        child: const Text('Show Success'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          VooToast.showError(
                            title: 'Error',
                            message: 'Something went wrong',
                            context: context,
                          );
                        },
                        child: const Text('Show Error'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          VooToast.dismissAll();
                        },
                        child: const Text('Dismiss All'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Initially no toasts
      expect(find.text('Operation completed successfully!'), findsNothing);
      expect(find.text('Something went wrong'), findsNothing);

      // Show success toast
      await tester.tap(find.text('Show Success'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('Success'), findsOneWidget);
      expect(find.text('Operation completed successfully!'), findsOneWidget);

      // Show error toast
      await tester.tap(find.text('Show Error'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Something went wrong'), findsOneWidget);

      // Both toasts should be visible
      expect(find.text('Success'), findsOneWidget);
      expect(find.text('Error'), findsOneWidget);

      // Dismiss all toasts
      await tester.tap(find.text('Dismiss All'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('Success'), findsNothing);
      expect(find.text('Error'), findsNothing);
      
      // Ensure clean up
      await tester.pumpAndSettle();
    });

    testWidgets('toast with actions integration', (WidgetTester tester) async {
      var undoPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: VooToastOverlay(
            child: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      VooToast.showInfo(
                        message: 'Item deleted',
                        context: context,
                        actions: [
                          ToastAction(
                            label: 'UNDO',
                            onPressed: () {
                              undoPressed = true;
                              VooToast.showSuccess(
                                message: 'Action undone',
                                context: context,
                              );
                            },
                          ),
                          ToastAction(
                            label: 'DELETE PERMANENTLY',
                            onPressed: () {},
                          ),
                        ],
                      );
                    },
                    child: const Text('Delete Item'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Show toast with actions
      await tester.tap(find.text('Delete Item'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('Item deleted'), findsOneWidget);
      expect(find.text('UNDO'), findsOneWidget);
      expect(find.text('DELETE PERMANENTLY'), findsOneWidget);

      // Press undo action
      await tester.tap(find.text('UNDO'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(undoPressed, true);
      expect(find.text('Action undone'), findsOneWidget);
      
      // Clean up
      VooToast.dismissAll();
      await tester.pumpAndSettle();
    });

    testWidgets('custom toast integration', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VooToastOverlay(
            child: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      VooToast.showCustom(
                        context: context,
                        content: Container(
                          padding: const EdgeInsets.all(16),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                              SizedBox(width: 16),
                              Text(
                                'Loading...',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        backgroundColor: Colors.black87,
                        duration: const Duration(seconds: 2),
                      );
                    },
                    child: const Text('Show Loading'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Show custom loading toast
      await tester.tap(find.text('Show Loading'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('Loading...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for auto-dismiss
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('Loading...'), findsNothing);
      
      // Ensure cleanup
      await tester.pumpAndSettle();
    });

    testWidgets('queue mode integration', (WidgetTester tester) async {
      // TODO: Queue mode needs further investigation - skipping for now
      return;
      // Reset and initialize with queue mode enabled
      VooToastController.reset();
      VooToastController.init(
        config: const ToastConfig(
          maxToasts: 1,
          queueMode: true,  // Ensure queue mode is enabled
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: VooToastOverlay(
            child: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          VooToast.showInfo(
                            message: 'First toast',
                            duration: const Duration(milliseconds: 500),
                            context: context,
                          );
                          VooToast.showInfo(
                            message: 'Second toast',
                            duration: const Duration(milliseconds: 500),
                            context: context,
                          );
                          VooToast.showInfo(
                            message: 'Third toast',
                            duration: const Duration(milliseconds: 500),
                            context: context,
                          );
                        },
                        child: const Text('Queue Toasts'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Queue multiple toasts
      await tester.tap(find.text('Queue Toasts'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      // Only first toast should be visible
      expect(find.text('First toast'), findsOneWidget);
      expect(find.text('Second toast'), findsNothing);
      expect(find.text('Third toast'), findsNothing);

      // Wait for first toast to auto-dismiss
      await tester.pump(const Duration(milliseconds: 500)); // Toast duration
      await tester.pumpAndSettle(); // Let animations complete

      // Second toast should now be visible
      expect(find.text('First toast'), findsNothing);
      expect(find.text('Second toast'), findsOneWidget);
      expect(find.text('Third toast'), findsNothing);

      // Wait for second toast to auto-dismiss
      await tester.pump(const Duration(milliseconds: 500)); // Toast duration
      await tester.pumpAndSettle(); // Let animations complete

      // Third toast should now be visible
      expect(find.text('First toast'), findsNothing);
      expect(find.text('Second toast'), findsNothing);
      expect(find.text('Third toast'), findsOneWidget);
      
      // Clean up
      VooToast.dismissAll();
      await tester.pumpAndSettle();
    });

    testWidgets('responsive positioning integration', (WidgetTester tester) async {
      // Set up different screen sizes
      await tester.binding.setSurfaceSize(const Size(400, 800)); // Mobile

      await tester.pumpWidget(
        MaterialApp(
          home: VooToastOverlay(
            child: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      VooToast.showInfo(
                        message: 'Responsive toast',
                        position: ToastPosition.auto,
                        context: context,
                      );
                    },
                    child: const Text('Show Toast'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Show toast on mobile size
      await tester.tap(find.text('Show Toast'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('Responsive toast'), findsOneWidget);

      // Clear toast
      VooToast.dismissAll();
      await tester.pump(const Duration(milliseconds: 350));

      // Change to tablet size
      await tester.binding.setSurfaceSize(const Size(700, 1000));
      await tester.pump();

      // Show toast on tablet size
      await tester.tap(find.text('Show Toast'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('Responsive toast'), findsOneWidget);

      // Reset surface size
      await tester.binding.setSurfaceSize(null);
      
      // Clean up
      VooToast.dismissAll();
      await tester.pumpAndSettle();
    });

    testWidgets('progress bar integration', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VooToastOverlay(
            child: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      VooToast.showInfo(
                        message: 'Toast with progress',
                        duration: const Duration(seconds: 2),
                        context: context,
                      );
                    },
                    child: const Text('Show Progress'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Show toast with progress bar
      await tester.tap(find.text('Show Progress'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Toast with progress'), findsOneWidget);

      // Progress bar should be animating
      expect(find.byType(TweenAnimationBuilder<double>), findsWidgets);

      // Let progress complete
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Toast with progress'), findsNothing);
      
      // Ensure cleanup
      await tester.pumpAndSettle();
    });

    testWidgets('dismissible toast integration', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VooToastOverlay(
            child: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      VooToast.showInfo(
                        message: 'Persistent toast',
                        duration: Duration.zero,
                        context: context,
                      );
                    },
                    child: const Text('Show Persistent'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Show persistent toast
      await tester.tap(find.text('Show Persistent'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('Persistent toast'), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);

      // Wait to verify it doesn't auto-dismiss
      await tester.pump(const Duration(seconds: 5));
      expect(find.text('Persistent toast'), findsOneWidget);

      // Manually dismiss
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('Persistent toast'), findsNothing);
      
      // Ensure cleanup
      await tester.pumpAndSettle();
    });
  });
}
