import 'package:equatable/equatable.dart';

class ResponsiveValue<T> extends Equatable {
  final T mobile;
  final T? tablet;
  final T? desktop;
  final T? widescreen;

  const ResponsiveValue({
    required this.mobile,
    this.tablet,
    this.desktop,
    this.widescreen,
  });

  T getValue({
    bool isMobile = false,
    bool isTablet = false,
    bool isDesktop = false,
    bool isWidescreen = false,
  }) {
    if (isWidescreen && widescreen != null) {
      return widescreen!;
    }
    if (isDesktop && desktop != null) {
      return desktop!;
    }
    if (isTablet && tablet != null) {
      return tablet!;
    }
    return mobile;
  }

  T getValueForWidth(double width) {
    if (width >= 1440 && widescreen != null) {
      return widescreen!;
    }
    if (width >= 1024 && desktop != null) {
      return desktop!;
    }
    if (width >= 600 && tablet != null) {
      return tablet!;
    }
    return mobile;
  }

  ResponsiveValue<T> copyWith({
    T? mobile,
    T? tablet,
    T? desktop,
    T? widescreen,
  }) {
    return ResponsiveValue<T>(
      mobile: mobile ?? this.mobile,
      tablet: tablet ?? this.tablet,
      desktop: desktop ?? this.desktop,
      widescreen: widescreen ?? this.widescreen,
    );
  }

  @override
  List<Object?> get props => [mobile, tablet, desktop, widescreen];
}