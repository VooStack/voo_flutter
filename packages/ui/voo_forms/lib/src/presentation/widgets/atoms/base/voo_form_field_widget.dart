import 'package:flutter/material.dart';

/// Base interface for all form field widgets
/// This allows VooForm and VooFormBuilder to accept any field widget
/// without needing factories or complex type hierarchies
abstract class VooFormFieldWidget extends Widget {
  /// Unique name/id for the field
  String get name;
  
  /// Optional label for the field
  String? get label;
  
  /// Whether the field is required
  bool get required;
  
  /// The current value of the field
  dynamic get value;
  
  /// The initial value of the field
  dynamic get initialValue;
  
  const VooFormFieldWidget({super.key});
}