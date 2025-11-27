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
          _buildStyleCard(
            context,
            title: 'Outlined',
            description: 'Modern outlined style with bold borders and clean look.',
            style: VooOverlayStyle.outlined,
            color: Colors.teal,
          ),
          _buildStyleCard(
            context,
            title: 'Elevated',
            description: 'Strong layered shadows for a floating card effect.',
            style: VooOverlayStyle.elevated,
            color: Colors.deepPurple,
          ),
          _buildStyleCard(
            context,
            title: 'Soft',
            description: 'Soft pastel colors with gentle rounded corners.',
            style: VooOverlayStyle.soft,
            color: Colors.pink,
          ),
          _buildStyleCard(
            context,
            title: 'Dark',
            description: 'Dark mode optimized with high contrast and white text.',
            style: VooOverlayStyle.dark,
            color: Colors.blueGrey,
          ),
          _buildStyleCard(
            context,
            title: 'Gradient',
            description: 'Gradient background with smooth color transitions.',
            style: VooOverlayStyle.gradient,
            color: Colors.orange,
          ),
          _buildStyleCard(
            context,
            title: 'Neumorphic',
            description: 'Soft 3D shadows with same-color highlights.',
            style: VooOverlayStyle.neumorphic,
            color: Colors.brown,
          ),
          _buildStyleCard(
            context,
            title: 'Fluent',
            description: 'Microsoft Fluent Design with acrylic/mica effects.',
            style: VooOverlayStyle.fluent,
            color: Colors.lightBlue,
          ),
          _buildStyleCard(
            context,
            title: 'Brutalist',
            description: 'Bold, stark design with hard edges and high contrast.',
            style: VooOverlayStyle.brutalist,
            color: Colors.black87,
          ),
          _buildStyleCard(
            context,
            title: 'Retro',
            description: 'Vintage aesthetic with warm colors and rounded forms.',
            style: VooOverlayStyle.retro,
            color: const Color(0xFF8B4513),
          ),
          _buildStyleCard(
            context,
            title: 'Neon',
            description: 'Glowing neon borders on dark backgrounds.',
            style: VooOverlayStyle.neon,
            color: Colors.cyan,
          ),
          _buildStyleCard(
            context,
            title: 'Paper',
            description: 'Paper/card-like appearance with subtle textures.',
            style: VooOverlayStyle.paper,
            color: Colors.blueGrey.shade300,
          ),
          _buildStyleCard(
            context,
            title: 'Frosted',
            description: 'Heavy frosted glass effect with strong blur.',
            style: VooOverlayStyle.frosted,
            color: Colors.indigo.shade300,
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
      VooOverlayStyle.outlined => [
          'Bold border outline',
          'Clean background',
          'No shadows',
          'Modern look',
        ],
      VooOverlayStyle.elevated => [
          'Strong layered shadows',
          'Floating card effect',
          'Premium feel',
        ],
      VooOverlayStyle.soft => [
          'Pastel colors',
          'Gentle rounded corners',
          'Subtle shadows',
          'Friendly appearance',
        ],
      VooOverlayStyle.dark => [
          'Dark background',
          'High contrast',
          'Reduced eye strain',
          'White text',
        ],
      VooOverlayStyle.gradient => [
          'Gradient background',
          'Primary to secondary colors',
          'Modern vibrant look',
        ],
      VooOverlayStyle.neumorphic => [
          'Soft 3D shadows',
          'Same-color highlights',
          'Subtle depth effect',
        ],
      VooOverlayStyle.fluent => [
          'Acrylic/mica effect',
          'Subtle blur (30 sigma)',
          'Clean rounded corners',
          'Windows 11 inspired',
        ],
      VooOverlayStyle.brutalist => [
          'Sharp edges',
          'High contrast',
          'Bold borders',
          'No shadows',
        ],
      VooOverlayStyle.retro => [
          'Warm color palette',
          'Offset shadows',
          'Vintage feel',
          'Sepia-toned',
        ],
      VooOverlayStyle.neon => [
          'Glowing borders',
          'Dark background',
          'Cyberpunk aesthetic',
          'Theme color glow',
        ],
      VooOverlayStyle.paper => [
          'Subtle shadows',
          'Clean look',
          'Minimal corners',
          'Card-like feel',
        ],
      VooOverlayStyle.frosted => [
          'Heavy blur (25 sigma)',
          'Semi-transparent',
          'Soft rounded corners',
          'Subtle border',
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
