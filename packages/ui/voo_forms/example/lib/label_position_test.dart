import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';

class LabelPositionTestPage extends StatelessWidget {
  const LabelPositionTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Label Position Test'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Testing Label Positions for Date Field',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            
            // Above position
            _buildSection(
              context,
              'Label Position: Above',
              VooFieldOptions.material.copyWith(
                labelPosition: LabelPosition.above,
              ),
            ),
            
            // Left position
            _buildSection(
              context,
              'Label Position: Left',
              VooFieldOptions.material.copyWith(
                labelPosition: LabelPosition.left,
              ),
            ),
            
            // Floating position (default)
            _buildSection(
              context,
              'Label Position: Floating',
              VooFieldOptions.material.copyWith(
                labelPosition: LabelPosition.floating,
              ),
            ),
            
            // Placeholder position
            _buildSection(
              context,
              'Label Position: Placeholder',
              VooFieldOptions.material.copyWith(
                labelPosition: LabelPosition.placeholder,
              ),
            ),
            
            // Hidden position
            _buildSection(
              context,
              'Label Position: Hidden',
              VooFieldOptions.material.copyWith(
                labelPosition: LabelPosition.hidden,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSection(
    BuildContext context,
    String title,
    VooFieldOptions options,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: VooFieldWidget(
            field: VooField.date(
              name: 'test_date',
              label: 'Select Date',
              hint: 'Choose a date',
              helper: 'This is a helper text',
            ),
            options: options,
            onChanged: (value) {
              debugPrint('Date selected: $value');
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}