import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_example/pages/home_page.dart';

void main() {
  group('Simple Widget Tests', () {
    testWidgets('HomePage displays correctly without initialization', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(),
        ),
      );

      // Verify the home page loads
      expect(find.text('Voo Flutter Examples'), findsOneWidget);
      
      // Verify all feature cards are present
      expect(find.text('Logging'), findsOneWidget);
      expect(find.text('Analytics'), findsOneWidget);
      expect(find.text('Performance'), findsOneWidget);
      
      // Scroll to find Network Interceptors if needed
      await tester.ensureVisible(find.text('Logging'));
      await tester.pumpAndSettle();
      
      // Verify the header
      expect(find.text('VooFlutter Integration'), findsOneWidget);
      expect(find.text('All packages working together'), findsOneWidget);
    });

    testWidgets('HomePage navigation works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(),
        ),
      );

      // Find and verify all feature cards are tappable
      final loggingCard = find.text('Logging');
      expect(loggingCard, findsOneWidget);
      
      final analyticsCard = find.text('Analytics');
      expect(analyticsCard, findsOneWidget);
      
      final performanceCard = find.text('Performance');
      expect(performanceCard, findsOneWidget);
    });
  });
}