import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay/src/domain/entities/overlay_action.dart';
import 'package:voo_adaptive_overlay/src/domain/entities/overlay_behavior.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_style.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_type.dart';
import 'package:voo_adaptive_overlay/src/presentation/molecules/overlay_action_bar.dart';
import 'package:voo_adaptive_overlay/src/presentation/styles/base_overlay_style.dart';

/// A fullscreen overlay that covers the entire screen.
class VooFullscreenOverlay extends StatelessWidget {
  /// The title of the overlay.
  final Widget? title;

  /// The main content of the overlay.
  final Widget? content;

  /// Builder for content that needs a scroll controller.
  final Widget Function(BuildContext, ScrollController?)? builder;

  /// Action buttons to display at the bottom.
  final List<VooOverlayAction>? actions;

  /// Visual style preset.
  final VooOverlayStyle style;

  /// Behavior configuration.
  final VooOverlayBehavior behavior;

  /// Callback when close button is pressed.
  final VoidCallback? onClose;

  /// Scroll controller for content.
  final ScrollController? scrollController;

  const VooFullscreenOverlay({
    super.key,
    this.title,
    this.content,
    this.builder,
    this.actions,
    this.style = VooOverlayStyle.material,
    this.behavior = const VooOverlayBehavior(),
    this.onClose,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final overlayStyle = BaseOverlayStyle.fromPreset(style);
    final backgroundColor = overlayStyle.getBackgroundColor(context, VooOverlayType.fullscreen);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: title,
        actions: [
          if (behavior.showCloseButton)
            IconButton(
              onPressed: onClose ?? () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
              tooltip: 'Close',
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (content != null)
              Expanded(
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
  }
}
