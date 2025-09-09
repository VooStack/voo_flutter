import 'package:flutter/material.dart';

/// Atomic dropdown overlay widget that provides a reusable dropdown overlay
/// with search functionality and proper click-outside-to-close behavior
class VooDropdownOverlay extends StatelessWidget {
  /// The layer link for positioning the overlay
  final LayerLink layerLink;

  /// The width of the overlay (usually matches the trigger widget width)
  final double width;

  /// Maximum height constraint for the overlay
  final double maxHeight;

  /// Callback when the overlay should be closed
  final VoidCallback onClose;

  /// The content to display in the overlay
  final Widget child;

  /// Optional search field configuration
  final VooDropdownSearchConfig? searchConfig;

  /// Optional header widget (appears after search, before content)
  final Widget? header;

  /// Vertical offset from the trigger widget
  final double verticalOffset;

  /// Border radius for the overlay
  final BorderRadius borderRadius;

  /// Elevation for the overlay
  final double elevation;

  const VooDropdownOverlay({
    super.key,
    required this.layerLink,
    required this.width,
    required this.onClose,
    required this.child,
    this.maxHeight = 300,
    this.searchConfig,
    this.header,
    this.verticalOffset = 8,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.elevation = 8,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        // Full screen invisible barrier to detect clicks outside
        Positioned.fill(
          child: GestureDetector(
            onTap: onClose,
            behavior: HitTestBehavior.opaque,
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        // The actual dropdown overlay
        Positioned(
          width: width,
          child: CompositedTransformFollower(
            link: layerLink,
            targetAnchor: Alignment.bottomLeft,
            offset: Offset(0, verticalOffset),
            // Wrap in GestureDetector to prevent clicks on dropdown from closing it
            child: GestureDetector(
              onTap: () {}, // Consume tap to prevent it from reaching the barrier
              child: Material(
                elevation: elevation,
                borderRadius: borderRadius,
                color: theme.colorScheme.surface,
                child: Container(
                  constraints: BoxConstraints(maxHeight: maxHeight),
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Optional search field
                      if (searchConfig != null) ...[
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: TextField(
                            controller: searchConfig!.controller,
                            focusNode: searchConfig!.focusNode,
                            autofocus: searchConfig!.autofocus,
                            decoration: InputDecoration(
                              hintText: searchConfig!.hintText,
                              prefixIcon: const Icon(Icons.search),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: searchConfig!.onChanged,
                          ),
                        ),
                      ],
                      // Optional header
                      if (header != null) header!,
                      // Divider between header and content
                      if (searchConfig != null || header != null)
                        const Divider(height: 1),
                      // Main content
                      Flexible(child: child),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Configuration for the search field in the dropdown overlay
class VooDropdownSearchConfig {
  /// Text controller for the search field
  final TextEditingController controller;

  /// Focus node for the search field
  final FocusNode? focusNode;

  /// Hint text for the search field
  final String hintText;

  /// Callback when search text changes
  final ValueChanged<String> onChanged;

  /// Whether to autofocus the search field
  final bool autofocus;

  const VooDropdownSearchConfig({
    required this.controller,
    required this.onChanged,
    this.focusNode,
    this.hintText = 'Search...',
    this.autofocus = true,
  });
}

/// Helper class to manage dropdown overlay state
class VooDropdownOverlayController {
  OverlayEntry? _overlayEntry;
  final BuildContext context;
  final LayerLink layerLink;
  bool _isOpen = false;

  VooDropdownOverlayController({
    required this.context,
    required this.layerLink,
  });

  bool get isOpen => _isOpen;

  /// Opens the dropdown overlay
  void open({
    required Widget Function(VoidCallback close) builder,
    required double width,
    double maxHeight = 300,
    double verticalOffset = 8,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(12)),
    double elevation = 8,
  }) {
    if (_isOpen) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => builder(close),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isOpen = true;
  }

  /// Closes the dropdown overlay
  void close() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOpen = false;
  }

  /// Rebuilds the overlay content
  void rebuild() {
    _overlayEntry?.markNeedsBuild();
  }

  /// Disposes the controller and removes any open overlay
  void dispose() {
    close();
  }
}