import 'package:flutter/material.dart';

@immutable
class VooPaddingTokens {
  final double buttonHorizontal;
  final double buttonVertical;
  final double cardInner;
  final double inputHorizontal;
  final double inputVertical;
  final double chipHorizontal;
  final double chipVertical;
  final double appBarHorizontal;
  final double tabHorizontal;
  final double tabVertical;
  final double listTileHorizontal;
  final double listTileVertical;
  final double containerSmall;
  final double containerMedium;
  final double containerLarge;

  const VooPaddingTokens({
    this.buttonHorizontal = 16.0,
    this.buttonVertical = 12.0,
    this.cardInner = 16.0,
    this.inputHorizontal = 12.0,
    this.inputVertical = 14.0,
    this.chipHorizontal = 12.0,
    this.chipVertical = 6.0,
    this.appBarHorizontal = 16.0,
    this.tabHorizontal = 16.0,
    this.tabVertical = 12.0,
    this.listTileHorizontal = 16.0,
    this.listTileVertical = 12.0,
    this.containerSmall = 8.0,
    this.containerMedium = 16.0,
    this.containerLarge = 24.0,
  });

  VooPaddingTokens scale(double scaleFactor) => VooPaddingTokens(
    buttonHorizontal: buttonHorizontal * scaleFactor,
    buttonVertical: buttonVertical * scaleFactor,
    cardInner: cardInner * scaleFactor,
    inputHorizontal: inputHorizontal * scaleFactor,
    inputVertical: inputVertical * scaleFactor,
    chipHorizontal: chipHorizontal * scaleFactor,
    chipVertical: chipVertical * scaleFactor,
    appBarHorizontal: appBarHorizontal * scaleFactor,
    tabHorizontal: tabHorizontal * scaleFactor,
    tabVertical: tabVertical * scaleFactor,
    listTileHorizontal: listTileHorizontal * scaleFactor,
    listTileVertical: listTileVertical * scaleFactor,
    containerSmall: containerSmall * scaleFactor,
    containerMedium: containerMedium * scaleFactor,
    containerLarge: containerLarge * scaleFactor,
  );

  EdgeInsets get button => EdgeInsets.symmetric(
    horizontal: buttonHorizontal,
    vertical: buttonVertical,
  );

  EdgeInsets get card => EdgeInsets.all(cardInner);

  EdgeInsets get input => EdgeInsets.symmetric(
    horizontal: inputHorizontal,
    vertical: inputVertical,
  );

  EdgeInsets get chip => EdgeInsets.symmetric(
    horizontal: chipHorizontal,
    vertical: chipVertical,
  );

  EdgeInsets get tab => EdgeInsets.symmetric(
    horizontal: tabHorizontal,
    vertical: tabVertical,
  );

  EdgeInsets get listTile => EdgeInsets.symmetric(
    horizontal: listTileHorizontal,
    vertical: listTileVertical,
  );
}