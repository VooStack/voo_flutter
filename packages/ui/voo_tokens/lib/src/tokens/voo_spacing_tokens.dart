import 'package:equatable/equatable.dart';

class VooSpacingTokens extends Equatable {
  final double xxs;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double xxxl;

  final double buttonPadding;
  final double cardPadding;
  final double listItemPadding;
  final double inputPadding;
  final double dialogPadding;

  final double gapSmall;
  final double gapMedium;
  final double gapLarge;

  const VooSpacingTokens({
    this.xxs = 2,
    this.xs = 4,
    this.sm = 8,
    this.md = 16,
    this.lg = 24,
    this.xl = 32,
    this.xxl = 48,
    this.xxxl = 64,
    this.buttonPadding = 12,
    this.cardPadding = 16,
    this.listItemPadding = 12,
    this.inputPadding = 12,
    this.dialogPadding = 24,
    this.gapSmall = 8,
    this.gapMedium = 16,
    this.gapLarge = 24,
  });

  VooSpacingTokens copyWith({
    double? xxs,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? xxxl,
    double? buttonPadding,
    double? cardPadding,
    double? listItemPadding,
    double? inputPadding,
    double? dialogPadding,
    double? gapSmall,
    double? gapMedium,
    double? gapLarge,
  }) {
    return VooSpacingTokens(
      xxs: xxs ?? this.xxs,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      xxxl: xxxl ?? this.xxxl,
      buttonPadding: buttonPadding ?? this.buttonPadding,
      cardPadding: cardPadding ?? this.cardPadding,
      listItemPadding: listItemPadding ?? this.listItemPadding,
      inputPadding: inputPadding ?? this.inputPadding,
      dialogPadding: dialogPadding ?? this.dialogPadding,
      gapSmall: gapSmall ?? this.gapSmall,
      gapMedium: gapMedium ?? this.gapMedium,
      gapLarge: gapLarge ?? this.gapLarge,
    );
  }

  VooSpacingTokens scale(double factor) {
    return VooSpacingTokens(
      xxs: xxs * factor,
      xs: xs * factor,
      sm: sm * factor,
      md: md * factor,
      lg: lg * factor,
      xl: xl * factor,
      xxl: xxl * factor,
      xxxl: xxxl * factor,
      buttonPadding: buttonPadding * factor,
      cardPadding: cardPadding * factor,
      listItemPadding: listItemPadding * factor,
      inputPadding: inputPadding * factor,
      dialogPadding: dialogPadding * factor,
      gapSmall: gapSmall * factor,
      gapMedium: gapMedium * factor,
      gapLarge: gapLarge * factor,
    );
  }

  @override
  List<Object?> get props => [
    xxs,
    xs,
    sm,
    md,
    lg,
    xl,
    xxl,
    xxxl,
    buttonPadding,
    cardPadding,
    listItemPadding,
    inputPadding,
    dialogPadding,
    gapSmall,
    gapMedium,
    gapLarge,
  ];
}
