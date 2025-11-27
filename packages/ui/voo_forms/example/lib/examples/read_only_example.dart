import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Example demonstrating read-only form mode
class ReadOnlyExample extends StatefulWidget {
  const ReadOnlyExample({super.key});

  @override
  State<ReadOnlyExample> createState() => _ReadOnlyExampleState();
}

class _ReadOnlyExampleState extends State<ReadOnlyExample> {
  bool _isReadOnly = true;

  // Sample data that would typically come from an API
  final _userData = const _UserData(
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@example.com',
    phone: '5551234567',
    company: 'Acme Corp',
    role: 'Software Engineer',
    bio: 'Passionate developer with 10 years of experience in building scalable applications.',
    isActive: true,
  );

  @override
  Widget build(BuildContext context) {
    final spacing = context.vooSpacing;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          TextButton.icon(
            onPressed: () => setState(() => _isReadOnly = !_isReadOnly),
            icon: Icon(_isReadOnly ? Icons.edit : Icons.visibility),
            label: Text(_isReadOnly ? 'Edit' : 'View'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status indicator
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.md,
                vertical: spacing.sm,
              ),
              decoration: BoxDecoration(
                color: _isReadOnly
                    ? theme.colorScheme.surfaceContainerLow
                    : theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    _isReadOnly ? Icons.visibility : Icons.edit,
                    size: 20,
                    color: _isReadOnly
                        ? theme.colorScheme.onSurfaceVariant
                        : theme.colorScheme.primary,
                  ),
                  SizedBox(width: spacing.sm),
                  Text(
                    _isReadOnly ? 'Viewing profile' : 'Editing profile',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _isReadOnly
                          ? theme.colorScheme.onSurfaceVariant
                          : theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing.md),
            // Form
            Card(
              child: Padding(
                padding: EdgeInsets.all(spacing.md),
                child: VooForm(
                  isReadOnly: _isReadOnly,
                  fields: [
                    VooFormSectionDivider(
                      name: 'personal_info',
                      label: 'Personal Information',
                    ),
                    VooTextField(
                      name: 'firstName',
                      label: 'First Name',
                      initialValue: _userData.firstName,
                    ),
                    VooTextField(
                      name: 'lastName',
                      label: 'Last Name',
                      initialValue: _userData.lastName,
                    ),
                    VooEmailField(
                      name: 'email',
                      label: 'Email',
                      initialValue: _userData.email,
                    ),
                    VooPhoneField(
                      name: 'phone',
                      label: 'Phone',
                      initialValue: _userData.phone,
                    ),
                    VooFormSectionDivider(
                      name: 'work_info',
                      label: 'Work Information',
                    ),
                    VooTextField(
                      name: 'company',
                      label: 'Company',
                      initialValue: _userData.company,
                    ),
                    VooDropdownField<String>(
                      name: 'role',
                      label: 'Role',
                      initialValue: _userData.role,
                      options: const [
                        'Software Engineer',
                        'Product Manager',
                        'Designer',
                        'Data Analyst',
                      ],
                    ),
                    VooMultilineField(
                      name: 'bio',
                      label: 'Bio',
                      initialValue: _userData.bio,
                      maxLines: 3,
                    ),
                    VooFormSectionDivider(
                      name: 'settings',
                      label: 'Settings',
                    ),
                    VooBooleanField(
                      name: 'isActive',
                      label: 'Active Account',
                      helper: 'Inactive accounts cannot log in',
                      initialValue: _userData.isActive,
                    ),
                  ],
                ),
              ),
            ),
            if (!_isReadOnly) ...[
              SizedBox(height: spacing.md),
              FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile saved!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  setState(() => _isReadOnly = true);
                },
                child: const Text('Save Changes'),
              ),
              SizedBox(height: spacing.sm),
              OutlinedButton(
                onPressed: () => setState(() => _isReadOnly = true),
                child: const Text('Cancel'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _UserData {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String company;
  final String role;
  final String bio;
  final bool isActive;

  const _UserData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.company,
    required this.role,
    required this.bio,
    required this.isActive,
  });
}
