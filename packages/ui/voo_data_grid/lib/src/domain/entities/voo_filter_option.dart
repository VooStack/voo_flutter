import 'package:flutter/material.dart';

/// Filter option for select/multiselect columns
class VooFilterOption {
  final dynamic value;
  final String label;
  final IconData? icon;
  final Widget? child;

  const VooFilterOption({
    required this.value,
    required this.label,
    this.icon,
    this.child,
  });
}