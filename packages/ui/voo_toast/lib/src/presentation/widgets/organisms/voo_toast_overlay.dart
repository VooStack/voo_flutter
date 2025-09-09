import 'package:flutter/material.dart';
import 'package:voo_toast/src/domain/entities/toast.dart';
import 'package:voo_toast/src/domain/enums/toast_animation.dart';
import 'package:voo_toast/src/domain/enums/toast_position.dart';
import 'package:voo_toast/src/presentation/state/voo_toast_controller.dart';
import 'package:voo_toast/src/presentation/widgets/molecules/voo_toast_card.dart';

class VooToastOverlay extends StatefulWidget {
  const VooToastOverlay({
    super.key,
    required this.child,
    this.controller,
  });

  final Widget child;
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
                    .map(
                      (entry) => _buildToastGroup(
                        context,
                        entry.key,
                        entry.value,
                      ),
                    )
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

    final width = MediaQuery.of(context).size.width;
    final config = _controller.config;

    if (width < config.breakpointMobile) {
      return config.mobilePosition;
    } else if (width < config.breakpointTablet) {
      return config.tabletPosition;
    } else {
      return config.webPosition;
    }
  }

  Widget _buildToastGroup(
    BuildContext context,
    ToastPosition position,
    List<Toast> toasts,
  ) =>
      Positioned(
        top: _getTop(position),
        bottom: _getBottom(position),
        left: _getLeft(position),
        right: _getRight(position),
        child: Align(
          alignment: _getAlignment(position),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: toasts
                .map(
                  (toast) => Padding(
                    padding: toast.margin ?? _controller.config.defaultMargin ?? const EdgeInsets.all(8),
                    child: AnimatedToast(
                      key: ValueKey(toast.id),
                      toast: toast,
                      animation: toast.animation,
                      animationDuration: _controller.config.animationDuration,
                      onDismiss: () => _controller.dismiss(toast.id),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );

  double? _getTop(ToastPosition position) {
    switch (position) {
      case ToastPosition.top:
      case ToastPosition.topLeft:
      case ToastPosition.topCenter:
      case ToastPosition.topRight:
        return 24;
      case ToastPosition.center:
      case ToastPosition.centerLeft:
      case ToastPosition.centerRight:
        return null;
      case ToastPosition.bottom:
      case ToastPosition.bottomLeft:
      case ToastPosition.bottomCenter:
      case ToastPosition.bottomRight:
      case ToastPosition.auto:
        return null;
    }
  }

  double? _getBottom(ToastPosition position) {
    switch (position) {
      case ToastPosition.top:
      case ToastPosition.topLeft:
      case ToastPosition.topCenter:
      case ToastPosition.topRight:
        return null;
      case ToastPosition.center:
      case ToastPosition.centerLeft:
      case ToastPosition.centerRight:
        return null;
      case ToastPosition.bottom:
      case ToastPosition.bottomLeft:
      case ToastPosition.bottomCenter:
      case ToastPosition.bottomRight:
        return 24;
      case ToastPosition.auto:
        return null;
    }
  }

  double? _getLeft(ToastPosition position) {
    switch (position) {
      case ToastPosition.topLeft:
      case ToastPosition.centerLeft:
      case ToastPosition.bottomLeft:
        return 24;
      case ToastPosition.top:
      case ToastPosition.topCenter:
      case ToastPosition.center:
      case ToastPosition.bottom:
      case ToastPosition.bottomCenter:
        return null;
      case ToastPosition.topRight:
      case ToastPosition.centerRight:
      case ToastPosition.bottomRight:
      case ToastPosition.auto:
        return null;
    }
  }

  double? _getRight(ToastPosition position) {
    switch (position) {
      case ToastPosition.topRight:
      case ToastPosition.centerRight:
      case ToastPosition.bottomRight:
        return 24;
      case ToastPosition.top:
      case ToastPosition.topCenter:
      case ToastPosition.center:
      case ToastPosition.bottom:
      case ToastPosition.bottomCenter:
        return null;
      case ToastPosition.topLeft:
      case ToastPosition.centerLeft:
      case ToastPosition.bottomLeft:
      case ToastPosition.auto:
        return null;
    }
  }

  Alignment _getAlignment(ToastPosition position) {
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

class AnimatedToast extends StatefulWidget {
  const AnimatedToast({
    super.key,
    required this.toast,
    required this.animation,
    required this.animationDuration,
    required this.onDismiss,
  });

  final Toast toast;
  final ToastAnimation animation;
  final Duration animationDuration;
  final VoidCallback onDismiss;

  @override
  State<AnimatedToast> createState() => _AnimatedToastState();
}

class _AnimatedToastState extends State<AnimatedToast> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _hoverController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _setupAnimations();
    _animationController.forward();
  }

  void _setupAnimations() {
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _bounceAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    switch (widget.animation) {
      case ToastAnimation.slideInFromTop:
        _slideAnimation = Tween<Offset>(
          begin: const Offset(0, -1.5),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );
        break;
      case ToastAnimation.slideInFromBottom:
        _slideAnimation = Tween<Offset>(
          begin: const Offset(0, 1.5),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );
        break;
      case ToastAnimation.slideInFromLeft:
        _slideAnimation = Tween<Offset>(
          begin: const Offset(-1.5, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );
        break;
      case ToastAnimation.slideInFromRight:
        _slideAnimation = Tween<Offset>(
          begin: const Offset(1.5, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );
        break;
      case ToastAnimation.slideIn:
        _slideAnimation = Tween<Offset>(
          begin: const Offset(0, -0.2),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.fastOutSlowIn,
          ),
        );
        break;
      default:
        _slideAnimation = const AlwaysStoppedAnimation(Offset.zero);
    }

    _scaleAnimation = widget.animation == ToastAnimation.scale
        ? Tween<double>(begin: 0.3, end: 1.0).animate(_bounceAnimation)
        : widget.animation == ToastAnimation.bounce
            ? Tween<double>(begin: 0.5, end: 1.0).animate(_bounceAnimation)
            : const AlwaysStoppedAnimation(1.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = MouseRegion(
      onEnter: (_) {
        _hoverController.forward();
      },
      onExit: (_) {
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) => Transform.scale(
          scale: 1.0 + (_hoverController.value * 0.02),
          child: Transform.translate(
            offset: Offset(0, -_hoverController.value * 2),
            child: child,
          ),
        ),
        child: VooToastCard(
          toast: widget.toast,
          onDismiss: widget.onDismiss,
        ),
      ),
    );

    if (widget.animation == ToastAnimation.none) {
      return child;
    }

    if (widget.animation == ToastAnimation.fade) {
      return FadeTransition(
        opacity: _fadeAnimation,
        child: child,
      );
    }

    if (widget.animation == ToastAnimation.scale) {
      return ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: child,
        ),
      );
    }

    if (widget.animation == ToastAnimation.bounce) {
      return ScaleTransition(
        scale: _scaleAnimation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.5),
            end: Offset.zero,
          ).animate(_bounceAnimation),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: child,
          ),
        ),
      );
    }

    if (widget.animation == ToastAnimation.rotate) {
      return RotationTransition(
        turns: Tween<double>(begin: -0.1, end: 0).animate(_bounceAnimation),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: child,
          ),
        ),
      );
    }

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: child,
      ),
    );
  }
}
