import 'package:flutter/material.dart';

@immutable
class VooComponentRadiusTokens {
  final double button;
  final double buttonSmall;
  final double buttonLarge;
  final double card;
  final double dialog;
  final double bottomSheet;
  final double input;
  final double chip;
  final double avatar;
  final double badge;
  final double tooltip;
  final double snackbar;
  final double dropdown;
  final double image;
  final double container;

  const VooComponentRadiusTokens({
    this.button = 8.0,
    this.buttonSmall = 4.0,
    this.buttonLarge = 12.0,
    this.card = 12.0,
    this.dialog = 16.0,
    this.bottomSheet = 16.0,
    this.input = 8.0,
    this.chip = 16.0,
    this.avatar = 999.0, // Full circle
    this.badge = 4.0,
    this.tooltip = 4.0,
    this.snackbar = 4.0,
    this.dropdown = 8.0,
    this.image = 8.0,
    this.container = 12.0,
  });

  VooComponentRadiusTokens scale(double scaleFactor) => VooComponentRadiusTokens(
    button: button * scaleFactor,
    buttonSmall: buttonSmall * scaleFactor,
    buttonLarge: buttonLarge * scaleFactor,
    card: card * scaleFactor,
    dialog: dialog * scaleFactor,
    bottomSheet: bottomSheet * scaleFactor,
    input: input * scaleFactor,
    chip: chip * scaleFactor,
    avatar: avatar, // Keep circle
    badge: badge * scaleFactor,
    tooltip: tooltip * scaleFactor,
    snackbar: snackbar * scaleFactor,
    dropdown: dropdown * scaleFactor,
    image: image * scaleFactor,
    container: container * scaleFactor,
  );

  BorderRadius get buttonRadius => BorderRadius.circular(button);
  BorderRadius get buttonSmallRadius => BorderRadius.circular(buttonSmall);
  BorderRadius get buttonLargeRadius => BorderRadius.circular(buttonLarge);
  BorderRadius get cardRadius => BorderRadius.circular(card);
  BorderRadius get dialogRadius => BorderRadius.circular(dialog);
  BorderRadius get bottomSheetRadius => BorderRadius.vertical(top: Radius.circular(bottomSheet));
  BorderRadius get inputRadius => BorderRadius.circular(input);
  BorderRadius get chipRadius => BorderRadius.circular(chip);
  BorderRadius get avatarRadius => BorderRadius.circular(avatar);
  BorderRadius get badgeRadius => BorderRadius.circular(badge);
  BorderRadius get tooltipRadius => BorderRadius.circular(tooltip);
  BorderRadius get snackbarRadius => BorderRadius.circular(snackbar);
  BorderRadius get dropdownRadius => BorderRadius.circular(dropdown);
  BorderRadius get imageRadius => BorderRadius.circular(image);
  BorderRadius get containerRadius => BorderRadius.circular(container);
}
