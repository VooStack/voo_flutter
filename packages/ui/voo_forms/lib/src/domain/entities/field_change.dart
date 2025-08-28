/// Represents a change in a form field's value
class FieldChange {
  final String fieldId;
  final dynamic oldValue;
  final dynamic newValue;

  const FieldChange({
    required this.fieldId,
    required this.oldValue,
    required this.newValue,
  });

  /// Check if the change is a deletion (had value, now null/empty)
  bool get isDeletion =>
      oldValue != null &&
      (newValue == null ||
          (newValue is String && newValue.isEmpty) ||
          (newValue is List && newValue.isEmpty));

  /// Check if the change is an addition (was null/empty, now has value)
  bool get isAddition =>
      (oldValue == null ||
          (oldValue is String && oldValue.isEmpty) ||
          (oldValue is List && oldValue.isEmpty)) &&
      newValue != null &&
      !(newValue is String && newValue.isEmpty) &&
      !(newValue is List && newValue.isEmpty);

  /// Check if the change is a modification (both have values but different)
  bool get isModification => !isDeletion && !isAddition;

  Map<String, dynamic> toMap() {
    return {
      'fieldId': fieldId,
      'oldValue': oldValue,
      'newValue': newValue,
      'type': isDeletion
          ? 'deletion'
          : isAddition
              ? 'addition'
              : 'modification',
    };
  }

  @override
  String toString() {
    return 'FieldChange(fieldId: $fieldId, oldValue: $oldValue, newValue: $newValue)';
  }
}