import 'package:flutter/material.dart';
import 'pages/calendar_views_page.dart';
import 'pages/selection_modes_page.dart';
import 'pages/events_page.dart';
import 'pages/pickers_page.dart';
import 'pages/themes_page.dart';
import 'pages/advanced_examples_page.dart';

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
    _NavigationItem(icon: Icons.code, label: 'Advanced', page: const AdvancedExamplesPage()),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final isTablet = MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 900;
    final isMobile = !isDesktop && !isTablet;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voo Calendar Examples'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      drawer: isMobile
          ? Drawer(
              child: ListView(
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.calendar_month,
                          size: 48,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Voo Calendar',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                        ),
                      ],
                    ),
                  ),
                  ..._pages.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return ListTile(
                      leading: Icon(item.icon),
                      title: Text(item.label),
                      selected: _selectedIndex == index,
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                        Navigator.of(context).pop(); // Close drawer
                      },
                    );
                  }),
                ],
              ),
            )
          : null,
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
    );
  }
}

class _NavigationItem {
  final IconData icon;
  final String label;
  final Widget page;

  const _NavigationItem({required this.icon, required this.label, required this.page});
}
