import 'package:flutter/material.dart';
import 'package:voo_ui/voo_ui.dart';
import 'data_grid_example.dart';
import 'calendar_example.dart';
import 'components_gallery.dart';
import 'design_system_demo.dart';

void main() {
  runApp(const VooUIExampleApp());
}

class VooUIExampleApp extends StatelessWidget {
  const VooUIExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const VooMaterialApp(
      title: 'Voo UI Example',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ComponentsGallery(),
    const CalendarExample(),
    const DataGridExample(),
    const DesignSystemDemo(),
  ];

  final List<NavigationDestination> _destinations = const [
    NavigationDestination(
      icon: Icon(Icons.widgets_outlined),
      selectedIcon: Icon(Icons.widgets),
      label: 'Components',
    ),
    NavigationDestination(
      icon: Icon(Icons.calendar_month_outlined),
      selectedIcon: Icon(Icons.calendar_month),
      label: 'Calendar',
    ),
    NavigationDestination(
      icon: Icon(Icons.table_chart_outlined),
      selectedIcon: Icon(Icons.table_chart),
      label: 'Data Grid',
    ),
    NavigationDestination(
      icon: Icon(Icons.palette_outlined),
      selectedIcon: Icon(Icons.palette),
      label: 'Design System',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: _destinations,
      ),
    );
  }
}
