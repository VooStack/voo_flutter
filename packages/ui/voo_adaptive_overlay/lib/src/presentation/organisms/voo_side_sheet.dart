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

/// A side sheet overlay that slides in from the side of the screen.
class VooSideSheet extends StatelessWidget {
  /// The title of the side sheet.
  final Widget? title;

  /// The main content of the side sheet.
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

  /// Whether to anchor the sheet on the right side.
  final bool anchorRight;

  const VooSideSheet({
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
    this.anchorRight = true,
  });

  @override
  Widget build(BuildContext context) {
    final overlayStyle = BaseOverlayStyle.fromPreset(style);
    final decoration = overlayStyle.getDecoration(context, VooOverlayType.sideSheet);
    final blurSigma = overlayStyle.getBlurSigma();
    final mediaQuery = MediaQuery.of(context);

    // Calculate width
    double? maxWidth = constraints.maxWidth;
    if (maxWidth != null && maxWidth <= 1) {
      maxWidth = mediaQuery.size.width * maxWidth;
    }
    maxWidth ??= 400;

    // Adjust border radius based on anchor side
    BorderRadius borderRadius;
    if (anchorRight) {
      borderRadius = BorderRadius.horizontal(
        left: overlayStyle.getBorderRadius(context, VooOverlayType.sideSheet).topLeft,
      );
    } else {
      borderRadius = BorderRadius.horizontal(
        right: overlayStyle.getBorderRadius(context, VooOverlayType.sideSheet).topLeft,
      );
    }

    Widget sheet = Container(
      width: maxWidth,
      decoration: decoration.copyWith(borderRadius: borderRadius),
      child: SafeArea(
        left: !anchorRight,
        right: anchorRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null || behavior.showCloseButton)
              OverlayHeader(
                title: title,
                showCloseButton: behavior.showCloseButton,
                onClose: onClose ?? () => Navigator.of(context).pop(),
                style: style,
              ),
            if (content != null)
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: style == VooOverlayStyle.material ? 24 : 16,
                  ),
                  child: content,
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
      sheet = ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: sheet,
        ),
      );
    }

    return Align(
      alignment: anchorRight ? Alignment.centerRight : Alignment.centerLeft,
      child: sheet,
    );
  }
}
