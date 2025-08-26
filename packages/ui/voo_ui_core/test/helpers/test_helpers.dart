import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Creates a test app with Material 3 theme
Widget createTestApp({
  required Widget child,
  ThemeData? theme,
  Size? screenSize,
}) {
  return MaterialApp(
    theme: theme ?? ThemeData(useMaterial3: true),
    home: screenSize != null
        ? MediaQuery(
            data: MediaQueryData(size: screenSize),
            child: VooResponsiveBuilder(
              child: VooDesignSystem(
                data: VooDesignSystemData.defaultSystem,
                child: Scaffold(body: child),
              ),
            ),
          )
        : VooDesignSystem(
            data: VooDesignSystemData.defaultSystem,
            child: Scaffold(body: child),
          ),
  );
}

/// Creates a test app with responsive context
Widget createResponsiveTestApp({
  required Widget child,
  required Size screenSize,
  ThemeData? theme,
}) {
  return MaterialApp(
    theme: theme ?? ThemeData(useMaterial3: true),
    home: MediaQuery(
      data: MediaQueryData(size: screenSize),
      child: VooResponsiveBuilder(
        child: VooDesignSystem(
          data: VooDesignSystemData.defaultSystem,
          child: Scaffold(body: child),
        ),
      ),
    ),
  );
}

/// Pumps widget and settles animations
Future<void> pumpWidgetAndSettle(
  WidgetTester tester,
  Widget widget, {
  Duration? duration,
}) async {
  await tester.pumpWidget(widget);
  await tester.pumpAndSettle(duration ?? const Duration(milliseconds: 100));
}

/// Finds widget by type and verifies it exists
Finder findAndVerify<T extends Widget>(WidgetTester tester) {
  final finder = find.byType(T);
  expect(finder, findsOneWidget);
  return finder;
}

/// Finds text and verifies it exists
Finder findTextAndVerify(WidgetTester tester, String text) {
  final finder = find.text(text);
  expect(finder, findsOneWidget);
  return finder;
}

/// Simulates a tap and settles animations
Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Common screen sizes for responsive testing
class TestScreenSizes {
  static const Size phonePortrait = Size(360, 800);
  static const Size phoneLandscape = Size(800, 360);
  static const Size tabletPortrait = Size(768, 1024);
  static const Size tabletLandscape = Size(1024, 768);
  static const Size desktop = Size(1920, 1080);
  static const Size desktopSmall = Size(1280, 720);
  static const Size tv = Size(3840, 2160);
}

/// Test themes
class TestThemes {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
  );
  
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
  );
}

/// Extension for widget tester convenience methods
extension WidgetTesterExtensions on WidgetTester {
  /// Gets the Material widget ancestor
  Material getMaterial(Finder finder) {
    return widget<Material>(
      find.ancestor(
        of: finder,
        matching: find.byType(Material),
      ).first,
    );
  }
  
  /// Gets the Container widget
  Container getContainer(Finder finder) {
    return widget<Container>(finder);
  }
  
  /// Gets the Text widget
  Text getText(Finder finder) {
    return widget<Text>(finder);
  }
  
  /// Gets the Icon widget
  Icon getIcon(Finder finder) {
    return widget<Icon>(finder);
  }
  
  /// Simulates entering text
  Future<void> enterTextAndSettle(Finder finder, String text) async {
    await enterText(finder, text);
    await pumpAndSettle();
  }
  
  /// Simulates long press
  Future<void> longPressAndSettle(Finder finder) async {
    await longPress(finder);
    await pumpAndSettle();
  }
  
  /// Simulates drag
  Future<void> dragAndSettle(
    Finder finder,
    Offset offset, {
    Duration? duration,
  }) async {
    await drag(finder, offset);
    await pumpAndSettle(duration ?? const Duration(milliseconds: 100));
  }
}

/// Golden test helpers
class GoldenTestHelpers {
  static String goldenPath(String name) => 'goldens/$name.png';
  
  static Future<void> expectGolden(
    WidgetTester tester,
    String name, {
    Size? size,
  }) async {
    if (size != null) {
      await tester.binding.setSurfaceSize(size);
    }
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(goldenPath(name)),
    );
  }
}

/// Mock callbacks
class MockCallbacks {
  final List<dynamic> calls = [];
  
  void onChanged<T>(T value) {
    calls.add(value);
  }
  
  void onPressed() {
    calls.add('pressed');
  }
  
  void onDeleted() {
    calls.add('deleted');
  }
  
  void onSelected<T>(T value) {
    calls.add(value);
  }
  
  void reset() {
    calls.clear();
  }
  
  bool get wasCalled => calls.isNotEmpty;
  int get callCount => calls.length;
  dynamic get lastCall => calls.isEmpty ? null : calls.last;
}

/// Test data generators
class TestData {
  static List<String> generateStringList(int count) {
    return List.generate(count, (i) => 'Item ${i + 1}');
  }
  
  static List<int> generateIntList(int count) {
    return List.generate(count, (i) => i);
  }
  
  static Map<String, bool> generateBoolMap(List<String> keys, {bool defaultValue = false}) {
    return Map.fromEntries(
      keys.map((key) => MapEntry(key, defaultValue)),
    );
  }
  
  static DateTimeRange generateDateRange({int days = 7}) {
    final now = DateTime.now();
    return DateTimeRange(
      start: now,
      end: now.add(Duration(days: days)),
    );
  }
}