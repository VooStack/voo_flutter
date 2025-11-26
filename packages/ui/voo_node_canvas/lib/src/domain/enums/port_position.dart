/// Defines the position of a port on a node.
///
/// Ports can be placed on any of the four sides of a node.
/// This allows for more flexible node layouts beyond the
/// traditional left-input/right-output pattern.
enum PortPosition {
  /// Port is positioned on the left side of the node.
  left,

  /// Port is positioned on the right side of the node.
  right,

  /// Port is positioned on the top of the node.
  top,

  /// Port is positioned on the bottom of the node.
  bottom,
}
