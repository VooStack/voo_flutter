import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/field_type.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_checkbox_field.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_date_field.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_dropdown_field.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_radio_field.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_slider_field.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_switch_field.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_text_form_field.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_time_field.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_list_field.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';

/// Factory class for creating field widgets based on field type
/// Follows atomic design and clean architecture principles
class FieldWidgetFactory {
  const FieldWidgetFactory();

  /// Creates the appropriate field widget based on field type
  Widget create({
    required BuildContext context,
    required VooFormField field,
    required VooFieldOptions options,
    bool isEditable = true,
    ValueChanged<dynamic>? onChanged,
    VoidCallback? onEditingComplete,
    ValueChanged<dynamic>? onSubmitted,
    VoidCallback? onTap,
    FocusNode? focusNode,
    TextEditingController? controller,
    String? error,
    bool showError = true,
    bool autofocus = false,
  }) {
    // Determine if field should be read-only
    // Field is read-only if:
    // 1. The entire form is not editable (isEditable = false), OR
    // 2. The individual field is marked as readOnly
    final effectiveReadOnly = !isEditable || field.readOnly;

    // If field is read-only, return the read-only widget
    if (effectiveReadOnly) {
      return _createReadOnlyWidget(
        context: context,
        field: field,
        options: options,
      );
    }

    // Handle custom field type
    if (field.type == VooFieldType.custom) {
      // If custom widget is provided directly
      if (field.customWidget != null) {
        return field.customWidget!;
      }

      // If custom builder is provided
      if (field.customBuilder != null) {
        return field.customBuilder!(context, field, field.value ?? field.initialValue);
      }

      // Fallback to a placeholder
      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          'Custom widget not configured',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    switch (field.type) {
      case VooFieldType.text:
      case VooFieldType.email:
      case VooFieldType.password:
      case VooFieldType.phone:
      case VooFieldType.url:
      case VooFieldType.number:
      case VooFieldType.multiline:
        return VooTextFormField(
          field: field,
          options: options,
          controller: controller,
          focusNode: focusNode,
          onChanged: (String value) {
            onChanged?.call(value);
          },
          onEditingComplete: onEditingComplete,
          onSubmitted: onSubmitted != null ? (value) => onSubmitted(value) : null,
          error: error,
          showError: showError,
          autoFocus: autofocus,
        );

      case VooFieldType.boolean:
        return VooSwitchFieldWidget(
          field: field,
          options: options,
          onChanged: (bool? value) {
            onChanged?.call(value);
          },
        );

      case VooFieldType.checkbox:
        return VooCheckboxFieldWidget(
          field: field,
          options: options,
          onChanged: (bool? value) {
            onChanged?.call(value);
          },
        );

      case VooFieldType.dropdown:
        // Create a generic helper method to build the dropdown
        Widget buildDropdown<DropdownType>() {
          // Try to cast the field - if it fails, use dynamic
          try {
            final typedField = field as VooFormField<DropdownType>;
            return VooDropdownFieldWidget<DropdownType>(
              field: typedField,
              options: options,
              onChanged: (DropdownType? value) {
                onChanged?.call(value);
              },
              error: error,
              showError: showError,
            );
          } catch (_) {
            // If cast fails, create with dynamic type
            return VooDropdownFieldWidget<dynamic>(
              field: field,
              options: options,
              onChanged: (dynamic value) {
                onChanged?.call(value);
              },
              error: error,
              showError: showError,
            );
          }
        }

        // Determine the type based on field configuration
        // First check if we have options to infer type from
        if (field.options != null && field.options!.isNotEmpty) {
          final firstOption = field.options!.first;
          final valueType = firstOption.value.runtimeType;

          if (valueType == String) {
            return buildDropdown<String>();
          } else if (valueType == int) {
            return buildDropdown<int>();
          } else if (valueType == double) {
            return buildDropdown<double>();
          } else if (valueType == bool) {
            return buildDropdown<bool>();
          }
        }

        // For async dropdowns or empty dropdowns, try to infer from initial value
        if (field.initialValue != null) {
          final valueType = field.initialValue.runtimeType;

          if (valueType == String) {
            return buildDropdown<String>();
          } else if (valueType == int) {
            return buildDropdown<int>();
          } else if (valueType == double) {
            return buildDropdown<double>();
          } else if (valueType == bool) {
            return buildDropdown<bool>();
          }
        }

        // If we have a value, use its type
        if (field.value != null) {
          final valueType = field.value.runtimeType;

          if (valueType == String) {
            return buildDropdown<String>();
          } else if (valueType == int) {
            return buildDropdown<int>();
          } else if (valueType == double) {
            return buildDropdown<double>();
          } else if (valueType == bool) {
            return buildDropdown<bool>();
          }
        }

        // Default fallback for truly dynamic dropdowns
        return buildDropdown<dynamic>();

      case VooFieldType.radio:
        return VooRadioFieldWidget(
          field: field,
          options: options,
          onChanged: (value) {
            onChanged?.call(value);
          },
        );

      case VooFieldType.slider:
        return VooSliderFieldWidget(
          field: field,
          options: options,
          onChanged: (double value) {
            onChanged?.call(value);
          },
          error: error,
          showError: showError,
        );

      case VooFieldType.date:
        return VooDateFieldWidget(
          field: field,
          options: options,
          onChanged: (DateTime? value) {
            onChanged?.call(value);
          },
          onTap: onTap,
          focusNode: focusNode,
          controller: controller,
          error: error,
          showError: showError,
        );

      case VooFieldType.time:
        return VooTimeFieldWidget(
          field: field,
          options: options,
          onChanged: (TimeOfDay? value) {
            onChanged?.call(value);
          },
          onTap: onTap,
          focusNode: focusNode,
          controller: controller,
          error: error,
          showError: showError,
        );

      case VooFieldType.list:
        // Create a generic helper method to build the list widget with proper type
        Widget buildListWidget<ItemType>() {
          // Try to cast the field - if it fails, use dynamic
          try {
            final typedField = field as VooFormField<List<ItemType>>;
            return VooListFieldWidget<ItemType>(
              field: typedField,
              options: options,
              onChanged: onChanged != null ? (List<ItemType>? value) => onChanged(value) : null,
              error: error,
              showError: showError,
            );
          } catch (_) {
            // If cast fails, create with dynamic type
            return VooListFieldWidget<dynamic>(
              field: field as VooFormField<List<dynamic>>,
              options: options,
              onChanged: onChanged != null ? (List<dynamic>? value) => onChanged(value) : null,
              error: error,
              showError: showError,
            );
          }
        }

        // Try to infer the type from the item template
        if (field.itemTemplate != null) {
          final templateType = field.itemTemplate!.type;

          // Infer type based on the template field type
          if (templateType == VooFieldType.text ||
              templateType == VooFieldType.email ||
              templateType == VooFieldType.phone ||
              templateType == VooFieldType.url ||
              templateType == VooFieldType.multiline ||
              templateType == VooFieldType.password) {
            return buildListWidget<String>();
          } else if (templateType == VooFieldType.number) {
            // Check if it's int or double based on validation or initial value
            if (field.itemTemplate!.initialValue is int) {
              return buildListWidget<int>();
            } else {
              return buildListWidget<double>();
            }
          } else if (templateType == VooFieldType.boolean || templateType == VooFieldType.checkbox) {
            return buildListWidget<bool>();
          } else if (templateType == VooFieldType.date) {
            return buildListWidget<DateTime>();
          } else if (templateType == VooFieldType.time) {
            return buildListWidget<TimeOfDay>();
          }
        }

        // Default fallback for dynamic lists
        return buildListWidget<dynamic>();

      default:
        // Fallback for unsupported types
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            'Unsupported field type: ${field.type}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
    }
  }

  /// Creates a read-only widget for displaying field values
  Widget _createReadOnlyWidget({
    required BuildContext context,
    required VooFormField field,
    required VooFieldOptions options,
  }) {
    // If custom readOnlyWidget is provided, use it
    if (field.readOnlyWidget != null) {
      return field.readOnlyWidget!;
    }

    final theme = Theme.of(context);
    final value = field.value ?? field.initialValue;

    // Build the display value based on field type
    String displayValue = '';
    Widget? trailingWidget;

    // Handle custom field in read-only mode
    if (field.type == VooFieldType.custom) {
      // If custom widget is provided, show it as-is (developer's responsibility to handle read-only)
      if (field.customWidget != null) {
        return field.customWidget!;
      }

      // If custom builder is provided, use it (developer can check isEditable in their builder)
      if (field.customBuilder != null) {
        return field.customBuilder!(context, field, field.value ?? field.initialValue);
      }

      // Fallback
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Text(
          'Custom field (read-only)',
          style: theme.textTheme.bodyLarge,
        ),
      );
    }

    switch (field.type) {
      case VooFieldType.text:
      case VooFieldType.email:
      case VooFieldType.phone:
      case VooFieldType.url:
      case VooFieldType.number:
      case VooFieldType.multiline:
        displayValue = value?.toString() ?? '-';
        break;

      case VooFieldType.password:
        displayValue = value != null ? '••••••••' : '-';
        break;

      case VooFieldType.boolean:
      case VooFieldType.checkbox:
        final boolValue = value as bool?;
        displayValue = boolValue == true
            ? 'Yes'
            : boolValue == false
                ? 'No'
                : '-';
        trailingWidget = Icon(
          boolValue == true ? Icons.check_circle : Icons.cancel,
          color: boolValue == true ? theme.colorScheme.primary : theme.colorScheme.error,
          size: 20,
        );
        break;

      case VooFieldType.dropdown:
      case VooFieldType.radio:
        if (value != null) {
          // If it's an option with label, try to display the label
          if (field.options != null && field.options!.isNotEmpty) {
            // Try to find the matching option
            try {
              final option = field.options!.firstWhere(
                (opt) => opt.value == value,
              );
              displayValue = option.label;
            } catch (_) {
              // If not found, just use the value's string representation
              displayValue = value.toString();
            }
          } else {
            displayValue = value.toString();
          }
        } else {
          displayValue = '-';
        }
        break;

      case VooFieldType.slider:
        final sliderValue = value as double?;
        displayValue = sliderValue != null ? sliderValue.toStringAsFixed(1) : '-';
        if (sliderValue != null) {
          final minValue = (field.min ?? 0).toDouble();
          final maxValue = (field.max ?? 100).toDouble();
          trailingWidget = SizedBox(
            width: 100,
            child: LinearProgressIndicator(
              value: (sliderValue - minValue) / (maxValue - minValue),
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
          );
        }
        break;

      case VooFieldType.date:
        if (value is DateTime) {
          displayValue = _formatDate(value);
        } else {
          displayValue = value?.toString() ?? '-';
        }
        trailingWidget = Icon(Icons.calendar_today, size: 18, color: theme.colorScheme.primary);
        break;

      case VooFieldType.time:
        if (value is TimeOfDay) {
          displayValue = value.format(context);
        } else {
          displayValue = value?.toString() ?? '-';
        }
        trailingWidget = Icon(Icons.access_time, size: 18, color: theme.colorScheme.primary);
        break;

      case VooFieldType.list:
        if (value is List) {
          final itemCount = value.length;
          displayValue = '$itemCount ${itemCount == 1 ? 'item' : 'items'}';
          if (itemCount > 0 && field.itemTemplate?.label != null) {
            displayValue = '$itemCount ${field.itemTemplate!.label}${itemCount == 1 ? '' : 's'}';
          }
        } else {
          displayValue = '0 items';
        }
        trailingWidget = Icon(Icons.list_alt, size: 18, color: theme.colorScheme.primary);
        break;

      default:
        displayValue = value?.toString() ?? '-';
    }

    // Create the read-only display widget
    final detailsWidget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (field.label != null && options.labelPosition != LabelPosition.hidden) ...[
                  Text(
                    field.label!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  displayValue,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: field.type == VooFieldType.multiline ? null : 1,
                  overflow: field.type == VooFieldType.multiline ? null : TextOverflow.ellipsis,
                ),
                if (field.helper != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    field.helper!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailingWidget != null) ...[
            const SizedBox(width: 12),
            trailingWidget,
          ],
        ],
      ),
    );

    return detailsWidget;
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
