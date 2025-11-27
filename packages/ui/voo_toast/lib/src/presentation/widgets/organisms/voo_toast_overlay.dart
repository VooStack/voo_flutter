import 'package:flutter/material.dart';
import 'package:voo_responsive/voo_responsive.dart';
import 'package:voo_toast/src/domain/entities/toast.dart';
import 'package:voo_toast/src/domain/enums/toast_animation.dart';
import 'package:voo_toast/src/domain/enums/toast_position.dart';
import 'package:voo_toast/src/domain/enums/toast_style.dart';
import 'package:voo_toast/src/presentation/state/voo_toast_controller.dart';
import 'package:voo_toast/src/presentation/widgets/molecules/voo_toast_card.dart';

/// A widget that displays toast notifications over its child.
///
/// Wrap your app's root widget with [VooToastOverlay] to enable
/// toast notifications throughout your app.
///
/// ```dart
/// MaterialApp(
///   home: VooToastOverlay(
///     child: MyHomePage(),
///   ),
/// )
/// ```
class VooToastOverlay extends StatefulWidget {
  const VooToastOverlay({
    super.key,
    required this.child,
    this.controller,
  });

  /// The child widget to display behind the toasts.
  final Widget child;

  /// Optional controller for managing toasts. Defaults to [VooToastController.instance].
  final VooToastController? controller;

  @override
  State<VooToastOverlay> createState() => _VooToastOverlayState();
}

class _VooToastOverlayState extends State<VooToastOverlay> {
  late VooToastController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? VooToastController.instance;
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          widget.child,
          StreamBuilder<List<Toast>>(
            stream: _controller.toastsStream,
            initialData: const [],
            builder: (context, snapshot) {
              final toasts = snapshot.data ?? [];
              if (toasts.isEmpty) return const SizedBox.shrink();

              final groupedToasts = _groupToastsByPosition(toasts);

              return Stack(
                children: groupedToasts.entries
                    .map((entry) => _ToastPositionGroup(
                          position: entry.key,
                          toasts: entry.value,
                          controller: _controller,
                        ))
                    .toList(),
              );
            },
          ),
        ],
      );

  Map<ToastPosition, List<Toast>> _groupToastsByPosition(List<Toast> toasts) {
    final grouped = <ToastPosition, List<Toast>>{};
    for (final toast in toasts) {
      final position = _resolvePosition(context, toast.position);
      grouped[position] = [...(grouped[position] ?? []), toast];
    }
    return grouped;
  }

  ToastPosition _resolvePosition(BuildContext context, ToastPosition position) {
    if (position != ToastPosition.auto) return position;

    final config = _controller.config;

    if (ResponsiveHelper.isMobile(context)) {
      return config.mobilePosition;
    } else if (ResponsiveHelper.isTablet(context)) {
      return config.tabletPosition;
    } else {
      return config.webPosition;
    }
  }
}

/// Widget that positions a group of toasts at a specific position.
class _ToastPositionGroup extends StatelessWidget {
  const _ToastPositionGroup({
    required this.position,
    required this.toasts,
    required this.controller,
  });

  final ToastPosition position;
  final List<Toast> toasts;
  final VooToastController controller;

  @override
  Widget build(BuildContext context) {
    // Use SafeArea padding for mobile
    final padding = MediaQuery.of(context).padding;
    final isMobile = ResponsiveHelper.isMobile(context);

    // Check if any toast uses snackbar style for edge-to-edge layout
    final hasSnackbar = toasts.any((t) =>
        (t.style ?? controller.config.defaultStyle).isSnackbar);

    return Positioned(
      top: _getTop(padding, isMobile),
      bottom: _getBottom(padding, isMobile, hasSnackbar),
      left: _getLeft(isMobile, hasSnackbar),
      right: _getRight(isMobile, hasSnackbar),
      child: Align(
        alignment: _getAlignment(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: toasts.asMap().entries.map((entry) {
            final index = entry.key;
            final toast = entry.value;
            return _AnimatedToastItem(
              key: ValueKey(toast.id),
              toast: toast,
              controller: controller,
              index: index,
            );
          }).toList(),
        ),
      ),
    );
  }

