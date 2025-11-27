import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay/voo_adaptive_overlay.dart';

class BasicDemoPage extends StatefulWidget {
  const BasicDemoPage({super.key});

  @override
  State<BasicDemoPage> createState() => _BasicDemoPageState();
}

class _BasicDemoPageState extends State<BasicDemoPage> {
  VooOverlayStyle _selectedStyle = VooOverlayStyle.material;

  static const _styleInfo = <VooOverlayStyle, (String, IconData, Color)>{
    VooOverlayStyle.material: ('Material', Icons.android, Colors.indigo),
    VooOverlayStyle.cupertino: ('Cupertino', Icons.apple, Colors.blue),
    VooOverlayStyle.glass: ('Glass', Icons.blur_on, Colors.purple),
    VooOverlayStyle.minimal: ('Minimal', Icons.remove, Colors.grey),
    VooOverlayStyle.outlined: ('Outlined', Icons.check_box_outline_blank, Colors.teal),
    VooOverlayStyle.elevated: ('Elevated', Icons.layers, Colors.deepPurple),
    VooOverlayStyle.soft: ('Soft', Icons.cloud, Colors.pink),
    VooOverlayStyle.dark: ('Dark', Icons.dark_mode, Colors.blueGrey),
    VooOverlayStyle.gradient: ('Gradient', Icons.gradient, Colors.orange),
    VooOverlayStyle.neumorphic: ('Neumorphic', Icons.circle, Colors.brown),
    VooOverlayStyle.fluent: ('Fluent', Icons.window, Colors.lightBlue),
    VooOverlayStyle.brutalist: ('Brutalist', Icons.square, Colors.black87),
    VooOverlayStyle.retro: ('Retro', Icons.radio, Color(0xFF8B4513)),
    VooOverlayStyle.neon: ('Neon', Icons.flash_on, Colors.cyan),
    VooOverlayStyle.paper: ('Paper', Icons.description, Colors.blueGrey),
    VooOverlayStyle.frosted: ('Frosted', Icons.ac_unit, Colors.indigo),
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final styleData = _styleInfo[_selectedStyle]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Usage'),
      ),
      body: Column(
        children: [
          // Style selector
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outlineVariant,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  styleData.$2,
                  color: styleData.$3,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Style:',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<VooOverlayStyle>(
                    value: _selectedStyle,
                    isExpanded: true,
                    underline: const SizedBox(),
                    borderRadius: BorderRadius.circular(12),
                    onChanged: (style) {
                      if (style != null) {
                        setState(() => _selectedStyle = style);
                      }
                    },
                    items: VooOverlayStyle.values
                        .where((s) => s != VooOverlayStyle.custom)
                        .map((style) {
                      final info = _styleInfo[style]!;
                      return DropdownMenuItem(
                        value: style,
                        child: Row(
                          children: [
                            Icon(info.$2, size: 18, color: info.$3),
                            const SizedBox(width: 8),
                            Text(info.$1),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          // Demo list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionHeader(context, 'Adaptive Overlays'),
                _buildSection(
                  context,
                  title: 'Adaptive Overlay',
                  description:
                      'Automatically picks the right presentation based on screen size.',
                  buttonLabel: 'Show Adaptive Overlay',
                  onPressed: () => _showAdaptiveOverlay(context),
                ),
                _buildSection(
                  context,
                  title: 'Confirmation Dialog',
                  description: 'Common pattern for confirming user actions.',
                  buttonLabel: 'Show Confirmation',
                  onPressed: () => _showConfirmation(context),
                ),
                _buildSection(
                  context,
                  title: 'Simple Alert',
                  description: 'Simple alert with just an OK button.',
                  buttonLabel: 'Show Alert',
                  onPressed: () => _showSimpleAlert(context),
                ),
                const SizedBox(height: 16),
                _buildSectionHeader(context, 'Specific Overlay Types'),
                _buildSection(
                  context,
                  title: 'Bottom Sheet',
                  description: 'Slides up from the bottom of the screen.',
                  buttonLabel: 'Show Bottom Sheet',
                  onPressed: () => _showBottomSheet(context),
                ),
                _buildSection(
                  context,
                  title: 'Modal Dialog',
                  description: 'Centered dialog with backdrop.',
                  buttonLabel: 'Show Modal',
                  onPressed: () => _showModal(context),
                ),
                _buildSection(
                  context,
                  title: 'Side Sheet',
                  description: 'Slides in from the side of the screen.',
                  buttonLabel: 'Show Side Sheet',
                  onPressed: () => _showSideSheet(context),
                ),
                _buildSection(
                  context,
                  title: 'Drawer',
                  description: 'Navigation drawer from left or right edge.',
                  buttonLabel: 'Show Drawer',
                  onPressed: () => _showDrawer(context),
                ),
                _buildSection(
                  context,
                  title: 'Action Sheet',
                  description: 'iOS-style action list with multiple options.',
                  buttonLabel: 'Show Action Sheet',
                  onPressed: () => _showActionSheet(context),
                ),
                _buildSection(
                  context,
                  title: 'Fullscreen Overlay',
                  description: 'Covers the entire screen.',
                  buttonLabel: 'Show Fullscreen',
                  onPressed: () => _showFullscreen(context),
                ),
                const SizedBox(height: 16),
                _buildSectionHeader(context, 'Notifications'),
                _buildSection(
                  context,
                  title: 'Snackbar',
                  description: 'Bottom notification with optional action.',
                  buttonLabel: 'Show Snackbar',
                  onPressed: () => _showSnackbar(context),
                ),
                _buildSection(
                  context,
                  title: 'Banner',
                  description: 'Full-width notification at top or bottom.',
                  buttonLabel: 'Show Banner',
                  onPressed: () => _showBanner(context),
                ),
                const SizedBox(height: 16),
                _buildSectionHeader(context, 'Alerts & Popups'),
                _buildSection(
                  context,
                  title: 'Alert Dialog',
                  description: 'System-style alert with icon and actions.',
                  buttonLabel: 'Show Alert',
                  onPressed: () => _showAlert(context),
                ),
                _buildPopupSection(context),
                _buildTooltipSection(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String description,
    required String buttonLabel,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onPressed,
              child: Text(buttonLabel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopupSection(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Popup Menu',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Contextual popup positioned near an element.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Builder(
              builder: (buttonContext) {
                return FilledButton(
                  onPressed: () {
                    final box = buttonContext.findRenderObject() as RenderBox;
                    final position = box.localToGlobal(Offset.zero);
                    final rect = Rect.fromLTWH(
                      position.dx,
                      position.dy,
                      box.size.width,
                      box.size.height,
                    );
                    _showPopup(context, rect);
                  },
                  child: const Text('Show Popup'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTooltipSection(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tooltip',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Informational hint near an element.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Builder(
              builder: (buttonContext) {
                return FilledButton(
                  onPressed: () {
                    final box = buttonContext.findRenderObject() as RenderBox;
                    final position = box.localToGlobal(Offset.zero);
                    final rect = Rect.fromLTWH(
                      position.dx,
                      position.dy,
                      box.size.width,
                      box.size.height,
                    );
                    _showTooltip(context, rect);
                  },
                  child: const Text('Show Tooltip'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  VooOverlayConfig get _config => VooOverlayConfig(style: _selectedStyle);

  Future<void> _showAdaptiveOverlay(BuildContext context) async {
    final result = await VooAdaptiveOverlay.show<String>(
      context: context,
      title: const Text('Adaptive Overlay'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('This overlay automatically adapts to your screen size:'),
          const SizedBox(height: 12),
          const Text('• Mobile → Bottom Sheet'),
          const Text('• Tablet → Modal Dialog'),
          const Text('• Desktop → Side Sheet'),
          const SizedBox(height: 16),
          Text('Current style: ${_styleInfo[_selectedStyle]!.$1}'),
        ],
      ),
      actions: [
        VooOverlayAction.cancel(),
        VooOverlayAction(
          label: 'Got it!',
          isPrimary: true,
          onPressed: () => Navigator.of(context).pop('confirmed'),
        ),
      ],
      config: _config,
    );

    if (context.mounted && result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Result: $result')),
      );
    }
  }

  Future<void> _showConfirmation(BuildContext context) async {
    final confirmed = await VooAdaptiveOverlay.show<bool>(
      context: context,
      title: const Text('Delete Item'),
      content: const Text(
        'Are you sure you want to delete this item? This action cannot be undone.',
      ),
      actions: [
        VooOverlayAction.cancel(),
        VooOverlayAction(
          label: 'Delete',
          isPrimary: true,
          isDestructive: true,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
      config: _config,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(confirmed == true ? 'Item deleted' : 'Cancelled'),
        ),
      );
    }
  }

  Future<void> _showSimpleAlert(BuildContext context) async {
    await VooAdaptiveOverlay.show(
      context: context,
      title: const Text('Success'),
      content: const Text('Your changes have been saved successfully!'),
      actions: [VooOverlayAction.ok()],
      config: _config,
    );
  }

  Future<void> _showBottomSheet(BuildContext context) async {
    await VooAdaptiveOverlay.showBottomSheet(
      context: context,
      title: const Text('Bottom Sheet'),
      content: const Text(
        'This slides up from the bottom of the screen. Great for mobile interfaces and quick selections.',
      ),
      actions: [VooOverlayAction.ok()],
      config: _config,
    );
  }

  Future<void> _showModal(BuildContext context) async {
    await VooAdaptiveOverlay.showModal(
      context: context,
      title: const Text('Modal Dialog'),
      content: const Text(
        'A centered dialog that appears in front of the content. Good for important messages and confirmations.',
      ),
      actions: [VooOverlayAction.ok()],
      config: _config,
    );
  }

  Future<void> _showSideSheet(BuildContext context) async {
    await VooAdaptiveOverlay.showSideSheet(
      context: context,
      title: const Text('Side Sheet'),
      content: const Text(
        'Slides in from the edge of the screen. Perfect for detailed content on larger screens.',
      ),
      actions: [VooOverlayAction.close()],
      config: _config,
    );
  }

  Future<void> _showDrawer(BuildContext context) async {
    await VooAdaptiveOverlay.showDrawer(
      context: context,
      title: const Text('Navigation Drawer'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('A drawer overlay great for navigation menus.'),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      config: _config,
    );
  }

  Future<void> _showActionSheet(BuildContext context) async {
    await VooAdaptiveOverlay.showActionSheet(
      context: context,
      title: const Text('Choose an Action'),
      message: const Text('Select one of the options below'),
      actions: [
        VooOverlayAction.withIcon(
          label: 'Share',
          icon: Icons.share,
        ),
        VooOverlayAction.withIcon(
          label: 'Copy Link',
          icon: Icons.link,
        ),
        VooOverlayAction.withIcon(
          label: 'Download',
          icon: Icons.download,
        ),
        VooOverlayAction.withIcon(
          label: 'Delete',
          icon: Icons.delete,
          isDestructive: true,
        ),
      ],
      cancelAction: VooOverlayAction.cancel(),
      style: _selectedStyle,
    );
  }

  Future<void> _showFullscreen(BuildContext context) async {
    await VooAdaptiveOverlay.showFullscreen(
      context: context,
      title: const Text('Fullscreen Overlay'),
      content: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fullscreen, size: 64),
            SizedBox(height: 16),
            Text(
              'This covers the entire screen.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text('Great for immersive experiences or onboarding flows.'),
          ],
        ),
      ),
      actions: [VooOverlayAction.close()],
      config: _config,
    );
  }

  Future<void> _showSnackbar(BuildContext context) async {
    await VooAdaptiveOverlay.showSnackbar(
      context: context,
      message: 'File saved successfully',
      icon: Icons.check_circle,
      action: VooOverlayAction(
        label: 'View',
        onPressed: () {},
        autoPop: false,
      ),
      style: _selectedStyle,
    );
  }

  Future<void> _showBanner(BuildContext context) async {
    await VooAdaptiveOverlay.showBanner(
      context: context,
      title: 'Update Available',
      message: 'A new version of the app is ready to install.',
      type: VooBannerType.info,
      action: VooOverlayAction(label: 'Update', onPressed: () {}),
      duration: const Duration(seconds: 4),
      style: _selectedStyle,
    );
  }

  Future<void> _showAlert(BuildContext context) async {
    final result = await VooAdaptiveOverlay.showAlert<bool>(
      context: context,
      title: 'Confirm Action',
      message: 'Are you sure you want to proceed with this action?',
      type: VooAlertType.confirm,
      style: _selectedStyle,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result == true ? 'Confirmed!' : 'Cancelled'),
        ),
      );
    }
  }

  Future<void> _showPopup(BuildContext context, Rect anchorRect) async {
    await VooAdaptiveOverlay.showPopup(
      context: context,
      anchorRect: anchorRect,
      content: const Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Text('Choose an action:'),
      ),
      actions: [
        VooOverlayAction.withIcon(label: 'Edit', icon: Icons.edit),
        VooOverlayAction.withIcon(label: 'Duplicate', icon: Icons.copy),
        VooOverlayAction.withIcon(
          label: 'Delete',
          icon: Icons.delete,
          isDestructive: true,
        ),
      ],
      style: _selectedStyle,
    );
  }

  Future<void> _showTooltip(BuildContext context, Rect anchorRect) async {
    await VooAdaptiveOverlay.showTooltip(
      context: context,
      message: 'This is a helpful tooltip that provides additional context!',
      anchorRect: anchorRect,
      duration: const Duration(seconds: 3),
      style: _selectedStyle,
    );
  }
}
