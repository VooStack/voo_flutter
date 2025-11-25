import 'package:flutter/material.dart';
import 'package:voo_json_tree/voo_json_tree.dart';

void main() {
  runApp(const VooJsonTreeExampleApp());
}

class VooJsonTreeExampleApp extends StatelessWidget {
  const VooJsonTreeExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VooJsonTree Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late JsonTreeController _controller;
  VooJsonTreeTheme? _currentTheme;
  String _themeName = 'System';
  bool _useBuilders = false;

  // Sample JSON data
  final Map<String, dynamic> _sampleData = {
    'user': {
      'id': 12345,
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'website': 'https://johndoe.dev',
      'isActive': true,
      'roles': ['admin', 'developer', 'reviewer'],
      'profile': {
        'avatar': 'https://example.com/avatar.png',
        'bio': 'Software developer with 10+ years of experience',
        '_internal': 'hidden field',
        'location': {
          'city': 'San Francisco',
          'state': 'CA',
          'country': 'USA',
          'coordinates': {
            'lat': 37.7749,
            'lng': -122.4194,
          },
        },
        'socialLinks': {
          'github': 'https://github.com/johndoe',
          'twitter': '@johndoe',
          'linkedin': null,
        },
      },
    },
    'settings': {
      'theme': 'dark',
      'notifications': {
        'email': true,
        'push': false,
        'sms': false,
      },
      'privacy': {
        'profileVisible': true,
        'showEmail': false,
      },
    },
    'stats': {
      'posts': 142,
      'followers': 1583,
      'following': 234,
      'lastLogin': '2024-01-15T10:30:00Z',
    },
    'important': 'This field is highlighted!',
    'tags': ['flutter', 'dart', 'mobile', 'web'],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _controller = JsonTreeController(
      config: const JsonTreeConfig(
        expandDepth: 2,
        enableSearch: true,
        enableCopy: true,
        showNodeCount: true,
      ),
    );
    _controller.setData(_sampleData);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _cycleTheme(BuildContext context) {
    setState(() {
      if (_themeName == 'System') {
        _currentTheme = VooJsonTreeTheme.dark();
        _themeName = 'Dark';
      } else if (_themeName == 'Dark') {
        _currentTheme = VooJsonTreeTheme.light();
        _themeName = 'Light';
      } else if (_themeName == 'Light') {
        _currentTheme = VooJsonTreeTheme.vscode();
        _themeName = 'VS Code';
      } else if (_themeName == 'VS Code') {
        _currentTheme = VooJsonTreeTheme.monokai();
        _themeName = 'Monokai';
      } else if (_themeName == 'Monokai') {
        _currentTheme = VooJsonTreeTheme.fromTokens();
        _themeName = 'Tokens';
      } else if (_themeName == 'Tokens') {
        _currentTheme = VooJsonTreeTheme.transparent();
        _themeName = 'Transparent';
      } else {
        _currentTheme = null; // System theme
        _themeName = 'System';
      }
    });
  }

  VooJsonTreeTheme _getTheme(BuildContext context) {
    return _currentTheme ?? VooJsonTreeTheme.system(context);
  }

  JsonTreeBuilders? _getBuilders() {
    if (!_useBuilders) return null;

    return JsonTreeBuilders(
      // Make URLs clickable (styled differently)
      valueBuilder: (context, node, defaultWidget) {
        final value = node.value;
        if (value is String && value.startsWith('http')) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.link, size: 12, color: Colors.blue),
                const SizedBox(width: 4),
                defaultWidget,
              ],
            ),
          );
        }
        return defaultWidget;
      },
      // Style internal/private keys differently
      keyBuilder: (context, node, defaultWidget) {
        if (node.key.startsWith('_')) {
          return Text(
            node.key,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
              fontFamily: 'monospace',
              fontSize: 13,
            ),
          );
        }
        return defaultWidget;
      },
      // Highlight important nodes
      nodeBuilder: (context, node, defaultWidget) {
        if (node.key == 'important') {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.amber, width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: defaultWidget,
          );
        }
        return defaultWidget;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VooJsonTree Example'),
        actions: [
          // Custom builders toggle
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Builders', style: TextStyle(fontSize: 12)),
              Switch(
                value: _useBuilders,
                onChanged: (value) => setState(() => _useBuilders = value),
              ),
            ],
          ),
          const SizedBox(width: 8),
          // Theme selector
          TextButton.icon(
            onPressed: () => _cycleTheme(context),
            icon: const Icon(Icons.palette),
            label: Text(_themeName),
          ),
          const SizedBox(width: 8),
          // Expand all
          IconButton(
            onPressed: _controller.expandAll,
            icon: const Icon(Icons.unfold_more),
            tooltip: 'Expand all',
          ),
          // Collapse all
          IconButton(
            onPressed: _controller.collapseAll,
            icon: const Icon(Icons.unfold_less),
            tooltip: 'Collapse all',
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Standard'),
            Tab(text: 'Minimal'),
            Tab(text: 'Developer'),
            Tab(text: 'Raw'),
            Tab(text: 'Responsive'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Standard tab
          _buildStandardTab(),
          // Minimal tab
          _buildMinimalTab(),
          // Developer tab
          _buildDeveloperTab(),
          // Raw tab
          _buildRawTab(),
          // Responsive tab
          _buildResponsiveTab(),
        ],
      ),
    );
  }

  Widget _buildStandardTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildInfoBar(
            'Standard View: Full features with controller, search, copy, keyboard navigation',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: VooJsonTree(
              controller: _controller,
              theme: _getTheme(context),
              builders: _getBuilders(),
              showToolbar: true,
              showPathBreadcrumb: true,
              config: const JsonTreeConfig(
                expandDepth: 2,
                enableSearch: true,
                enableCopy: true,
                enableContextMenu: true,
                enableKeyboardNavigation: true,
                showNodeCount: true,
                animateExpansion: true,
              ),
              onNodeTap: (node) {
                debugPrint('Tapped: ${node.path}');
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildSelectedInfo(),
        ],
      ),
    );
  }

  Widget _buildMinimalTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildInfoBar(
            'Minimal View: Bare-bones tree with no extras - just collapsible nodes',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: VooJsonTree.minimal(
              data: _sampleData,
              theme: _getTheme(context),
              onNodeTap: (node) {
                debugPrint('Minimal tapped: ${node.path}');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildInfoBar(
            'Developer View: All expanded, full metadata, ideal for debugging',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: VooJsonTree.developer(
              data: _sampleData,
              theme: _getTheme(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRawTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildInfoBar(
            'Raw View: Transparent background - tree in custom container',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.purple.shade900,
                    Colors.blue.shade900,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: VooJsonTree.raw(
                data: _sampleData,
                config: const JsonTreeConfig(
                  expandDepth: 1,
                  showNodeCount: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildInfoBar(
            'Responsive View: Auto-adapts to screen size (resize window to see)',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: VooJsonTreeResponsive(
              data: _sampleData,
              theme: _getTheme(context),
              mobileConfig: JsonTreeConfig.minimal(),
              tabletConfig: JsonTreeConfig.compact(),
              desktopConfig: JsonTreeConfig.full(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBar(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedInfo() {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final selected = _controller.selectedNode;
        if (selected == null) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected: ${selected.path}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Type: ${selected.type.displayName} | '
                      'Depth: ${selected.depth}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: _controller.clearSelection,
                child: const Text('Clear'),
              ),
            ],
          ),
        );
      },
    );
  }
}