  double? _getTop(EdgeInsets safeArea, bool isMobile) {
    switch (position) {
      case ToastPosition.top:
      case ToastPosition.topLeft:
      case ToastPosition.topCenter:
      case ToastPosition.topRight:
        return isMobile ? safeArea.top + 8 : 24;
      case ToastPosition.center:
      case ToastPosition.centerLeft:
      case ToastPosition.centerRight:
      case ToastPosition.bottom:
      case ToastPosition.bottomLeft:
      case ToastPosition.bottomCenter:
      case ToastPosition.bottomRight:
      case ToastPosition.auto:
        return null;
    }
  }

  double? _getBottom(EdgeInsets safeArea, bool isMobile, bool hasSnackbar) {
    switch (position) {
      case ToastPosition.top:
      case ToastPosition.topLeft:
      case ToastPosition.topCenter:
      case ToastPosition.topRight:
      case ToastPosition.center:
      case ToastPosition.centerLeft:
      case ToastPosition.centerRight:
      case ToastPosition.auto:
        return null;
      case ToastPosition.bottom:
      case ToastPosition.bottomLeft:
      case ToastPosition.bottomCenter:
      case ToastPosition.bottomRight:
        // Snackbars sit closer to the edge
        if (hasSnackbar && isMobile) {
          return safeArea.bottom;
        }
        return isMobile ? safeArea.bottom + 8 : 24;
    }
  }

  double? _getLeft(bool isMobile, bool hasSnackbar) {
    // Snackbars use minimal horizontal margin for edge-to-edge look
    if (hasSnackbar && isMobile) {
      return 8;
    }

    switch (position) {
      case ToastPosition.topLeft:
      case ToastPosition.centerLeft:
      case ToastPosition.bottomLeft:
        return isMobile ? 16 : 24;
      case ToastPosition.top:
      case ToastPosition.topCenter:
      case ToastPosition.center:
      case ToastPosition.bottom:
      case ToastPosition.bottomCenter:
        return isMobile ? 16 : null;
      case ToastPosition.topRight:
      case ToastPosition.centerRight:
      case ToastPosition.bottomRight:
      case ToastPosition.auto:
        return isMobile ? 16 : null;
    }
  }

  double? _getRight(bool isMobile, bool hasSnackbar) {
    // Snackbars use minimal horizontal margin for edge-to-edge look
    if (hasSnackbar && isMobile) {
      return 8;
    }

    switch (position) {
      case ToastPosition.topRight:
      case ToastPosition.centerRight:
      case ToastPosition.bottomRight:
        return isMobile ? 16 : 24;
      case ToastPosition.top:
      case ToastPosition.topCenter:
      case ToastPosition.center:
      case ToastPosition.bottom:
      case ToastPosition.bottomCenter:
        return isMobile ? 16 : null;
      case ToastPosition.topLeft:
      case ToastPosition.centerLeft:
      case ToastPosition.bottomLeft:
      case ToastPosition.auto:
        return isMobile ? 16 : null;
    }
  }

  Alignment _getAlignment() {
    switch (position) {
      case ToastPosition.top:
      case ToastPosition.topCenter:
        return Alignment.topCenter;
      case ToastPosition.topLeft:
        return Alignment.topLeft;
      case ToastPosition.topRight:
        return Alignment.topRight;
      case ToastPosition.center:
        return Alignment.center;
      case ToastPosition.centerLeft:
        return Alignment.centerLeft;
      case ToastPosition.centerRight:
        return Alignment.centerRight;
      case ToastPosition.bottom:
      case ToastPosition.bottomCenter:
        return Alignment.bottomCenter;
      case ToastPosition.bottomLeft:
        return Alignment.bottomLeft;
      case ToastPosition.bottomRight:
        return Alignment.bottomRight;
      case ToastPosition.auto:
        return Alignment.bottomCenter;
    }
  }
}

/// Animated toast item with enter/exit transitions.
class _AnimatedToastItem extends StatefulWidget {
  const _AnimatedToastItem({
    super.key,
    required this.toast,
    required this.controller,
    required this.index,
  });

  final Toast toast;
  final VooToastController controller;
  final int index;

  @override
  State<_AnimatedToastItem> createState() => _AnimatedToastItemState();
}

