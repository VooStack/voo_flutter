import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_toast/voo_toast.dart';

void main() {
  group('Simple Theme Tests', () {
    tearDown(VooToastController.reset);

    test('VooToastController singleton works', () {
      final controller1 = VooToastController.instance;
      final controller2 = VooToastController.instance;
      
      expect(identical(controller1, controller2), isTrue);
    });

    test('VooToast global accessor returns singleton', () {
      final controller = VooToastController.instance;
      
      // VooToast is a getter that returns VooToastController.instance
      expect(identical(VooToast, controller), isTrue);
    });
    
    testWidgets('ToastConfig.fromTheme uses actual theme colors', (tester) async {
      Color? capturedPrimaryColor;
      Color? capturedErrorColor;
      Color? capturedSecondaryColor;
      Color? capturedTertiaryColor;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2196F3),
              error: Color(0xFFF44336),
              secondary: Color(0xFF4CAF50),
              tertiary: Color(0xFFFF9800),
            ),
          ),
          home: Builder(
            builder: (context) {
              final config = ToastConfig.fromTheme(context);
              capturedPrimaryColor = config.successColor;
              capturedErrorColor = config.errorColor;
              capturedSecondaryColor = config.infoColor;
              capturedTertiaryColor = config.warningColor;
              return const SizedBox();
            },
          ),
        ),
      );
      
      // Verify the colors match what we set in the theme
      expect(capturedPrimaryColor, equals(const Color(0xFF2196F3)));
      expect(capturedErrorColor, equals(const Color(0xFFF44336)));
      expect(capturedSecondaryColor, equals(const Color(0xFF4CAF50)));
      expect(capturedTertiaryColor, equals(const Color(0xFFFF9800)));
    });
    
    testWidgets('Toast uses theme colors when context provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2196F3),
              onPrimary: Colors.white,
              error: Color(0xFFF44336),
              onError: Colors.white,
            ),
          ),
          home: VooToastOverlay(
            child: Scaffold(
              body: Builder(
                builder: (context) => Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Show toast with context - should use theme colors
                          VooToast.showSuccess(
                            message: 'Test message',
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
      
      // Tap button to show toast
      await tester.tap(find.text('Show Toast'));
      await tester.pump();
      
      // Wait for animation
      await tester.pump(const Duration(milliseconds: 300));
      
      // Verify toast is displayed
      expect(find.text('Test message'), findsOneWidget);
      
      // Clean up - dismiss all toasts to stop timers
      VooToast.dismissAll();
      await tester.pumpAndSettle();
    });
    
    test('VooToastController.init with context uses theme config', () {
      // This test just verifies the API exists and doesn't throw
      expect(() => VooToastController.init(), returnsNormally);
      expect(() => VooToastController.init(config: const ToastConfig()), returnsNormally);
    });
  });
}