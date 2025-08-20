import 'package:flutter/material.dart';
import 'package:voo_logging_devtools_extension/presentation/pages/logs_tab.dart';
import 'package:voo_logging_devtools_extension/presentation/pages/network_tab.dart';
import 'package:voo_logging_devtools_extension/presentation/pages/performance_tab.dart';
import 'package:voo_logging_devtools_extension/presentation/pages/analytics_tab.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/logger_tab_bar.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/logger_toolbar.dart';

class VooLoggerPage extends StatefulWidget {
  const VooLoggerPage({super.key});

  @override
  State<VooLoggerPage> createState() => _VooLoggerPageState();
}

class _VooLoggerPageState extends State<VooLoggerPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          const LoggerToolbar(),
          LoggerTabBar(tabController: _tabController),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                LogsTab(),
                NetworkTab(),
                PerformanceTab(),
                AnalyticsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
