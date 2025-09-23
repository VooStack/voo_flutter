import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class VooElevationTokens extends Equatable {
  final bool isDarkMode;

  final double level0;
  final double level1;
  final double level2;
  final double level3;
  final double level4;
  final double level5;

  final double card;
  final double dialog;
  final double menu;
  final double tooltip;
  final double snackbar;

  const VooElevationTokens({
    this.isDarkMode = false,
    this.level0 = 0,
    this.level1 = 1,
    this.level2 = 2,
    this.level3 = 4,
    this.level4 = 8,
    this.level5 = 16,
    this.card = 2,
    this.dialog = 16,
    this.menu = 4,
    this.tooltip = 2,
    this.snackbar = 4,
  });

  List<BoxShadow> shadow0() => [];

  List<BoxShadow> shadow1() => [
    BoxShadow(color: isDarkMode ? Colors.black.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, 1)),
  ];

  List<BoxShadow> shadow2() => [
    BoxShadow(color: isDarkMode ? Colors.black.withValues(alpha: 0.4) : Colors.black.withValues(alpha: 0.08), blurRadius: 4, offset: const Offset(0, 2)),
  ];

  List<BoxShadow> shadow3() => [
    BoxShadow(color: isDarkMode ? Colors.black.withValues(alpha: 0.5) : Colors.black.withValues(alpha: 0.12), blurRadius: 8, offset: const Offset(0, 4)),
  ];

  List<BoxShadow> shadow4() => [
    BoxShadow(color: isDarkMode ? Colors.black.withValues(alpha: 0.6) : Colors.black.withValues(alpha: 0.16), blurRadius: 16, offset: const Offset(0, 8)),
  ];

  List<BoxShadow> shadow5() => [
    BoxShadow(color: isDarkMode ? Colors.black.withValues(alpha: 0.7) : Colors.black.withValues(alpha: 0.24), blurRadius: 24, offset: const Offset(0, 12)),
  ];

  @override
  List<Object?> get props => [isDarkMode, level0, level1, level2, level3, level4, level5, card, dialog, menu, tooltip, snackbar];
}
