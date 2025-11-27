import 'package:flutter/material.dart';
import 'package:voo_tokens/voo_tokens.dart';

import 'examples/address_form_example.dart';
import 'examples/basic_form_example.dart';
import 'examples/field_types_example.dart';
import 'examples/file_upload_example.dart';
import 'examples/form_actions_example.dart';
import 'examples/layout_example.dart';
import 'examples/read_only_example.dart';
import 'examples/registration_example.dart';
import 'examples/validation_example.dart';

void main() {
  runApp(const VooFormsExampleApp());
}

class VooFormsExampleApp extends StatelessWidget {
  const VooFormsExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VooForms Examples',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.vooSpacing;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('VooForms'),
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () => _showAboutDialog(context),
              ),
            ],
          ),
          SliverPadding(
            padding: EdgeInsets.all(spacing.md),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _SectionHeader(title: 'Getting Started'),
                SizedBox(height: spacing.sm),
                _ExampleCard(
                  title: 'Basic Form',
                  description: 'Simple form with text fields, validation, and submission',
                  icon: Icons.article_outlined,
                  color: Colors.blue,
                  onTap: () => _navigateTo(context, const BasicFormExample()),
                ),
                SizedBox(height: spacing.sm),
                _ExampleCard(
                  title: 'Field Types',
                  description: 'All available field types: text, email, phone, dropdown, etc.',
                  icon: Icons.input,
                  color: Colors.green,
                  onTap: () => _navigateTo(context, const FieldTypesExample()),
                ),
                SizedBox(height: spacing.lg),
                _SectionHeader(title: 'Features'),
                SizedBox(height: spacing.sm),
                _ExampleCard(
                  title: 'Validation',
                  description: 'Built-in and custom validators with real-time feedback',
                  icon: Icons.check_circle_outline,
                  color: Colors.orange,
                  onTap: () => _navigateTo(context, const ValidationExample()),
                ),
                SizedBox(height: spacing.sm),
                _ExampleCard(
                  title: 'Layouts',
                  description: 'Vertical, horizontal, grid, and dynamic layouts',
                  icon: Icons.grid_view,
                  color: Colors.purple,
                  onTap: () => _navigateTo(context, const LayoutExample()),
                ),
                SizedBox(height: spacing.sm),
                _ExampleCard(
                  title: 'Read-Only Mode',
                  description: 'Display forms in view-only mode for detail pages',
                  icon: Icons.visibility,
                  color: Colors.teal,
                  onTap: () => _navigateTo(context, const ReadOnlyExample()),
                ),
                SizedBox(height: spacing.sm),
                _ExampleCard(
                  title: 'Form Actions',
                  description: 'Add buttons to fields for related actions',
                  icon: Icons.touch_app,
                  color: Colors.pink,
                  onTap: () => _navigateTo(context, const FormActionsExample()),
                ),
                SizedBox(height: spacing.lg),
                _SectionHeader(title: 'Advanced Examples'),
                SizedBox(height: spacing.sm),
                _ExampleCard(
                  title: 'File Uploads',
                  description: 'File picker with drag-drop, size limits, and type restrictions',
                  icon: Icons.upload_file,
                  color: Colors.indigo,
                  onTap: () => _navigateTo(context, const FileUploadExample()),
                ),
                SizedBox(height: spacing.sm),
                _ExampleCard(
                  title: 'Address Forms',
                  description: 'Billing and shipping address forms with state dropdown',
                  icon: Icons.location_on,
                  color: Colors.red,
                  onTap: () => _navigateTo(context, const AddressFormExample()),
                ),
                SizedBox(height: spacing.sm),
                _ExampleCard(
                  title: 'Registration',
                  description: 'Complete user registration with sections and validation',
                  icon: Icons.person_add,
                  color: Colors.cyan,
                  onTap: () => _navigateTo(context, const RegistrationExample()),
                ),
                SizedBox(height: spacing.xl),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'VooForms',
      applicationVersion: '0.2.3',
      applicationLegalese: 'A comprehensive forms package for Flutter',
      children: [
        const SizedBox(height: 16),
        const Text(
          'VooForms provides type-safe, validated form fields with '
          'Material 3 design and responsive layouts.',
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ExampleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.vooSpacing;
    final radius = context.vooRadius;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: radius.card,
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: radius.card,
        child: Padding(
          padding: EdgeInsets.all(spacing.md),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              SizedBox(width: spacing.md),
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
                    SizedBox(height: spacing.xxs),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
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
}
