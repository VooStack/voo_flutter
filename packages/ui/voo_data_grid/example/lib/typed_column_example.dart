import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// Example demonstrating type-safe columns with TypedVooDataColumn
class TypedColumnExample extends StatelessWidget {
  const TypedColumnExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Type-Safe Column Example')),
      body: _buildGrid(),
    );
  }

  Widget _buildGrid() {
    // Create a controller with typed data source
    final controller = VooDataGridController<Person>(
      dataSource: _createDataSource(),
      columns: _createColumns(),
    );

    return VooDataGrid<Person>(
      controller: controller,
      showToolbar: true,
      showPagination: true,
    );
  }

  List<VooDataColumn<Person>> _createColumns() {
    return [
      // Type-safe string column
      TypedVooDataColumn<Person, String>(
        field: 'name',
        label: 'Name',
        typedValueGetter: (person) => person.name,
        typedValueFormatter: (name) => name.toUpperCase(),
        width: 200,
      ),
      
      // Type-safe int column
      TypedVooDataColumn<Person, int>(
        field: 'age',
        label: 'Age',
        typedValueGetter: (person) => person.age,
        typedValueFormatter: (age) => '$age years',
        typedCellBuilder: (context, age, person) {
          final color = age < 18 
              ? Colors.orange 
              : age < 65 
                  ? Colors.green 
                  : Colors.blue;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$age years',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          );
        },
        width: 100,
        textAlign: TextAlign.center,
      ),
      
      // Type-safe DateTime column
      TypedVooDataColumn<Person, DateTime>(
        field: 'birthDate',
        label: 'Birth Date',
        typedValueGetter: (person) => person.birthDate,
        typedValueFormatter: (date) {
          return '${date.day}/${date.month}/${date.year}';
        },
        width: 150,
        dataType: VooDataColumnType.date,
      ),
      
      // Type-safe double column (salary)
      TypedVooDataColumn<Person, double>(
        field: 'salary',
        label: 'Salary',
        typedValueGetter: (person) => person.salary,
        typedValueFormatter: (salary) {
          // Format with thousand separators
          final formatted = salary.toStringAsFixed(2)
              .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), 
                  (Match m) => '${m[1]},');
          return '\$$formatted';
        },
        width: 150,
        textAlign: TextAlign.right,
        dataType: VooDataColumnType.number,
      ),
      
      // Type-safe enum column
      TypedVooDataColumn<Person, Department>(
        field: 'department',
        label: 'Department',
        typedValueGetter: (person) => person.department,
        typedValueFormatter: (dept) => dept.displayName,
        typedCellBuilder: (context, dept, person) {
          return Chip(
            label: Text(dept.displayName),
            backgroundColor: dept.color.withValues(alpha: 0.2),
            labelStyle: TextStyle(color: dept.color),
          );
        },
        width: 150,
        filterable: true,
        filterOptions: Department.values.map((dept) => VooFilterOption(
          value: dept,
          label: dept.displayName,
        )).toList(),
      ),
      
      // Type-safe boolean column
      TypedVooDataColumn<Person, bool>(
        field: 'isActive',
        label: 'Active',
        typedValueGetter: (person) => person.isActive,
        typedCellBuilder: (context, isActive, person) {
          return Icon(
            isActive ? Icons.check_circle : Icons.cancel,
            color: isActive ? Colors.green : Colors.red,
          );
        },
        width: 80,
        textAlign: TextAlign.center,
        dataType: VooDataColumnType.boolean,
      ),
    ];
  }

  VooDataGridSource<Person> _createDataSource() {
    // Create a simple local data source
    return SimpleLocalDataSource<Person>(_generateSampleData());
  }

  List<Person> _generateSampleData() {
    return [
      Person(
        name: 'Alice Johnson',
        age: 28,
        birthDate: DateTime(1995, 3, 15),
        salary: 75000.50,
        department: Department.engineering,
        isActive: true,
      ),
      Person(
        name: 'Bob Smith',
        age: 35,
        birthDate: DateTime(1988, 7, 22),
        salary: 82000.00,
        department: Department.sales,
        isActive: true,
      ),
      Person(
        name: 'Charlie Brown',
        age: 42,
        birthDate: DateTime(1981, 11, 8),
        salary: 95000.75,
        department: Department.management,
        isActive: false,
      ),
      Person(
        name: 'Diana Prince',
        age: 31,
        birthDate: DateTime(1992, 5, 30),
        salary: 68000.00,
        department: Department.hr,
        isActive: true,
      ),
      Person(
        name: 'Edward Norton',
        age: 26,
        birthDate: DateTime(1997, 9, 12),
        salary: 58000.25,
        department: Department.engineering,
        isActive: true,
      ),
      Person(
        name: 'Fiona Green',
        age: 39,
        birthDate: DateTime(1984, 2, 18),
        salary: 72000.00,
        department: Department.marketing,
        isActive: true,
      ),
      Person(
        name: 'George Wilson',
        age: 45,
        birthDate: DateTime(1978, 12, 3),
        salary: 105000.00,
        department: Department.management,
        isActive: true,
      ),
      Person(
        name: 'Helen Troy',
        age: 29,
        birthDate: DateTime(1994, 6, 25),
        salary: 64000.50,
        department: Department.support,
        isActive: false,
      ),
      Person(
        name: 'Ian Malcolm',
        age: 37,
        birthDate: DateTime(1986, 10, 14),
        salary: 88000.00,
        department: Department.engineering,
        isActive: true,
      ),
      Person(
        name: 'Julia Roberts',
        age: 33,
        birthDate: DateTime(1990, 4, 7),
        salary: 71000.75,
        department: Department.sales,
        isActive: true,
      ),
    ];
  }
}

// Simple local data source implementation
class SimpleLocalDataSource<T> extends VooDataGridSource<T> {
  SimpleLocalDataSource(List<T> data) : super(mode: VooDataGridMode.local) {
    setLocalData(data);
    loadData(); // Initial load
  }
}

// Domain models with strong typing
class Person {
  final String name;
  final int age;
  final DateTime birthDate;
  final double salary;
  final Department department;
  final bool isActive;

  Person({
    required this.name,
    required this.age,
    required this.birthDate,
    required this.salary,
    required this.department,
    required this.isActive,
  });
}

enum Department {
  engineering('Engineering', Colors.blue),
  sales('Sales', Colors.green),
  marketing('Marketing', Colors.purple),
  hr('Human Resources', Colors.orange),
  support('Support', Colors.teal),
  management('Management', Colors.red);

  final String displayName;
  final Color color;
  
  const Department(this.displayName, this.color);
}

// Example usage in main app
void main() {
  runApp(const MaterialApp(
    home: TypedColumnExample(),
  ));
}