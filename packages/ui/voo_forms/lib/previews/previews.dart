import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_forms/previews/utils/us_state.dart';
import 'package:voo_forms/voo_forms.dart';

// ============================================================================
// INDIVIDUAL FIELD PREVIEWS
// ============================================================================

@Preview(name: 'Toggleable Form - Edit/Read-Only')
Widget previewToggleableFormField() => const WidgetsPreview();

class WidgetsPreview extends StatefulWidget {
  const WidgetsPreview({super.key});

  @override
  State<WidgetsPreview> createState() => _WidgetsPreviewState();
}

class _WidgetsPreviewState extends State<WidgetsPreview> {
  USStates initialValue = USStates.values.first;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          VooFormBuilder(
            form: VooForm(
              id: 'VooForm',
              fields: [
                VooField.dropdown<USStates>(
                  name: 'dropdown',
                  initialValue: initialValue,
                  options: USStates.values,
                  onChanged: (value) => setState(() {
                    initialValue = value ?? initialValue;
                  }),
                  converter: (value) => VooFieldOption(value: value, label: value.displayName),
                ),
                VooField.dropdownAsync<USStates>(
                  name: 'dropdown',
                  initialValue: initialValue,
                  asyncOptionsLoader: (v) async {
                    await Future<void>.delayed(const Duration(seconds: 3));
                    return USStates.values;
                  },
                  onChanged: (value) => setState(() {
                    initialValue = value ?? initialValue;
                  }),
                  converter: (value) => VooFieldOption(value: value, label: value.displayName),
                ),
              ],
            ),
          ),
        ],
      );
}
