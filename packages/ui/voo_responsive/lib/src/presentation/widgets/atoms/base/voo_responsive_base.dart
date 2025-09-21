import 'package:flutter/material.dart';
import 'package:voo_responsive/src/domain/entities/screen_info.dart';

abstract class VooResponsiveBase extends StatelessWidget {
  const VooResponsiveBase({super.key});

  @protected
  ScreenInfo getScreenInfo(BuildContext context) {
    return ScreenInfo.fromContext(context);
  }

  @protected
  bool isMobile(BuildContext context) {
    return getScreenInfo(context).isMobileLayout;
  }

  @protected
  bool isTablet(BuildContext context) {
    return getScreenInfo(context).isTabletLayout;
  }

  @protected
  bool isDesktop(BuildContext context) {
    return getScreenInfo(context).isDesktopLayout;
  }
}