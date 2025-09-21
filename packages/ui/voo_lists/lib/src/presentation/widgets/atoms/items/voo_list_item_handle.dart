import 'package:flutter/material.dart';

class VooListItemHandle extends StatelessWidget {
  final Widget? child;

  const VooListItemHandle({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child ?? const Icon(
      Icons.drag_handle,
      color: Colors.grey,
    );
  }
}