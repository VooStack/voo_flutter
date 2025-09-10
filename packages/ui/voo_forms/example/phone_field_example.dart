import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VooPhoneField Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const PhoneFieldExample(),
    );
  }
}

class PhoneFieldExample extends StatefulWidget {
  const PhoneFieldExample({super.key});

  @override
  State<PhoneFieldExample> createState() => _PhoneFieldExampleState();
}

class _PhoneFieldExampleState extends State<PhoneFieldExample> {
  final _formController = VooFormController();
  String? _selectedCountry;
  String? _phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VooPhoneField Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: VooForm(
          controller: _formController,
          fields: [
            const Text(
              'Phone Field with Country Selection',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Phone field without default country (allows selection)
            VooPhoneField(
              name: 'phone1',
              label: 'Phone Number (Select Country)',
              helper: 'Tap the flag to select a different country',
              validators: const [RequiredValidation<String>()],
              onChanged: (value) {
                setState(() {
                  _phoneNumber = value;
                });
              },
              onCountryChanged: (country) {
                setState(() {
                  _selectedCountry = country.name;
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            // Phone field with fixed country (US)
            const VooPhoneField(
              name: 'phone2',
              label: 'US Phone Number (Fixed)',
              defaultCountryCode: 'US',
              allowCountrySelection: false,
              helper: 'US format only',
              validators: [RequiredValidation<String>()],
            ),
            
            const SizedBox(height: 24),
            
            // Phone field with UK default
            const VooPhoneField(
              name: 'phone3',
              label: 'UK Phone Number',
              defaultCountryCode: 'GB',
              showDialCode: true,
              helper: 'UK format with country code',
              validators: [RequiredValidation<String>()],
            ),
            
            const SizedBox(height: 24),
            
            // Display current values
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Values:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Selected Country: ${_selectedCountry ?? 'None'}'),
                    Text('Phone Number: ${_phoneNumber ?? 'None'}'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await _formController.submit(
                    onSubmit: (values) async {
                      // Show the submitted values
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Submitted: $values'),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                  );
                  
                  if (!result.success && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all required fields'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }
}