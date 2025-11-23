import 'package:flutter_test/flutter_test.dart';
import 'package:voo_node_canvas_example/main.dart';

void main() {
  testWidgets('VooNodeCanvas example app renders', (WidgetTester tester) async {
    await tester.pumpWidget(const VooNodeCanvasExampleApp());
    expect(find.text('VooNodeCanvas Example'), findsOneWidget);
  });
}
