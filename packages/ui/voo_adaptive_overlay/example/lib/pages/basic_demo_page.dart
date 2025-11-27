import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay/voo_adaptive_overlay.dart';

class BasicDemoPage extends StatelessWidget {
  const BasicDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Usage'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            context,
            title: 'Adaptive Overlay',
            description: 'Automatically picks the right presentation based on screen size.',
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
            title: 'Alert Dialog',
            description: 'Simple alert with just an OK button.',
            buttonLabel: 'Show Alert',
            onPressed: () => _showAlert(context),
          ),
          _buildSection(
            context,
            title: 'Force Bottom Sheet',
            description: 'Always show as bottom sheet regardless of screen size.',
            buttonLabel: 'Show Bottom Sheet',
            onPressed: () => _showBottomSheet(context),
          ),
          _buildSection(
            context,
            title: 'Force Modal',
            description: 'Always show as centered modal dialog.',
            buttonLabel: 'Show Modal',
            onPressed: () => _showModal(context),
          ),
          _buildSection(
            context,
            title: 'Force Side Sheet',
            description: 'Always show as side sheet from the right.',
            buttonLabel: 'Show Side Sheet',
            onPressed: () => _showSideSheet(context),
          ),
        ],
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

  Future<void> _showAdaptiveOverlay(BuildContext context) async {
    final result = await VooAdaptiveOverlay.show<String>(
      context: context,
      title: const Text('Adaptive Overlay'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This overlay automatically adapts to your screen size:',
          ),
          SizedBox(height: 12),
          Text('• Mobile → Bottom Sheet'),
          Text('• Tablet → Modal Dialog'),
          Text('• Desktop → Side Sheet'),
          SizedBox(height: 16),
          Text('Try resizing your window to see the different presentations!'),
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
    );

    if (context.mounted && result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Result: $result')),
      );
    }
  }

  Future<void> _showConfirmation(BuildContext context) async {
    final confirmed = await context.showConfirmation(
      title: 'Delete Item',
      message: 'Are you sure you want to delete this item? This action cannot be undone.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(confirmed == true ? 'Item deleted' : 'Cancelled'),
        ),
      );
    }
  }

  Future<void> _showAlert(BuildContext context) async {
    await context.showAlert(
      title: 'Success',
      message: 'Your changes have been saved successfully!',
    );
  }

  Future<void> _showBottomSheet(BuildContext context) async {
    await VooAdaptiveOverlay.showBottomSheet(
      context: context,
      title: const Text('Bottom Sheet'),
      content: const Text(
        'This is always displayed as a bottom sheet, regardless of screen size.',
      ),
      actions: [VooOverlayAction.ok()],
    );
  }

  Future<void> _showModal(BuildContext context) async {
    await VooAdaptiveOverlay.showModal(
      context: context,
      title: const Text('Modal Dialog'),
      content: const Text(
        'This is always displayed as a centered modal dialog.',
      ),
      actions: [VooOverlayAction.ok()],
    );
  }

  Future<void> _showSideSheet(BuildContext context) async {
    await VooAdaptiveOverlay.showSideSheet(
      context: context,
      title: const Text('Side Sheet'),
      content: const Text(
        'This is always displayed as a side sheet from the right edge.',
      ),
      actions: [VooOverlayAction.close()],
    );
  }
}
