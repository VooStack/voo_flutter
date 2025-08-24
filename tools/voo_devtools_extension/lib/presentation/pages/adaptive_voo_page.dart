import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_logging_devtools_extension/core/services/plugin_detection_service.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/log_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/log_event.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/network_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/network_event.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/performance_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/performance_event.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/analytics_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/analytics_event.dart';
import 'package:voo_logging_devtools_extension/presentation/pages/logs_tab.dart';
import 'package:voo_logging_devtools_extension/presentation/pages/network_tab.dart';
import 'package:voo_logging_devtools_extension/presentation/pages/performance_tab.dart';
import 'package:voo_logging_devtools_extension/presentation/pages/analytics_tab.dart';
import 'package:voo_ui/voo_ui.dart';

class AdaptiveVooPage extends StatefulWidget {
  final Map<String, bool> pluginStatus;

  const AdaptiveVooPage({super.key, required this.pluginStatus});

  @override
  State<AdaptiveVooPage> createState() => _AdaptiveVooPageState();
}

class _AdaptiveVooPageState extends State<AdaptiveVooPage> {
  int _selectedIndex = 0;
  bool _isNavCollapsed = false;
  double _navWidth = 250.0;
  final double _navMinWidth = 72.0;
  final double _navMaxWidth = 350.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Build list of available tabs
    final availableTabs = _buildAvailableTabs();

    if (availableTabs.isEmpty) {
      return _buildNoPluginsView(context);
    }

