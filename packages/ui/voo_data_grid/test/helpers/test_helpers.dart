import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wraps a widget with MaterialApp and Scaffold for testing
Widget makeTestableWidget({required Widget child, ThemeData? theme, Size? screenSize}) => MaterialApp(
  theme: theme ?? ThemeData.light(),
  home: Scaffold(body: child),
);

/// Wraps a widget with Material for simple tests
Widget wrapWithMaterial(Widget widget) => MaterialApp(home: Material(child: widget));

/// Creates a simple MaterialApp wrapper for widgets that need navigation
Widget wrapWithNavigation(Widget widget) => MaterialApp(home: widget);

/// Pumps widget and settles all animations
Future<void> pumpAndSettle(WidgetTester tester, Widget widget, {Duration? duration}) async {
  await tester.pumpWidget(widget);
  await tester.pumpAndSettle(duration ?? const Duration(milliseconds: 100));
}

/// Helper to find widgets by key
Finder findByKey(String key) => find.byKey(Key(key));

/// Helper to verify widget exists
void expectWidgetExists(Type widgetType) {
  expect(find.byType(widgetType), findsOneWidget);
}

/// Helper to verify text exists
void expectTextExists(String text) {
  expect(find.text(text), findsOneWidget);
}
