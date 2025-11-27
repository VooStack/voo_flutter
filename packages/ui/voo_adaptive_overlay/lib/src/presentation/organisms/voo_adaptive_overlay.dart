import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay/src/domain/entities/overlay_action.dart';
import 'package:voo_adaptive_overlay/src/domain/entities/overlay_config.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_style.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_type.dart';
import 'package:voo_adaptive_overlay/src/presentation/organisms/voo_action_sheet.dart';
import 'package:voo_adaptive_overlay/src/presentation/organisms/voo_alert.dart';
import 'package:voo_adaptive_overlay/src/presentation/organisms/voo_banner.dart';
import 'package:voo_adaptive_overlay/src/presentation/organisms/voo_bottom_sheet.dart';
import 'package:voo_adaptive_overlay/src/presentation/organisms/voo_drawer.dart';
import 'package:voo_adaptive_overlay/src/presentation/organisms/voo_fullscreen_overlay.dart';
import 'package:voo_adaptive_overlay/src/presentation/organisms/voo_modal_dialog.dart';
import 'package:voo_adaptive_overlay/src/presentation/organisms/voo_popup.dart';
import 'package:voo_adaptive_overlay/src/presentation/organisms/voo_side_sheet.dart';
import 'package:voo_adaptive_overlay/src/presentation/organisms/voo_snackbar.dart';
import 'package:voo_adaptive_overlay/src/presentation/organisms/voo_tooltip.dart';
import 'package:voo_adaptive_overlay/src/presentation/utils/overlay_route.dart';
import 'package:voo_responsive/voo_responsive.dart';

/// Main adaptive overlay widget that automatically selects the appropriate
/// overlay type based on screen size.
///
/// This is the primary API for showing adaptive overlays in your app.
///
/// ## Basic Usage
///
/// ```dart
/// // Show an adaptive overlay
/// final result = await VooAdaptiveOverlay.show<bool>(
///   context: context,
///   title: Text('Confirm'),
///   content: Text('Are you sure?'),
///   actions: [
///     VooOverlayAction.cancel(),
///     VooOverlayAction.confirm(onPressed: () => Navigator.pop(context, true)),
///   ],
/// );
///
/// // Show a specific overlay type
/// await VooAdaptiveOverlay.showBottomSheet(...);
/// await VooAdaptiveOverlay.showModal(...);
/// await VooAdaptiveOverlay.showSideSheet(...);
/// await VooAdaptiveOverlay.showDrawer(...);
/// await VooAdaptiveOverlay.showActionSheet(...);
/// await VooAdaptiveOverlay.showSnackbar(...);
/// ```
class VooAdaptiveOverlay {
  VooAdaptiveOverlay._();

  /// Shows an adaptive overlay that automatically selects the presentation
  /// type based on screen size.
  ///
  /// Returns a [Future] that resolves to the value passed to [Navigator.pop]
  /// when the overlay is dismissed.
  static Future<T?> show<T>({
    required BuildContext context,
    Widget? title,
    Widget? content,
    Widget Function(BuildContext, ScrollController?)? builder,
    List<VooOverlayAction>? actions,
    VooOverlayConfig config = VooOverlayConfig.material,
  }) {
    final screenInfo = ScreenInfo.fromContext(context);
    final overlayType = _determineOverlayType(screenInfo, config);

    return Navigator.of(context, rootNavigator: config.useRootNavigator).push<T>(
      VooOverlayRoute<T>(
        config: config,
        overlayType: overlayType,
        builder: (context) =>
            _buildOverlay(context: context, title: title, content: content, builder: builder, actions: actions, config: config, overlayType: overlayType),
      ),
    );
  }

  /// Shows a bottom sheet overlay regardless of screen size.
  static Future<T?> showBottomSheet<T>({
    required BuildContext context,
    Widget? title,
    Widget? content,
    Widget Function(BuildContext, ScrollController?)? builder,
    List<VooOverlayAction>? actions,
    VooOverlayConfig config = VooOverlayConfig.material,
  }) => show<T>(
    context: context,
    title: title,
    content: content,
    builder: builder,
    actions: actions,
    config: config.copyWith(forceType: VooOverlayType.bottomSheet),
  );