class _AnimatedToastItemState extends State<_AnimatedToastItem>
    with TickerProviderStateMixin {
  late AnimationController _enterController;
  late AnimationController _hoverController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _enterController = AnimationController(
      duration: widget.controller.config.animationDuration,
      vsync: this,
    );

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _setupAnimations();

    // Staggered entrance - delay based on index
    final staggerDelay = Duration(milliseconds: widget.index * 50);
    Future.delayed(staggerDelay, () {
      if (mounted) {
        _enterController.forward();
      }
    });
  }

  void _setupAnimations() {
    final curve = CurvedAnimation(
      parent: _enterController,
      curve: Curves.easeOutCubic,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(curve);

    switch (widget.toast.animation) {
      case ToastAnimation.slideInFromTop:
        _slideAnimation = Tween<Offset>(
          begin: const Offset(0, -1.0),
          end: Offset.zero,
        ).animate(curve);
        _scaleAnimation = const AlwaysStoppedAnimation(1.0);
        break;
      case ToastAnimation.slideInFromBottom:
        _slideAnimation = Tween<Offset>(
          begin: const Offset(0, 1.0),
          end: Offset.zero,
        ).animate(curve);
        _scaleAnimation = const AlwaysStoppedAnimation(1.0);
        break;
      case ToastAnimation.slideInFromLeft:
        _slideAnimation = Tween<Offset>(
          begin: const Offset(-1.0, 0),
          end: Offset.zero,
        ).animate(curve);
        _scaleAnimation = const AlwaysStoppedAnimation(1.0);
        break;
      case ToastAnimation.slideInFromRight:
        _slideAnimation = Tween<Offset>(
          begin: const Offset(1.0, 0),
          end: Offset.zero,
        ).animate(curve);
        _scaleAnimation = const AlwaysStoppedAnimation(1.0);
        break;
      case ToastAnimation.slideIn:
        _slideAnimation = Tween<Offset>(
          begin: const Offset(0, -0.15),
          end: Offset.zero,
        ).animate(curve);
        _scaleAnimation = const AlwaysStoppedAnimation(1.0);
        break;
      case ToastAnimation.scale:
        _slideAnimation = const AlwaysStoppedAnimation(Offset.zero);
        _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(parent: _enterController, curve: Curves.easeOutBack),
        );
        break;
      case ToastAnimation.bounce:
        _slideAnimation = Tween<Offset>(
          begin: const Offset(0, -0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _enterController, curve: Curves.elasticOut),
        );
        _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
          CurvedAnimation(parent: _enterController, curve: Curves.elasticOut),
        );
        break;
      case ToastAnimation.rotate:
        _slideAnimation = const AlwaysStoppedAnimation(Offset.zero);
        _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(curve);
        break;
      case ToastAnimation.fade:
      case ToastAnimation.none:
        _slideAnimation = const AlwaysStoppedAnimation(Offset.zero);
        _scaleAnimation = const AlwaysStoppedAnimation(1.0);
        break;
    }
  }

  @override
  void dispose() {
    _enterController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final margin = widget.toast.margin ??
        widget.controller.config.defaultMargin ??
        const EdgeInsets.symmetric(vertical: 4, horizontal: 0);

    Widget child = Padding(
      padding: margin,
      child: MouseRegion(
        onEnter: (_) => _hoverController.forward(),
        onExit: (_) => _hoverController.reverse(),
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) => Transform.scale(
            scale: 1.0 + (_hoverController.value * 0.015),
            child: Transform.translate(
              offset: Offset(0, -_hoverController.value * 2),
              child: child,
            ),
          ),
          child: VooToastCard(
            toast: widget.toast,
            onDismiss: () => widget.controller.dismiss(widget.toast.id),
            config: widget.controller.config,
            iconSize: widget.controller.config.iconSize,
            closeButtonSize: widget.controller.config.closeButtonSize,
            progressBarHeight: widget.controller.config.progressBarHeight,
          ),
        ),
      ),
    );

    if (widget.toast.animation == ToastAnimation.none) {
      return child;
    }

    // Apply rotation for rotate animation
    if (widget.toast.animation == ToastAnimation.rotate) {
      child = AnimatedBuilder(
        animation: _enterController,
        builder: (context, child) => Transform.rotate(
          angle: (1 - _enterController.value) * -0.05,
          child: child,
        ),
        child: child,
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: child,
        ),
      ),
    );
  }
}
