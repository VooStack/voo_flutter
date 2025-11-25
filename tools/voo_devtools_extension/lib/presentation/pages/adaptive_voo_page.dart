import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_devtools_extension/core/models/keyboard_shortcut.dart';
import 'package:voo_devtools_extension/core/services/keyboard_shortcuts_service.dart';
import 'package:voo_devtools_extension/core/services/plugin_detection_service.dart';
import 'package:voo_devtools_extension/core/services/preferences_service.dart';
import 'package:voo_devtools_extension/core/services/theme_service.dart';
import 'package:voo_devtools_extension/presentation/blocs/log_bloc.dart';
import 'package:voo_devtools_extension/presentation/blocs/log_event.dart';
import 'package:voo_devtools_extension/presentation/blocs/network_bloc.dart';
import 'package:voo_devtools_extension/presentation/blocs/network_event.dart';
import 'package:voo_devtools_extension/presentation/blocs/performance_bloc.dart';
import 'package:voo_devtools_extension/presentation/blocs/performance_event.dart';
import 'package:voo_devtools_extension/presentation/blocs/analytics_bloc.dart';
import 'package:voo_devtools_extension/presentation/blocs/analytics_event.dart';
import 'package:voo_devtools_extension/presentation/pages/logs_tab.dart';
import 'package:voo_devtools_extension/presentation/pages/network_tab.dart';
import 'package:voo_devtools_extension/presentation/pages/performance_tab.dart';
import 'package:voo_devtools_extension/presentation/pages/analytics_tab.dart';
import 'package:voo_devtools_extension/presentation/widgets/molecules/export_dialog.dart';
import 'package:voo_devtools_extension/presentation/widgets/molecules/shortcuts_help_dialog.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

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

  final _focusNode = FocusNode();
  final _shortcutsService = KeyboardShortcutsService();
  final _preferencesService = PreferencesService();
  final _themeService = ThemeService();
  List<TabInfo> _availableTabs = [];

  @override
  void initState() {
    super.initState();
    _registerKeyboardShortcuts();
    _loadPreferences();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _shortcutsService.unregisterAll();
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    await _preferencesService.initialize();
    final prefs = _preferencesService.preferences;
    setState(() {
      _navWidth = prefs.navPanelWidth;
      _isNavCollapsed = prefs.isNavCollapsed;
      _selectedIndex = prefs.lastSelectedTabIndex;
    });
  }

  void _saveNavWidth() {
    _preferencesService.setNavPanelWidth(_navWidth);
  }

  void _saveNavCollapsed() {
    _preferencesService.setNavCollapsed(_isNavCollapsed);
  }

  void _saveSelectedIndex() {
    _preferencesService.setLastSelectedTabIndex(_selectedIndex);
  }

  void _registerKeyboardShortcuts() {
    // Tab navigation
    _shortcutsService.register(AppShortcuts.tab1.id, () => _switchToTab(0));
    _shortcutsService.register(AppShortcuts.tab2.id, () => _switchToTab(1));
    _shortcutsService.register(AppShortcuts.tab3.id, () => _switchToTab(2));
    _shortcutsService.register(AppShortcuts.tab4.id, () => _switchToTab(3));

    // Actions
    _shortcutsService.register(AppShortcuts.refresh.id, _handleRefresh);
    _shortcutsService.register(AppShortcuts.clearData.id, _handleClear);
    _shortcutsService.register(AppShortcuts.exportData.id, _handleExport);

    // View
    _shortcutsService.register(AppShortcuts.toggleTheme.id, () => _themeService.toggleTheme());

    // Help
    _shortcutsService.register(AppShortcuts.showHelp.id, _showShortcutsHelp);
  }

  void _switchToTab(int index) {
    if (index < _availableTabs.length) {
      setState(() => _selectedIndex = index);
      _saveSelectedIndex();
    }
  }

  void _handleRefresh() {
    if (_availableTabs.isNotEmpty) {
      _refreshCurrentTab(_availableTabs[_selectedIndex].pluginName);
    }
  }

  void _handleClear() {
    if (_availableTabs.isNotEmpty) {
      _clearCurrentTab(_availableTabs[_selectedIndex].pluginName);
    }
  }

  void _handleExport() {
    if (_availableTabs.isNotEmpty) {
      _exportCurrentTab(_availableTabs[_selectedIndex].pluginName);
    }
  }

  void _showShortcutsHelp() {
    ShortcutsHelpDialog.show(context);
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (_shortcutsService.handleKeyEvent(event)) {
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Build list of available tabs and store for keyboard shortcuts
    _availableTabs = _buildAvailableTabs();

    if (_availableTabs.isEmpty) {
      return _buildNoPluginsView(context);
    }

    // Wrap with Focus to capture keyboard shortcuts
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
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
                          _saveNavCollapsed();
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
                    itemCount: _availableTabs.length,
                    itemBuilder: (context, index) {
                      final tab = _availableTabs[index];
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
                          _saveSelectedIndex();
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
                onHorizontalDragEnd: (_) => _saveNavWidth(),
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
                _buildHeader(_availableTabs[_selectedIndex], theme),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _availableTabs[_selectedIndex].content,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
                tooltip: 'Refresh (${AppShortcuts.refresh.displayString})',
              ),
              IconButton(
                icon: const Icon(Icons.clear_all),
                onPressed: () => _clearCurrentTab(tab.pluginName),
                tooltip: 'Clear (${AppShortcuts.clearData.displayString})',
              ),
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: () => _exportCurrentTab(tab.pluginName),
                tooltip: 'Export (${AppShortcuts.exportData.displayString})',
              ),
              const SizedBox(width: 8),
              const VerticalDivider(width: 1, indent: 8, endIndent: 8),
              const SizedBox(width: 8),
              ListenableBuilder(
                listenable: _themeService,
                builder: (context, _) {
                  final isDark = _themeService.isDarkMode;
                  return IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) {
                        return RotationTransition(
                          turns: animation,
                          child: FadeTransition(opacity: animation, child: child),
                        );
                      },
                      child: Icon(
                        isDark ? Icons.dark_mode : Icons.light_mode,
                        key: ValueKey(isDark),
                      ),
                    ),
                    onPressed: () => _themeService.toggleTheme(),
                    tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.keyboard),
                onPressed: _showShortcutsHelp,
                tooltip: 'Keyboard Shortcuts (${AppShortcuts.showHelp.displayString})',
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
    switch (pluginName) {
      case 'voo_logging':
        final state = context.read<LogBloc>().state;
        ExportDialog.showForLogs(context, state.filteredLogs);
        break;
      case 'voo_network':
        final state = context.read<NetworkBloc>().state;
        ExportDialog.showForNetwork(context, state.filteredNetworkRequests);
        break;
      case 'voo_performance':
        final state = context.read<PerformanceBloc>().state;
        ExportDialog.showForPerformance(context, state.filteredPerformanceLogs);
        break;
      case 'voo_analytics':
        final state = context.read<AnalyticsBloc>().state;
        ExportDialog.showForAnalytics(context, state.filteredEvents);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Export not available for this tab'),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }
}

class TabInfo {
  final String pluginName;
  final Widget content;

  TabInfo({required this.pluginName, required this.content});
}
