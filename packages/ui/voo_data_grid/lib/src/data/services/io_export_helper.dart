import 'dart:typed_data';

/// Non-web (IO) implementation stub for file downloads
void downloadFile({
  required Uint8List bytes,
  required String filename,
}) {
  // On non-web platforms, this is handled differently
  // This stub exists for conditional imports
  throw UnsupportedError('Download not supported on this platform. Use shareOrPrint instead.');
}