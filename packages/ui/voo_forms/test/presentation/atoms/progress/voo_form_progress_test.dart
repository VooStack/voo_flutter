import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/progress/voo_form_progress.dart';

void main() {
  group('VooFormProgress', () {
    testWidgets('shows indeterminate progress by default', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: VooFormProgress())));

      final progress = tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
      expect(progress.value, isNull);
    });

    testWidgets('shows determinate progress with value', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: VooFormProgress(isIndeterminate: false, value: 0.5))));

      final progress = tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
      expect(progress.value, 0.5);
    });

    testWidgets('applies custom height', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: VooFormProgress(height: 8.0))));

      final progress = tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
      expect(progress.minHeight, 8.0);
    });

    testWidgets('applies custom colors', (WidgetTester tester) async {
      const backgroundColor = Colors.grey;
      const valueColor = Colors.blue;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooFormProgress(backgroundColor: backgroundColor, valueColor: valueColor),
          ),
        ),
      );

      final progress = tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
      expect(progress.backgroundColor, backgroundColor);
      expect((progress.valueColor! as AlwaysStoppedAnimation<Color>).value, valueColor);
    });

    testWidgets('applies border radius when provided', (WidgetTester tester) async {
      const borderRadius = BorderRadius.all(Radius.circular(10));

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: VooFormProgress(borderRadius: borderRadius)),
        ),
      );

      expect(find.byType(ClipRRect), findsOneWidget);
      final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clipRRect.borderRadius, borderRadius);
    });

    testWidgets('animates value changes', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: VooFormProgress(isIndeterminate: false, value: 0.3))));

      final progress = tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
      expect(progress.valueColor, isA<AlwaysStoppedAnimation<Color>>());
    });
  });

  group('VooFormCircularProgress', () {
    testWidgets('shows circular progress indicator', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: VooFormCircularProgress())));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('applies custom size', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: VooFormCircularProgress(size: 48.0))));

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 48.0);
      expect(sizedBox.height, 48.0);
    });

    testWidgets('applies custom stroke width', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: VooFormCircularProgress(strokeWidth: 4.0))));

      final progress = tester.widget<CircularProgressIndicator>(find.byType(CircularProgressIndicator));
      expect(progress.strokeWidth, 4.0);
    });

    testWidgets('shows determinate circular progress with value', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: VooFormCircularProgress(value: 0.75))));

      final progress = tester.widget<CircularProgressIndicator>(find.byType(CircularProgressIndicator));
      expect(progress.value, 0.75);
    });

    testWidgets('applies custom value color', (WidgetTester tester) async {
      const valueColor = Colors.red;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: VooFormCircularProgress(valueColor: valueColor)),
        ),
      );

      final progress = tester.widget<CircularProgressIndicator>(find.byType(CircularProgressIndicator));
      expect((progress.valueColor! as AlwaysStoppedAnimation<Color>).value, valueColor);
    });
  });
}
