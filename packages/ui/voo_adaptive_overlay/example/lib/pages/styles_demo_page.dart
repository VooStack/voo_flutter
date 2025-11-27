import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay/voo_adaptive_overlay.dart';

class StylesDemoPage extends StatelessWidget {
  const StylesDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Style Presets'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStyleCard(
            context,
            title: 'Material',
            description: 'Standard Material Design 3 with theme colors and shadows.',
            style: VooOverlayStyle.material,
            color: Colors.indigo,
          ),
          _buildStyleCard(
            context,
            title: 'Cupertino',
            description: 'iOS-style with rounded corners, drag handle, and blur backdrop.',
            style: VooOverlayStyle.cupertino,
            color: Colors.blue,
          ),
          _buildStyleCard(
            context,
            title: 'Glass',
            description: 'Glassmorphism effect with frosted glass and subtle borders.',
            style: VooOverlayStyle.glass,
            color: Colors.purple,
          ),
          _buildStyleCard(
            context,
            title: 'Minimal',
            description: 'Clean, borderless design focused on content.',
            style: VooOverlayStyle.minimal,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildStyleCard(
    BuildContext context, {
    required String title,
    required String description,
    required VooOverlayStyle style,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.style, color: color),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => _showStyledOverlay(context, title, style),
              child: Text('Show $title Style'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showStyledOverlay(
    BuildContext context,
    String styleName,
    VooOverlayStyle style,
  ) async {
    await VooAdaptiveOverlay.show(
      context: context,
      title: Text('$styleName Style'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('This overlay is using the $styleName style preset.'),
          const SizedBox(height: 16),
          const Text('Features:'),
          const SizedBox(height: 8),
          _buildFeatureList(style),
        ],
      ),
      actions: [
        VooOverlayAction.cancel(),
        VooOverlayAction.ok(),
      ],
      config: VooOverlayConfig(style: style),
    );
  }

  Widget _buildFeatureList(VooOverlayStyle style) {
    final features = switch (style) {
      VooOverlayStyle.material => [
          'Material 3 colors',
          'Elevation shadows',
          'Standard rounded corners',
        ],
      VooOverlayStyle.cupertino => [
          'iOS-style rounded corners',
          'Blur backdrop effect',
          'Drag handle indicator',
        ],
      VooOverlayStyle.glass => [
          'Frosted glass background',
          'Blur effect (15 sigma)',
          'Subtle white border',
          'Translucent colors',
        ],
      VooOverlayStyle.minimal => [
          'Clean surface color',
          'Subtle border only',
          'No shadows',
          'Focus on content',
        ],
      VooOverlayStyle.custom => [
          'User-defined styles',
        ],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features.map((f) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            const Icon(Icons.check, size: 16),
            const SizedBox(width: 8),
            Text(f),
          ],
        ),
      )).toList(),
    );
  }
}