  /// Shows a modal dialog overlay regardless of screen size.
  static Future<T?> showModal<T>({
    required BuildContext context,
    Widget? title,
    Widget? content,
    Widget Function(BuildContext, ScrollController?)? builder,
    List<VooOverlayAction>? actions,
    VooOverlayConfig config = VooOverlayConfig.material,
  }) => show<T>(
    context: context,
    title: title,
    content: content,
    builder: builder,
    actions: actions,
    config: config.copyWith(forceType: VooOverlayType.modal),
  );

  /// Shows a side sheet overlay regardless of screen size.
  static Future<T?> showSideSheet<T>({
    required BuildContext context,
    Widget? title,
    Widget? content,
    Widget Function(BuildContext, ScrollController?)? builder,
    List<VooOverlayAction>? actions,
    VooOverlayConfig config = VooOverlayConfig.material,
  }) => show<T>(
    context: context,
    title: title,
    content: content,
    builder: builder,
    actions: actions,
    config: config.copyWith(forceType: VooOverlayType.sideSheet),
  );

  /// Shows a fullscreen overlay regardless of screen size.
  static Future<T?> showFullscreen<T>({
    required BuildContext context,
    Widget? title,
    Widget? content,
    Widget Function(BuildContext, ScrollController?)? builder,
    List<VooOverlayAction>? actions,
    VooOverlayConfig config = VooOverlayConfig.material,
  }) => show<T>(
    context: context,
    title: title,
    content: content,
    builder: builder,
    actions: actions,
    config: config.copyWith(forceType: VooOverlayType.fullscreen),
  );

  /// Shows a drawer overlay from the left or right.
  static Future<T?> showDrawer<T>({
    required BuildContext context,
    Widget? title,
    Widget? content,
    Widget Function(BuildContext, ScrollController?)? builder,
    List<VooOverlayAction>? actions,
    bool anchorRight = false,
    Widget? leading,
    List<Widget>? trailing,
    VooOverlayConfig config = VooOverlayConfig.material,
  }) => Navigator.of(context, rootNavigator: config.useRootNavigator).push<T>(
    VooOverlayRoute<T>(
      config: config.copyWith(anchorRight: anchorRight),
      overlayType: VooOverlayType.drawer,
      builder: (context) => VooDrawer(
        title: title,
        content: content,
        builder: builder,
        actions: actions,
        style: config.style,
        behavior: config.behavior,
        constraints: config.constraints,
        anchorRight: anchorRight,
        leading: leading,
        trailing: trailing,
      ),
    ),
  );

  /// Shows an action sheet with a list of options.
  ///
  /// ```dart
  /// await VooAdaptiveOverlay.showActionSheet(
  ///   context: context,
  ///   title: Text('Choose an option'),
  ///   actions: [
  ///     VooOverlayAction(label: 'Camera', icon: Icons.camera_alt),
  ///     VooOverlayAction(label: 'Gallery', icon: Icons.photo),
  ///     VooOverlayAction.destructive(label: 'Delete', icon: Icons.delete),
  ///   ],
  ///   cancelAction: VooOverlayAction.cancel(),
  /// );
  /// ```
  static Future<T?> showActionSheet<T>({
    required BuildContext context,
    Widget? title,
    Widget? message,
    required List<VooOverlayAction> actions,
    VooOverlayAction? cancelAction,
    VooOverlayStyle? style,
    VooOverlayConfig config = VooOverlayConfig.cupertino,
  }) {
    final effectiveStyle = style ?? config.style;
    final effectiveConfig = style != null ? config.copyWith(style: style) : config;
    return Navigator.of(context, rootNavigator: effectiveConfig.useRootNavigator).push<T>(
      VooOverlayRoute<T>(
        config: effectiveConfig,
        overlayType: VooOverlayType.actionSheet,
        builder: (context) => Align(
          alignment: Alignment.bottomCenter,
          child: VooActionSheet(
            title: title,
            message: message,
            actions: actions,
            cancelAction: cancelAction,
            style: effectiveStyle,
            behavior: effectiveConfig.behavior,
          ),
        ),
      ),
    );
  }

