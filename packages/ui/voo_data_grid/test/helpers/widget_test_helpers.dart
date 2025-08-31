import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// Test implementation of VooDataGridSource for testing
class TestDataGridSource extends VooDataGridSource {
  TestDataGridSource({
    super.mode = VooDataGridMode.local,
    List<dynamic>? data,
  }) {
    if (data != null) {
      setLocalData(data);
    }
  }

  @override
  Future<VooDataGridResponse> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));
    return VooDataGridResponse(
      rows: [],
      totalRows: 0,
      page: page,
      pageSize: pageSize,
    );
  }
}

/// Test controller for VooDataGrid
class TestDataGridController extends VooDataGridController {
  TestDataGridController({
    super.initialPageSize = 10,
    super.initialPage = 1,
  });
}

/// Helper to create a testable data grid
Widget createTestDataGrid({
  required List<VooDataColumn> columns,
  required VooDataGridSource source,
  VooDataGridController? controller,
  bool showPagination = true,
  bool showFilters = true,
}) {
  return MaterialApp(
    home: Scaffold(
      body: VooDataGrid(
        columns: columns,
        source: source,
        controller: controller ?? TestDataGridController(),
        showPagination: showPagination,
        showFilters: showFilters,
      ),
    ),
  );
}

/// Helper to tap a widget and wait for animations
Future<void> tapAndSettle(
  WidgetTester tester,
  Finder finder, {
  Duration? duration,
}) async {
  await tester.tap(finder);
  await tester.pumpAndSettle(duration ?? const Duration(milliseconds: 100));
}

/// Helper to enter text and wait for animations
Future<void> enterTextAndSettle(
  WidgetTester tester,
  Finder finder,
  String text, {
  Duration? duration,
}) async {
  await tester.enterText(finder, text);
  await tester.pumpAndSettle(duration ?? const Duration(milliseconds: 100));
}

/// Helper to scroll to a widget
Future<void> scrollToWidget(
  WidgetTester tester,
  Finder finder, {
  double delta = 300,
}) async {
  await tester.dragUntilVisible(
    finder,
    find.byType(SingleChildScrollView),
    Offset(0, delta),
  );
}

/// Verify column headers exist
void verifyColumnHeaders(List<String> headers) {
  for (final header in headers) {
    expect(find.text(header), findsOneWidget);
  }
}

/// Verify data cell exists
void verifyDataCell(String value) {
  expect(find.text(value), findsWidgets);
}

/// Get the current page number from pagination
int? getCurrentPageNumber(WidgetTester tester) {
  final pageFinder = find.textContaining('Page');
  if (pageFinder.evaluate().isEmpty) return null;
  
  final text = tester.widget<Text>(pageFinder).data!;
  final match = RegExp(r'Page (\d+)').firstMatch(text);
  return match != null ? int.parse(match.group(1)!) : null;
}