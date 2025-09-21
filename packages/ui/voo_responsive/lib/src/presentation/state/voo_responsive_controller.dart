import 'package:flutter/material.dart';
import 'package:voo_responsive/src/domain/entities/screen_info.dart';

class VooResponsiveController extends ChangeNotifier {
  ScreenInfo? _screenInfo;

  ScreenInfo? get screenInfo => _screenInfo;

  void updateScreenInfo(BuildContext context) {
    _screenInfo = ScreenInfo.fromContext(context);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}