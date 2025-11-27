import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay/src/domain/entities/overlay_action.dart';
import 'package:voo_adaptive_overlay/src/domain/entities/overlay_behavior.dart';
import 'package:voo_adaptive_overlay/src/domain/entities/overlay_constraints.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_style.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_type.dart';
import 'package:voo_adaptive_overlay/src/presentation/atoms/overlay_handle.dart';
import 'package:voo_adaptive_overlay/src/presentation/molecules/overlay_action_bar.dart';
import 'package:voo_adaptive_overlay/src/presentation/molecules/overlay_header.dart';
import 'package:voo_adaptive_overlay/src/presentation/styles/base_overlay_style.dart';

/// A bottom sheet overlay that slides up from the bottom of the screen.
class VooBottomSheet extends StatelessWidget {
  /// The title of the bottom sheet.
  final Widget? title;

  /// The main content of the bottom sheet.
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

  const VooBottomSheet({
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
  });

  @override
  Widget build(BuildContext context) {
    final overlayStyle = BaseOverlayStyle.fromPreset(style);
    final decoration = overlayStyle.getDecoration(context, VooOverlayType.bottomSheet);
    final blurSigma = overlayStyle.getBlurSigma();

    Widget sheet = Container(
      decoration: decoration,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (behavior.showDragHandle)
              OverlayHandle(style: style),
            if (title != null || behavior.showCloseButton)
              OverlayHeader(
                title: title,
                showCloseButton: behavior.showCloseButton,
                onClose: onClose ?? () => Navigator.of(context).pop(),
                style: style,
              ),
            if (content != null)
              Flexible(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: style == VooOverlayStyle.material ? 24 : 16,
                  ),
                  child: DefaultTextStyle.merge(
                    style: Theme.of(context).textTheme.bodyLarge,
                    child: content!,
                  ),
                ),
              ),
            if (builder != null)
              Flexible(
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
        borderRadius: overlayStyle.getBorderRadius(context, VooOverlayType.bottomSheet),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: sheet,
        ),
      );
    }

    return sheet;
  }
}
