import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Atomic widget for rating form field
class VooRatingFieldWidget extends StatelessWidget {
  final VooFormField field;
  final VooFieldOptions options;
  final ValueChanged<double?>? onChanged;
  final String? error;
  final bool showError;
  final int maxRating;
  final IconData? icon;
  final IconData? selectedIcon;

  const VooRatingFieldWidget({
    super.key,
    required this.field,
    required this.options,
    this.onChanged,
    this.error,
    this.showError = true,
    this.maxRating = 5,
    this.icon,
    this.selectedIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = context.vooDesign;
    
    final errorText = showError ? (error ?? field.error) : null;
    final hasError = errorText != null && errorText.isNotEmpty;
    
    final currentRating = (field.value as num?)?.toDouble() ?? 0.0;
    final effectiveIcon = icon ?? Icons.star_border;
    final effectiveSelectedIcon = selectedIcon ?? Icons.star;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.label != null && options.labelPosition != LabelPosition.hidden)
          Padding(
            padding: EdgeInsets.only(bottom: design.spacingSm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  field.label!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: hasError
                        ? theme.colorScheme.error
                        : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (currentRating > 0)
                  Text(
                    '${currentRating.toStringAsFixed(1)}/$maxRating',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: design.spacingSm,
            vertical: design.spacingXs,
          ),
          decoration: hasError
              ? BoxDecoration(
                  border: Border.all(color: theme.colorScheme.error),
                  borderRadius: BorderRadius.circular(design.radiusSm),
                )
              : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(maxRating, (index) {
              final rating = index + 1;
              final isSelected = rating <= currentRating;
              
              return GestureDetector(
                onTap: field.enabled && !field.readOnly
                    ? () {
                        final newRating = rating.toDouble();
                        onChanged?.call(newRating);
                        field.onChanged?.call(newRating);
                      }
                    : null,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: design.spacingXs),
                  child: Icon(
                    isSelected ? effectiveSelectedIcon : effectiveIcon,
                    color: isSelected
                        ? Colors.amber
                        : theme.colorScheme.onSurfaceVariant,
                    size: design.iconSizeLg,
                  ),
                ),
              );
            }),
          ),
        ),
        if (field.helper != null)
          Padding(
            padding: EdgeInsets.only(top: design.spacingXs),
            child: Text(
              field.helper!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        if (hasError) ...[
          SizedBox(height: design.spacingXs),
          Padding(
            padding: EdgeInsets.only(left: design.spacingLg),
            child: Text(
              errorText,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ],
    );
  }
}