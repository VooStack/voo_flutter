import 'package:flutter/material.dart';
import 'package:voo_responsive/src/domain/entities/screen_info.dart';
import 'package:voo_tokens/voo_tokens.dart';

class VooResponsiveController extends ChangeNotifier {
  ScreenInfo? _screenInfo;
  ResponsiveTokens? _responsiveTokens;

  ScreenInfo? get screenInfo => _screenInfo;
  ResponsiveTokens? get responsiveTokens => _responsiveTokens;

  void updateScreenInfo(BuildContext context) {
    _screenInfo = ScreenInfo.fromContext(context);
    _updateResponsiveTokens(context);
    notifyListeners();
  }

  void _updateResponsiveTokens(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    _responsiveTokens = ResponsiveTokens.forScreenWidth(
      mediaQuery.size.width,
      isDark: isDark,
    );
  }
}
