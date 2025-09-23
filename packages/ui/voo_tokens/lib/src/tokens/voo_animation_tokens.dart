import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class VooAnimationTokens extends Equatable {
  final Duration durationInstant;
  final Duration durationFast;
  final Duration durationNormal;
  final Duration durationSlow;
  final Duration durationSlowest;

  final Curve curveEaseIn;
  final Curve curveEaseOut;
  final Curve curveEaseInOut;
  final Curve curveLinear;
  final Curve curveBounce;
  final Curve curveElastic;

  final Duration pageTransition;
  final Duration dialogAnimation;
  final Duration tooltipDelay;
  final Duration rippleDuration;

  const VooAnimationTokens({
    this.durationInstant = const Duration(milliseconds: 50),
    this.durationFast = const Duration(milliseconds: 150),
    this.durationNormal = const Duration(milliseconds: 250),
    this.durationSlow = const Duration(milliseconds: 400),
    this.durationSlowest = const Duration(milliseconds: 600),
    this.curveEaseIn = Curves.easeIn,
    this.curveEaseOut = Curves.easeOut,
    this.curveEaseInOut = Curves.easeInOut,
    this.curveLinear = Curves.linear,
    this.curveBounce = Curves.bounceOut,
    this.curveElastic = Curves.elasticOut,
    this.pageTransition = const Duration(milliseconds: 250),
    this.dialogAnimation = const Duration(milliseconds: 150),
    this.tooltipDelay = const Duration(milliseconds: 500),
    this.rippleDuration = const Duration(milliseconds: 250),
  });

  @override
  List<Object?> get props => [
        durationInstant,
        durationFast,
        durationNormal,
        durationSlow,
        durationSlowest,
        curveEaseIn,
        curveEaseOut,
        curveEaseInOut,
        curveLinear,
        curveBounce,
        curveElastic,
        pageTransition,
        dialogAnimation,
        tooltipDelay,
        rippleDuration,
      ];
}