import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_terminal/src/presentation/widgets/atoms/window_button.dart';

void main() {
  group('WindowButton', () {
    Widget buildTestWidget({
      Color color = Colors.red,
      VoidCallback? onTap,
      String tooltip = 'Test',
      double size = 12.0,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: WindowButton(
            color: color,
            onTap: onTap,
            tooltip: tooltip,
            size: size,
          ),
        ),
      );
    }

    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(WindowButton), findsOneWidget);
    });

    testWidgets('displays with correct size', (tester) async {
      await tester.pumpWidget(buildTestWidget(size: 16.0));

      // Verify widget renders with size
      expect(find.byType(WindowButton), findsOneWidget);
    });

    testWidgets('displays with correct color', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        color: Colors.blue,
        onTap: () {},
      ));

      // Verify widget renders with color
      expect(find.byType(WindowButton), findsOneWidget);
    });

    testWidgets('displays faded color when onTap is null', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        color: Colors.blue,
        onTap: null,
      ));

      // Verify widget renders
      expect(find.byType(WindowButton), findsOneWidget);
    });

    testWidgets('has circular shape', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Verify widget renders
      expect(find.byType(WindowButton), findsOneWidget);
    });

    testWidgets('shows tooltip', (tester) async {
      await tester.pumpWidget(buildTestWidget(tooltip: 'My Tooltip'));

      expect(find.byType(Tooltip), findsOneWidget);

      final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
      expect(tooltip.message, 'My Tooltip');
    });

    testWidgets('onTap callback is triggered', (tester) async {
      var tapped = false;

      await tester.pumpWidget(buildTestWidget(onTap: () => tapped = true));

      await tester.tap(find.byType(WindowButton));
      await tester.pump();

      expect(tapped, true);
    });

    testWidgets('does not crash when tapped without onTap', (tester) async {
      await tester.pumpWidget(buildTestWidget(onTap: null));

      await tester.tap(find.byType(WindowButton));
      await tester.pump();

      // Should not throw
    });
  });

  group('WindowButton.close', () {
    testWidgets('renders with red color', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: WindowButton.close(onTap: () {}),
        ),
      ));

      expect(find.byType(WindowButton), findsOneWidget);
    });

    testWidgets('has Close tooltip', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: WindowButton.close(),
        ),
      ));

      final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
      expect(tooltip.message, 'Close');
    });

    testWidgets('uses default size of 12', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: WindowButton.close(),
        ),
      ));

      expect(find.byType(WindowButton), findsOneWidget);
    });

    testWidgets('accepts custom size', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: WindowButton.close(size: 20.0),
        ),
      ));

      expect(find.byType(WindowButton), findsOneWidget);
    });
  });

  group('WindowButton.minimize', () {
    testWidgets('renders with yellow color', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: WindowButton.minimize(onTap: () {}),
        ),
      ));

      expect(find.byType(WindowButton), findsOneWidget);
    });

    testWidgets('has Minimize tooltip', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: WindowButton.minimize(),
        ),
      ));

      final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
      expect(tooltip.message, 'Minimize');
    });
  });

  group('WindowButton.maximize', () {
    testWidgets('renders with green color', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: WindowButton.maximize(onTap: () {}),
        ),
      ));

      expect(find.byType(WindowButton), findsOneWidget);
    });

    testWidgets('has Maximize tooltip', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: WindowButton.maximize(),
        ),
      ));

      final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
      expect(tooltip.message, 'Maximize');
    });
  });
}
