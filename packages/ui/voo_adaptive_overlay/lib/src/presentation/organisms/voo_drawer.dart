import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay/src/domain/entities/overlay_action.dart';
import 'package:voo_adaptive_overlay/src/domain/entities/overlay_behavior.dart';
import 'package:voo_adaptive_overlay/src/domain/entities/overlay_constraints.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_style.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_type.dart';
import 'package:voo_adaptive_overlay/src/presentation/molecules/overlay_action_bar.dart';
import 'package:voo_adaptive_overlay/src/presentation/molecules/overlay_header.dart';
import 'package:voo_adaptive_overlay/src/presentation/styles/base_overlay_style.dart';

/// A drawer overlay that slides in from the left or right.
///
/// Great for navigation menus, settings panels, or any content
/// that benefits from a slide-in panel design.
class VooDrawer extends StatelessWidget {
  /// The title of the drawer.
  final Widget? title;

  /// The main content of the drawer.
  final Widget? content;

  /// Builder for content that needs a scroll controller.
  final Widget Function(BuildContext, ScrollController?)? builder;

  /// Action buttons to display at the bottom.
  final List<VooOverlayAction>? actions;

  /// Visual style preset.
  final VooOverlayStyle style;

  /// Behavior configuration.
  final VooOverlayBehavior behavior;

  /// Size constraints.
  final VooOverlayConstraints constraints;

  /// Callback when close button is pressed.
  final VoidCallback? onClose;

  /// Scroll controller for content.
  final ScrollController? scrollController;

  /// Whether to anchor the drawer on the right side.
  /// If false, anchors on the left.
  final bool anchorRight;

  /// Leading widget in the header (e.g., back button).
  final Widget? leading;

  /// Trailing widgets in the header.
  final List<Widget>? trailing;

  const VooDrawer({
    super.key,
    this.title,
    this.content,
    this.builder,
    this.actions,
    this.style = VooOverlayStyle.material,
    this.behavior = const VooOverlayBehavior(),
    this.constraints = const VooOverlayConstraints(),
    this.onClose,
    this.scrollController,
    this.anchorRight = false,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final overlayStyle = BaseOverlayStyle.fromPreset(style);
    final blurSigma = overlayStyle.getBlurSigma();
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);

    // Calculate width
    double? maxWidth = constraints.maxWidth;
    if (maxWidth != null && maxWidth <= 1) {
      maxWidth = mediaQuery.size.width * maxWidth;
    }
    maxWidth ??= 320;

    // Adjust border radius based on anchor side
    BorderRadius borderRadius;
    if (anchorRight) {
      borderRadius = BorderRadius.horizontal(
        left: overlayStyle
            .getBorderRadius(context, VooOverlayType.drawer)
            .topLeft,
      );
    } else {
      borderRadius = BorderRadius.horizontal(
        right: overlayStyle
            .getBorderRadius(context, VooOverlayType.drawer)
            .topLeft,
      );
    }

    final decoration =
        overlayStyle.getDecoration(context, VooOverlayType.drawer).copyWith(
              borderRadius: borderRadius,
            );

    Widget drawer = Container(
      width: maxWidth,
      decoration: decoration,
      child: SafeArea(
        left: !anchorRight,
        right: anchorRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null || behavior.showCloseButton || leading != null)
              OverlayHeader(
                title: title,
                showCloseButton: behavior.showCloseButton,
                onClose: onClose ?? () => Navigator.of(context).pop(),
                style: style,
                leading: leading,
                trailing: trailing,
              ),
            if (content != null)
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: style == VooOverlayStyle.material ? 24 : 16,
                  ),
                  child: DefaultTextStyle.merge(
                    style: theme.textTheme.bodyLarge,
                    child: content!,
                  ),
                ),
              ),
            if (builder != null)
              Expanded(
                child: builder!(context, scrollController),
              ),
            if (actions != null && actions!.isNotEmpty)
              OverlayActionBar(
                actions: actions!,
                style: style,
              ),
          ],
        ),
      ),
    );

    if (blurSigma > 0) {
      drawer = ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: drawer,
        ),
      );
    }

    return Align(
      alignment: anchorRight ? Alignment.centerRight : Alignment.centerLeft,
      child: drawer,
    );
  }
}
