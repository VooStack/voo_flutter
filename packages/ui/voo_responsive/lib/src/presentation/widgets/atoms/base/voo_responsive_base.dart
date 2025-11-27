import 'package:flutter/material.dart';
import 'package:voo_responsive/src/domain/entities/screen_info.dart';

abstract class VooResponsiveBase extends StatelessWidget {
  const VooResponsiveBase({super.key});

  @protected
  ScreenInfo getScreenInfo(BuildContext context) => ScreenInfo.fromContext(context);

  @protected
  bool isMobile(BuildContext context) => getScreenInfo(context).isMobileLayout;

  @protected
  bool isTablet(BuildContext context) => getScreenInfo(context).isTabletLayout;

  @protected
  bool isDesktop(BuildContext context) => getScreenInfo(context).isDesktopLayout;
}
