import 'package:flutter/material.dart';

/// Device type based on screen characteristics
enum VooDeviceType {
  /// Phone devices (< 600dp width)
  phone,

  /// Tablet devices (600-840dp width)
  tablet,

  /// Desktop/laptop devices (> 840dp width)
  desktop,

  /// TV or large displays (> 1920dp width)
  tv,
}

/// Screen size categories following Material Design 3 breakpoints
enum VooScreenSize {
  /// Extra small (< 360dp)
  xs,

  /// Small (360-600dp)
  small,

  /// Medium (600-840dp)
  medium,

  /// Large (840-1240dp)
  large,

  /// Extra large (1240-1920dp)
  xl,

  /// Extra extra large (> 1920dp)
  xxl,
}

/// Orientation with additional context
enum VooOrientation {
  portrait,
  landscape,

  /// Square or nearly square aspect ratio
  square,
}

/// Responsive breakpoints following Material Design 3 guidelines
class VooBreakpoints {
  /// Extra small breakpoint (phones in portrait)
  static const double xs = 0;

  /// Small breakpoint (larger phones, small tablets in portrait)
  static const double small = 360;

  /// Medium breakpoint (tablets in portrait, phones in landscape)
  static const double medium = 600;

  /// Large breakpoint (tablets in landscape, small laptops)
  static const double large = 840;

  /// Extra large breakpoint (desktops, large tablets)
  static const double xl = 1240;

  /// Extra extra large breakpoint (large desktops, TVs)
  static const double xxl = 1920;

  /// Compact width (< 600dp) - Material 3 window size class
  static const double compact = 600;

  /// Medium width (600-840dp) - Material 3 window size class
  static const double mediumWidth = 840;

  /// Expanded width (> 840dp) - Material 3 window size class
  static const double expanded = 840;
}

/// Layout grid configuration for responsive layouts
class VooGridConfig {
  final int columns;
  final double gutter;
  final double margin;

  const VooGridConfig({
    required this.columns,
    required this.gutter,
    required this.margin,
  });

  /// Phone grid configuration (4 columns)
  static const phone = VooGridConfig(
    columns: 4,
    gutter: 16,
    margin: 16,
  );

  /// Tablet grid configuration (8 columns)
  static const tablet = VooGridConfig(
    columns: 8,
    gutter: 24,
    margin: 24,
  );

  /// Desktop grid configuration (12 columns)
  static const desktop = VooGridConfig(
    columns: 12,
    gutter: 24,
    margin: 24,
  );

  /// Large desktop grid configuration (12 columns with larger margins)
  static const largeDesktop = VooGridConfig(
    columns: 12,
    gutter: 32,
    margin: 32,
  );
}

/// Responsive context providing screen information and utilities
class VooResponsive extends InheritedWidget {
  final VooDeviceType deviceType;
  final VooScreenSize screenSize;
  final VooOrientation orientation;
  final VooGridConfig gridConfig;
  final Size screenDimensions;
  final EdgeInsets safeArea;
  final double pixelRatio;
  final bool isHighDensity;
  final bool isFoldable;
  final bool hasNotch;

  const VooResponsive({
    super.key,
    required this.deviceType,
    required this.screenSize,
    required this.orientation,
    required this.gridConfig,
    required this.screenDimensions,
    required this.safeArea,
    required this.pixelRatio,
    required this.isHighDensity,
    required this.isFoldable,
    required this.hasNotch,
    required super.child,
  });

