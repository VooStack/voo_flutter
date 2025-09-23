// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:voo_navigation_example/main.dart';

void main() {
  testWidgets('VooNavigation example app smoke test',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const VooNavigationExampleApp());

    // Verify that the dashboard is selected by default
    expect(find.text('Dashboard'), findsWidgets);

    // Verify navigation items are present
    expect(find.byIcon(Icons.dashboard_outlined), findsOneWidget);
    expect(find.byIcon(Icons.analytics_outlined), findsOneWidget);
  });
}
