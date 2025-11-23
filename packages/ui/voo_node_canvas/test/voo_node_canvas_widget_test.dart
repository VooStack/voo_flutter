import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_node_canvas/voo_node_canvas.dart';

void main() {
  group('VooNodeCanvas Widget', () {
    late CanvasController controller;

    setUp(() {
      controller = CanvasController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooNodeCanvas(
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.byType(VooNodeCanvas), findsOneWidget);
    });

    testWidgets('displays nodes', (tester) async {
      controller.addNode(const CanvasNode(
        id: 'node1',
        position: Offset(100, 100),
        size: Size(150, 100),
        child: Text('Node 1'),
      ));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooNodeCanvas(
              controller: controller,
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Node 1'), findsOneWidget);
    });

    testWidgets('shows grid when enabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooNodeCanvas(
              controller: controller,
              config: const CanvasConfig(showGrid: true),
            ),
          ),
        ),
      );

      expect(find.byType(CanvasGrid), findsOneWidget);
    });

    testWidgets('hides grid when disabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooNodeCanvas(
              controller: controller,
              config: const CanvasConfig(showGrid: false),
            ),
          ),
        ),
      );

      expect(find.byType(CanvasGrid), findsNothing);
    });

    testWidgets('calls onNodeTap when node is tapped', (tester) async {
      CanvasNode? tappedNode;

      controller.addNode(const CanvasNode(
        id: 'node1',
        position: Offset(100, 100),
        size: Size(150, 100),
      ));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooNodeCanvas(
              controller: controller,
              onNodeTap: (node) => tappedNode = node,
            ),
          ),
        ),
      );

      await tester.pump();

      // Find the NodeWidget and tap it
      final nodeWidgetFinder = find.byType(NodeWidget);
      expect(nodeWidgetFinder, findsOneWidget);

      await tester.tap(nodeWidgetFinder);
      await tester.pump();

      expect(tappedNode?.id, 'node1');
    });

    testWidgets('calls onCanvasTap when background is tapped', (tester) async {
      var canvasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooNodeCanvas(
              controller: controller,
              onCanvasTap: () => canvasTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(VooNodeCanvas));
      await tester.pump();

      expect(canvasTapped, true);
    });

    testWidgets('updates when controller changes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooNodeCanvas(
              controller: controller,
            ),
          ),
        ),
      );

      controller.addNode(const CanvasNode(
        id: 'node1',
        position: Offset(100, 100),
        child: Text('Added Node'),
      ));

      await tester.pump();

      expect(find.text('Added Node'), findsOneWidget);
    });

    testWidgets('applies custom config', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooNodeCanvas(
              controller: controller,
              config: const CanvasConfig(
                gridSize: 40,
                backgroundColor: Colors.black,
              ),
            ),
          ),
        ),
      );

      expect(controller.state.config.gridSize, 40);
    });
  });
}
