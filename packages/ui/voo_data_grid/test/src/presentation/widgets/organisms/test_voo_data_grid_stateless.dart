import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'VooDataGridStateless Test',
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
    home: const VooDesignSystem(data: VooDesignSystemData.defaultSystem, child: MyHomePage()),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late VooDataGridState<Product> _state;
  final List<VooDataColumn<Product>> _columns = [
    VooDataColumn<Product>(field: 'id', label: 'ID', valueGetter: (product) => product.id),
    VooDataColumn<Product>(field: 'name', label: 'Name', valueGetter: (product) => product.name),
    VooDataColumn<Product>(field: 'price', label: 'Price', valueGetter: (product) => product.price, valueFormatter: (value) => '\$${value.toStringAsFixed(2)}'),
    VooDataColumn<Product>(field: 'stock', label: 'Stock', valueGetter: (product) => product.stock),
  ];

  @override
  void initState() {
    super.initState();
    _state = VooDataGridState<Product>(
      rows: [
        Product(id: 'P1', name: 'Product 1', price: 10.0, stock: 5),
        Product(id: 'P2', name: 'Product 2', price: 20.0, stock: 10),
        Product(id: 'P3', name: 'Product 3', price: 30.0, stock: 15),
      ],
      totalRows: 3,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: const Text('VooDataGridStateless Test')),
    body: VooDataGridStateless<Product>(
      state: _state,
      columns: _columns,
      onPageChanged: (page) {
        setState(() {
          _state = _state.copyWith(currentPage: page);
        });
      },
      onFilterChanged: (field, filter) {
        setState(() {
          final newFilters = Map<String, VooDataFilter>.from(_state.filters);
          if (filter == null) {
            newFilters.remove(field);
          } else {
            newFilters[field] = filter;
          }
          _state = _state.copyWith(filters: newFilters);
        });
      },
    ),
  );
}

class Product {
  final String id;
  final String name;
  final double price;
  final int stock;

  Product({required this.id, required this.name, required this.price, required this.stock});
}
