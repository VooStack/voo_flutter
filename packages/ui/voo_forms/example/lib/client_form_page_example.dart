import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';

/// Example showing how to use VooFormFieldAction with a custom form page
/// that wraps VooFormPageBuilder with providers and state management
class ClientFormPageExample extends StatefulWidget {
  const ClientFormPageExample({super.key});

  @override
  State<ClientFormPageExample> createState() => _ClientFormPageExampleState();
}

class _ClientFormPageExampleState extends State<ClientFormPageExample> {
  final List<Client> _clients = [
    Client(id: '1', name: 'Acme Corp'),
    Client(id: '2', name: 'Global Tech'),
  ];
  
  Client? _selectedClient;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Form Page Example'),
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
                // Using a custom form page that wraps VooFormPageBuilder
                VooFormFieldAction(
                  icon: const Icon(Icons.add),
                  tooltip: 'Add new client',
                  title: 'New Client',
                  formBuilder: (context) => ClientFormPage(
                    onClientAdded: (client) {
                      setState(() {
                        _clients.add(client);
                        _selectedClient = client;
                      });
                    },
                  ),
                ),
              ],
            ),
            VooTextField(
              name: 'projectName',
              label: 'Project Name',
              placeholder: 'Enter project name',
            ),
          ],
        ),
        onSubmit: (values) {
          debugPrint('Form submitted with client: ${_selectedClient?.name}');
        },
      ),
    );
  }
}

/// Custom form page that wraps VooFormPageBuilder
/// This demonstrates how you can use providers, cubits, or other state management
class ClientFormPage extends StatefulWidget {
  final void Function(Client) onClientAdded;
  
  const ClientFormPage({
    super.key,
    required this.onClientAdded,
  });

  @override
  State<ClientFormPage> createState() => _ClientFormPageState();
}

class _ClientFormPageState extends State<ClientFormPage> {
  // In a real app, this could be a Cubit or ChangeNotifier
  final Map<String, dynamic> _formData = {};
  
  @override
  Widget build(BuildContext context) {
    // In a real app, you might wrap this with BlocProvider:
    // return BlocProvider(
    //   create: (context) => ClientFormCubit(
    //     clientRepository: context.read<ClientRepository>(),
    //   ),
    //   child: BlocBuilder<ClientFormCubit, ClientFormState>(
    //     builder: (context, state) => _buildForm(context),
    //   ),
    // );
    
    return _buildForm();
  }
  
  Widget _buildForm() {
    return VooFormPageBuilder(
      form: VooForm(
        fields: [
          VooTextField(
            name: 'name',
            label: 'Name',
            required: true,
            onChanged: (value) => _formData['name'] = value,
          ),
          VooTextField(
            name: 'companyName',
            label: 'Company Name',
            onChanged: (value) => _formData['companyName'] = value,
          ),
          VooTextField(
            name: 'address',
            label: 'Address',
            onChanged: (value) => _formData['address'] = value,
          ),
          VooTextField(
            name: 'city',
            label: 'City',
            onChanged: (value) => _formData['city'] = value,
          ),
          VooTextField(
            name: 'state',
            label: 'State',
            onChanged: (value) => _formData['state'] = value,
          ),
          VooIntegerField(
            name: 'zip',
            label: 'Zip',
            onChanged: (value) => _formData['zip'] = value,
          ),
          VooPhoneField(
            name: 'phone',
            label: 'Phone',
            onChanged: (value) => _formData['phone'] = value,
          ),
          VooEmailField(
            name: 'email',
            label: 'Email',
            onChanged: (value) => _formData['email'] = value,
          ),
        ],
      ),
      showSubmitButton: true,
      showCancelButton: true,
      submitText: 'Add Client',
      onSubmit: (values) {
        // In a real app with Cubit:
        // context.read<ClientFormCubit>().submitForm();
        
        if (values['name'] != null) {
          final newClient = Client(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: values['name'] as String,
            companyName: values['companyName'] as String?,
            address: values['address'] as String?,
            city: values['city'] as String?,
            state: values['state'] as String?,
            zip: values['zip'] as int?,
            phone: values['phone'] as String?,
            email: values['email'] as String?,
          );
          
          widget.onClientAdded(newClient);
          Navigator.of(context).pop();
        }
      },
      onCancel: () => Navigator.of(context).pop(),
    );
  }
}

// Example with actual BLoC pattern (commented out to avoid dependencies)
/*
class ClientFormPageWithBloc extends StatelessWidget {
  const ClientFormPageWithBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClientFormCubit(
        clientRepository: context.read<ClientRepository>(),
      ),
      child: BlocBuilder<ClientFormCubit, ClientFormState>(
        builder: (context, state) {
          return VooFormPageBuilder(
            form: VooForm(
              fields: [
                VooTextField(
                  name: 'name',
                  label: 'Name',
                  initialValue: state.name,
                  onChanged: (value) => 
                    context.read<ClientFormCubit>().onNameChanged(value),
                ),
                VooTextField(
                  name: 'companyName',
                  label: 'Company Name',
                  initialValue: state.companyName,
                  onChanged: (value) => 
                    context.read<ClientFormCubit>().onCompanyNameChanged(value),
                ),
                // ... other fields
              ],
            ),
            showSubmitButton: true,
            submitEnabled: state.isValid,
            isLoading: state.isSubmitting,
            onSubmit: (_) => context.read<ClientFormCubit>().submitForm(),
            onSuccess: () => Navigator.of(context).pop(),
            onError: (error) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $error')),
            ),
          );
        },
      ),
    );
  }
}
*/

// Sample client model
class Client {
  final String id;
  final String name;
  final String? companyName;
  final String? address;
  final String? city;
  final String? state;
  final int? zip;
  final String? phone;
  final String? email;
  
  const Client({
    required this.id,
    required this.name,
    this.companyName,
    this.address,
    this.city,
    this.state,
    this.zip,
    this.phone,
    this.email,
  });
}