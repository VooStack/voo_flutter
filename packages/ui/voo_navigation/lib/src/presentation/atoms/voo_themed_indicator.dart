import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_theme.dart';
import 'package:voo_navigation/src/presentation/atoms/voo_line_indicator.dart';

/// A themed indicator widget that adapts to different visual styles
///
/// Renders the appropriate indicator based on the theme preset:
/// - Pill: Material 3 style rounded background
/// - Glow: Glassmorphism style with shadow glow
/// - Line: Minimal style thin underline
/// - Embossed: Neomorphism style pressed-in indicator
/// - Background: Full background highlight
///
/// ```dart
/// VooThemedIndicator(
///   theme: config.effectiveTheme,
///   isSelected: isCurrentItem,
///   child: Icon(Icons.home),
/// )
/// ```
class VooThemedIndicator extends StatelessWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// Whether the indicator is active/selected
  final bool isSelected;

  /// The content to display (usually icon + label)
  final Widget child;

  /// Custom indicator color (overrides theme)
  final Color? color;

  /// Width of the indicator (for background types)
  final double? width;

  /// Height of the indicator (for background types)
  final double? height;

  /// Position of line indicator
  final VooLineIndicatorPosition linePosition;

  const VooThemedIndicator({
    super.key,
    required this.theme,
    required this.isSelected,
    required this.child,
    this.color,
    this.width,
    this.height,
    this.linePosition = VooLineIndicatorPosition.bottom,
  });

  @override
  Widget build(BuildContext context) {
    if (!isSelected && theme.indicatorStyle != VooThemeIndicatorStyle.background) {
      return child;
    }

    final indicatorColor = color ?? theme.resolveIndicatorColor(context);

    return switch (theme.indicatorStyle) {
      VooThemeIndicatorStyle.pill => _buildPillIndicator(context, indicatorColor),
      VooThemeIndicatorStyle.glow => _buildGlowIndicator(context, indicatorColor),
      VooThemeIndicatorStyle.line => _buildLineIndicator(context, indicatorColor),
      VooThemeIndicatorStyle.embossed =>
        _buildEmbossedIndicator(context, indicatorColor),
      VooThemeIndicatorStyle.background =>
        _buildBackgroundIndicator(context, indicatorColor),
      VooThemeIndicatorStyle.none => child,
    };
  }

  Widget _buildPillIndicator(BuildContext context, Color indicatorColor) {
    return AnimatedContainer(
      duration: theme.animationDuration,
      curve: theme.animationCurve,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? indicatorColor.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(theme.indicatorBorderRadius),
      ),
      child: child,
    );
  }

  Widget _buildGlowIndicator(BuildContext context, Color indicatorColor) {
    return AnimatedContainer(
      duration: theme.animationDuration,
      curve: theme.animationCurve,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? indicatorColor.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(theme.indicatorBorderRadius),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: indicatorColor.withValues(alpha: 0.25),
                  blurRadius: theme.indicatorGlowBlur,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: indicatorColor.withValues(alpha: 0.1),
                  blurRadius: theme.indicatorGlowBlur * 0.5,
                  spreadRadius: -2,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }

  Widget _buildLineIndicator(BuildContext context, Color indicatorColor) {
    final isHorizontal = linePosition == VooLineIndicatorPosition.bottom ||
        linePosition == VooLineIndicatorPosition.top;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: child,
        ),
        Positioned(
          left: linePosition == VooLineIndicatorPosition.left ? 0 : null,
          right: linePosition == VooLineIndicatorPosition.right ? 0 : null,
          top: linePosition == VooLineIndicatorPosition.top ? 0 : null,
          bottom: linePosition == VooLineIndicatorPosition.bottom ? 0 : null,
          child: AnimatedContainer(
            duration: theme.animationDuration,
            curve: theme.animationCurve,
            width: isHorizontal ? (isSelected ? 24 : 0) : 3,
            height: isHorizontal ? 3 : (isSelected ? 24 : 0),
            decoration: BoxDecoration(
              color: indicatorColor,
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmbossedIndicator(BuildContext context, Color indicatorColor) {
    final themeData = Theme.of(context);
    final isDark = themeData.brightness == Brightness.dark;

    final shadowOpacity = isDark ? 0.3 : 0.12;

    return AnimatedContainer(
      duration: theme.animationDuration,
      curve: theme.animationCurve,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? indicatorColor.withValues(alpha: 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(theme.indicatorBorderRadius),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: shadowOpacity),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                  spreadRadius: -2,
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: shadowOpacity * 0.5),
                  blurRadius: 4,
                  offset: const Offset(-1, -1),
                  spreadRadius: -2,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }

  Widget _buildBackgroundIndicator(BuildContext context, Color indicatorColor) {
    return AnimatedContainer(
      duration: theme.animationDuration,
      curve: theme.animationCurve,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isSelected
            ? indicatorColor.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(theme.indicatorBorderRadius),
      ),
      child: child,
    );
  }
}

/// A sliding pill indicator for bottom navigation
///
/// Smoothly animates position when selection changes
class VooSlidingPillIndicator extends StatelessWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// Total number of items
  final int itemCount;

  /// Currently selected index
  final int selectedIndex;

  /// Height of the indicator
  final double height;

  /// Vertical offset from top
  final double topOffset;

  /// Custom indicator color (overrides theme)
  final Color? color;

  const VooSlidingPillIndicator({
    super.key,
    required this.theme,
    required this.itemCount,
    required this.selectedIndex,
    this.height = 4,
    this.topOffset = 8,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) return const SizedBox.shrink();

    final indicatorColor = color ?? theme.resolveIndicatorColor(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth / itemCount;
        final pillWidth = itemWidth * 0.65;
        final leftPosition =
            (itemWidth * selectedIndex) + (itemWidth - pillWidth) / 2;

        return AnimatedPositioned(
          duration: theme.animationDuration,
          curve: theme.animationCurve,
          left: leftPosition,
          top: topOffset,
          child: _buildPill(indicatorColor, pillWidth),
        );
      },
    );
  }

  Widget _buildPill(Color indicatorColor, double pillWidth) {
    final showGlow = theme.indicatorStyle == VooThemeIndicatorStyle.glow ||
        theme.preset == VooNavigationPreset.glassmorphism;

    return Container(
      width: pillWidth,
      height: height,
      decoration: BoxDecoration(
        color: indicatorColor,
        borderRadius: BorderRadius.circular(height / 2),
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: indicatorColor.withValues(alpha: 0.4),
                  blurRadius: theme.indicatorGlowBlur,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
    );
  }
}

/// A vertical edge indicator for navigation rails
///
/// Displays a colored bar on the left edge of selected items
class VooEdgeBarIndicator extends StatelessWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// Whether the indicator is active
  final bool isSelected;

  /// Height of the indicator
  final double height;

  /// Width of the indicator bar
  final double width;

  /// Custom indicator color (overrides theme)
  final Color? color;

  const VooEdgeBarIndicator({
    super.key,
    required this.theme,
    required this.isSelected,
    this.height = 32,
    this.width = 3,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final indicatorColor = color ?? theme.resolveIndicatorColor(context);
    final showGlow = theme.indicatorStyle == VooThemeIndicatorStyle.glow ||
        theme.preset == VooNavigationPreset.glassmorphism;

    return AnimatedContainer(
      duration: theme.animationDuration,
      curve: theme.animationCurve,
      width: width,
      height: isSelected ? height : 0,
      decoration: BoxDecoration(
        color: indicatorColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(width),
          bottomRight: Radius.circular(width),
        ),
        boxShadow: isSelected && showGlow
            ? [
                BoxShadow(
                  color: indicatorColor.withValues(alpha: 0.5),
                  blurRadius: 8,
                  offset: const Offset(2, 0),
                ),
              ]
            : null,
      ),
    );
  }
}
