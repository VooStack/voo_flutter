import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_terminal/src/domain/entities/terminal_theme.dart';
import 'package:voo_terminal/src/presentation/widgets/atoms/window_controls.dart';
import 'package:voo_terminal/src/presentation/widgets/molecules/terminal_header.dart';

void main() {
  group('TerminalHeader', () {
    late VooTerminalTheme theme;

    setUp(() {
      theme = VooTerminalTheme.classic();
    });

    Widget buildTestWidget({
      String? title,
      Widget? titleWidget,
      Widget? leading,
      List<Widget>? actions,
      double? height,
      EdgeInsets? padding,
      VoidCallback? onClose,
      VoidCallback? onMinimize,
      VoidCallback? onMaximize,
      bool showWindowControls = false,
      TextAlign titleAlignment = TextAlign.start,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: TerminalHeader(
            theme: theme,
            title: title,
            titleWidget: titleWidget,
            leading: leading,
            actions: actions,
            height: height,
            padding: padding,
            onClose: onClose,
            onMinimize: onMinimize,
            onMaximize: onMaximize,
            showWindowControls: showWindowControls,
            titleAlignment: titleAlignment,
          ),
        ),
      );
    }

    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(TerminalHeader), findsOneWidget);
    });

    testWidgets('displays title', (tester) async {
      await tester.pumpWidget(buildTestWidget(title: 'Terminal Title'));

      expect(find.text('Terminal Title'), findsOneWidget);
    });

    testWidgets('uses titleWidget over title string', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        title: 'String Title',
        titleWidget: const Text('Widget Title'),
      ));

      expect(find.text('Widget Title'), findsOneWidget);
      expect(find.text('String Title'), findsNothing);
    });

    testWidgets('shows leading widget', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        leading: const Icon(Icons.terminal, key: Key('leading-icon')),
      ));

      expect(find.byKey(const Key('leading-icon')), findsOneWidget);
    });

    testWidgets('shows action widgets', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        actions: [
          IconButton(
            key: const Key('action-1'),
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
          IconButton(
            key: const Key('action-2'),
            icon: const Icon(Icons.close),
            onPressed: () {},
          ),
        ],
      ));

      expect(find.byKey(const Key('action-1')), findsOneWidget);
      expect(find.byKey(const Key('action-2')), findsOneWidget);
    });

    testWidgets('uses theme height by default', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final container = tester.widget<Container>(find.byType(Container).first);
      final constraints = container.constraints;

      expect(constraints?.maxHeight, theme.headerHeight);
    });

    testWidgets('uses custom height when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(height: 50.0));

      final container = tester.widget<Container>(find.byType(Container).first);
      final constraints = container.constraints;

      expect(constraints?.maxHeight, 50.0);
    });

    testWidgets('uses theme padding by default', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final container = tester.widget<Container>(find.byType(Container).first);

      expect(container.padding, theme.headerPadding);
    });

    testWidgets('uses custom padding when provided', (tester) async {
      const customPadding = EdgeInsets.all(20.0);

      await tester.pumpWidget(buildTestWidget(padding: customPadding));

      final container = tester.widget<Container>(find.byType(Container).first);

      expect(container.padding, customPadding);
    });

    testWidgets('shows window controls when enabled', (tester) async {
      await tester.pumpWidget(buildTestWidget(showWindowControls: true));

      expect(find.byType(WindowControls), findsOneWidget);
    });

    testWidgets('hides window controls when disabled', (tester) async {
      await tester.pumpWidget(buildTestWidget(showWindowControls: false));

      expect(find.byType(WindowControls), findsNothing);
    });

    testWidgets('onClose callback is triggered', (tester) async {
      var closeCalled = false;

      await tester.pumpWidget(buildTestWidget(
        showWindowControls: true,
        onClose: () => closeCalled = true,
      ));

      // Find close button (red)
      final closeButton = find.byWidgetPredicate(
        (widget) => widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color == const Color(0xFFFF5F56),
      );

      await tester.tap(closeButton.first);
      await tester.pump();

      expect(closeCalled, true);
    });

    testWidgets('onMinimize callback is triggered', (tester) async {
      var minimizeCalled = false;

      await tester.pumpWidget(buildTestWidget(
        showWindowControls: true,
        onMinimize: () => minimizeCalled = true,
      ));

      // Find minimize button (yellow)
      final minimizeButton = find.byWidgetPredicate(
        (widget) => widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color == const Color(0xFFFFBD2E),
      );

      await tester.tap(minimizeButton.first);
      await tester.pump();

      expect(minimizeCalled, true);
    });

    testWidgets('onMaximize callback is triggered', (tester) async {
      var maximizeCalled = false;

      await tester.pumpWidget(buildTestWidget(
        showWindowControls: true,
        onMaximize: () => maximizeCalled = true,
      ));

      // Find maximize button (green)
      final maximizeButton = find.byWidgetPredicate(
        (widget) => widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color == const Color(0xFF27C93F),
      );

      await tester.tap(maximizeButton.first);
      await tester.pump();

      expect(maximizeCalled, true);
    });

    testWidgets('applies theme surface color', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.color, theme.surfaceColor);
    });

    testWidgets('applies theme border', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      final border = decoration.border as Border;

      expect(border.bottom.color, theme.borderColor);
      expect(border.bottom.width, theme.borderWidth);
    });

    testWidgets('title uses theme font family', (tester) async {
      await tester.pumpWidget(buildTestWidget(title: 'Test'));

      final text = tester.widget<Text>(find.text('Test'));

      expect(text.style?.fontFamily, theme.fontFamily);
    });

    testWidgets('title uses scaled font size from theme', (tester) async {
      await tester.pumpWidget(buildTestWidget(title: 'Test'));

      final text = tester.widget<Text>(find.text('Test'));

      expect(text.style?.fontSize, theme.fontSize * theme.headerTitleScale);
    });

    testWidgets('title respects titleAlignment', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        title: 'Centered Title',
        titleAlignment: TextAlign.center,
      ));

      final text = tester.widget<Text>(find.text('Centered Title'));

      expect(text.textAlign, TextAlign.center);
    });

    testWidgets('title has ellipsis overflow', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        title: 'Very long title that should be truncated',
      ));

      final text = tester.widget<Text>(
        find.text('Very long title that should be truncated'),
      );

      expect(text.overflow, TextOverflow.ellipsis);
    });
  });
}
