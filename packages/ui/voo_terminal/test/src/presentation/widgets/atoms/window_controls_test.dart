import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_terminal/src/presentation/widgets/atoms/window_button.dart';
import 'package:voo_terminal/src/presentation/widgets/atoms/window_controls.dart';

void main() {
  group('WindowControls', () {
    Widget buildTestWidget({
      VoidCallback? onClose,
      VoidCallback? onMinimize,
      VoidCallback? onMaximize,
      double spacing = 8.0,
      double buttonSize = 12.0,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: WindowControls(
            onClose: onClose,
            onMinimize: onMinimize,
            onMaximize: onMaximize,
            spacing: spacing,
            buttonSize: buttonSize,
          ),
        ),
      );
    }

    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(WindowControls), findsOneWidget);
    });

    testWidgets('contains three window buttons', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(WindowButton), findsNWidgets(3));
    });

    testWidgets('displays close button', (tester) async {
      await tester.pumpWidget(buildTestWidget(onClose: () {}));

      // Three window buttons should exist
      expect(find.byType(WindowButton), findsNWidgets(3));
    });

    testWidgets('displays minimize button', (tester) async {
      await tester.pumpWidget(buildTestWidget(onMinimize: () {}));

      expect(find.byType(WindowButton), findsNWidgets(3));
    });

    testWidgets('displays maximize button', (tester) async {
      await tester.pumpWidget(buildTestWidget(onMaximize: () {}));

      expect(find.byType(WindowButton), findsNWidgets(3));
    });

    testWidgets('onClose callback is triggered', (tester) async {
      var closeCalled = false;

      await tester.pumpWidget(buildTestWidget(
        onClose: () => closeCalled = true,
      ));

      // Tap the first button (close)
      await tester.tap(find.byType(WindowButton).first);
      await tester.pump();

      expect(closeCalled, true);
    });

    testWidgets('onMinimize callback is triggered', (tester) async {
      var minimizeCalled = false;

      await tester.pumpWidget(buildTestWidget(
        onMinimize: () => minimizeCalled = true,
      ));

      // Tap the second button (minimize)
      await tester.tap(find.byType(WindowButton).at(1));
      await tester.pump();

      expect(minimizeCalled, true);
    });

    testWidgets('onMaximize callback is triggered', (tester) async {
      var maximizeCalled = false;

      await tester.pumpWidget(buildTestWidget(
        onMaximize: () => maximizeCalled = true,
      ));

      // Tap the third button (maximize)
      await tester.tap(find.byType(WindowButton).at(2));
      await tester.pump();

      expect(maximizeCalled, true);
    });

    testWidgets('uses custom spacing', (tester) async {
      await tester.pumpWidget(buildTestWidget(spacing: 16.0));

      // Verify controls render with custom spacing
      expect(find.byType(WindowControls), findsOneWidget);
    });

    testWidgets('uses custom button size', (tester) async {
      await tester.pumpWidget(buildTestWidget(buttonSize: 20.0));

      // Verify controls render with custom size
      expect(find.byType(WindowControls), findsOneWidget);
    });

    testWidgets('buttons are in correct order: close, minimize, maximize', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        onClose: () {},
        onMinimize: () {},
        onMaximize: () {},
      ));

      final row = tester.widget<Row>(find.byType(Row).first);
      final children = row.children;

      // Should be: WindowButton (close), SizedBox, WindowButton (minimize), SizedBox, WindowButton (maximize)
      expect(children.length, 5);
      expect(children[0], isA<WindowButton>());
      expect(children[1], isA<SizedBox>());
      expect(children[2], isA<WindowButton>());
      expect(children[3], isA<SizedBox>());
      expect(children[4], isA<WindowButton>());
    });

    testWidgets('has minimum main axis size', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final row = tester.widget<Row>(find.byType(Row).first);

      expect(row.mainAxisSize, MainAxisSize.min);
    });
  });
}
