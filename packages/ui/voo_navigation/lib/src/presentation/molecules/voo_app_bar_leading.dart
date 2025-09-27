import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';

/// App bar leading widget that handles menu, back button, or custom widget
class VooAppBarLeading extends StatelessWidget {
  /// Whether to show menu button
  final bool showMenuButton;

  /// Navigation configuration
  final VooNavigationConfig? config;

  const VooAppBarLeading({
    super.key,
    required this.showMenuButton,
    this.config,
  });

  @override
  Widget build(BuildContext context) {
    if (!showMenuButton) return const SizedBox.shrink();

    if (config?.appBarLeading != null) {
      return config!.appBarLeading!;
    }

    // Show menu button for drawer on mobile
    final scaffoldState = Scaffold.maybeOf(context);
    if (scaffoldState != null && scaffoldState.hasDrawer) {
      return IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          scaffoldState.openDrawer();
          if (config?.enableHapticFeedback ?? true) {
            HapticFeedback.lightImpact();
          }
        },
        tooltip: 'Open navigation menu',
      );
    }

    // Show back button if can pop
    if (Navigator.of(context).canPop()) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
          if (config?.enableHapticFeedback ?? true) {
            HapticFeedback.lightImpact();
          }
        },
        tooltip: 'Go back',
      );
    }

    return const SizedBox.shrink();
  }
}
