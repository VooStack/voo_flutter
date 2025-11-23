/// Defines the type of a node port.
///
/// Ports can be either input ports that receive connections,
/// or output ports that initiate connections.
enum PortType {
  /// An input port that can receive connections from output ports.
  input,

  /// An output port that can connect to input ports.
  output,
}
