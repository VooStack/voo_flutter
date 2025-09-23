import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class VooRadiusTokens extends Equatable {
  final double none;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double full;

  final BorderRadius button;
  final BorderRadius card;
  final BorderRadius input;
  final BorderRadius dialog;
  final BorderRadius chip;
  final BorderRadius tooltip;

  VooRadiusTokens({
    this.none = 0,
    this.xs = 2,
    this.sm = 4,
    this.md = 8,
    this.lg = 12,
    this.xl = 16,
    this.xxl = 24,
    this.full = 9999,
    BorderRadius? button,
    BorderRadius? card,
    BorderRadius? input,
    BorderRadius? dialog,
    BorderRadius? chip,
    BorderRadius? tooltip,
  })  : button = button ?? BorderRadius.circular(8),
        card = card ?? BorderRadius.circular(12),
        input = input ?? BorderRadius.circular(8),
        dialog = dialog ?? BorderRadius.circular(16),
        chip = chip ?? BorderRadius.circular(9999),
        tooltip = tooltip ?? BorderRadius.circular(8);

  VooRadiusTokens scale(double factor) {
    return VooRadiusTokens(
      none: none,
      xs: xs * factor,
      sm: sm * factor,
      md: md * factor,
      lg: lg * factor,
      xl: xl * factor,
      xxl: xxl * factor,
      full: full,
      button: BorderRadius.circular(md * factor),
      card: BorderRadius.circular(lg * factor),
      input: BorderRadius.circular(md * factor),
      dialog: BorderRadius.circular(xl * factor),
      chip: BorderRadius.circular(full),
      tooltip: BorderRadius.circular(md * factor),
    );
  }

  @override
  List<Object?> get props => [
        none,
        xs,
        sm,
        md,
        lg,
        xl,
        xxl,
        full,
        button,
        card,
        input,
        dialog,
        chip,
        tooltip,
      ];
}