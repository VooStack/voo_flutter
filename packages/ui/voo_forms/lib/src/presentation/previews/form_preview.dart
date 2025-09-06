import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_forms/src/presentation/widgets/organisms/forms/voo_form.dart';
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
  Widget build(BuildContext context) => VooFormPageBuilder(
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
          ],
        ),
      );
}
