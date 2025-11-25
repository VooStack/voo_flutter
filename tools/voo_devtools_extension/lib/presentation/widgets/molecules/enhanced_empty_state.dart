import 'package:flutter/material.dart';
import 'package:voo_devtools_extension/presentation/theme/app_theme.dart';

/// Types of empty states
enum EmptyStateType {
  /// No data has been received yet
  noData,

  /// Data exists but filters result in empty view
  filteredEmpty,

  /// An error occurred while loading data
  error,

  /// Waiting for connection to be established
  connecting,
}

/// Enhanced empty state widget with animations and contextual variations
class EnhancedEmptyState extends StatefulWidget {
  final EmptyStateType type;
  final String? customTitle;
  final String? customMessage;
  final IconData? customIcon;
  final Widget? action;
  final VoidCallback? onRetry;

  const EnhancedEmptyState({
    super.key,
    required this.type,
    this.customTitle,
    this.customMessage,
    this.customIcon,
    this.action,
    this.onRetry,
  });

  /// Factory constructor for no data state
  factory EnhancedEmptyState.noData({
    Key? key,
    String? title,
    String? message,
    IconData? icon,
    Widget? action,
  }) {
    return EnhancedEmptyState(
      key: key,
      type: EmptyStateType.noData,
      customTitle: title,
      customMessage: message,
      customIcon: icon,
      action: action,
    );
  }

  /// Factory constructor for filtered empty state
  factory EnhancedEmptyState.filteredEmpty({
    Key? key,
    String? title,
    String? message,
    VoidCallback? onClearFilters,
  }) {
    return EnhancedEmptyState(
      key: key,
      type: EmptyStateType.filteredEmpty,
      customTitle: title,
      customMessage: message,
      action: onClearFilters != null
          ? TextButton.icon(
              onPressed: onClearFilters,
              icon: const Icon(Icons.filter_alt_off),
              label: const Text('Clear Filters'),
            )
          : null,
    );
  }

  /// Factory constructor for error state
  factory EnhancedEmptyState.error({
    Key? key,
    String? title,
    String? message,
    VoidCallback? onRetry,
  }) {
    return EnhancedEmptyState(
      key: key,
      type: EmptyStateType.error,
      customTitle: title,
      customMessage: message,
      onRetry: onRetry,
    );
  }

  /// Factory constructor for connecting state
  factory EnhancedEmptyState.connecting({
    Key? key,
    String? title,
    String? message,
  }) {
    return EnhancedEmptyState(
      key: key,
      type: EmptyStateType.connecting,
      customTitle: title,
      customMessage: message,
    );
  }

  @override
  State<EnhancedEmptyState> createState() => _EnhancedEmptyStateState();
}

class _EnhancedEmptyStateState extends State<EnhancedEmptyState>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );

    _animationController.forward();

    // For connecting state, loop the animation
    if (widget.type == EmptyStateType.connecting) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final config = _getStateConfig();

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => Opacity(
        opacity: _fadeAnimation.value,
        child: Transform.scale(
          scale: _scaleAnimation.value,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingXxl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon with pulse animation for connecting state
                  Transform.scale(
                    scale: widget.type == EmptyStateType.connecting
                        ? _pulseAnimation.value
                        : 1.0,
                    child: _buildIconContainer(config, colorScheme),
                  ),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Title
                  Text(
                    config.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  // Message
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Text(
                      config.message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Action button or loading indicator
                  if (widget.type == EmptyStateType.connecting) ...[
                    const SizedBox(height: AppTheme.spacingXl),
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.primary,
                      ),
                    ),
                  ] else if (widget.action != null ||
                      widget.type == EmptyStateType.error) ...[
                    const SizedBox(height: AppTheme.spacingXl),
                    if (widget.action != null)
                      widget.action!
                    else if (widget.type == EmptyStateType.error &&
                        widget.onRetry != null)
                      FilledButton.icon(
                        onPressed: widget.onRetry,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                  ],
                  // Tips section for no data state
                  if (widget.type == EmptyStateType.noData &&
                      widget.action == null) ...[
                    const SizedBox(height: AppTheme.spacingXxl),
                    _buildTipsSection(theme, colorScheme),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer(
    _StateConfig config,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      decoration: BoxDecoration(
        color: config.backgroundColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: config.backgroundColor.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Icon(
        config.icon,
        size: 48,
        color: config.iconColor,
      ),
    );
  }

  Widget _buildTipsSection(ThemeData theme, ColorScheme colorScheme) {
    final tips = [
      'Make sure your app is running with Voo plugins initialized',
      'Check that DevTools is connected to your app',
      'Logs will appear here in real-time as your app runs',
    ];

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 16,
                color: colorScheme.primary,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                'Quick Tips',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          ...tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  Expanded(
                    child: Text(
                      tip,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _StateConfig _getStateConfig() {
    final colorScheme = Theme.of(context).colorScheme;

    switch (widget.type) {
      case EmptyStateType.noData:
        return _StateConfig(
          title: widget.customTitle ?? 'No Data Yet',
          message: widget.customMessage ??
              'Data will appear here as your app generates logs and events.',
          icon: widget.customIcon ?? Icons.inbox_outlined,
          iconColor: colorScheme.onSurfaceVariant,
          backgroundColor: colorScheme.surfaceContainerHighest,
        );
      case EmptyStateType.filteredEmpty:
        return _StateConfig(
          title: widget.customTitle ?? 'No Matches Found',
          message: widget.customMessage ??
              'Your current filters don\'t match any items. Try adjusting your search or filters.',
          icon: widget.customIcon ?? Icons.filter_alt_off,
          iconColor: colorScheme.tertiary,
          backgroundColor: colorScheme.tertiaryContainer,
        );
      case EmptyStateType.error:
        return _StateConfig(
          title: widget.customTitle ?? 'Something Went Wrong',
          message: widget.customMessage ??
              'We couldn\'t load the data. Please check your connection and try again.',
          icon: widget.customIcon ?? Icons.error_outline,
          iconColor: colorScheme.error,
          backgroundColor: colorScheme.errorContainer,
        );
      case EmptyStateType.connecting:
        return _StateConfig(
          title: widget.customTitle ?? 'Connecting...',
          message: widget.customMessage ??
              'Establishing connection to your Flutter app. Make sure your app is running.',
          icon: widget.customIcon ?? Icons.sync,
          iconColor: colorScheme.primary,
          backgroundColor: colorScheme.primaryContainer,
        );
    }
  }
}

class _StateConfig {
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const _StateConfig({
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });
}
