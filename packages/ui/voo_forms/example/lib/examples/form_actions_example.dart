import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Example demonstrating form field actions
class FormActionsExample extends StatefulWidget {
  const FormActionsExample({super.key});

  @override
  State<FormActionsExample> createState() => _FormActionsExampleState();
}

class _FormActionsExampleState extends State<FormActionsExample> {
  final _categories = <_Category>[
    const _Category(id: '1', name: 'Electronics'),
    const _Category(id: '2', name: 'Clothing'),
    const _Category(id: '3', name: 'Home & Garden'),
  ];
  _Category? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final spacing = context.vooSpacing;

    return Scaffold(
      appBar: AppBar(title: const Text('Form Actions')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoCard(context),
            SizedBox(height: spacing.md),
            Card(
              child: Padding(
                padding: EdgeInsets.all(spacing.md),
                child: VooForm(
                  fields: [
                    VooTextField(
                      name: 'productName',
                      label: 'Product Name',
                      placeholder: 'Enter product name',
                      validators: [RequiredValidation()],
                    ),
                    // Dropdown with action to add new category
                    VooDropdownField<_Category>(
                      name: 'category',
                      label: 'Category',
                      placeholder: 'Select a category',
                      options: _categories,
                      initialValue: _selectedCategory,
                      displayTextBuilder: (cat) => cat.name,
                      onChanged: (cat) => setState(() => _selectedCategory = cat),
                      actions: [
                        VooFormFieldAction(
                          icon: const Icon(Icons.add),
                          tooltip: 'Add new category',
                          title: 'New Category',
                          formBuilder: (context) => _AddCategoryForm(
                            onCategoryAdded: (category) {
                              setState(() {
                                _categories.add(category);
                                _selectedCategory = category;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    VooCurrencyField(
                      name: 'price',
                      label: 'Price',
                      placeholder: '\$0.00',
                      validators: [RequiredValidation()],
                    ),
                    VooIntegerField(
                      name: 'quantity',
                      label: 'Quantity',
                      placeholder: '0',
                      initialValue: 1,
                    ),
                    VooMultilineField(
                      name: 'description',
                      label: 'Description',
                      placeholder: 'Enter product description...',
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: spacing.md),
            FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Product saved!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Save Product'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.vooSpacing;

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: theme.colorScheme.primary,
          ),
          SizedBox(width: spacing.sm),
          Expanded(
            child: Text(
              'Click the + button on the Category field to add a new category. '
              'The form opens as a dialog on medium screens and as a side panel on large screens.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddCategoryForm extends StatefulWidget {
  final void Function(_Category) onCategoryAdded;

  const _AddCategoryForm({required this.onCategoryAdded});

  @override
  State<_AddCategoryForm> createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<_AddCategoryForm> {
  final _controller = VooFormController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.vooSpacing;

    return Padding(
      padding: EdgeInsets.all(spacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VooForm(
            controller: _controller,
            fields: [
              VooTextField(
                name: 'name',
                label: 'Category Name',
                placeholder: 'Enter category name',
                validators: [RequiredValidation()],
              ),
              VooTextField(
                name: 'description',
                label: 'Description',
                placeholder: 'Optional description',
              ),
            ],
          ),
          SizedBox(height: spacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              SizedBox(width: spacing.sm),
              FilledButton(
                onPressed: _submit,
                child: const Text('Add Category'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (_controller.validate()) {
      final values = _controller.values;
      final newCategory = _Category(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: values['name'] as String,
      );
      widget.onCategoryAdded(newCategory);
      Navigator.of(context).pop();
    }
  }
}

class _Category {
  final String id;
  final String name;

  const _Category({required this.id, required this.name});
}
