import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay_example/pages/basic_demo_page.dart';
import 'package:voo_adaptive_overlay_example/pages/custom_content_demo_page.dart';
import 'package:voo_adaptive_overlay_example/pages/notifications_demo_page.dart';
import 'package:voo_adaptive_overlay_example/pages/styles_demo_page.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VooAdaptiveOverlay Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('VooAdaptiveOverlay Demo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isWide ? 32 : 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildInfoCard(context),
                const SizedBox(height: 24),
                _buildDemoCard(
                  context,
                  title: 'Basic Usage',
                  description: 'Simple examples showing the adaptive behavior.',
                  icon: Icons.auto_awesome,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BasicDemoPage()),
                  ),
                ),
                const SizedBox(height: 16),
                _buildDemoCard(
                  context,
                  title: 'Style Presets',
                  description: 'Material, iOS, Glass, and Minimal styles.',
                  icon: Icons.palette_outlined,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StylesDemoPage()),
                  ),
                ),
                const SizedBox(height: 16),
                _buildDemoCard(
                  context,
                  title: 'Custom Content',
                  description: 'Forms, lists, and complex content layouts.',
                  icon: Icons.widgets_outlined,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CustomContentDemoPage()),
                  ),
                ),
                const SizedBox(height: 16),
                _buildDemoCard(
                  context,
                  title: 'Notifications & Popups',
                  description: 'Snackbars, banners, alerts, and popups.',
                  icon: Icons.notifications_outlined,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NotificationsDemoPage()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    String currentMode;
    IconData modeIcon;

    if (screenWidth < 600) {
      currentMode = 'Mobile (Bottom Sheet)';
      modeIcon = Icons.smartphone;
    } else if (screenWidth < 1024) {
      currentMode = 'Tablet (Modal Dialog)';
      modeIcon = Icons.tablet;
    } else {
      currentMode = 'Desktop (Side Sheet)';
      modeIcon = Icons.desktop_windows;
    }

    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              modeIcon,
              size: 48,
              color: theme.colorScheme.onPrimaryContainer,
            ),
            const SizedBox(height: 12),
            Text(
              'Current Mode',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              currentMode,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Width: ${screenWidth.toInt()}px',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.onSecondaryContainer,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
