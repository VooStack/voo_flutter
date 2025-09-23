import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class VooTypographyTokens extends Equatable {
  static const String _fontFamily = 'Inter';
  static const String _monospaceFontFamily = 'JetBrains Mono';

  final String fontFamily;
  final String monospaceFontFamily;

  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle displaySmall;

  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;

  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;

  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;

  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;

  final TextStyle code;
  final TextStyle codeBlock;
  final TextStyle caption;
  final TextStyle overline;
  final TextStyle button;

  const VooTypographyTokens({
    this.fontFamily = _fontFamily,
    this.monospaceFontFamily = _monospaceFontFamily,
    this.displayLarge = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 57,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.25,
      height: 1.12,
    ),
    this.displayMedium = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.16,
    ),
    this.displaySmall = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.22,
    ),
    this.headlineLarge = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 32,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.25,
    ),
    this.headlineMedium = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.29,
    ),
    this.headlineSmall = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.33,
    ),
    this.titleLarge = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.27,
    ),
    this.titleMedium = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      height: 1.5,
    ),
    this.titleSmall = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.43,
    ),
    this.bodyLarge = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.5,
    ),
    this.bodyMedium = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.43,
    ),
    this.bodySmall = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.33,
    ),
    this.labelLarge = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
    ),
    this.labelMedium = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.33,
    ),
    this.labelSmall = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.45,
    ),
    this.code = const TextStyle(
      fontFamily: _monospaceFontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.43,
    ),
    this.codeBlock = const TextStyle(
      fontFamily: _monospaceFontFamily,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.5,
    ),
    this.caption = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
    ),
    this.overline = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 10,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.5,
      height: 1.6,
    ),
    this.button = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      height: 1.43,
    ),
  });

  VooTypographyTokens scale(double factor) {
    return VooTypographyTokens(
      fontFamily: fontFamily,
      monospaceFontFamily: monospaceFontFamily,
      displayLarge: displayLarge.copyWith(fontSize: displayLarge.fontSize! * factor),
      displayMedium: displayMedium.copyWith(fontSize: displayMedium.fontSize! * factor),
      displaySmall: displaySmall.copyWith(fontSize: displaySmall.fontSize! * factor),
      headlineLarge: headlineLarge.copyWith(fontSize: headlineLarge.fontSize! * factor),
      headlineMedium: headlineMedium.copyWith(fontSize: headlineMedium.fontSize! * factor),
      headlineSmall: headlineSmall.copyWith(fontSize: headlineSmall.fontSize! * factor),
      titleLarge: titleLarge.copyWith(fontSize: titleLarge.fontSize! * factor),
      titleMedium: titleMedium.copyWith(fontSize: titleMedium.fontSize! * factor),
      titleSmall: titleSmall.copyWith(fontSize: titleSmall.fontSize! * factor),
      bodyLarge: bodyLarge.copyWith(fontSize: bodyLarge.fontSize! * factor),
      bodyMedium: bodyMedium.copyWith(fontSize: bodyMedium.fontSize! * factor),
      bodySmall: bodySmall.copyWith(fontSize: bodySmall.fontSize! * factor),
      labelLarge: labelLarge.copyWith(fontSize: labelLarge.fontSize! * factor),
      labelMedium: labelMedium.copyWith(fontSize: labelMedium.fontSize! * factor),
      labelSmall: labelSmall.copyWith(fontSize: labelSmall.fontSize! * factor),
      code: code.copyWith(fontSize: code.fontSize! * factor),
      codeBlock: codeBlock.copyWith(fontSize: codeBlock.fontSize! * factor),
      caption: caption.copyWith(fontSize: caption.fontSize! * factor),
      overline: overline.copyWith(fontSize: overline.fontSize! * factor),
      button: button.copyWith(fontSize: button.fontSize! * factor),
    );
  }

  @override
  List<Object?> get props => [
        fontFamily,
        monospaceFontFamily,
        displayLarge,
        displayMedium,
        displaySmall,
        headlineLarge,
        headlineMedium,
        headlineSmall,
        titleLarge,
        titleMedium,
        titleSmall,
        bodyLarge,
        bodyMedium,
        bodySmall,
        labelLarge,
        labelMedium,
        labelSmall,
        code,
        codeBlock,
        caption,
        overline,
        button,
      ];
}