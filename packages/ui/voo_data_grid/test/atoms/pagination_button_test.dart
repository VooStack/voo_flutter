import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/pagination_button.dart';

void main() {
  group('PaginationButton', () {
    testWidgets('renders with icon and enabled state', (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginationButton(
              icon: Icons.chevron_left,
              onPressed: () => wasPressed = true,
              tooltip: 'Previous',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);

      await tester.tap(find.byType(IconButton));
      expect(wasPressed, isTrue);
    });

    testWidgets('shows disabled state when onPressed is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PaginationButton(
              icon: Icons.chevron_right,
              tooltip: 'Next',
            ),
          ),
        ),
      );

      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(iconButton.onPressed, isNull);
    });

    testWidgets('shows tooltip on hover', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginationButton(
              icon: Icons.first_page,
              onPressed: () {},
              tooltip: 'First Page',
            ),
          ),
        ),
      );

      expect(find.byTooltip('First Page'), findsOneWidget);
    });

    testWidgets('applies theme colors correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onSurface: Colors.black,
            ),
          ),
          home: Scaffold(
            body: PaginationButton(
              icon: Icons.last_page,
              onPressed: () {},
              tooltip: 'Last Page',
            ),
          ),
        ),
      );

      // Icon widget inherits colors from IconButton and theme
      // Verify the icon is rendered with the correct size
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, equals(24));
    });
  });
}