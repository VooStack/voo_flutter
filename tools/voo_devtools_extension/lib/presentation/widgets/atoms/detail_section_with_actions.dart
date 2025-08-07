import 'package:flutter/material.dart';

class DetailSectionWithActions extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;

  const DetailSectionWithActions({
    super.key,
    required this.title,
    required this.content,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            if (actions.isNotEmpty) Row(children: actions),
          ],
        ),
        const SizedBox(height: 8),
        content,
      ],
    );
  }
}