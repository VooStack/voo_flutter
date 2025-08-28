import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';
import 'package:voo_ui_core/voo_ui_core.dart' as core;

/// Example showing how to use forms with different design systems
class DesignSystemExample extends StatefulWidget {
  const DesignSystemExample({super.key});

  @override
  State<DesignSystemExample> createState() => _DesignSystemExampleState();
}

class _DesignSystemExampleState extends State<DesignSystemExample> {
  late VooFormController _controller;
  core.DesignSystemType _currentSystem = core.DesignSystemType.voo;
  bool _isDarkMode = false;
  
  @override
  void initState() {
    super.initState();
    _controller = VooFormController(form: _buildForm());
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  VooForm _buildForm() {
    return VooForm(
      id: 'design_system_demo',
      title: 'Design System Demo',
      description: 'Experience forms with different design systems',
      layout: FormLayout.vertical,
      validationMode: FormValidationMode.onChange,
      fields: [
        VooFieldUtils.textField(
          id: 'name',
          name: 'name',
          label: 'Full Name',
          required: true,
          prefixIcon: Icons.person,
          validators: [
            VooValidator.required(),
            VooValidator.minLength(2),
          ],
        ),
        VooFieldUtils.emailField(
          id: 'email',
          name: 'email',
          required: true,
        ),
        VooFieldUtils.dropdownField(
          id: 'role',
          name: 'role',
          label: 'Role',
          initialValue: 'developer',
          options: const [
            VooFieldOption(value: 'developer', label: 'Developer'),
            VooFieldOption(value: 'designer', label: 'Designer'),
            VooFieldOption(value: 'manager', label: 'Manager'),
            VooFieldOption(value: 'other', label: 'Other'),
          ],
        ),
        VooFieldUtils.switchField(
          id: 'notifications',
          name: 'notifications',
          label: 'Enable Notifications',
          helper: 'Receive updates about new features',
          prefixIcon: Icons.notifications,
          initialValue: true,
        ),
        VooFieldUtils.sliderField(
          id: 'experience',
          name: 'experience',
          label: 'Years of Experience',
          min: 0,
          max: 20,
          initialValue: 5.0,
        ),
        VooFieldUtils.multiSelectField(
          id: 'skills',
          name: 'skills',
          label: 'Your Skills',
          helper: 'Select all that apply',
          options: const [
            VooFieldOption(value: 'flutter', label: 'Flutter'),
            VooFieldOption(value: 'react', label: 'React'),
            VooFieldOption(value: 'vue', label: 'Vue'),
            VooFieldOption(value: 'angular', label: 'Angular'),
            VooFieldOption(value: 'swift', label: 'Swift'),
            VooFieldOption(value: 'kotlin', label: 'Kotlin'),
          ],
        ),
        VooFieldUtils.textAreaField(
          id: 'bio',
          name: 'bio',
          label: 'Bio',
          hint: 'Tell us about yourself...',
          maxLength: 500,
          minLines: 3,
          maxLines: 5,
        ),
        VooFieldUtils.checkboxField(
          id: 'terms',
          name: 'terms',
          label: 'I agree to the terms and conditions',
        ),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // Create design system based on current selection
    final designSystem = _currentSystem == core.DesignSystemType.voo
      ? core.VooDesignTokens(isDarkMode: _isDarkMode)
      : core.MaterialDesignTokens(isDarkMode: _isDarkMode);
    
    return Theme(
      data: designSystem.toThemeData(isDark: _isDarkMode),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Design System Example'),
          actions: [
            // Design System Selector
            PopupMenuButton<core.DesignSystemType>(
              icon: const Icon(Icons.palette),
              tooltip: 'Choose Design System',
              onSelected: (type) {
                setState(() {
                  _currentSystem = type;
                });
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: core.DesignSystemType.voo,
                  child: Row(
                    children: [
                      Icon(
                        Icons.stars,
                        color: _currentSystem == core.DesignSystemType.voo
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      const SizedBox(width: 8),
                      const Text('Voo Design'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: core.DesignSystemType.material,
                  child: Row(
                    children: [
                      Icon(
                        Icons.android,
                        color: _currentSystem == core.DesignSystemType.material
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      const SizedBox(width: 8),
                      const Text('Material Design'),
                    ],
                  ),
                ),
              ],
            ),
            // Dark Mode Toggle
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              tooltip: _isDarkMode ? 'Light Mode' : 'Dark Mode',
              onPressed: () {
                setState(() {
                  _isDarkMode = !_isDarkMode;
                });
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Current Design System Info Card
              Card(
                child: ListTile(
                  leading: Icon(
                    _currentSystem == core.DesignSystemType.voo
                        ? Icons.stars
                        : Icons.android,
                    size: 40,
                  ),
                  title: Text(
                    _currentSystem == core.DesignSystemType.voo
                        ? 'Voo Design System'
                        : 'Material Design System',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    _currentSystem == core.DesignSystemType.voo
                        ? 'Modern design inspired by Discord and GitHub'
                        : 'Google\'s Material Design 3',
                  ),
                  trailing: Chip(
                    label: Text(_isDarkMode ? 'Dark' : 'Light'),
                    avatar: Icon(
                      _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      size: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Form with current design system
              _buildThemedForm(context),
              
              const SizedBox(height: 24),
              
              // Sample Components Section
              _buildComponentShowcase(context),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildThemedForm(BuildContext context) {
    return Card(
      elevation: _currentSystem == core.DesignSystemType.voo ? 2 : 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: VooFormBuilder(
          controller: _controller,
          form: _controller.form,
          showProgress: true,
          showValidation: true,
          onSubmit: (values) async {
            await Future.delayed(const Duration(seconds: 1));
            if (!context.mounted) return;
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Form submitted with ${_currentSystem == core.DesignSystemType.voo ? "Voo" : "Material"} Design!',
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildComponentShowcase(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Component Showcase',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            // Buttons
            Text('Buttons', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Primary'),
                ),
                FilledButton(
                  onPressed: () {},
                  child: const Text('Filled'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Outlined'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Text'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Chips
            Text('Chips', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                const Chip(label: Text('Default')),
                Chip(
                  label: const Text('With Icon'),
                  avatar: const Icon(Icons.star, size: 16),
                ),
                ActionChip(
                  label: const Text('Action'),
                  onPressed: () {},
                ),
                FilterChip(
                  label: const Text('Filter'),
                  selected: true,
                  onSelected: (_) {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Cards with different elevations
            Text('Cards', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text('Flat', style: theme.textTheme.bodySmall),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text('Elevated', style: theme.textTheme.bodySmall),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text('Raised', style: theme.textTheme.bodySmall),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Dividers
            Text('Dividers', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            const Divider(),
            VooFormSectionDivider.inset(),
            VooFormSectionTextDivider.or(),
          ],
        ),
      ),
    );
  }
}

/// Comparison view showing both design systems side by side
class DesignSystemComparison extends StatelessWidget {
  const DesignSystemComparison({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design System Comparison'),
      ),
      body: Row(
        children: [
          // Voo Design Side
          Expanded(
            child: _buildDesignSystemPanel(
              context,
              core.DesignSystemType.voo,
              'Voo Design',
              'Discord/GitHub inspired',
            ),
          ),
          const VerticalDivider(width: 1),
          // Material Design Side
          Expanded(
            child: _buildDesignSystemPanel(
              context,
              core.DesignSystemType.material,
              'Material Design',
              'Google\'s Material 3',
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDesignSystemPanel(
    BuildContext context,
    core.DesignSystemType type,
    String title,
    String subtitle,
  ) {
    final designSystem = type == core.DesignSystemType.voo
        ? core.VooDesignTokens(isDarkMode: Theme.of(context).brightness == Brightness.dark)
        : core.MaterialDesignTokens(isDarkMode: Theme.of(context).brightness == Brightness.dark);
    
    return Theme(
      data: designSystem.toThemeData(
        isDark: Theme.of(context).brightness == Brightness.dark,
      ),
      child: Container(
        color: designSystem.colors.surface,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Card(
                child: ListTile(
                  title: Text(title),
                  subtitle: Text(subtitle),
                  leading: Icon(
                    type == core.DesignSystemType.voo
                        ? Icons.stars
                        : Icons.android,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Sample Form Fields
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              
              // Buttons
              ElevatedButton(
                onPressed: () {},
                child: const Text('Primary Button'),
              ),
              const SizedBox(height: 8),
              
              OutlinedButton(
                onPressed: () {},
                child: const Text('Secondary Button'),
              ),
              const SizedBox(height: 16),
              
              // Switch
              SwitchListTile(
                title: const Text('Enable Feature'),
                subtitle: const Text('This uses the design system'),
                value: true,
                onChanged: (_) {},
              ),
              
              // Chips
              Wrap(
                spacing: 8,
                children: [
                  const Chip(label: Text('Tag 1')),
                  const Chip(label: Text('Tag 2')),
                  FilterChip(
                    label: const Text('Filter'),
                    selected: true,
                    onSelected: (_) {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}