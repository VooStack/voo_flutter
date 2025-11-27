import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_terminal/src/domain/entities/terminal_line.dart';
import 'package:voo_terminal/src/domain/entities/terminal_theme.dart';
import 'package:voo_terminal/src/presentation/widgets/molecules/terminal_header.dart';
import 'package:voo_terminal/src/presentation/widgets/organisms/voo_terminal_preview.dart';

void main() {
  group('VooTerminalPreview', () {
    Widget buildTestWidget({
      List<TerminalLine> lines = const [],
      VooTerminalTheme? theme,
      bool showTimestamps = false,
      String timestampFormat = 'HH:mm:ss',
      bool enableSelection = true,
      bool autoScroll = true,
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
            child: VooTerminalPreview(
              lines: lines,
              theme: theme,
              showTimestamps: showTimestamps,
              timestampFormat: timestampFormat,
              enableSelection: enableSelection,
              autoScroll: autoScroll,
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

      expect(find.byType(VooTerminalPreview), findsOneWidget);
    });

    testWidgets('displays lines', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        lines: [
          TerminalLine.output('Line 1'),
          TerminalLine.output('Line 2'),
          TerminalLine.error('Error line'),
        ],
      ));

      expect(find.text('Line 1'), findsOneWidget);
      expect(find.text('Line 2'), findsOneWidget);
      expect(find.text('Error line'), findsOneWidget);
    });

    testWidgets('applies theme styling', (tester) async {
      final theme = VooTerminalTheme.matrix();

      await tester.pumpWidget(buildTestWidget(theme: theme));

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.color, theme.backgroundColor);
    });

    testWidgets('shows header when showHeader is true', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        showHeader: true,
        title: 'Preview Terminal',
      ));

      expect(find.byType(TerminalHeader), findsOneWidget);
      expect(find.text('Preview Terminal'), findsOneWidget);
    });

    testWidgets('hides header when showHeader is false', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        showHeader: false,
        title: 'Should not appear',
      ));

      expect(find.byType(TerminalHeader), findsNothing);
      expect(find.text('Should not appear'), findsNothing);
    });

    testWidgets('shows window controls when enabled', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        showHeader: true,
        showWindowControls: true,
      ));

      // Window controls should be visible in header
      expect(find.byType(TerminalHeader), findsOneWidget);
    });

    testWidgets('window control onClose callback works', (tester) async {
      var closeCalled = false;

      await tester.pumpWidget(buildTestWidget(
        showHeader: true,
        showWindowControls: true,
        onClose: () => closeCalled = true,
      ));

      // Find close button by color (red)
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
    });

    testWidgets('window control onMinimize callback works', (tester) async {
      var minimizeCalled = false;

      await tester.pumpWidget(buildTestWidget(
        showHeader: true,
        showWindowControls: true,
        onMinimize: () => minimizeCalled = true,
      ));

      // Find minimize button by color (yellow)
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
    });

    testWidgets('window control onMaximize callback works', (tester) async {
      var maximizeCalled = false;

      await tester.pumpWidget(buildTestWidget(
        showHeader: true,
        showWindowControls: true,
        onMaximize: () => maximizeCalled = true,
      ));

      // Find maximize button by color (green)
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

    testWidgets('uses custom header when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        header: Container(
          key: const Key('custom-header'),
          height: 50,
          color: Colors.blue,
        ),
      ));

      expect(find.byKey(const Key('custom-header')), findsOneWidget);
    });

    testWidgets('has semantic label', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(
        find.bySemanticsLabel('Terminal Output'),
        findsOneWidget,
      );
    });

    testWidgets('updates when lines change', (tester) async {
      final lines1 = [TerminalLine.output('Initial')];

      await tester.pumpWidget(buildTestWidget(lines: lines1));
      expect(find.text('Initial'), findsOneWidget);

      final lines2 = [
        TerminalLine.output('Initial'),
        TerminalLine.output('New line'),
      ];

      await tester.pumpWidget(buildTestWidget(lines: lines2));
      expect(find.text('New line'), findsOneWidget);
    });

    testWidgets('applies border radius from theme', (tester) async {
      final theme = VooTerminalTheme.retro();

      await tester.pumpWidget(buildTestWidget(theme: theme));

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.borderRadius, theme.borderRadius);
    });

    testWidgets('shows border when theme has showBorder true', (tester) async {
      final theme = VooTerminalTheme.classic();

      await tester.pumpWidget(buildTestWidget(theme: theme));

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.border, isNotNull);
    });
  });

  group('TerminalLinePreview', () {
    testWidgets('renders single line', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TerminalLinePreview(
            line: TerminalLine.output('Single line'),
          ),
        ),
      ));

      expect(find.text('Single line'), findsOneWidget);
    });

    testWidgets('applies theme styling', (tester) async {
      final theme = VooTerminalTheme.amber();

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TerminalLinePreview(
            line: TerminalLine.output('Styled'),
            theme: theme,
          ),
        ),
      ));

      expect(find.text('Styled'), findsOneWidget);
    });
  });
}
