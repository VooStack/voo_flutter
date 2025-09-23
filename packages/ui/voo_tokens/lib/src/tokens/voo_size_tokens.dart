import 'package:flutter/material.dart';

@immutable
class VooSizeTokens {
  final double iconSmall;
  final double iconMedium;
  final double iconLarge;
  final double avatarSmall;
  final double avatarMedium;
  final double avatarLarge;
  final double buttonHeightSmall;
  final double buttonHeightMedium;
  final double buttonHeightLarge;
  final double inputHeight;
  final double appBarHeight;
  final double tabBarHeight;
  final double bottomNavigationHeight;
  final double chipHeight;
  final double dividerThickness;
  final double progressBarHeight;
  final double switchWidth;
  final double switchHeight;
  final double checkboxSize;
  final double radioSize;

  const VooSizeTokens({
    this.iconSmall = 16.0,
    this.iconMedium = 24.0,
    this.iconLarge = 32.0,
    this.avatarSmall = 32.0,
    this.avatarMedium = 40.0,
    this.avatarLarge = 56.0,
    this.buttonHeightSmall = 32.0,
    this.buttonHeightMedium = 40.0,
    this.buttonHeightLarge = 48.0,
    this.inputHeight = 48.0,
    this.appBarHeight = 56.0,
    this.tabBarHeight = 48.0,
    this.bottomNavigationHeight = 56.0,
    this.chipHeight = 32.0,
    this.dividerThickness = 1.0,
    this.progressBarHeight = 4.0,
    this.switchWidth = 48.0,
    this.switchHeight = 24.0,
    this.checkboxSize = 20.0,
    this.radioSize = 20.0,
  });

  VooSizeTokens scale(double scaleFactor) => VooSizeTokens(
    iconSmall: iconSmall * scaleFactor,
    iconMedium: iconMedium * scaleFactor,
    iconLarge: iconLarge * scaleFactor,
    avatarSmall: avatarSmall * scaleFactor,
    avatarMedium: avatarMedium * scaleFactor,
    avatarLarge: avatarLarge * scaleFactor,
    buttonHeightSmall: buttonHeightSmall * scaleFactor,
    buttonHeightMedium: buttonHeightMedium * scaleFactor,
    buttonHeightLarge: buttonHeightLarge * scaleFactor,
    inputHeight: inputHeight * scaleFactor,
    appBarHeight: appBarHeight * scaleFactor,
    tabBarHeight: tabBarHeight * scaleFactor,
    bottomNavigationHeight: bottomNavigationHeight * scaleFactor,
    chipHeight: chipHeight * scaleFactor,
    dividerThickness: dividerThickness * scaleFactor,
    progressBarHeight: progressBarHeight * scaleFactor,
    switchWidth: switchWidth * scaleFactor,
    switchHeight: switchHeight * scaleFactor,
    checkboxSize: checkboxSize * scaleFactor,
    radioSize: radioSize * scaleFactor,
  );
}