  /// Shows a snackbar notification.
  ///
  /// ```dart
  /// await VooAdaptiveOverlay.showSnackbar(
  ///   context: context,
  ///   message: 'Item deleted',
  ///   action: VooOverlayAction(label: 'Undo', onPressed: () => print('Undo')),
  ///   duration: Duration(seconds: 4),
  /// );
  /// ```
  static Future<void> showSnackbar({
    required BuildContext context,
    required String message,
    IconData? icon,
    VooOverlayAction? action,
    bool showCloseButton = false,
    Duration duration = const Duration(seconds: 4),
    VooOverlayStyle style = VooOverlayStyle.material,
    bool floating = true,
    Color? backgroundColor,
    Color? textColor,
    bool useRootNavigator = true,
  }) async {
    final overlayEntry = OverlayEntry(
      builder: (context) => _SnackbarOverlay(
        message: message,
        icon: icon,
        action: action,
        showCloseButton: showCloseButton,
        style: style,
        floating: floating,
        backgroundColor: backgroundColor,
        textColor: textColor,
        onClose: () {},
      ),
    );

    final overlay = Overlay.of(context, rootOverlay: useRootNavigator);
    overlay.insert(overlayEntry);

    await Future<void>.delayed(duration);
    overlayEntry.remove();
  }

  /// Shows a popup menu near an anchor point.
  ///
  /// ```dart
  /// await VooAdaptiveOverlay.showPopup(
  ///   context: context,
  ///   anchorRect: buttonRect,
  ///   content: Text('Popup content'),
  ///   actions: [
  ///     VooOverlayAction.withIcon(label: 'Edit', icon: Icons.edit),
  ///     VooOverlayAction.withIcon(label: 'Delete', icon: Icons.delete),
  ///   ],
  /// );
  /// ```
  static Future<T?> showPopup<T>({
    required BuildContext context,
    Widget? content,
    List<VooOverlayAction>? actions,
    Rect? anchorRect,
    VooPopupPosition position = VooPopupPosition.auto,
    VooOverlayStyle style = VooOverlayStyle.material,
    double maxWidth = 280,
    double maxHeight = 400,
    bool showArrow = true,
    Color? backgroundColor,
    Offset offset = Offset.zero,
    bool useRootNavigator = true,
  }) => Navigator.of(context, rootNavigator: useRootNavigator).push<T>(
    VooOverlayRoute<T>(
      config: VooOverlayConfig(style: style),
      overlayType: VooOverlayType.popup,
      builder: (context) => VooPopup(
        content: content,
        actions: actions,
        style: style,
        position: position,
        anchorRect: anchorRect,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        showArrow: showArrow,
        backgroundColor: backgroundColor,
        offset: offset,
      ),
    ),
  );

  /// Shows a banner notification at the top or bottom of the screen.
  ///
  /// ```dart
  /// await VooAdaptiveOverlay.showBanner(
  ///   context: context,
  ///   message: 'New version available!',
  ///   type: VooBannerType.info,
  ///   action: VooOverlayAction(label: 'Update', onPressed: () {}),
  /// );
  /// ```
  static Future<void> showBanner({
    required BuildContext context,
    required String message,
    String? title,
    IconData? icon,
    VooBannerType type = VooBannerType.neutral,
    VooBannerPosition position = VooBannerPosition.top,
    VooOverlayAction? action,
    bool showCloseButton = true,
    Duration? duration,
    VooOverlayStyle style = VooOverlayStyle.material,
    Color? backgroundColor,
    Color? textColor,
    bool useRootNavigator = true,
  }) async {
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _BannerOverlay(
        message: message,
        title: title,
        icon: icon,
        type: type,
        position: position,
        action: action,
        showCloseButton: showCloseButton,
        style: style,
        backgroundColor: backgroundColor,
        textColor: textColor,
        onClose: () => overlayEntry?.remove(),
      ),
    );

    final overlay = Overlay.of(context, rootOverlay: useRootNavigator);
    overlay.insert(overlayEntry);

