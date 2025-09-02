import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_forms/previews/utils/us_state.dart';
import 'package:voo_forms/voo_forms.dart';

// ============================================================================
// Previews for dropdowns using the new widget pattern
// ============================================================================

@Preview(name: 'Dropdown Field - Basic')
Widget previewBasicDropdown() => const BasicDropdownPreview();

class BasicDropdownPreview extends StatefulWidget {
  const BasicDropdownPreview({super.key});

  @override
  State<BasicDropdownPreview> createState() => _BasicDropdownPreviewState();
}

class _BasicDropdownPreviewState extends State<BasicDropdownPreview> {
  USStates? selectedState;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: VooDropdownField<USStates>(
          name: 'state',
          label: 'Select State',
          placeholder: 'Choose a state',
          options: USStates.values,
          value: selectedState,
          displayTextBuilder: (state) => state.displayName,
          onChanged: (USStates? value) => setState(() {
            selectedState = value;
          }),
        ),
      );
}

@Preview(name: 'Async Dropdown Field')
Widget previewAsyncDropdown() => const AsyncDropdownPreview();

class AsyncDropdownPreview extends StatefulWidget {
  const AsyncDropdownPreview({super.key});

  @override
  State<AsyncDropdownPreview> createState() => _AsyncDropdownPreviewState();
}

class _AsyncDropdownPreviewState extends State<AsyncDropdownPreview> {
  USStates? selectedState;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: VooAsyncDropdownField<USStates>(
          name: 'async_state',
          label: 'Select State (Async)',
          placeholder: 'Loading states...',
          value: selectedState,
          displayTextBuilder: (state) => state.displayName,
          asyncOptionsLoader: (query) async {
            // Simulate API call
            await Future<void>.delayed(const Duration(seconds: 2));
            // Filter states based on query
            if (query.isEmpty) {
              return USStates.values;
            }
            return USStates.values.where((state) => 
              state.displayName.toLowerCase().contains(query.toLowerCase()),
            ).toList();
          },
          onChanged: (USStates? value) => setState(() {
            selectedState = value;
          }),
        ),
      );
}

@Preview(name: 'Dropdown in Form')
Widget previewDropdownInForm() => const DropdownFormPreview();

class DropdownFormPreview extends StatefulWidget {
  const DropdownFormPreview({super.key});

  @override
  State<DropdownFormPreview> createState() => _DropdownFormPreviewState();
}

class _DropdownFormPreviewState extends State<DropdownFormPreview> {
  USStates? selectedState;
  String? selectedCity;
  bool isEditable = true;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Toggle edit mode
            SwitchListTile(
              title: const Text('Editable'),
              value: isEditable,
              onChanged: (value) => setState(() {
                isEditable = value;
              }),
            ),
            const SizedBox(height: 16),
            // Form with dropdowns
            VooForm(
              fields: [
                VooTextField(
                  name: 'name',
                  label: 'Full Name',
                  placeholder: 'Enter your name',
                  required: true,
                  enabled: isEditable,
                ),
                VooDropdownField<USStates>(
                  name: 'state',
                  label: 'State',
                  placeholder: 'Select a state',
                  options: USStates.values,
                  value: selectedState,
                  displayTextBuilder: (state) => state.displayName,
                  required: true,
                  enabled: isEditable,
                  onChanged: (USStates? value) => setState(() {
                    selectedState = value;
                    selectedCity = null; // Reset city when state changes
                  }),
                ),
                VooDropdownField<String>(
                  name: 'city',
                  label: 'City',
                  placeholder: selectedState == null ? 'Select a state first' : 'Select a city',
                  options: selectedState == null ? [] : _getCitiesForState(selectedState!),
                  value: selectedCity,
                  enabled: isEditable && selectedState != null,
                  onChanged: (String? value) => setState(() {
                    selectedCity = value;
                  }),
                ),
              ],
              onSubmit: (values) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Form submitted: $values'),
                  ),
                );
              },
              isEditable: isEditable,
              showSubmitButton: isEditable,
            ),
          ],
        ),
      );
  
  List<String> _getCitiesForState(USStates state) {
    // Sample cities for demonstration
    switch (state) {
      case USStates.california:
        return ['Los Angeles', 'San Francisco', 'San Diego', 'Sacramento'];
      case USStates.texas:
        return ['Houston', 'Austin', 'Dallas', 'San Antonio'];
      case USStates.new_york:
        return ['New York City', 'Buffalo', 'Rochester', 'Albany'];
      default:
        return ['City 1', 'City 2', 'City 3'];
    }
  }
}
