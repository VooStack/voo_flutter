import 'package:flutter/material.dart';
import 'pages/calendar_views_page.dart';
import 'pages/selection_modes_page.dart';
import 'pages/events_page.dart';
import 'pages/pickers_page.dart';
import 'pages/themes_page.dart';

void main() {
  runApp(const VooCalendarExampleApp());
}

class VooCalendarExampleApp extends StatelessWidget {
  const VooCalendarExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voo Calendar Examples',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(),
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

  final List<_NavigationItem> _pages = [
    _NavigationItem(icon: Icons.calendar_view_month, label: 'Views', page: const CalendarViewsPage()),
    _NavigationItem(icon: Icons.select_all, label: 'Selection', page: const SelectionModesPage()),
    _NavigationItem(icon: Icons.event, label: 'Events', page: const EventsPage()),
    _NavigationItem(icon: Icons.date_range, label: 'Pickers', page: const PickersPage()),
    _NavigationItem(icon: Icons.palette, label: 'Themes', page: const ThemesPage()),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final isTablet = MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voo Calendar Examples'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: Row(
        children: [
          if (isDesktop || isTablet)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: isDesktop ? NavigationRailLabelType.all : NavigationRailLabelType.selected,
              destinations: _pages.map((item) => NavigationRailDestination(icon: Icon(item.icon), label: Text(item.label))).toList(),
            ),
          Expanded(child: _pages[_selectedIndex].page),
        ],
      ),
      bottomNavigationBar: isDesktop || isTablet
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: _pages.map((item) => NavigationDestination(icon: Icon(item.icon), label: item.label)).toList(),
            ),
    );
  }
}

class _NavigationItem {
  final IconData icon;
  final String label;
  final Widget page;

  const _NavigationItem({required this.icon, required this.label, required this.page});
}