  /// Get the responsive context from the widget tree
  static VooResponsive of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<VooResponsive>();
    assert(result != null, 'No VooResponsive found in context');
    return result!;
  }

  /// Try to get the responsive context, returns null if not found
  static VooResponsive? maybeOf(BuildContext context) => context.dependOnInheritedWidgetOfExactType<VooResponsive>();

  /// Check if current device is phone
  bool get isPhone => deviceType == VooDeviceType.phone;

  /// Check if current device is tablet
  bool get isTablet => deviceType == VooDeviceType.tablet;

  /// Check if current device is desktop
  bool get isDesktop => deviceType == VooDeviceType.desktop;

  /// Check if current device is TV
  bool get isTV => deviceType == VooDeviceType.tv;

  /// Check if screen is in portrait orientation
  bool get isPortrait => orientation == VooOrientation.portrait;

  /// Check if screen is in landscape orientation
  bool get isLandscape => orientation == VooOrientation.landscape;

  /// Check if screen is compact (Material 3 window size class)
  bool get isCompact => screenDimensions.width < VooBreakpoints.compact;

  /// Check if screen is medium (Material 3 window size class)
  bool get isMedium =>
      screenDimensions.width >= VooBreakpoints.compact &&
      screenDimensions.width < VooBreakpoints.expanded;

  /// Check if screen is expanded (Material 3 window size class)
  bool get isExpanded => screenDimensions.width >= VooBreakpoints.expanded;

  /// Get value based on screen size
  T value<T>({
    T? xs,
    T? small,
    T? medium,
    T? large,
    T? xl,
    T? xxl,
    required T defaultValue,
  }) {
    switch (screenSize) {
      case VooScreenSize.xs:
        return xs ?? small ?? defaultValue;
      case VooScreenSize.small:
        return small ?? defaultValue;
      case VooScreenSize.medium:
        return medium ?? small ?? defaultValue;
      case VooScreenSize.large:
        return large ?? medium ?? defaultValue;
      case VooScreenSize.xl:
        return xl ?? large ?? defaultValue;
      case VooScreenSize.xxl:
        return xxl ?? xl ?? large ?? defaultValue;
    }
  }

  /// Get value based on device type
  T device<T>({
    T? phone,
    T? tablet,
    T? desktop,
    T? tv,
    required T defaultValue,
  }) {
    switch (deviceType) {
      case VooDeviceType.phone:
        return phone ?? defaultValue;
      case VooDeviceType.tablet:
        return tablet ?? defaultValue;
      case VooDeviceType.desktop:
        return desktop ?? defaultValue;
      case VooDeviceType.tv:
        return tv ?? desktop ?? defaultValue;
    }
  }

  /// Get value based on orientation
  T orientationValue<T>({
    T? portrait,
    T? landscape,
    T? square,
    required T defaultValue,
  }) {
    switch (orientation) {
      case VooOrientation.portrait:
        return portrait ?? defaultValue;
      case VooOrientation.landscape:
        return landscape ?? defaultValue;
      case VooOrientation.square:
        return square ?? portrait ?? defaultValue;
    }
  }

  @override
  bool updateShouldNotify(VooResponsive oldWidget) => deviceType != oldWidget.deviceType ||
        screenSize != oldWidget.screenSize ||
        orientation != oldWidget.orientation ||
        screenDimensions != oldWidget.screenDimensions ||
        safeArea != oldWidget.safeArea;
}

/// Widget that provides responsive context to its children
class VooResponsiveBuilder extends StatelessWidget {
  final Widget child;

  const VooResponsiveBuilder({
    super.key,
    required this.child,
  });

  static VooDeviceType _getDeviceType(double width) {
    if (width < VooBreakpoints.compact) {
      return VooDeviceType.phone;
    } else if (width < VooBreakpoints.expanded) {
      return VooDeviceType.tablet;
    } else if (width < VooBreakpoints.xxl) {
      return VooDeviceType.desktop;
    } else {
      return VooDeviceType.tv;
    }
  }

  static VooScreenSize _getScreenSize(double width) {
    if (width < VooBreakpoints.small) {
      return VooScreenSize.xs;
    } else if (width < VooBreakpoints.medium) {
      return VooScreenSize.small;
    } else if (width < VooBreakpoints.large) {
      return VooScreenSize.medium;
    } else if (width < VooBreakpoints.xl) {
      return VooScreenSize.large;
    } else if (width < VooBreakpoints.xxl) {
      return VooScreenSize.xl;
    } else {
      return VooScreenSize.xxl;
    }
  }

  static VooOrientation _getOrientation(Size size) {
    final aspectRatio = size.width / size.height;
    if (aspectRatio > 0.9 && aspectRatio < 1.1) {
      return VooOrientation.square;
    } else if (size.width > size.height) {
      return VooOrientation.landscape;
    } else {
      return VooOrientation.portrait;
    }
  }

  static VooGridConfig _getGridConfig(VooDeviceType deviceType) {
    switch (deviceType) {
      case VooDeviceType.phone:
        return VooGridConfig.phone;
      case VooDeviceType.tablet:
        return VooGridConfig.tablet;
      case VooDeviceType.desktop:
        return VooGridConfig.desktop;
      case VooDeviceType.tv:
        return VooGridConfig.largeDesktop;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final deviceType = _getDeviceType(size.width);
    final screenSize = _getScreenSize(size.width);
    final orientation = _getOrientation(size);
    final gridConfig = _getGridConfig(deviceType);

    return VooResponsive(
      deviceType: deviceType,
      screenSize: screenSize,
      orientation: orientation,
      gridConfig: gridConfig,
      screenDimensions: size,
      safeArea: mediaQuery.padding,
      pixelRatio: mediaQuery.devicePixelRatio,
      isHighDensity: mediaQuery.devicePixelRatio > 2.0,
      isFoldable: mediaQuery.displayFeatures.isNotEmpty,
      hasNotch: mediaQuery.padding.top > 24,
      child: child,
    );
  }
}

/// Responsive widget that shows different content based on screen size
class VooResponsiveLayout extends StatelessWidget {
  final Widget? phone;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? tv;

