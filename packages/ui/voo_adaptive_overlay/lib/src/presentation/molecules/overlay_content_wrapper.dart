import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_style.dart';

/// Wrapper widget that provides consistent padding and styling for overlay content.
class OverlayContentWrapper extends StatelessWidget {
  /// The content to wrap.
  final Widget child;

  /// The overlay style preset.
  final VooOverlayStyle style;

  /// Custom padding for the content.
  final EdgeInsets? padding;

  /// Whether to add scrolling capability.
  final bool scrollable;

  /// Scroll controller for scrollable content.
  final ScrollController? scrollController;

  /// Scroll physics for scrollable content.
  final ScrollPhysics? physics;

  const OverlayContentWrapper({
    super.key,
    required this.child,
    this.style = VooOverlayStyle.material,
    this.padding,
    this.scrollable = false,
    this.scrollController,
    this.physics,
  });

  EdgeInsets _getPadding() {
    if (padding != null) return padding!;
    switch (style) {
      case VooOverlayStyle.cupertino:
        return const EdgeInsets.symmetric(horizontal: 16);
      case VooOverlayStyle.material:
        return const EdgeInsets.symmetric(horizontal: 24);
      case VooOverlayStyle.glass:
        return const EdgeInsets.symmetric(horizontal: 20);
      case VooOverlayStyle.minimal:
        return const EdgeInsets.symmetric(horizontal: 16);
      case VooOverlayStyle.custom:
        return const EdgeInsets.symmetric(horizontal: 24);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
      padding: _getPadding(),
      child: child,
    );

    if (scrollable) {
      content = SingleChildScrollView(
        controller: scrollController,
        physics: physics,
        child: content,
      );
    }

    return content;
  }
}