    if (duration != null) {
      await Future<void>.delayed(duration);
      overlayEntry.remove();
    }
  }

  /// Shows a tooltip near an anchor point.
  ///
  /// ```dart
  /// await VooAdaptiveOverlay.showTooltip(
  ///   context: context,
  ///   message: 'This is a helpful tip',
  ///   anchorRect: iconRect,
  ///   duration: Duration(seconds: 3),
  /// );
  /// ```
  static Future<void> showTooltip({
    required BuildContext context,
    required String message,
    Widget? content,
    Rect? anchorRect,
    VooTooltipPosition position = VooTooltipPosition.auto,
    Duration duration = const Duration(seconds: 3),
    VooOverlayStyle style = VooOverlayStyle.material,
    double maxWidth = 240,
    bool showArrow = true,
    Color? backgroundColor,
    Color? textColor,
    Offset offset = Offset.zero,
    bool useRootNavigator = true,
  }) async {
    final overlayEntry = OverlayEntry(
      builder: (context) => _TooltipOverlay(
        message: message,
        content: content,
        style: style,
        position: position,
        anchorRect: anchorRect,
        maxWidth: maxWidth,
        showArrow: showArrow,
        backgroundColor: backgroundColor,
        textColor: textColor,
        offset: offset,
      ),
    );

    final overlay = Overlay.of(context, rootOverlay: useRootNavigator);
    overlay.insert(overlayEntry);

    await Future<void>.delayed(duration);
    overlayEntry.remove();
  }

  /// Shows an alert dialog for critical messages.
  ///
  /// ```dart
  /// final confirmed = await VooAdaptiveOverlay.showAlert(
  ///   context: context,
  ///   title: 'Delete Item?',
  ///   message: 'This action cannot be undone.',
  ///   type: VooAlertType.confirm,
  /// );
  /// ```
  static Future<T?> showAlert<T>({
    required BuildContext context,
    required String title,
    required String message,
    Widget? content,
    VooAlertType type = VooAlertType.info,
    List<VooOverlayAction> actions = const [],
    VooOverlayStyle style = VooOverlayStyle.material,
    IconData? icon,
    Color? iconColor,
    double maxWidth = 340,
    VooOverlayConfig config = VooOverlayConfig.material,
  }) => Navigator.of(context, rootNavigator: config.useRootNavigator).push<T>(
    VooOverlayRoute<T>(
      config: config.copyWith(style: style),
      overlayType: VooOverlayType.alert,
      builder: (context) => VooAlert(
        title: title,
        message: message,
        content: content,
        type: type,
        style: style,
        actions: actions,
        icon: icon,
        iconColor: iconColor,
        maxWidth: maxWidth,
      ),
    ),
  );

  /// Determines the appropriate overlay type based on screen info and config.
  static VooOverlayType _determineOverlayType(ScreenInfo screenInfo, VooOverlayConfig config) {
    // If forced type is specified, use it
    if (config.forceType != null) {
      return config.forceType!;
    }

    final width = screenInfo.width;
    final breakpoints = config.breakpoints;

    // Check for fullscreen on very small screens
    if (breakpoints.useFullscreenForCompact && width < breakpoints.fullscreenThreshold) {
      return VooOverlayType.fullscreen;
    }

    // Bottom sheet for mobile
    if (width < breakpoints.bottomSheetMaxWidth) {
      return VooOverlayType.bottomSheet;
    }

    // Modal for tablet
    if (width < breakpoints.modalMaxWidth) {
      return VooOverlayType.modal;
    }

    // Desktop - choose between side sheet and modal
    if (breakpoints.preferSideSheetOnDesktop) {
      return VooOverlayType.sideSheet;
    }

    return VooOverlayType.modal;
  }

  /// Builds the appropriate overlay widget based on the determined type.
  static Widget _buildOverlay({
    required BuildContext context,
    Widget? title,
    Widget? content,
    Widget Function(BuildContext, ScrollController?)? builder,
    List<VooOverlayAction>? actions,
    required VooOverlayConfig config,
    required VooOverlayType overlayType,
  }) {
    switch (overlayType) {
      case VooOverlayType.bottomSheet:
        return VooBottomSheet(
          title: title,
          content: content,
          builder: builder,
          actions: actions,
          style: config.style,
          behavior: config.behavior,
          constraints: config.constraints,
        );
      case VooOverlayType.modal:
        return VooModalDialog(
          title: title,
          content: content,
          builder: builder,
          actions: actions,
          style: config.style,
          behavior: config.behavior,
          constraints: config.constraints,
        );
      case VooOverlayType.sideSheet:
        return VooSideSheet(
          title: title,
          content: content,
          builder: builder,
          actions: actions,
          style: config.style,
          behavior: config.behavior,
          constraints: config.constraints,
          anchorRight: config.anchorRight,
        );
      case VooOverlayType.fullscreen:
        return VooFullscreenOverlay(title: title, content: content, builder: builder, actions: actions, style: config.style, behavior: config.behavior);
      case VooOverlayType.drawer:
        return VooDrawer(
          title: title,
          content: content,
          builder: builder,
          actions: actions,
          style: config.style,
          behavior: config.behavior,
          constraints: config.constraints,
          anchorRight: config.anchorRight,
        );
      case VooOverlayType.actionSheet:
        return VooActionSheet(title: title, actions: actions ?? [], style: config.style, behavior: config.behavior);
      case VooOverlayType.snackbar:
      case VooOverlayType.popup:
      case VooOverlayType.banner:
      case VooOverlayType.tooltip:
        // These types are handled separately
        return const SizedBox.shrink();
      case VooOverlayType.alert:
        return VooAlert(
          title: title is Text ? title.data ?? '' : 'Alert',
          message: content is Text ? content.data ?? '' : '',
          content: content is Text ? null : content,
          style: config.style,
          actions: actions ?? [],
        );
    }
  }
}

