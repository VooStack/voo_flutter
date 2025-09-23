import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

/// Entity representing a file that can be either from a URL or uploaded
/// Supports both existing files (from URL) and newly uploaded files (PlatformFile)
class VooFile extends Equatable {
  /// URL of an existing file (e.g., already uploaded to server)
  final String? url;

  /// Platform file for newly selected/uploaded files
  final PlatformFile? platformFile;

  /// Optional display name (overrides platformFile name or URL filename)
  final String? displayName;

  /// File size in bytes (uses platformFile size if available, otherwise needs to be provided)
  final int? size;

  /// File extension (derived from platformFile or URL)
  final String? extension;

  /// MIME type of the file
  final String? mimeType;

  /// Whether this file is from a URL (existing) or newly uploaded
  bool get isFromUrl => url != null && platformFile == null;

  /// Whether this file is newly selected/uploaded
  bool get isNewFile => platformFile != null;

  /// Whether this file has any content
  bool get hasFile => url != null || platformFile != null;

  /// Get the display name for the file
  String get name {
    if (displayName != null) return displayName!;
    if (platformFile != null) return platformFile!.name;
    if (url != null) {
      // Extract filename from URL
      final uri = Uri.tryParse(url!);
      if (uri != null) {
        final segments = uri.pathSegments;
        if (segments.isNotEmpty) {
          return Uri.decodeFull(segments.last);
        }
      }
    }
    return 'Unknown file';
  }

  /// Get the file extension
  String? get fileExtension {
    if (extension != null) return extension;
    if (platformFile?.extension != null) return platformFile!.extension;

    // Try to extract from name
    final fileName = name;
    final lastDot = fileName.lastIndexOf('.');
    if (lastDot != -1 && lastDot < fileName.length - 1) {
      return fileName.substring(lastDot + 1).toLowerCase();
    }
    return null;
  }

  /// Get the file size
  int get fileSize {
    if (platformFile != null) return platformFile!.size;
    return size ?? 0;
  }

  const VooFile({this.url, this.platformFile, this.displayName, this.size, this.extension, this.mimeType})
    : assert(url != null || platformFile != null, 'Either url or platformFile must be provided');

  /// Create VooFile from URL (for existing files)
  factory VooFile.fromUrl(String url, {String? displayName, int? size, String? extension, String? mimeType}) =>
      VooFile(url: url, displayName: displayName, size: size, extension: extension, mimeType: mimeType);

  /// Create VooFile from PlatformFile (for newly uploaded files)
  factory VooFile.fromPlatformFile(PlatformFile file) => VooFile(platformFile: file, size: file.size, extension: file.extension);

  /// Copy with new values
  VooFile copyWith({String? url, PlatformFile? platformFile, String? displayName, int? size, String? extension, String? mimeType}) => VooFile(
    url: url ?? this.url,
    platformFile: platformFile ?? this.platformFile,
    displayName: displayName ?? this.displayName,
    size: size ?? this.size,
    extension: extension ?? this.extension,
    mimeType: mimeType ?? this.mimeType,
  );

  @override
  List<Object?> get props => [url, platformFile, displayName, size, extension, mimeType];

  @override
  String toString() => 'VooFile(name: $name, isFromUrl: $isFromUrl, size: $fileSize)';
}
