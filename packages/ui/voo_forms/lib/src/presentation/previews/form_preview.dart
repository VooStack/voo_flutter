import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_forms/voo_forms.dart';
import 'package:voo_ui_core/voo_ui_core.dart' hide VooTextField;

@Preview(name: 'Form Preview')
Widget formPreview() => const FormPreview();

class FormPreview extends StatefulWidget {
  const FormPreview({super.key});

  @override
  State<FormPreview> createState() => _FormPreviewState();
}

class _FormPreviewState extends State<FormPreview> {
  bool readOnly = false;
  VooFormController controller = VooFormController(errorDisplayMode: VooFormErrorDisplayMode.onSubmit);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: VooFormPageBuilder(
      controller: controller, // Pass the controller to VooFormPageBuilder
      actionsBuilder: (context, controller) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          VooButton(
            child: readOnly ? const Text('Edit') : const Text('Read Only'),
            onPressed: () {
              setState(() {
                readOnly = !readOnly;
              });
            },
          ),
          const SizedBox(width: 8),
          VooButton(
            child: const Text('Validate'),
            onPressed: () {
              // Force validation to show errors
              final isValid = controller.validateAll(force: true);
              log('Form is ${isValid ? 'valid' : 'invalid'}');
            },
          ),
          const SizedBox(width: 8),
          VooButton(
            child: const Text('Submit'),
            onPressed: () async {
              // Submit will also validate and show errors
              final success = await controller.submit(
                onSubmit: (values) async {
                  log('Submitting form with values: $values');
                },
                onSuccess: () {
                  log('Form submitted successfully');
                },
                onError: (error) {
                  log('Form submission error: $error');
                },
              );
              log('Submit ${success ? 'succeeded' : 'failed'}');
            },
          ),
          const SizedBox(width: 8),
          VooButton(
            child: const Text('Clear Errors'),
            onPressed: () {
              controller.clearErrors();
            },
          ),
        ],
      ),
      form: VooForm(
        controller: controller,
        isReadOnly: readOnly,
        fields: [
          VooDropdownField(name: 'name', label: 'Name', options: const ['Option 1', 'Option 2'], validators: [VooValidator.required()]),
          VooTextField(
            name: 'text',
            label: 'Text Field',
            // No initial value to demonstrate required validation
            validators: [VooValidator.required()],
          ),
          VooCheckboxField(
            name: 'checkbox',
            // No initial value to demonstrate required validation
            label: 'Checkbox Label',
            validators: [VooValidator.required()],
          ),
          VooDateField(
            name: 'date',
            label: 'Date Field',
            // No initial value to demonstrate required validation
            validators: [VooValidator.required()],
          ),
          const VooFileField(
            name: 'file',
            label: 'Upload File',
            initialValue: VooFile(url: 'https://www.cte.iup.edu/cte/Resources/PDF_TestPage.pdf'),
          ),
          VooMultiSelectField(
            name: 'multi_select',
            label: 'Multi Select',
            options: const ['Option 1', 'Option 2', 'Option 3'],
            validators: [VooValidator.required()],
            optionBuilder: (context, item, isSelected, displayText) =>
                VooOption(title: displayText, isSelected: isSelected, showCheckbox: true, showCheckmark: false, subtitle: 'Subtitle for $displayText'),
          ),
        ],
      ),
    ),
  );
}