/// Internal snackbar overlay widget with animation.
class _SnackbarOverlay extends StatefulWidget {
  final String message;
  final IconData? icon;
  final VooOverlayAction? action;
  final bool showCloseButton;
  final VooOverlayStyle style;
  final bool floating;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback onClose;

  const _SnackbarOverlay({
    required this.message,
    this.icon,
    this.action,
    required this.showCloseButton,
    required this.style,
    required this.floating,
    this.backgroundColor,
    this.textColor,
    required this.onClose,
  });

  @override
  State<_SnackbarOverlay> createState() => _SnackbarOverlayState();
}

class _SnackbarOverlayState extends State<_SnackbarOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _fadeAnimation,
    child: SlideTransition(
      position: _slideAnimation,
      child: VooSnackbar(
        message: widget.message,
        icon: widget.icon,
        action: widget.action,
        showCloseButton: widget.showCloseButton,
        style: widget.style,
        floating: widget.floating,
        backgroundColor: widget.backgroundColor,
        textColor: widget.textColor,
        onClose: widget.onClose,
      ),
    ),
  );
}

/// Internal banner overlay widget with animation.
class _BannerOverlay extends StatefulWidget {
  final String message;
  final String? title;
  final IconData? icon;
  final VooBannerType type;
  final VooBannerPosition position;
  final VooOverlayAction? action;
  final bool showCloseButton;
  final VooOverlayStyle style;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback onClose;

  const _BannerOverlay({
    required this.message,
    this.title,
    this.icon,
    required this.type,
    required this.position,
    this.action,
    required this.showCloseButton,
    required this.style,
    this.backgroundColor,
    this.textColor,
    required this.onClose,
  });

  @override
  State<_BannerOverlay> createState() => _BannerOverlayState();
}

class _BannerOverlayState extends State<_BannerOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 250), vsync: this);

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    final slideBegin = widget.position == VooBannerPosition.top ? const Offset(0, -1) : const Offset(0, 1);

    _slideAnimation = Tween<Offset>(begin: slideBegin, end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _fadeAnimation,
    child: SlideTransition(
      position: _slideAnimation,
      child: VooBanner(
        message: widget.message,
        title: widget.title,
        icon: widget.icon,
        type: widget.type,
        position: widget.position,
        action: widget.action,
        showCloseButton: widget.showCloseButton,
        style: widget.style,
        backgroundColor: widget.backgroundColor,
        textColor: widget.textColor,
        onClose: widget.onClose,
      ),
    ),
  );
}

/// Internal tooltip overlay widget with animation.
class _TooltipOverlay extends StatefulWidget {
  final String message;
  final Widget? content;
  final VooOverlayStyle style;
  final VooTooltipPosition position;
  final Rect? anchorRect;
  final double maxWidth;
  final bool showArrow;
  final Color? backgroundColor;
  final Color? textColor;
  final Offset offset;

  const _TooltipOverlay({
    required this.message,
    this.content,
    required this.style,
    required this.position,
    this.anchorRect,
    required this.maxWidth,
    required this.showArrow,
    this.backgroundColor,
    this.textColor,
    required this.offset,
  });

  @override
  State<_TooltipOverlay> createState() => _TooltipOverlayState();
}

class _TooltipOverlayState extends State<_TooltipOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _fadeAnimation,
    child: ScaleTransition(
      scale: _scaleAnimation,
      child: VooTooltip(
        message: widget.message,
        content: widget.content,
        style: widget.style,
        position: widget.position,
        anchorRect: widget.anchorRect,
        maxWidth: widget.maxWidth,
        showArrow: widget.showArrow,
        backgroundColor: widget.backgroundColor,
        textColor: widget.textColor,
        offset: widget.offset,
      ),
    ),
  );
}
