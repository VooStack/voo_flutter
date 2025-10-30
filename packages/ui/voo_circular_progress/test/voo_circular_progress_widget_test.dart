import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_circular_progress/voo_circular_progress.dart';

void main() {
  group('VooCircularProgress', () {
    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooCircularProgress(
              rings: [
                const ProgressRing(
                  current: 50,
                  goal: 100,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(VooCircularProgress), findsOneWidget);
    });

    testWidgets('renders with multiple rings', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooCircularProgress(
              rings: [
                const ProgressRing(
                  current: 50,
                  goal: 100,
                  color: Colors.blue,
                ),
                const ProgressRing(
                  current: 75,
                  goal: 100,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(VooCircularProgress), findsOneWidget);
    });

    testWidgets('renders center widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooCircularProgress(
              rings: [
                const ProgressRing(
                  current: 50,
                  goal: 100,
                  color: Colors.blue,
                ),
              ],
              centerWidget: const Text('Center'),
            ),
          ),
        ),
      );

      expect(find.text('Center'), findsOneWidget);
    });

    testWidgets('respects custom size', (tester) async {
      const customSize = 300.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooCircularProgress(
              rings: [
                const ProgressRing(
                  current: 50,
                  goal: 100,
                  color: Colors.blue,
                ),
              ],
              size: customSize,
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(VooCircularProgress),
          matching: find.byType(SizedBox),
        ).first,
      );

      expect(sizedBox.width, customSize);
      expect(sizedBox.height, customSize);
    });

    testWidgets('animates progress changes', (tester) async {
      double progress = 50;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => Column(
                children: [
                  VooCircularProgress(
                    rings: [
                      ProgressRing(
                        current: progress,
                        goal: 100,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => setState(() => progress = 75),
                    child: const Text('Update'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Initial state
      await tester.pump();

      // Update progress
      await tester.tap(find.text('Update'));
      await tester.pump();

      // Animation should be in progress
      await tester.pump(const Duration(milliseconds: 500));

      // Complete animation
      await tester.pumpAndSettle();

      expect(find.byType(VooCircularProgress), findsOneWidget);
    });

    test('asserts on empty rings list', () {
      expect(
        () => VooCircularProgress(rings: const []),
        throwsA(isA<AssertionError>()),
      );
    });

    test('asserts on invalid size', () {
      expect(
        () => VooCircularProgress(
          rings: [
            const ProgressRing(
              current: 50,
              goal: 100,
              color: Colors.blue,
            ),
          ],
          size: 0,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('asserts on negative gap', () {
      expect(
        () => VooCircularProgress(
          rings: [
            const ProgressRing(
              current: 50,
              goal: 100,
              color: Colors.blue,
            ),
          ],
          gapBetweenRings: -1,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
