class VooException implements Exception {
  final String message;
  final String? code;
  final dynamic details;
  final StackTrace? stackTrace;

  const VooException(this.message, {this.code, this.details, this.stackTrace});

  @override
  String toString() {
    final buffer = StringBuffer('VooException: $message');
    if (code != null) {
      buffer.write(' (code: $code)');
    }
    if (details != null) {
      buffer.write('\nDetails: $details');
    }
    if (stackTrace != null) {
      buffer.write('\n$stackTrace');
    }
    return buffer.toString();
  }
}
