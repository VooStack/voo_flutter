import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/config/options/voo_field_options.dart';

/// InheritedWidget for providing field options to child widgets
class VooFieldOptionsProvider extends InheritedWidget {
  final VooFieldOptions options;

  const VooFieldOptionsProvider({
    super.key,
    required this.options,
    required super.child,
  });

  static VooFieldOptions? of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<VooFieldOptionsProvider>();
    return provider?.options;
  }

  @override
  bool updateShouldNotify(VooFieldOptionsProvider oldWidget) => options != oldWidget.options;
}
