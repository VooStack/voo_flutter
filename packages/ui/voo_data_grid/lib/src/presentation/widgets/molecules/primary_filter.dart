import 'package:flutter/material.dart';

/// Represents a primary filter option
class PrimaryFilter {
  /// Unique identifier for the filter
  final String id;
  
  /// Display label for the filter
  final String label;
  
  /// Optional icon to display
  final IconData? icon;
  
  /// Optional count/badge value
  final int? count;
  
  /// The filter value to apply when selected
  final dynamic value;
  
  /// Optional custom filter function
  final bool Function(dynamic item)? filterFunction;
  
  const PrimaryFilter({
    required this.id,
    required this.label,
    this.icon,
    this.count,
    this.value,
    this.filterFunction,
  });
}