import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Atomic widget for color picker form field
class VooColorFieldWidget extends StatelessWidget {
  final VooFormField field;
  final VooFieldOptions options;
  final ValueChanged<Color?>? onChanged;
  final VoidCallback? onTap;
  final String? error;
  final bool showError;

  const VooColorFieldWidget({
    super.key,
    required this.field,
    required this.options,
    this.onChanged,
    this.onTap,
    this.error,
    this.showError = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = context.vooDesign;
    
    final errorText = showError ? (error ?? field.error) : null;
    final hasError = errorText != null && errorText.isNotEmpty;
    
    // Get color from value
    Color? selectedColor;
    if (field.value != null) {
      if (field.value is Color) {
        selectedColor = field.value as Color;
      } else if (field.value is int) {
        selectedColor = Color(field.value as int);
      } else if (field.value is String) {
        // Try to parse hex color string
        final hexString = (field.value as String).replaceAll('#', '');
        if (hexString.length == 6 || hexString.length == 8) {
          selectedColor = Color(int.parse('0xFF$hexString'));
        }
      }
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.label != null && options.labelPosition != LabelPosition.hidden)
          Padding(
            padding: EdgeInsets.only(bottom: design.spacingSm),
            child: Text(
              field.label!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: hasError
                    ? theme.colorScheme.error
                    : theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        InkWell(
          onTap: field.enabled && !field.readOnly
              ? () async {
                  // Show color picker dialog
                  final pickedColor = await showDialog<Color>(
                    context: context,
                    builder: (context) => _ColorPickerDialog(
                      initialColor: selectedColor ?? theme.colorScheme.primary,
                    ),
                  );
                  
                  if (pickedColor != null) {
                    onChanged?.call(pickedColor);
                    // Safely call field.onChanged with type checking
                    try {
                      final dynamic dynField = field;
                      final callback = dynField.onChanged;
                      if (callback != null) {
                        callback(pickedColor);
                      }
                    } catch (_) {
                      // Silently ignore type casting errors
                    }
                  }
                  onTap?.call();
                }
              : null,
          borderRadius: BorderRadius.circular(design.radiusMd),
          child: Container(
            padding: EdgeInsets.all(design.spacingMd),
            decoration: BoxDecoration(
              border: Border.all(
                color: hasError
                    ? theme.colorScheme.error
                    : theme.colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(design.radiusMd),
              color: field.enabled
                  ? null
                  : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: selectedColor ?? Colors.transparent,
                    border: Border.all(
                      color: theme.colorScheme.outline,
                    ),
                    borderRadius: BorderRadius.circular(design.radiusSm),
                  ),
                  child: selectedColor == null
                      ? Icon(
                          Icons.palette,
                          color: theme.colorScheme.onSurfaceVariant,
                        )
                      : null,
                ),
                SizedBox(width: design.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedColor != null
                            ? '#${(((selectedColor.r * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0') + ((selectedColor.g * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0') + ((selectedColor.b * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')).toUpperCase()}'
                            : field.hint ?? 'Select color',
                        style: theme.textTheme.bodyMedium,
                      ),
                      if (field.helper != null) ...[
                        SizedBox(height: design.spacingXs),
                        Text(
                          field.helper!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
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

/// Simple color picker dialog
class _ColorPickerDialog extends StatefulWidget {
  final Color initialColor;

  const _ColorPickerDialog({
    required this.initialColor,
  });

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color selectedColor;
  
  static const List<Color> _colors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
  ];

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    return AlertDialog(
      title: const Text('Choose color'),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: _colors.length,
          itemBuilder: (context, index) {
            final color = _colors[index];
            return InkWell(
              onTap: () {
                setState(() {
                  selectedColor = color;
                });
              },
              borderRadius: BorderRadius.circular(design.radiusSm),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(design.radiusSm),
                  border: Border.all(
                    color: selectedColor == color
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: selectedColor == color
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                      )
                    : null,
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(selectedColor),
          child: const Text('Select'),
        ),
      ],
    );
  }
}