    // Use custom collapsible navigation drawer
    return Scaffold(
      body: Row(
        children: [
          // Collapsible Navigation Panel
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _isNavCollapsed ? _navMinWidth : _navWidth,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                right: BorderSide(
                  color: theme.colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // Header with collapse button
                Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(
                    horizontal: _isNavCollapsed ? 8 : 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      if (!_isNavCollapsed) ...[
                        Icon(
                          Icons.dashboard_customize,
                          size: 24,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Dev Stack',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      IconButton(
                        icon: Icon(
                          _isNavCollapsed ? Icons.menu : Icons.menu_open,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _isNavCollapsed = !_isNavCollapsed;
                          });
                        },
                        tooltip: _isNavCollapsed
                            ? 'Expand menu'
                            : 'Collapse menu',
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Navigation Items
                Expanded(
                  child: ListView.builder(
                    itemCount: availableTabs.length,
                    itemBuilder: (context, index) {
                      final tab = availableTabs[index];
                      final info = PluginDetectionService.getPluginInfo(
                        tab.pluginName,
                      );
                      final isSelected = _selectedIndex == index;

                      return ListTile(
                        selected: isSelected,
                        selectedTileColor: colorScheme.primaryContainer
                            .withValues(alpha: 0.3),
                        leading: _getIconForPlugin(
                          tab.pluginName,
                          selected: isSelected,
                          size: 20,
                        ),
                        title: !_isNavCollapsed
                            ? Text(info.name, overflow: TextOverflow.ellipsis)
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: _isNavCollapsed ? 16 : 16,
                          vertical: 4,
                        ),
                        horizontalTitleGap: _isNavCollapsed ? 0 : 12,
                        minLeadingWidth: 24,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Resizable divider
          if (!_isNavCollapsed)
            MouseRegion(
              cursor: SystemMouseCursors.resizeColumn,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    _navWidth = (_navWidth + details.delta.dx).clamp(
                      _navMinWidth,
                      _navMaxWidth,
                    );
                  });
                },
                child: Container(
                  width: 4,
                  color: Colors.transparent,
                  child: Center(
                    child: Container(
                      width: 1,
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                ),
              ),
            ),
          // Main Content
          Expanded(
            child: Column(
              children: [
                _buildHeader(availableTabs[_selectedIndex], theme),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: availableTabs[_selectedIndex].content,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(TabInfo tab, ThemeData theme) {
    final info = PluginDetectionService.getPluginInfo(tab.pluginName);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant, width: 1),
        ),
      ),
      child: Row(
        children: [
          _getIconForPlugin(tab.pluginName, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                info.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                info.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Quality of life: Quick actions
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => _refreshCurrentTab(tab.pluginName),
                tooltip: 'Refresh',
              ),
              IconButton(
                icon: const Icon(Icons.clear_all),
                onPressed: () => _clearCurrentTab(tab.pluginName),
                tooltip: 'Clear',
              ),
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: () => _exportCurrentTab(tab.pluginName),
                tooltip: 'Export',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoPluginsView(BuildContext context) {
    return Scaffold(
      body: Center(
        child: VooEmptyState(
          icon: Icons.extension_off,
          title: 'No Voo Plugins Detected',
          message: 'Initialize Voo plugins in your app to see data here.',
          action: TextButton.icon(
            onPressed: () {
              // Could open documentation
            },
            icon: const Icon(Icons.help_outline),
            label: const Text('View Documentation'),
          ),
        ),
      ),
    );
  }

  List<TabInfo> _buildAvailableTabs() {
    final tabs = <TabInfo>[];

    if (widget.pluginStatus['voo_logging'] == true) {
      tabs.add(TabInfo(pluginName: 'voo_logging', content: const LogsTab()));
    }

    if (widget.pluginStatus['voo_analytics'] == true) {
      tabs.add(
        TabInfo(pluginName: 'voo_analytics', content: const AnalyticsTab()),
      );
    }

    // Separate Network and Performance into individual tabs
    if (widget.pluginStatus['voo_performance'] == true) {
      tabs.add(TabInfo(pluginName: 'voo_network', content: const NetworkTab()));

      tabs.add(
        TabInfo(pluginName: 'voo_performance', content: const PerformanceTab()),
      );
    }

    if (widget.pluginStatus['voo_telemetry'] == true) {
      tabs.add(
        TabInfo(
          pluginName: 'voo_telemetry',
          content: const Center(child: Text('Telemetry view coming soon')),
        ),
      );
    }

    return tabs;
  }

  Widget _getIconForPlugin(
    String pluginName, {
    double size = 24,
    bool selected = false,
  }) {
    IconData iconData;
    switch (pluginName) {
      case 'voo_logging':
        iconData = selected ? Icons.article : Icons.article_outlined;
        break;
      case 'voo_analytics':
        iconData = selected ? Icons.analytics : Icons.analytics_outlined;
        break;
      case 'voo_network':
        iconData = selected ? Icons.wifi : Icons.wifi_outlined;
        break;
      case 'voo_performance':
        iconData = selected ? Icons.speed : Icons.speed_outlined;
        break;
      case 'voo_telemetry':
        iconData = selected
            ? Icons.satellite_alt
            : Icons.satellite_alt_outlined;
        break;
      default:
        iconData = Icons.extension;
    }

    return Icon(iconData, size: size);
  }

  void _refreshCurrentTab(String pluginName) {
    // Refresh data based on the plugin
    switch (pluginName) {
      case 'voo_logging':
        context.read<LogBloc>().add(LoadLogs());
        break;
      case 'voo_network':
        context.read<NetworkBloc>().add(LoadNetworkLogs());
        break;
      case 'voo_performance':
        context.read<PerformanceBloc>().add(LoadPerformanceLogs());
        break;
      case 'voo_analytics':
        context.read<AnalyticsBloc>().add(LoadAnalyticsEvents());
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Refreshing ${PluginDetectionService.getPluginInfo(pluginName).name}...',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _clearCurrentTab(String pluginName) {
    final pluginInfo = PluginDetectionService.getPluginInfo(pluginName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Data'),
        content: Text('Clear all ${pluginInfo.name} data?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();

              // Clear data based on plugin
              switch (pluginName) {
                case 'voo_logging':
                  context.read<LogBloc>().add(ClearLogs());
                  break;
                case 'voo_network':
                  context.read<NetworkBloc>().add(ClearNetworkLogs());
                  break;
                case 'voo_performance':
                  context.read<PerformanceBloc>().add(ClearPerformanceLogs());
                  break;
                case 'voo_analytics':
                  context.read<AnalyticsBloc>().add(ClearAnalyticsEvents());
                  break;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${pluginInfo.name} data cleared')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _exportCurrentTab(String pluginName) {
    final pluginInfo = PluginDetectionService.getPluginInfo(pluginName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Export ${pluginInfo.name} data as:'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _performExport(pluginName, 'json');
                  },
                  icon: const Icon(Icons.code),
                  label: const Text('JSON'),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _performExport(pluginName, 'csv');
                  },
                  icon: const Icon(Icons.table_chart),
                  label: const Text('CSV'),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _performExport(String pluginName, String format) {
    // TODO: Implement actual export functionality
    // For now, just show success message
    final pluginInfo = PluginDetectionService.getPluginInfo(pluginName);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${pluginInfo.name} data exported as ${format.toUpperCase()}',
        ),
        action: SnackBarAction(
          label: 'Open',
          onPressed: () {
            // TODO: Open the exported file
          },
        ),
      ),
    );
  }
}

class TabInfo {
  final String pluginName;
  final Widget content;

  TabInfo({required this.pluginName, required this.content});
}
