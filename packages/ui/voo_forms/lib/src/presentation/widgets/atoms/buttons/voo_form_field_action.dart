import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/routes/voo_side_panel_route.dart';
import 'package:voo_responsive/voo_responsive.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Atomic form field action button that opens a form in different ways based on screen size
/// - XL screens: Opens form in a side panel
/// - L screens (tablets): Opens form in a dialog
/// - Mobile: Opens form in a bottom sheet
///
/// The formBuilder should return any widget, typically a VooFormPageBuilder
/// or a widget that wraps VooFormPageBuilder (e.g., with BlocProvider)
class VooFormFieldAction extends StatelessWidget {
  /// Icon for the action button
  final Widget? icon;

  /// Tooltip text
  final String? tooltip;

  /// Builder function that returns the form widget
  /// This can be a VooFormPageBuilder or any widget that contains one
  /// Example: () => ClientFormPage() where ClientFormPage uses VooFormPageBuilder internally
  final WidgetBuilder formBuilder;

  /// Title for the side panel/dialog/bottom sheet header
  /// Optional - if not provided, no header will be shown
  final String? title;

  /// Whether the action is enabled
  final bool enabled;

  /// Custom button builder
  final Widget Function(BuildContext, VoidCallback)? buttonBuilder;

  /// Width of side panel on XL screens
  final double sidePanelWidth;

  /// Height factor for bottom sheet (0.0 to 1.0)
  final double bottomSheetHeightFactor;

  /// Whether dialog/bottom sheet/side panel is dismissible
  final bool isDismissible;

  /// Callback when the form should exit
  /// Defaults to Navigator.of(context).pop() if not provided
  final void Function(BuildContext)? onExit;

  const VooFormFieldAction({
    super.key,
    this.icon,
    this.tooltip,
    required this.formBuilder,
    this.title,
    this.enabled = true,
    this.buttonBuilder,
    this.sidePanelWidth = 400,
    this.bottomSheetHeightFactor = 0.9,
    this.isDismissible = true,
    this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final onPressed = enabled ? () => _handleAction(context) : null;

    // Use custom button builder if provided
    if (buttonBuilder != null) {
      return buttonBuilder!(context, onPressed ?? () {});
    }

    // Default icon button
    return IconButton(
      onPressed: onPressed,
      icon: icon ?? const Icon(Icons.add),
      tooltip: tooltip,
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.all(8),
      visualDensity: VisualDensity.compact,
    );
  }

  Future<void> _handleAction(BuildContext context) async {
    final screenSize = ResponsiveHelper.getScreenSize(context);

    switch (screenSize) {
      case ScreenSize.extraLarge:
        // Open in side panel (requires parent to handle)
        await _openSidePanel(context);
        break;
      case ScreenSize.large:
      case ScreenSize.medium:
        // Open in dialog
        await _openDialog(context);
        break;
      case ScreenSize.small:
      case ScreenSize.extraSmall:
        // Open in bottom sheet
        await _openBottomSheet(context);
        break;
    }

    // Result handling is done through the form's own callbacks
  }

  Future<dynamic> _openSidePanel(BuildContext context) async =>
      // Use Navigator to push a side panel route
      Navigator.of(context).push(VooSidePanelRoute(form: formBuilder(context), title: title, width: sidePanelWidth, dismissible: isDismissible));

  Future<dynamic> _openDialog(BuildContext context) async {
    final radius = context.vooRadius;

    return showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (context) => Dialog(
        child: Container(
          constraints: BoxConstraints(maxWidth: 600, maxHeight: MediaQuery.of(context).size.height * 0.8),
          child: ClipRRect(
            borderRadius: radius.dialog,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) _buildHeader(context),
                Expanded(child: formBuilder(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> _openBottomSheet(BuildContext context) async {
    final spacing = context.vooSpacing;
    final radius = context.vooRadius;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * bottomSheetHeightFactor,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(radius.xl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: EdgeInsets.only(top: spacing.inputPadding),
              width: 40,
              height: spacing.xs,
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(spacing.xxs)),
            ),
            if (title != null) _buildHeader(context),
            Expanded(child: formBuilder(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.vooSpacing;

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.2))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title!, style: theme.textTheme.titleLarge),
          IconButton(
            onPressed: () {
              if (onExit != null) {
                onExit!(context);
              } else {
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
