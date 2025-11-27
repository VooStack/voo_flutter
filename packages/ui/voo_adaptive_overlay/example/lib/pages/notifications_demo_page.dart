import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay/voo_adaptive_overlay.dart';

class NotificationsDemoPage extends StatelessWidget {
  const NotificationsDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications & Popups'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(context, 'Snackbars'),
          _buildSnackbarSection(context),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Banners'),
          _buildBannerSection(context),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Alerts'),
          _buildAlertSection(context),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Popups & Tooltips'),
          _buildPopupSection(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSnackbarSection(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildDemoButton(
          context,
          label: 'Basic Snackbar',
          color: Colors.indigo,
          onPressed: () => VooAdaptiveOverlay.showSnackbar(
            context: context,
            message: 'This is a basic snackbar',
          ),
        ),
        _buildDemoButton(
          context,
          label: 'With Icon',
          color: Colors.cyan,
          onPressed: () => VooAdaptiveOverlay.showSnackbar(
            context: context,
            message: 'Message saved to drafts',
            icon: Icons.save,
          ),
        ),
        _buildDemoButton(
          context,
          label: 'With Action',
          color: Colors.deepOrange,
          onPressed: () => VooAdaptiveOverlay.showSnackbar(
            context: context,
            message: 'Item deleted',
            action: VooOverlayAction(
              label: 'Undo',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Undone!')),
                );
              },
              autoPop: false,
            ),
          ),
        ),
        _buildDemoButton(
          context,
          label: 'With Close Button',
          color: Colors.brown,
          onPressed: () => VooAdaptiveOverlay.showSnackbar(
            context: context,
            message: 'You have new notifications',
            showCloseButton: true,
            duration: const Duration(seconds: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerSection(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildDemoButton(
          context,
          label: 'Info Banner',
          color: Colors.blue,
          onPressed: () => VooAdaptiveOverlay.showBanner(
            context: context,
            message: 'New features are available!',
            type: VooBannerType.info,
            duration: const Duration(seconds: 3),
          ),
        ),
        _buildDemoButton(
          context,
          label: 'Success Banner',
          color: Colors.green,
          onPressed: () => VooAdaptiveOverlay.showBanner(
            context: context,
            title: 'Success!',
            message: 'Your profile has been updated.',
            type: VooBannerType.success,
            duration: const Duration(seconds: 3),
          ),
        ),
        _buildDemoButton(
          context,
          label: 'Warning Banner',
          color: Colors.orange,
          onPressed: () => VooAdaptiveOverlay.showBanner(
            context: context,
            title: 'Warning',
            message: 'Your subscription expires in 3 days.',
            type: VooBannerType.warning,
            action: VooOverlayAction(label: 'Renew', onPressed: () {}),
            duration: const Duration(seconds: 5),
          ),
        ),
        _buildDemoButton(
          context,
          label: 'Error Banner',
          color: Colors.red,
          onPressed: () => VooAdaptiveOverlay.showBanner(
            context: context,
            title: 'Connection Error',
            message: 'Unable to connect to the server.',
            type: VooBannerType.error,
          ),
        ),
        _buildDemoButton(
          context,
          label: 'Bottom Banner',
          color: Colors.purple,
          onPressed: () => VooAdaptiveOverlay.showBanner(
            context: context,
            message: 'Banner at the bottom',
            position: VooBannerPosition.bottom,
            duration: const Duration(seconds: 3),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertSection(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildDemoButton(
          context,
          label: 'Info Alert',
          color: Colors.blue,
          onPressed: () => VooAdaptiveOverlay.showAlert(
            context: context,
            title: 'Information',
            message: 'This is an informational alert with important details.',
            type: VooAlertType.info,
          ),
        ),
        _buildDemoButton(
          context,
          label: 'Success Alert',
          color: Colors.green,
          onPressed: () => VooAdaptiveOverlay.showAlert(
            context: context,
            title: 'Success!',
            message: 'Your payment has been processed successfully.',
            type: VooAlertType.success,
          ),
        ),
        _buildDemoButton(
          context,
          label: 'Warning Alert',
          color: Colors.orange,
          onPressed: () => VooAdaptiveOverlay.showAlert(
            context: context,
            title: 'Warning',
            message: 'This action may have unintended consequences.',
            type: VooAlertType.warning,
          ),
        ),
        _buildDemoButton(
          context,
          label: 'Error Alert',
          color: Colors.red,
          onPressed: () => VooAdaptiveOverlay.showAlert(
            context: context,
            title: 'Error',
            message: 'Failed to save your changes. Please try again.',
            type: VooAlertType.error,
          ),
        ),
        _buildDemoButton(
          context,
          label: 'Confirm Alert',
          color: Colors.deepPurple,
          onPressed: () async {
            final confirmed = await VooAdaptiveOverlay.showAlert<bool>(
              context: context,
              title: 'Delete Account?',
              message:
                  'This will permanently delete your account and all associated data. This action cannot be undone.',
              type: VooAlertType.confirm,
            );
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(confirmed == true ? 'Confirmed' : 'Cancelled'),
                ),
              );
            }
          },
        ),
        _buildDemoButton(
          context,
          label: 'Custom Actions',
          color: Colors.teal,
          onPressed: () => VooAdaptiveOverlay.showAlert(
            context: context,
            title: 'Save Changes?',
            message: 'You have unsaved changes. What would you like to do?',
            type: VooAlertType.confirm,
            actions: [
              VooOverlayAction(label: 'Discard', isDestructive: true),
              VooOverlayAction(label: 'Save Draft'),
              VooOverlayAction(label: 'Save & Exit', isPrimary: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPopupSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Builder(
              builder: (buttonContext) {
                return _buildDemoButton(
                  context,
                  label: 'Show Popup',
                  color: Colors.indigo,
                  onPressed: () {
                    final box =
                        buttonContext.findRenderObject() as RenderBox;
                    final position = box.localToGlobal(Offset.zero);
                    final rect = Rect.fromLTWH(
                      position.dx,
                      position.dy,
                      box.size.width,
                      box.size.height,
                    );
                    VooAdaptiveOverlay.showPopup(
                      context: context,
                      anchorRect: rect,
                      content: const Text('This is a popup with custom content!'),
                      actions: [
                        VooOverlayAction.withIcon(
                          label: 'Edit',
                          icon: Icons.edit,
                        ),
                        VooOverlayAction.withIcon(
                          label: 'Share',
                          icon: Icons.share,
                        ),
                        VooOverlayAction.withIcon(
                          label: 'Delete',
                          icon: Icons.delete,
                          isDestructive: true,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            Builder(
              builder: (buttonContext) {
                return _buildDemoButton(
                  context,
                  label: 'Show Tooltip',
                  color: Colors.cyan,
                  onPressed: () {
                    final box =
                        buttonContext.findRenderObject() as RenderBox;
                    final position = box.localToGlobal(Offset.zero);
                    final rect = Rect.fromLTWH(
                      position.dx,
                      position.dy,
                      box.size.width,
                      box.size.height,
                    );
                    VooAdaptiveOverlay.showTooltip(
                      context: context,
                      message: 'This is a helpful tooltip explaining this feature!',
                      anchorRect: rect,
                    );
                  },
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Note',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Popups and tooltips are positioned relative to the button that triggered them. '
                  'They automatically adjust their position based on available screen space.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDemoButton(
    BuildContext context, {
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(backgroundColor: color),
      child: Text(label),
    );
  }
}
