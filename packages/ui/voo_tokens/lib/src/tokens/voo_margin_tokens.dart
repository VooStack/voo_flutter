import 'package:flutter/material.dart';

@immutable
class VooMarginTokens {
  final double pageHorizontal;
  final double pageVertical;
  final double sectionBottom;
  final double cardOuter;
  final double listItemHorizontal;
  final double listItemVertical;
  final double dialogHorizontal;
  final double dialogVertical;
  final double betweenElements;
  final double betweenSections;

  const VooMarginTokens({
    this.pageHorizontal = 16.0,
    this.pageVertical = 24.0,
    this.sectionBottom = 32.0,
    this.cardOuter = 12.0,
    this.listItemHorizontal = 16.0,
    this.listItemVertical = 8.0,
    this.dialogHorizontal = 24.0,
    this.dialogVertical = 24.0,
    this.betweenElements = 8.0,
    this.betweenSections = 24.0,
  });

  VooMarginTokens scale(double scaleFactor) => VooMarginTokens(
    pageHorizontal: pageHorizontal * scaleFactor,
    pageVertical: pageVertical * scaleFactor,
    sectionBottom: sectionBottom * scaleFactor,
    cardOuter: cardOuter * scaleFactor,
    listItemHorizontal: listItemHorizontal * scaleFactor,
    listItemVertical: listItemVertical * scaleFactor,
    dialogHorizontal: dialogHorizontal * scaleFactor,
    dialogVertical: dialogVertical * scaleFactor,
    betweenElements: betweenElements * scaleFactor,
    betweenSections: betweenSections * scaleFactor,
  );

  EdgeInsets get page => EdgeInsets.symmetric(horizontal: pageHorizontal, vertical: pageVertical);

  EdgeInsets get card => EdgeInsets.all(cardOuter);

  EdgeInsets get listItem => EdgeInsets.symmetric(horizontal: listItemHorizontal, vertical: listItemVertical);

  EdgeInsets get dialog => EdgeInsets.symmetric(horizontal: dialogHorizontal, vertical: dialogVertical);
}
