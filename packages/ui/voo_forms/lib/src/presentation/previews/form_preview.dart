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

  @override
  Widget build(BuildContext context) => Scaffold(
        body: VooFormPageBuilder(
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
            ],
          ),
          form: VooForm(
            isReadOnly: readOnly,
            fields: [
              const VooFormSection(
                title: 'Personal Information',
                description: 'Enter your basic details',
                isCollapsible: true,
                children: [
                  VooTextField(
                    name: 'first_name',
                    placeholder: 'First Name',
                    initialValue: 'John',
                  ),
                  VooTextField(
                    name: 'last_name',
                    placeholder: 'Last Name',
                    initialValue: 'Doe',
                  ),
                ],
              ),
              const VooDropdownField(
                name: 'name',
                options: ['Option 1', 'Option 2'],
                initialValue: 'Option 1',
              ),
              const VooTextField(name: 'text', initialValue: 'Initial Value'),
              const VooCheckboxField(name: 'checkbox', initialValue: true),
              VooDateField(name: 'date', initialValue: DateTime.now()),
              const VooFormSection(
                title: 'Financial Information',
                description: 'Currency fields with proper formatting',
                isCollapsible: true,
                children: [
                  VooCurrencyField(
                    name: 'salary',
                    label: 'Annual Salary (USD)',
                    initialValue: 75000.00,
                    currencySymbol: '\$',
                  ),
                  VooCurrencyField(
                    name: 'bonus',
                    label: 'Bonus (EUR)',
                    initialValue: 5000.00,
                    currencySymbol: '€',
                  ),
                  VooCurrencyField(
                    name: 'savings',
                    label: 'Savings (GBP)',
                    initialValue: 12500.50,
                    currencySymbol: '£',
                  ),
                  VooCurrencyField(
                    name: 'investment',
                    label: 'Investment (JPY)',
                    initialValue: 1000000,
                    currencySymbol: '¥',
                    decimalDigits: 0,
                  ),
                ],
              ),
              const VooFileField(
                name: 'file',
                label: 'Upload File',
                initialValue: VooFile(url: 'https://www.cte.iup.edu/cte/Resources/PDF_TestPage.pdf'),
              ),
            ],
          ),
        ),
      );
}
