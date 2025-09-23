/// Configuration for how a field should be displayed in form layouts
class VooFieldLayout {
  /// Whether the field should take full width regardless of layout
  final bool fullWidth;

  /// How many columns this field should span in grid layouts
  final int? gridSpan;

  /// Minimum width for this field in wrapped layouts
  final double? minWidth;

  /// Maximum width for this field in wrapped layouts
  final double? maxWidth;

  /// Whether this field should start on a new row
  final bool newRow;

  /// Custom flex value for flexible layouts
  final int? flex;

  const VooFieldLayout({this.fullWidth = false, this.gridSpan, this.minWidth, this.maxWidth, this.newRow = false, this.flex});

  /// Default layout for most fields
  static const VooFieldLayout standard = VooFieldLayout();

  /// Layout for fields that should take full width
  static const VooFieldLayout fullWidthField = VooFieldLayout(fullWidth: true, newRow: true);

  /// Layout for compact fields (like checkboxes)
  static const VooFieldLayout compact = VooFieldLayout(minWidth: 150, maxWidth: 250);

  /// Layout for wide fields (like text areas, list fields)
  static const VooFieldLayout wide = VooFieldLayout(fullWidth: true, newRow: true, minWidth: 400);
}
