import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Example demonstrating different form layouts
class LayoutExample extends StatefulWidget {
  const LayoutExample({super.key});

  @override
  State<LayoutExample> createState() => _LayoutExampleState();
}

class _LayoutExampleState extends State<LayoutExample> {
  FormLayout _selectedLayout = FormLayout.dynamic;

  @override
  Widget build(BuildContext context) {
    final spacing = context.vooSpacing;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Layouts')),
      body: Column(
        children: [
          // Layout selector
          Container(
            padding: EdgeInsets.all(spacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              border: Border(
                bottom: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Layout',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: spacing.sm),
                Wrap(
                  spacing: spacing.sm,
                  children: FormLayout.values
                      .where((l) => l != FormLayout.stepped && l != FormLayout.tabbed)
                      .map((layout) => ChoiceChip(
                            label: Text(_getLayoutName(layout)),
                            selected: _selectedLayout == layout,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() => _selectedLayout = layout);
                              }
                            },
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          // Form content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(spacing.md),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(spacing.md),
                  child: VooForm(
                    key: ValueKey(_selectedLayout),
                    layout: _selectedLayout,
                    gridColumns: 3,
                    fields: _buildFields(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<VooFormFieldWidget> _buildFields() {
    return [
      VooTextField(
        name: 'firstName',
        label: 'First Name',
        placeholder: 'Enter first name',
        layout: VooFieldLayout.standard,
      ),
      VooTextField(
        name: 'lastName',
        label: 'Last Name',
        placeholder: 'Enter last name',
        layout: VooFieldLayout.standard,
      ),
      VooEmailField(
        name: 'email',
        label: 'Email',
        placeholder: 'example@email.com',
        layout: VooFieldLayout.standard,
      ),
      VooPhoneField(
        name: 'phone',
        label: 'Phone',
        placeholder: '(555) 123-4567',
        layout: VooFieldLayout.standard,
      ),
      VooDropdownField<String>(
        name: 'country',
        label: 'Country',
        placeholder: 'Select country',
        options: const ['USA', 'Canada', 'UK', 'Australia'],
        layout: VooFieldLayout.standard,
      ),
      VooTextField(
        name: 'city',
        label: 'City',
        placeholder: 'Enter city',
        layout: VooFieldLayout.standard,
      ),
    ];
  }

  String _getLayoutName(FormLayout layout) {
    switch (layout) {
      case FormLayout.vertical:
        return 'Vertical';
      case FormLayout.horizontal:
        return 'Horizontal';
      case FormLayout.grid:
        return 'Grid';
      case FormLayout.wrapped:
        return 'Wrapped';
      case FormLayout.dynamic:
        return 'Dynamic';
      case FormLayout.stepped:
        return 'Stepped';
      case FormLayout.tabbed:
        return 'Tabbed';
    }
  }
}
