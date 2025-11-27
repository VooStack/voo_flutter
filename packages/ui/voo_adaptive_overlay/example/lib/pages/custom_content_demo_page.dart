import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay/voo_adaptive_overlay.dart';

class CustomContentDemoPage extends StatelessWidget {
  const CustomContentDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Content'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDemoCard(
            context,
            title: 'Form Content',
            description: 'Overlay with form inputs and validation.',
            icon: Icons.edit_document,
            onPressed: () => _showFormOverlay(context),
          ),
          _buildDemoCard(
            context,
            title: 'Scrollable List',
            description: 'Overlay with a long scrollable list of items.',
            icon: Icons.list,
            onPressed: () => _showListOverlay(context),
          ),
          _buildDemoCard(
            context,
            title: 'Builder Pattern',
            description: 'Using the builder for scroll controller access.',
            icon: Icons.build,
            onPressed: () => _showBuilderOverlay(context),
          ),
          _buildDemoCard(
            context,
            title: 'Custom Actions',
            description: 'Multiple action buttons with different styles.',
            icon: Icons.smart_button,
            onPressed: () => _showCustomActionsOverlay(context),
          ),
          _buildDemoCard(
            context,
            title: 'Non-Dismissible',
            description: 'Overlay that cannot be dismissed by tapping outside.',
            icon: Icons.lock_outline,
            onPressed: () => _showNonDismissibleOverlay(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: theme.colorScheme.onSecondaryContainer),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showFormOverlay(BuildContext context) async {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    await VooAdaptiveOverlay.show(
      context: context,
      title: const Text('Create Account'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email Address',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          const TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock_outline),
            ),
          ),
        ],
      ),
      actions: [
        VooOverlayAction.cancel(),
        VooOverlayAction(
          label: 'Create Account',
          isPrimary: true,
          icon: Icons.person_add,
          autoPop: false,
          onPressed: () {
            // Validate and submit
            Navigator.of(context).pop('created');
          },
        ),
      ],
    );

    nameController.dispose();
    emailController.dispose();
  }

  Future<void> _showListOverlay(BuildContext context) async {
    final selected = await VooAdaptiveOverlay.show<int>(
      context: context,
      title: const Text('Select a Country'),
      builder: (context, scrollController) {
        return ListView.builder(
          controller: scrollController,
          shrinkWrap: true,
          itemCount: _countries.length,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemBuilder: (context, index) {
            final country = _countries[index];
            return ListTile(
              leading: Text(country.flag, style: const TextStyle(fontSize: 24)),
              title: Text(country.name),
              subtitle: Text(country.code),
              onTap: () => Navigator.of(context).pop(index),
            );
          },
        );
      },
      config: const VooOverlayConfig(
        behavior: VooOverlayBehavior(showCloseButton: true),
      ),
    );

    if (context.mounted && selected != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selected: ${_countries[selected].name}')),
      );
    }
  }

  Future<void> _showBuilderOverlay(BuildContext context) async {
    await VooAdaptiveOverlay.show(
      context: context,
      title: const Text('Builder Pattern'),
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: List.generate(
              20,
              (index) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text('Item ${index + 1}'),
                  subtitle: const Text('Using scroll controller'),
                ),
              ),
            ),
          ),
        );
      },
      actions: [VooOverlayAction.close()],
    );
  }

  Future<void> _showCustomActionsOverlay(BuildContext context) async {
    await VooAdaptiveOverlay.show(
      context: context,
      title: const Text('Document Options'),
      content: const Text('What would you like to do with this document?'),
      actions: [
        VooOverlayAction.cancel(),
        VooOverlayAction.destructive(
          label: 'Delete',
          icon: Icons.delete_outline,
          onPressed: () {
            // Handle delete
          },
        ),
        VooOverlayAction.save(
          label: 'Save',
          onPressed: () {
            // Handle save
          },
        ),
      ],
    );
  }

  Future<void> _showNonDismissibleOverlay(BuildContext context) async {
    await VooAdaptiveOverlay.show(
      context: context,
      title: const Text('Important'),
      content: const Text(
        'This overlay cannot be dismissed by tapping outside or pressing the '
        'back button. You must use the action buttons.',
      ),
      actions: [
        VooOverlayAction.ok(),
      ],
      config: const VooOverlayConfig(
        behavior: VooOverlayBehavior.nonDismissible,
      ),
    );
  }

  static final _countries = [
    (name: 'United States', code: 'US', flag: '🇺🇸'),
    (name: 'United Kingdom', code: 'GB', flag: '🇬🇧'),
    (name: 'Canada', code: 'CA', flag: '🇨🇦'),
    (name: 'Australia', code: 'AU', flag: '🇦🇺'),
    (name: 'Germany', code: 'DE', flag: '🇩🇪'),
    (name: 'France', code: 'FR', flag: '🇫🇷'),
    (name: 'Japan', code: 'JP', flag: '🇯🇵'),
    (name: 'South Korea', code: 'KR', flag: '🇰🇷'),
    (name: 'Brazil', code: 'BR', flag: '🇧🇷'),
    (name: 'Mexico', code: 'MX', flag: '🇲🇽'),
    (name: 'India', code: 'IN', flag: '🇮🇳'),
    (name: 'China', code: 'CN', flag: '🇨🇳'),
    (name: 'Italy', code: 'IT', flag: '🇮🇹'),
    (name: 'Spain', code: 'ES', flag: '🇪🇸'),
    (name: 'Netherlands', code: 'NL', flag: '🇳🇱'),
  ];
}
