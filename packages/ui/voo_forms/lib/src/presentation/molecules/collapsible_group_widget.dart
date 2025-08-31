import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_config.dart';

/// Widget that renders a collapsible group
class CollapsibleGroupWidget extends StatelessWidget {
  final FieldGroup group;
  final Widget child;

  const CollapsibleGroupWidget({
    super.key,
    required this.group,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ExpansionTile(
      title: Text(
        group.title ?? 'Section',
        style: theme.textTheme.titleMedium,
      ),
      initiallyExpanded: group.initiallyExpanded,
      children: [child],
    );
  }
}