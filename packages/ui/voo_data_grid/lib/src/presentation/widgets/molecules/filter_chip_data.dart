/// Data class for filter chip information
class FilterChipData {
  /// The label to display for the filter
  final String label;
  
  /// The actual value of the filter
  final dynamic value;
  
  /// Optional display value if different from value
  final String? displayValue;

  const FilterChipData({
    required this.label,
    required this.value,
    this.displayValue,
  });
}