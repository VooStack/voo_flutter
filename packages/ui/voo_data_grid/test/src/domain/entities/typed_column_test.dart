import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

class TestUser {
  final String name;
  final int age;
  final DateTime birthDate;
  final double salary;

  TestUser({required this.name, required this.age, required this.birthDate, required this.salary});
}

void main() {
  group('TypedVooDataColumn', () {
    test('should provide type safety for string values', () {
      final column = TypedVooDataColumn<TestUser, String>(
        field: 'name',
        label: 'Name',
        typedValueGetter: (user) => user.name,
        typedValueFormatter: (name) => name.toUpperCase(),
      );

      final testUser = TestUser(name: 'John Doe', age: 30, birthDate: DateTime(1993, 5, 15), salary: 50000.0);

      // Test value getter
      expect(column.valueGetter?.call(testUser), 'John Doe');

      // Test value formatter
      expect(column.valueFormatter?.call('John Doe'), 'JOHN DOE');
    });

    test('should provide type safety for int values', () {
      final column = TypedVooDataColumn<TestUser, int>(
        field: 'age',
        label: 'Age',
        typedValueGetter: (user) => user.age,
        typedValueFormatter: (age) => '$age years old',
      );

      final testUser = TestUser(name: 'Jane Smith', age: 25, birthDate: DateTime(1998, 3, 20), salary: 60000.0);

      // Test value getter
      expect(column.valueGetter?.call(testUser), 25);

      // Test value formatter
      expect(column.valueFormatter?.call(25), '25 years old');
    });

    test('should provide type safety for DateTime values', () {
      final column = TypedVooDataColumn<TestUser, DateTime>(
        field: 'birthDate',
        label: 'Birth Date',
        typedValueGetter: (user) => user.birthDate,
        typedValueFormatter: (date) => '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      );

      final testUser = TestUser(name: 'Bob Johnson', age: 35, birthDate: DateTime(1988, 12, 10), salary: 75000.0);

      // Test value getter
      expect(column.valueGetter?.call(testUser), DateTime(1988, 12, 10));

      // Test value formatter
      expect(column.valueFormatter?.call(DateTime(1988, 12, 10)), '1988-12-10');
    });

    test('should provide type safety for double values', () {
      final column = TypedVooDataColumn<TestUser, double>(
        field: 'salary',
        label: 'Salary',
        typedValueGetter: (user) => user.salary,
        typedValueFormatter: (salary) => '\$${salary.toStringAsFixed(2)}',
      );

      final testUser = TestUser(name: 'Alice Williams', age: 28, birthDate: DateTime(1995, 7, 22), salary: 55000.50);

      // Test value getter
      expect(column.valueGetter?.call(testUser), 55000.50);

      // Test value formatter
      expect(column.valueFormatter?.call(55000.50), '\$55000.50');
    });

    test('should handle null values gracefully', () {
      final column = TypedVooDataColumn<TestUser, String>(
        field: 'name',
        label: 'Name',
        typedValueGetter: (user) => user.name,
        typedValueFormatter: (name) => name.toUpperCase(),
      );

      // Test formatter with unexpected type
      expect(column.valueFormatter?.call(null), '');
      expect(column.valueFormatter?.call(123), '123'); // Falls back to toString
    });

    test('should work with custom cell builder', () {
      final column = TypedVooDataColumn<TestUser, int>(
        field: 'age',
        label: 'Age',
        typedValueGetter: (user) => user.age,
        typedCellBuilder: (context, age, user) =>
            Container(padding: const EdgeInsets.all(8.0), color: age >= 30 ? Colors.green : Colors.blue, child: Text('$age years')),
      );

      final testUser = TestUser(name: 'Test User', age: 32, birthDate: DateTime.now(), salary: 50000.0);

      // Test that cell builder is properly set
      expect(column.cellBuilder != null, true);

      // Test cell builder with correct type
      final widget = column.cellBuilder?.call(MockBuildContext(), 32, testUser);
      expect(widget != null, true);
    });

    test('copyWith should preserve typed functions', () {
      final originalColumn = TypedVooDataColumn<TestUser, String>(
        field: 'name',
        label: 'Name',
        typedValueGetter: (user) => user.name,
        typedValueFormatter: (name) => name.toLowerCase(),
      );

      final copiedColumn = originalColumn.copyWith(label: 'Full Name', typedValueFormatter: (name) => name.toUpperCase());

      expect(copiedColumn.label, 'Full Name');
      expect(copiedColumn.field, 'name');

      final testUser = TestUser(name: 'Test Name', age: 25, birthDate: DateTime.now(), salary: 45000.0);

      expect(copiedColumn.valueGetter?.call(testUser), 'Test Name');
      expect(copiedColumn.valueFormatter?.call('Test Name'), 'TEST NAME');
    });
  });
}

// Mock BuildContext for testing
class MockBuildContext extends BuildContext {
  @override
  bool get debugDoingBuild => throw UnimplementedError();

  @override
  InheritedWidget dependOnInheritedElement(InheritedElement ancestor, {Object? aspect}) {
    throw UnimplementedError();
  }

  @override
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>({Object? aspect}) {
    throw UnimplementedError();
  }

  @override
  DiagnosticsNode describeElement(String name, {DiagnosticsTreeStyle style = DiagnosticsTreeStyle.errorProperty}) {
    throw UnimplementedError();
  }

  @override
  List<DiagnosticsNode> describeMissingAncestor({required Type expectedAncestorType}) {
    throw UnimplementedError();
  }

  @override
  DiagnosticsNode describeOwnershipChain(String name) {
    throw UnimplementedError();
  }

  @override
  DiagnosticsNode describeWidget(String name, {DiagnosticsTreeStyle style = DiagnosticsTreeStyle.errorProperty}) {
    throw UnimplementedError();
  }

  @override
  void dispatchNotification(Notification notification) {
    throw UnimplementedError();
  }

  @override
  T? findAncestorRenderObjectOfType<T extends RenderObject>() {
    throw UnimplementedError();
  }

  @override
  T? findAncestorStateOfType<T extends State<StatefulWidget>>() {
    throw UnimplementedError();
  }

  @override
  T? findAncestorWidgetOfExactType<T extends Widget>() {
    throw UnimplementedError();
  }

  @override
  RenderObject? findRenderObject() {
    throw UnimplementedError();
  }

  @override
  T? findRootAncestorStateOfType<T extends State<StatefulWidget>>() {
    throw UnimplementedError();
  }

  @override
  InheritedElement? getElementForInheritedWidgetOfExactType<T extends InheritedWidget>() {
    throw UnimplementedError();
  }

  @override
  T? getInheritedWidgetOfExactType<T extends InheritedWidget>() {
    throw UnimplementedError();
  }

  @override
  BuildOwner? get owner => throw UnimplementedError();

  @override
  Size? get size => throw UnimplementedError();

  @override
  void visitAncestorElements(ConditionalElementVisitor visitor) {
    throw UnimplementedError();
  }

  @override
  void visitChildElements(ElementVisitor visitor) {
    throw UnimplementedError();
  }

  @override
  Widget get widget => throw UnimplementedError();

  @override
  bool get mounted => throw UnimplementedError();
}