  const VooResponsiveLayout({
    super.key,
    this.phone,
    this.tablet,
    this.desktop,
    this.tv,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = VooResponsive.of(context);

    switch (responsive.deviceType) {
      case VooDeviceType.phone:
        return phone ?? tablet ?? desktop ?? const SizedBox.shrink();
      case VooDeviceType.tablet:
        return tablet ?? desktop ?? phone ?? const SizedBox.shrink();
      case VooDeviceType.desktop:
        return desktop ?? tablet ?? phone ?? const SizedBox.shrink();
      case VooDeviceType.tv:
        return tv ?? desktop ?? tablet ?? const SizedBox.shrink();
    }
  }
}

/// Responsive padding that adjusts based on screen size
class VooResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? phonePadding;
  final EdgeInsetsGeometry? tabletPadding;
  final EdgeInsetsGeometry? desktopPadding;

  const VooResponsivePadding({
    super.key,
    required this.child,
    this.phonePadding,
    this.tabletPadding,
    this.desktopPadding,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = VooResponsive.of(context);

    EdgeInsetsGeometry padding;
    switch (responsive.deviceType) {
      case VooDeviceType.phone:
        padding = phonePadding ?? const EdgeInsets.all(16);
        break;
      case VooDeviceType.tablet:
        padding = tabletPadding ?? const EdgeInsets.all(24);
        break;
      case VooDeviceType.desktop:
      case VooDeviceType.tv:
        padding = desktopPadding ?? const EdgeInsets.all(32);
        break;
    }

    return Padding(
      padding: padding,
      child: child,
    );
  }
}

/// Responsive grid that adjusts columns based on screen size
class VooResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int? phoneColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final double? spacing;
  final double? runSpacing;

  const VooResponsiveGrid({
    super.key,
    required this.children,
    this.phoneColumns,
    this.tabletColumns,
    this.desktopColumns,
    this.spacing,
    this.runSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = VooResponsive.of(context);

    int columns;
    switch (responsive.deviceType) {
      case VooDeviceType.phone:
        columns = phoneColumns ?? 2;
        break;
      case VooDeviceType.tablet:
        columns = tabletColumns ?? 3;
        break;
      case VooDeviceType.desktop:
      case VooDeviceType.tv:
        columns = desktopColumns ?? 4;
        break;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing ?? responsive.gridConfig.gutter,
        mainAxisSpacing: runSpacing ?? responsive.gridConfig.gutter,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// Extension on BuildContext for easy access to responsive utilities
extension VooResponsiveContext on BuildContext {
  /// Get the responsive context
  VooResponsive get responsive => VooResponsive.of(this);

  /// Get the current device type
  VooDeviceType get deviceType => responsive.deviceType;

  /// Get the current screen size
  VooScreenSize get screenSize => responsive.screenSize;

  /// Check if current device is phone
  bool get isPhone => responsive.isPhone;

  /// Check if current device is tablet
  bool get isTablet => responsive.isTablet;

  /// Check if current device is desktop
  bool get isDesktop => responsive.isDesktop;

  /// Check if screen is compact
  bool get isCompact => responsive.isCompact;

  /// Check if screen is medium
  bool get isMedium => responsive.isMedium;

  /// Check if screen is expanded
  bool get isExpanded => responsive.isExpanded;
}

/// Utility class for responsive values
class VooResponsiveValue<T> {
  final T? xs;
  final T? small;
  final T? medium;
  final T? large;
  final T? xl;
  final T? xxl;
  final T defaultValue;

  const VooResponsiveValue({
    this.xs,
    this.small,
    this.medium,
    this.large,
    this.xl,
    this.xxl,
    required this.defaultValue,
  });

  T getValue(VooScreenSize screenSize) {
    switch (screenSize) {
      case VooScreenSize.xs:
        return xs ?? small ?? defaultValue;
      case VooScreenSize.small:
        return small ?? defaultValue;
      case VooScreenSize.medium:
        return medium ?? small ?? defaultValue;
      case VooScreenSize.large:
        return large ?? medium ?? defaultValue;
      case VooScreenSize.xl:
        return xl ?? large ?? defaultValue;
      case VooScreenSize.xxl:
        return xxl ?? xl ?? large ?? defaultValue;
    }
  }
}
