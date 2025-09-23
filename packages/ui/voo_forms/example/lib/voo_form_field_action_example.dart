import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';

/// Example demonstrating VooFormFieldAction widget
/// Shows how to add related items (like clients) from within a form
class VooFormFieldActionExample extends StatefulWidget {
  const VooFormFieldActionExample({super.key});

  @override
  State<VooFormFieldActionExample> createState() =>
      _VooFormFieldActionExampleState();
}

class _VooFormFieldActionExampleState extends State<VooFormFieldActionExample> {
  final List<Client> _clients = [
    Client(id: '1', name: 'Acme Corp'),
    Client(id: '2', name: 'Global Tech'),
    Client(id: '3', name: 'Innovate Inc'),
  ];

  Client? _selectedClient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VooFormFieldAction Example'),
      ),
      body: VooFormPageBuilder(
        form: VooForm(
          fields: [
            VooDropdownField<Client>(
              name: 'client',
              label: 'Client',
              options: _clients,
              initialValue: _selectedClient,
              displayTextBuilder: (client) => client.name,
              onChanged: (client) => setState(() => _selectedClient = client),
              actions: [
                // This button adapts to screen size:
                // - XL screens: Opens form in side panel
                // - Tablet: Opens form in dialog
                // - Mobile: Opens form in bottom sheet
                VooFormFieldAction(
                  icon: const Icon(Icons.add),
                  tooltip: 'Add new client',
                  title: 'New Client',
                  formBuilder: (context) => _buildClientForm(),
                ),
              ],
            ),
            VooTextField(
              name: 'projectName',
              label: 'Project Name',
              placeholder: 'Enter project name',
            ),
            VooMultilineField(
              name: 'description',
              label: 'Description',
              placeholder: 'Enter project description',
              minLines: 3,
              maxLines: 5,
            ),
            VooDateField(
              name: 'startDate',
              label: 'Start Date',
              placeholder: 'Select start date',
            ),
            VooDateField(
              name: 'endDate',
              label: 'End Date',
              placeholder: 'Select end date',
            ),
            VooListField<String>(
              name: 'tags',
              label: 'Tags',
              items: const [],
              itemBuilder: (context, tag, index) => VooTextField(
                name: 'tag_$index',
                initialValue: tag,
                placeholder: 'Enter tag',
              ),
              onAddPressed: () {
                // Add tag logic
              },
              actions: [
                VooFormFieldAction(
                  icon: const Icon(Icons.label),
                  tooltip: 'Manage tags',
                  title: 'Tag Manager',
                  formBuilder: (context) => _buildTagManagerForm(),
                ),
              ],
            ),
          ],
        ),
        onSubmit: (values) {
          // Handle form submission
          debugPrint('Form submitted with values: $values');
        },
        showSubmitButton: true,
        showCancelButton: true,
      ),
    );
  }

  Widget _buildClientForm() {
    // Example 1: Direct VooFormPageBuilder (most common case)
    return VooFormPageBuilder(
      header: AppBar(
        title: const Text('New Client'),
        automaticallyImplyLeading: false,
      ),
      form: VooForm(
        fields: [
          VooTextField(
            name: 'name',
            label: 'Client Name',
            placeholder: 'Enter client name',
          ),
          VooEmailField(
            name: 'email',
            label: 'Email',
            placeholder: 'client@example.com',
          ),
          VooPhoneField(
            name: 'phone',
            label: 'Phone',
            placeholder: '+1 (555) 000-0000',
          ),
          VooTextField(
            name: 'company',
            label: 'Company',
            placeholder: 'Enter company name',
          ),
          VooMultilineField(
            name: 'notes',
            label: 'Notes',
            placeholder: 'Additional notes about the client',
            minLines: 2,
            maxLines: 4,
          ),
        ],
      ),
      showSubmitButton: true,
      showCancelButton: true,
      submitText: 'Add Client',
      cancelText: 'Cancel',
      onSubmit: (values) {
        if (values['name'] != null && values['email'] != null) {
          final newClient = Client(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: values['name'] as String,
            email: values['email'] as String?,
            phone: values['phone'] as String?,
          );
          setState(() {
            _clients.add(newClient);
            _selectedClient = newClient;
          });
          Navigator.of(context).pop();
        }
      },
      onCancel: () => Navigator.of(context).pop(),
    );
  }

  Widget _buildTagManagerForm() {
    // Example 2: Could wrap with providers if needed
    // For example, with BLoC:
    // return BlocProvider(
    //   create: (context) => TagCubit(),
    //   child: _buildTagFormPage(),
    // );
    return _buildTagFormPage();
  }

  Widget _buildTagFormPage() {
    final availableTags = [
      'Flutter',
      'Dart',
      'Mobile',
      'Web',
      'Desktop',
      'UI/UX',
      'Backend',
      'Frontend',
      'Database',
      'Cloud',
    ];

    return VooFormPageBuilder(
      header: AppBar(
        title: const Text('Tag Manager'),
        automaticallyImplyLeading: false,
      ),
      form: VooForm(
        fields: [
          // Since we need custom UI, we wrap it in a stateful builder
          // In a real app, you might create a VooTagSelectorField
        ],
      ),
      footer: StatefulBuilder(
        builder: (context, setState) {
          final selectedTags = <String>[];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select tags for your project:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: availableTags.map((tag) {
                    final isSelected = selectedTags.contains(tag);
                    return FilterChip(
                      label: Text(tag),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedTags.add(tag);
                          } else {
                            selectedTags.remove(tag);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
      showSubmitButton: true,
      showCancelButton: true,
      submitText: 'Apply Tags',
      cancelText: 'Cancel',
      onSubmit: (values) {
        // Handle tag application
        debugPrint('Tags applied');
        Navigator.of(context).pop();
      },
      onCancel: () => Navigator.of(context).pop(),
    );
  }
}

// Sample client model
class Client {
  final String id;
  final String name;
  final String? email;
  final String? phone;

  const Client({
    required this.id,
    required this.name,
    this.email,
    this.phone,
  });
}
