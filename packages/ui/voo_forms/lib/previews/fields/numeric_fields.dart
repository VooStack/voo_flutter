import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_forms/voo_forms.dart';

// ============================================================================
// Previews for numeric fields using the new widget pattern
// ============================================================================

@Preview(name: 'Numeric Fields - Basic')
Widget previewBasicNumericFields() => const BasicNumericFieldsPreview();

class BasicNumericFieldsPreview extends StatelessWidget {
  const BasicNumericFieldsPreview({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const VooNumberField(
              name: 'quantity',
              label: 'Quantity',
              placeholder: 'Enter quantity',
              helper: 'Can include decimals',
            ),
            const SizedBox(height: 16),
            VooIntegerField(
              name: 'age',
              label: 'Age',
              placeholder: 'Enter your age',
              min: 0,
              max: 150,
              required: true,
            ),
            const SizedBox(height: 16),
            VooDecimalField(
              name: 'weight',
              label: 'Weight (kg)',
              placeholder: '0.00',
              min: 0,
              max: 500,
            ),
            const SizedBox(height: 16),
            VooCurrencyField(
              name: 'price',
              label: 'Product Price',
              placeholder: '\$0.00',
              max: 999999,
            ),
            const SizedBox(height: 16),
            VooPercentageField(
              name: 'discount',
              label: 'Discount Percentage',
              placeholder: '0%',
            ),
          ],
        ),
      );
}

@Preview(name: 'Numeric Fields with Steppers')
Widget previewNumericSteppers() => const NumericSteppersPreview();

class NumericSteppersPreview extends StatefulWidget {
  const NumericSteppersPreview({super.key});

  @override
  State<NumericSteppersPreview> createState() => _NumericSteppersPreviewState();
}

class _NumericSteppersPreviewState extends State<NumericSteppersPreview> {
  int quantity = 1;
  double price = 29.99;
  double percentage = 15.0;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            VooIntegerField(
              name: 'quantity',
              label: 'Quantity',
              value: quantity,
              min: 1,
              max: 100,
              onChanged: (int? value) => setState(() => quantity = value ?? 1),
              actions: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: quantity > 1 
                    ? () => setState(() => quantity--) 
                    : null,
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: quantity < 100 
                    ? () => setState(() => quantity++) 
                    : null,
                ),
              ],
            ),
            const SizedBox(height: 16),
            VooCurrencyField(
              name: 'price',
              label: 'Unit Price',
              value: price,
              onChanged: (double? value) => setState(() => price = value ?? 0),
              actions: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: price > 0 
                    ? () => setState(() => price -= 0.50) 
                    : null,
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => setState(() => price += 0.50),
                ),
              ],
            ),
            const SizedBox(height: 16),
            VooPercentageField(
              name: 'tax',
              label: 'Tax Rate',
              value: percentage,
              onChanged: (double? value) => setState(() => percentage = value ?? 0.0),
              actions: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: percentage > 0 
                    ? () => setState(() => percentage -= 5.0) 
                    : null,
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: percentage < 100 
                    ? () => setState(() => percentage += 5.0) 
                    : null,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Subtotal: \$${(quantity * price).toStringAsFixed(2)}'),
                    Text('Tax: \$${(quantity * price * percentage / 100).toStringAsFixed(2)}'),
                    const Divider(),
                    Text(
                      'Total: \$${(quantity * price * (1 + percentage / 100)).toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

@Preview(name: 'Numeric Fields with Validation')
Widget previewNumericValidation() => const NumericValidationPreview();

class NumericValidationPreview extends StatefulWidget {
  const NumericValidationPreview({super.key});

  @override
  State<NumericValidationPreview> createState() => _NumericValidationPreviewState();
}

class _NumericValidationPreviewState extends State<NumericValidationPreview> {
  String? ageError;
  String? salaryError;

  void _validateAge(int? value) {
    setState(() {
      if (value == null) {
        ageError = 'Age is required';
      } else if (value < 18) {
        ageError = 'Must be at least 18 years old';
      } else if (value > 65) {
        ageError = 'Must be 65 or younger';
      } else {
        ageError = null;
      }
    });
  }

  void _validateSalary(double? value) {
    setState(() {
      if (value == null) {
        salaryError = 'Salary is required';
      } else if (value < 15000) {
        salaryError = 'Minimum salary is \$15,000';
      } else if (value > 1000000) {
        salaryError = 'Maximum salary is \$1,000,000';
      } else {
        salaryError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            VooIntegerField(
              name: 'age',
              label: 'Age (18-65)',
              error: ageError,
              onChanged: _validateAge,
              min: 0,
              max: 120,
            ),
            const SizedBox(height: 16),
            VooCurrencyField(
              name: 'salary',
              label: 'Annual Salary',
              error: salaryError,
              onChanged: _validateSalary,
            ),
          ],
        ),
      );
}

@Preview(name: 'Numeric Fields in Form')
Widget previewNumericForm() => const NumericFormPreview();

class NumericFormPreview extends StatelessWidget {
  const NumericFormPreview({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: VooForm(
          fields: [
            const VooTextField(
              name: 'product',
              label: 'Product Name',
              required: true,
            ),
            VooIntegerField(
              name: 'quantity',
              label: 'Quantity',
              min: 1,
              max: 1000,
              required: true,
            ),
            VooCurrencyField(
              name: 'unitPrice',
              label: 'Unit Price',
              required: true,
            ),
            VooPercentageField(
              name: 'discount',
              label: 'Discount',
            ),
            VooPercentageField(
              name: 'tax',
              label: 'Tax Rate',
              required: true,
            ),
          ],
          onSubmit: (values) {
            final quantity = values['quantity'] as int? ?? 1;
            final unitPrice = values['unitPrice'] as double? ?? 0;
            final discount = (values['discount'] as double? ?? 0).toInt();
            final tax = (values['tax'] as double? ?? 0).toInt();
            
            final subtotal = quantity * unitPrice;
            final discountAmount = subtotal * discount / 100;
            final taxableAmount = subtotal - discountAmount;
            final taxAmount = taxableAmount * tax / 100;
            final total = taxableAmount + taxAmount;
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Total: \$${total.toStringAsFixed(2)}'),
              ),
            );
          },
        ),
      );
}