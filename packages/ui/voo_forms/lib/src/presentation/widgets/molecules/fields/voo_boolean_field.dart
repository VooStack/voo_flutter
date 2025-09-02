import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/inputs/voo_switch_input.dart';

/// Boolean field molecule that composes atoms to create a complete switch field
/// Uses VooSwitchInput atom for the actual switch control
class VooBooleanField extends VooFieldBase<bool> {
  const VooBooleanField({
    super.key,
    required super.name,
    super.label,
    super.labelWidget,
    super.helper,
    bool? initialValue,
    super.value,
    super.required,
    super.enabled,
    super.readOnly,
    super.validators,
    super.onChanged,
    super.actions,
    super.gridColumns,
    super.layout,
    super.isHidden,
  }) : super(
          initialValue: initialValue ?? false,
        );

  @override
  Widget build(BuildContext context) {
    // Return empty widget if hidden
    if (isHidden) return const SizedBox.shrink();
    
    final theme = Theme.of(context);
    final currentValue = value ?? initialValue ?? false;

    // Build the switch with label or labelWidget in a row
    final switchRow = Row(
      children: [
        if (labelWidget != null || label != null) ...[
          Expanded(
            child: GestureDetector(
              onTap: enabled && !readOnly && onChanged != null ? () => onChanged!(!currentValue) : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (labelWidget != null)
                    labelWidget!
                  else
                    buildLabel(context),
                  if (helper != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      helper!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
        VooSwitchInput(
          value: currentValue,
          onChanged: enabled && !readOnly ? onChanged : null,
          enabled: enabled && !readOnly,
        ),
        if (actions != null && actions!.isNotEmpty) ...[
          const SizedBox(width: 8),
          ...actions!,
        ],
      ],
    );

    // Wrap in a card-like container for better visual separation
    final container = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: enabled ? theme.colorScheme.surface : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: switchRow,
    );
    
    return buildFieldContainer(context, container);
  }
}
