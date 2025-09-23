import 'package:flutter/material.dart';

@immutable
class VooGapTokens {
  final double listItems;
  final double formFields;
  final double buttonGroup;
  final double iconText;
  final double chipGroup;
  final double gridItems;
  final double tabItems;
  final double inlineElements;
  final double stackedElements;

  const VooGapTokens({
    this.listItems = 8.0,
    this.formFields = 16.0,
    this.buttonGroup = 12.0,
    this.iconText = 8.0,
    this.chipGroup = 8.0,
    this.gridItems = 16.0,
    this.tabItems = 0.0,
    this.inlineElements = 8.0,
    this.stackedElements = 16.0,
  });

  VooGapTokens scale(double scaleFactor) => VooGapTokens(
    listItems: listItems * scaleFactor,
    formFields: formFields * scaleFactor,
    buttonGroup: buttonGroup * scaleFactor,
    iconText: iconText * scaleFactor,
    chipGroup: chipGroup * scaleFactor,
    gridItems: gridItems * scaleFactor,
    tabItems: tabItems * scaleFactor,
    inlineElements: inlineElements * scaleFactor,
    stackedElements: stackedElements * scaleFactor,
  );
}