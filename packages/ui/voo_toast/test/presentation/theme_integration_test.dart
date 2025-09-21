import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_toast/src/presentation/widgets/molecules/voo_toast_card.dart';
import 'package:voo_toast/voo_toast.dart';

void main() {
  group('Theme Integration Tests', () {
    // Reset singleton after each test
    tearDown(VooToastController.reset);

    group('ToastConfig.fromTheme', () {
      testWidgets('creates config with theme colors', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              colorScheme: const ColorScheme.light(
                primary: Colors.blue,
                error: Colors.red,
                secondary: Colors.green,
                tertiary: Colors.orange,
              ),
              textTheme: const TextTheme(
                bodyMedium: TextStyle(fontSize: 14),
                titleSmall: TextStyle(fontSize: 12),
              ),
              cardTheme: const CardThemeData(elevation: 8.0),
            ),
            home: Builder(
              builder: (context) {
                final config = ToastConfig.fromTheme(context);

                // Verify theme colors are applied
                expect(config.successColor, equals(Theme.of(context).colorScheme.primary));
                expect(config.errorColor, equals(Theme.of(context).colorScheme.error));
                expect(config.infoColor, equals(Theme.of(context).colorScheme.secondary));
                expect(config.warningColor, equals(Theme.of(context).colorScheme.tertiary));

                // Verify text styles
                expect(config.textStyle, equals(Theme.of(context).textTheme.bodyMedium));
                expect(config.titleStyle?.fontSize, equals(12));
                expect(config.titleStyle?.fontWeight, equals(FontWeight.bold));

                // Verify elevation from theme
                expect(config.defaultElevation, equals(8.0));

                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('uses theme colors in toast cards', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF1976D2),
                error: Color(0xFFD32F2F),
                secondary: Color(0xFF388E3C),
                onSecondary: Colors.white,
                tertiary: Color(0xFFF57C00),
                onTertiary: Colors.white,
              ),
            ),
            home: VooToastOverlay(
              child: Builder(
                builder: (context) => Scaffold(
                  body: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        VooToast.showSuccess(
                          message: 'Success message',
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
        await tester.pump(const Duration(milliseconds: 350));

        // Verify toast is displayed
        expect(find.text('Success message'), findsOneWidget);

        // Verify we can find the toast card (this confirms it's rendered)
        expect(find.byType(VooToastCard), findsOneWidget);

        // Clean up
        VooToast.dismissAll();
        await tester.pumpAndSettle();
      });
    });

    group('Singleton Pattern', () {
      test('VooToastController maintains single instance', () {
        final controller1 = VooToastController.instance;
        final controller2 = VooToastController.instance;

        expect(identical(controller1, controller2), isTrue);
      });

      test('VooToastController factory returns same instance', () {
        final controller1 = VooToastController();
        final controller2 = VooToastController();

        expect(identical(controller1, controller2), isTrue);
      });

      test('VooToastController.init replaces instance', () {
        final controller1 = VooToastController.instance;

        VooToastController.init(
          config: const ToastConfig(
            defaultDuration: Duration(seconds: 5),
          ),
        );

        final controller2 = VooToastController.instance;

        expect(identical(controller1, controller2), isFalse);
        expect(controller2.config.defaultDuration, equals(const Duration(seconds: 5)));
      });

      test('VooToastController.reset clears instance', () {
        final controller1 = VooToastController.instance;
        expect(controller1, isNotNull);

        VooToastController.reset();

        final controller2 = VooToastController.instance;
        expect(identical(controller1, controller2), isFalse);
      });

      test('VooToast global accessor returns singleton', () {
        final controller = VooToastController.instance;

        // VooToast is a getter that returns VooToastController.instance
        expect(identical(VooToast, controller), isTrue);

        // Multiple accesses return the same instance
        expect(identical(VooToast, VooToast), isTrue);
      });
    });

    group('Theme-aware Toast Display', () {
      testWidgets('uses theme colors when no config provided', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
              ),
            ),
            home: VooToastOverlay(
              child: Builder(
                builder: (context) => Scaffold(
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          VooToast.showSuccess(
                            message: 'Theme success',
                            context: context,
                          );
                        },
                        child: const Text('Success'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          VooToast.showError(
                            message: 'Theme error',
                            context: context,
                          );
                        },
                        child: const Text('Error'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          VooToast.showWarning(
                            message: 'Theme warning',
                            context: context,
                          );
                        },
                        child: const Text('Warning'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          VooToast.showInfo(
                            message: 'Theme info',
                            context: context,
                          );
                        },
                        child: const Text('Info'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        // Test success toast with theme colors
        await tester.tap(find.text('Success'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 350));
        expect(find.text('Theme success'), findsOneWidget);

        // Dismiss toast
        VooToast.dismissAll();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 350));

        // Test error toast with theme colors
        await tester.tap(find.text('Error'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 350));
        expect(find.text('Theme error'), findsOneWidget);

        // Dismiss toast
        VooToast.dismissAll();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 350));

        // Test warning toast with theme colors
        await tester.tap(find.text('Warning'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 350));
        expect(find.text('Theme warning'), findsOneWidget);

        // Dismiss toast
        VooToast.dismissAll();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 350));

        // Test info toast with theme colors
        await tester.tap(find.text('Info'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 350));
        expect(find.text('Theme info'), findsOneWidget);

        // Clean up
        VooToast.dismissAll();
        await tester.pumpAndSettle();
      });

      testWidgets('dark theme colors are applied correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: VooToastOverlay(
              child: Builder(
                builder: (context) => Scaffold(
                  body: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        VooToast.showInfo(
                          message: 'Dark theme toast',
                          context: context,
                        );
                      },
                      child: const Text('Show Dark Toast'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        // Show toast
        await tester.tap(find.text('Show Dark Toast'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 350));

        // Verify toast appears
        expect(find.text('Dark theme toast'), findsOneWidget);

        // Clean up
        VooToast.dismissAll();
        await tester.pumpAndSettle();

        // Get theme
        final context = tester.element(find.byType(Scaffold));
        final theme = Theme.of(context);

        // Verify dark theme is active
        expect(theme.brightness, equals(Brightness.dark));
      });
    });

    group('Factory Constructor with Context', () {
      testWidgets('creates controller with theme config', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              colorScheme: const ColorScheme.light(
                primary: Colors.teal,
                error: Colors.pink,
              ),
            ),
            home: Builder(
              builder: (context) {
                // Create controller with context
                final controller = VooToastController(context: context);

                // Config should be created from theme
                final config = controller.config;

                expect(config.successColor, equals(Colors.teal));
                expect(config.errorColor, equals(Colors.pink));

                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('init with context uses theme config', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              colorScheme: const ColorScheme.light(
                primary: Colors.indigo,
                secondary: Colors.amber,
              ),
              cardTheme: const CardThemeData(elevation: 12.0),
            ),
            home: Builder(
              builder: (context) {
                // Initialize with context
                VooToastController.init(context: context);

                final controller = VooToastController.instance;
                final config = controller.config;

                expect(config.successColor, equals(Colors.indigo));
                expect(config.infoColor, equals(Colors.amber));
                expect(config.defaultElevation, equals(12.0));

                return const SizedBox();
              },
            ),
          ),
        );
      });
    });
  });
}
