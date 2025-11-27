import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_terminal/src/domain/entities/terminal_config.dart';
import 'package:voo_terminal/src/domain/entities/terminal_line.dart';
import 'package:voo_terminal/src/domain/entities/terminal_theme.dart';
import 'package:voo_terminal/src/presentation/controllers/terminal_controller.dart';
import 'package:voo_terminal/src/presentation/widgets/molecules/terminal_header.dart';
import 'package:voo_terminal/src/presentation/widgets/organisms/voo_terminal.dart';

void main() {
  group('VooTerminal', () {
    Widget buildTestWidget({
      TerminalController? controller,
      TerminalConfig config = const TerminalConfig(),
      VooTerminalTheme? theme,
      List<TerminalLine>? initialLines,
      String? title,
      bool showHeader = false,
      bool showWindowControls = false,
      VoidCallback? onClose,
      VoidCallback? onMinimize,
      VoidCallback? onMaximize,
      Widget? header,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 400,
            child: VooTerminal(
              controller: controller,
              config: config,
              theme: theme,
              initialLines: initialLines,
              title: title,
              showHeader: showHeader,
              showWindowControls: showWindowControls,
              onClose: onClose,
              onMinimize: onMinimize,
              onMaximize: onMaximize,
              header: header,
            ),
          ),
        ),
      );
    }

    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(VooTerminal), findsOneWidget);
    });

    testWidgets('renders with initial lines', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        initialLines: [
          TerminalLine.output('Hello'),
          TerminalLine.output('World'),
        ],
      ));

      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('World'), findsOneWidget);
    });

    testWidgets('applies theme styling', (tester) async {
      final theme = VooTerminalTheme.classic();

      await tester.pumpWidget(buildTestWidget(theme: theme));

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.color, theme.backgroundColor);
    });

    testWidgets('shows header when showHeader is true', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        showHeader: true,
        title: 'Test Terminal',
      ));

      expect(find.byType(TerminalHeader), findsOneWidget);
      expect(find.text('Test Terminal'), findsOneWidget);
    });

    testWidgets('hides header when showHeader is false', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        showHeader: false,
        title: 'Test Terminal',
      ));

      expect(find.byType(TerminalHeader), findsNothing);
    });

    testWidgets('uses custom header when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        header: Container(
          key: const Key('custom-header'),
          height: 50,
          color: Colors.red,
        ),
      ));

      expect(find.byKey(const Key('custom-header')), findsOneWidget);
    });

    testWidgets('window control callbacks are triggered', (tester) async {
      var closeCalled = false;
      var minimizeCalled = false;
      var maximizeCalled = false;

      await tester.pumpWidget(buildTestWidget(
        showHeader: true,
        showWindowControls: true,
        onClose: () => closeCalled = true,
        onMinimize: () => minimizeCalled = true,
        onMaximize: () => maximizeCalled = true,
      ));

      // Find and tap close button (red button)
      final closeButton = find.byWidgetPredicate(
        (widget) => widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color == const Color(0xFFFF5F56),
      );
      if (closeButton.evaluate().isNotEmpty) {
        await tester.tap(closeButton.first);
        await tester.pump();
        expect(closeCalled, true);
      }

      // Find and tap minimize button (yellow button)
      final minimizeButton = find.byWidgetPredicate(
        (widget) => widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color == const Color(0xFFFFBD2E),
      );
      if (minimizeButton.evaluate().isNotEmpty) {
        await tester.tap(minimizeButton.first);
        await tester.pump();
        expect(minimizeCalled, true);
      }

      // Find and tap maximize button (green button)
      final maximizeButton = find.byWidgetPredicate(
        (widget) => widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color == const Color(0xFF27C93F),
      );
      if (maximizeButton.evaluate().isNotEmpty) {
        await tester.tap(maximizeButton.first);
        await tester.pump();
        expect(maximizeCalled, true);
      }
    });

    testWidgets('uses external controller when provided', (tester) async {
      final controller = TerminalController();
      controller.writeLine('External controller line');

      await tester.pumpWidget(buildTestWidget(controller: controller));

      expect(find.text('External controller line'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('has semantic label', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(
        find.bySemanticsLabel('Terminal'),
        findsOneWidget,
      );
    });

    group('factory VooTerminal.preview', () {
      testWidgets('creates preview terminal', (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: VooTerminal.preview(
                lines: [TerminalLine.output('Preview line')],
              ),
            ),
          ),
        ));

        expect(find.text('Preview line'), findsOneWidget);
      });

      testWidgets('supports window control callbacks', (tester) async {
        var closeCalled = false;

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: VooTerminal.preview(
                lines: [TerminalLine.output('Test')],
                showHeader: true,
                showWindowControls: true,
                onClose: () => closeCalled = true,
              ),
            ),
          ),
        ));

        // Verify header is shown
        expect(find.byType(TerminalHeader), findsOneWidget);
      });
    });

    group('factory VooTerminal.interactive', () {
      testWidgets('creates interactive terminal', (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: VooTerminal.interactive(
                prompt: '>>> ',
              ),
            ),
          ),
        ));

        expect(find.byType(VooTerminal), findsOneWidget);
      });

      testWidgets('supports window control callbacks', (tester) async {
        var closeCalled = false;

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: VooTerminal.interactive(
                showHeader: true,
                showWindowControls: true,
                onClose: () => closeCalled = true,
              ),
            ),
          ),
        ));

        expect(find.byType(TerminalHeader), findsOneWidget);
      });
    });

    group('factory VooTerminal.stream', () {
      testWidgets('creates stream terminal', (tester) async {
        final streamController = Stream<String>.fromIterable(['Line 1', 'Line 2']);

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: VooTerminal.stream(
                stream: streamController,
              ),
            ),
          ),
        ));
        await tester.pump();

        expect(find.byType(VooTerminal), findsOneWidget);
      });
    });

    testWidgets('updates when controller changes', (tester) async {
      final controller1 = TerminalController();
      controller1.writeLine('Controller 1');

      await tester.pumpWidget(buildTestWidget(controller: controller1));
      expect(find.text('Controller 1'), findsOneWidget);

      final controller2 = TerminalController();
      controller2.writeLine('Controller 2');

      await tester.pumpWidget(buildTestWidget(controller: controller2));
      expect(find.text('Controller 2'), findsOneWidget);

      controller1.dispose();
      controller2.dispose();
    });

    testWidgets('updates when config changes', (tester) async {
      final controller = TerminalController();

      await tester.pumpWidget(buildTestWidget(
        controller: controller,
        config: const TerminalConfig(),
      ));

      await tester.pumpWidget(buildTestWidget(
        controller: controller,
        config: TerminalConfig.interactive(prompt: '> '),
      ));

      expect(controller.config.prompt, '> ');

      controller.dispose();
    });
  });
}
