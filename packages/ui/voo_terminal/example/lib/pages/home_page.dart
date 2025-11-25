import 'package:flutter/material.dart';

import 'package:voo_terminal_example/pages/preview_demo_page.dart';
import 'package:voo_terminal_example/pages/interactive_demo_page.dart';
import 'package:voo_terminal_example/pages/theme_showcase_page.dart';
import 'package:voo_terminal_example/pages/log_viewer_demo_page.dart';

/// Home page with navigation to different demos.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VooTerminal Examples'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DemoCard(
            title: 'Preview Terminal',
            description: 'Read-only terminal for displaying logs and output',
            icon: Icons.visibility,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PreviewDemoPage()),
            ),
          ),
          const SizedBox(height: 12),
          _DemoCard(
            title: 'Interactive Terminal',
            description: 'Full command-line interface with history',
            icon: Icons.terminal,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InteractiveDemoPage()),
            ),
          ),
          const SizedBox(height: 12),
          _DemoCard(
            title: 'Theme Showcase',
            description: 'Browse all available terminal themes',
            icon: Icons.palette,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ThemeShowcasePage()),
            ),
          ),
          const SizedBox(height: 12),
          _DemoCard(
            title: 'Log Viewer',
            description: 'Stream-based log viewer demo',
            icon: Icons.list_alt,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LogViewerDemoPage()),
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _DemoCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.7),
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
