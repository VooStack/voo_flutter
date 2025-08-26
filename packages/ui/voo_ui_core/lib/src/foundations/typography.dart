import 'package:flutter/material.dart';

class VooTypography {
  static TextStyle getMonospaceStyle(BuildContext context) =>
      Theme.of(context)
          .textTheme
          .bodySmall!
          .copyWith(fontFamily: 'monospace', fontSize: 12);

  static TextStyle getTitleStyle(BuildContext context) =>
      Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(fontWeight: FontWeight.bold);

  static TextStyle getSubtitleStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          );

  static TextStyle getLabelStyle(BuildContext context) =>
      Theme.of(context).textTheme.labelMedium!.copyWith(
            fontWeight: FontWeight.w500,
          );

  static TextStyle getCodeStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontFamily: 'monospace',
            color: Theme.of(context).colorScheme.primary,
          );
}