import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
import 'package:voo_forms/voo_forms.dart';

/// File field molecule that handles file selection
/// Supports mobile and web platforms via file_picker
/// Supports both URL-based files and newly uploaded files
/// Supports drag and drop on web and desktop platforms
/// Follows atomic design and KISS principle
class VooFileField extends VooFieldBase<VooFile?> {
  /// Allowed file extensions (e.g., ['pdf', 'doc', 'docx'])
  final List<String>? allowedExtensions;

  /// File type filter
  final FileType fileType;

  /// Whether to allow multiple files
  final bool allowMultiple;

  /// Whether to allow compression (images/videos)
  final bool allowCompression;

  /// Whether to show file preview
  final bool showPreview;

  /// Custom button text
  final String? buttonText;

  /// Custom button icon
  final Widget? buttonIcon;

  /// Maximum file size in bytes
  final int? maxFileSize;

  /// Error message for invalid file size
  final String? fileSizeErrorMessage;

  /// Callback when file is selected
  final void Function(VooFile?)? onFileSelected;

  /// Callback when file is removed
  final VoidCallback? onFileRemoved;

  /// Whether to show image preview for image files
  final bool showImagePreview;

  /// Whether to enable drag and drop (web/desktop only)
  final bool enableDragDrop;

  const VooFileField({
    super.key,
    required super.name,
    super.label,
    super.labelWidget,
    super.hint,
    super.helper,
    super.placeholder,
    super.enabled,
    super.readOnly,
    super.validators,
    super.actions,
    super.prefixIcon,
    super.suffixIcon,
    super.gridColumns,
    super.error,
    super.showError,
    super.layout,
    super.isHidden,
    super.minWidth,
    super.maxWidth,
    super.minHeight,
    super.maxHeight,
    super.initialValue,
    this.allowedExtensions,
    this.fileType = FileType.any,
    this.allowMultiple = false,
    this.allowCompression = true,
    this.showPreview = true,
    this.buttonText,
    this.buttonIcon,
    this.maxFileSize,
    this.fileSizeErrorMessage,
    this.onFileSelected,
    this.onFileRemoved,
    this.showImagePreview = true,
    this.enableDragDrop = true,
  });

  @override
  Widget build(BuildContext context) {
    // Return empty widget if hidden
    if (isHidden) return const SizedBox.shrink();

    // Get the error for this field using the base class method
    final fieldError = getFieldError(context);

    Widget fileField = FormField<VooFile?>(
      initialValue: initialValue,
      validator: (value) {
        if (isRequired && value == null) {
          return 'This field is required';
        }
        if (validators != null) {
          for (final validator in validators!) {
            final error = validator.validate(value);
            if (error != null) return error;
          }
        }
        return null;
      },
      builder: (FormFieldState<VooFile?> fieldState) => _VooFileFieldContent(fieldState: fieldState, field: this),
    );

    // Apply standard field building pattern
    fileField = buildWithHelper(context, fileField);

    // Build with error if present
    if (fieldError != null && fieldError.isNotEmpty) {
      fileField = buildWithError(context, fileField);
    }

    fileField = buildWithLabel(context, fileField);
    fileField = buildWithActions(context, fileField);

    return buildFieldContainer(context, fileField);
  }

  @override
  VooFileField copyWith({VooFile? initialValue, String? label, VooFieldLayout? layout, String? name, bool? readOnly}) => VooFileField(
    key: key,
    name: name ?? this.name,
    label: label ?? this.label,
    labelWidget: labelWidget,
    hint: hint,
    helper: helper,
    placeholder: placeholder,
    initialValue: initialValue ?? this.initialValue,
    enabled: enabled,
    readOnly: readOnly ?? this.readOnly,
    validators: validators,
    actions: actions,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    gridColumns: gridColumns,
    error: error,
    showError: showError,
    layout: layout ?? this.layout,
    isHidden: isHidden,
    minWidth: minWidth,
    maxWidth: maxWidth,
    minHeight: minHeight,
    maxHeight: maxHeight,
    allowedExtensions: allowedExtensions,
    fileType: fileType,
    allowMultiple: allowMultiple,
    allowCompression: allowCompression,
    showPreview: showPreview,
    buttonText: buttonText,
    buttonIcon: buttonIcon,
    maxFileSize: maxFileSize,
    fileSizeErrorMessage: fileSizeErrorMessage,
    onFileSelected: onFileSelected,
    onFileRemoved: onFileRemoved,
    showImagePreview: showImagePreview,
    enableDragDrop: enableDragDrop,
  );
}

/// Internal stateful widget to handle drag and drop state
class _VooFileFieldContent extends StatefulWidget {
  final FormFieldState<VooFile?> fieldState;
  final VooFileField field;

  const _VooFileFieldContent({required this.fieldState, required this.field});

  @override
  State<_VooFileFieldContent> createState() => _VooFileFieldContentState();
}

class _VooFileFieldContentState extends State<_VooFileFieldContent> {
  bool _isDragging = false;

  bool get _canDragDrop =>
      widget.field.enableDragDrop && (kIsWeb || !Platform.isAndroid && !Platform.isIOS) && widget.field.enabled && !widget.field.getEffectiveReadOnly(context);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasFile = widget.fieldState.value != null;
    final effectiveReadOnly = widget.field.getEffectiveReadOnly(context);

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // File selection area with drag and drop
        _buildFileSelectionArea(context, theme, hasFile, effectiveReadOnly),

        // Action buttons (only show in edit mode)
        if (hasFile && widget.field.enabled && !effectiveReadOnly) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => _removeFile(context),
                icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                label: Text('Remove', style: TextStyle(color: theme.colorScheme.error)),
              ),
              const SizedBox(width: 8),
              TextButton.icon(onPressed: () => _pickFile(context), icon: const Icon(Icons.refresh), label: const Text('Change')),
            ],
          ),
        ],
      ],
    );

    // Wrap with DropTarget for drag and drop support
    if (_canDragDrop) {
      content = DropTarget(
        onDragEntered: (details) {
          setState(() {
            _isDragging = true;
          });
        },
        onDragExited: (details) {
          setState(() {
            _isDragging = false;
          });
        },
        onDragDone: (details) async {
          setState(() {
            _isDragging = false;
          });

          if (details.files.isNotEmpty) {
            final file = details.files.first;
            await _handleDroppedFile(context, file);
          }
        },
        child: content,
      );
    }

    return content;
  }

  Widget _buildFileSelectionArea(BuildContext context, ThemeData theme, bool hasFile, bool effectiveReadOnly) {
    // Determine the border and background colors based on state
    Color borderColor;
    Color backgroundColor;
    double borderWidth = 1;

    if (widget.field.error != null) {
      borderColor = theme.colorScheme.error;
      borderWidth = 2;
    } else if (_isDragging) {
      borderColor = theme.colorScheme.primary;
      borderWidth = 2;
    } else if (effectiveReadOnly) {
      borderColor = theme.colorScheme.outline.withValues(alpha: 0.2);
    } else {
      borderColor = theme.colorScheme.outline.withValues(alpha: 0.3);
    }

    if (_isDragging) {
      backgroundColor = theme.colorScheme.primary.withValues(alpha: 0.08);
    } else if (effectiveReadOnly) {
      backgroundColor = theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);
    } else {
      backgroundColor = theme.colorScheme.surface;
    }

    return InkWell(
      onTap: widget.field.enabled && !effectiveReadOnly ? () => _pickFile(context) : null,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: borderWidth, style: _isDragging ? BorderStyle.solid : BorderStyle.solid),
          borderRadius: BorderRadius.circular(12),
          color: backgroundColor,
        ),
        child: hasFile ? _buildFilePreview(context) : _buildPlaceholder(context, effectiveReadOnly),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context, bool effectiveReadOnly) {
    final theme = Theme.of(context);

    if (effectiveReadOnly) {
      return Row(
        children: [
          Icon(Icons.attach_file, size: 24, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
          const SizedBox(width: 12),
          Text('No file attached', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5))),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          _isDragging ? Icons.file_download : (widget.field.buttonIcon != null ? null : Icons.cloud_upload_outlined),
          size: 48,
          color: _isDragging ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
        if (widget.field.buttonIcon != null && !_isDragging) widget.field.buttonIcon!,
        const SizedBox(height: 8),
        Text(
          _isDragging ? 'Drop file here' : (widget.field.buttonText ?? 'Click to select file'),
          style: theme.textTheme.bodyLarge?.copyWith(color: _isDragging ? theme.colorScheme.primary : theme.colorScheme.primary, fontWeight: FontWeight.w500),
        ),
        if (!_isDragging && _canDragDrop) ...[
          const SizedBox(height: 4),
          Text('or drag and drop', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6))),
        ],
        if (widget.field.placeholder != null && !_isDragging) ...[
          const SizedBox(height: 4),
          Text(
            widget.field.placeholder!,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
            textAlign: TextAlign.center,
          ),
        ],
        if (widget.field.allowedExtensions != null && widget.field.allowedExtensions!.isNotEmpty && !_isDragging) ...[
          const SizedBox(height: 4),
          Text(
            'Allowed: ${widget.field.allowedExtensions!.join(', ')}',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
          ),
        ],
      ],
    );
  }

  Widget _buildFilePreview(BuildContext context) {
    final theme = Theme.of(context);
    final file = widget.fieldState.value!;
    final isImageFile = _isImageFile(file.fileExtension);

    return Row(
      children: [
        // File icon or image preview
        if (isImageFile && widget.field.showImagePreview && file.isFromUrl) ...[
          // Show image preview from URL
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              file.url!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => ColoredBox(
                color: theme.colorScheme.primaryContainer,
                child: Icon(Icons.broken_image, color: theme.colorScheme.onPrimaryContainer),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return ColoredBox(
                  color: theme.colorScheme.primaryContainer,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ] else ...[
          // Show file icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, borderRadius: BorderRadius.circular(8)),
            child: Icon(_getFileIcon(file.fileExtension), color: theme.colorScheme.onPrimaryContainer),
          ),
        ],
        const SizedBox(width: 12),

        // File info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(file.name, style: theme.textTheme.bodyLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                  if (file.isFromUrl) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
                      child: Text('Uploaded', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onPrimaryContainer)),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                file.fileSize > 0 ? _formatFileSize(file.fileSize) : 'Unknown size',
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
              ),
            ],
          ),
        ),

        // URL preview action
        if (file.isFromUrl) ...[
          IconButton(
            onPressed: () => _openUrl(context, file.url!),
            icon: const Icon(Icons.open_in_new),
            tooltip: 'Open file',
            color: theme.colorScheme.primary,
          ),
        ],
      ],
    );
  }

  Future<void> _handleDroppedFile(BuildContext context, XFile droppedFile) async {
    try {
      // Get file info
      final bytes = await droppedFile.readAsBytes();
      final fileName = droppedFile.name;
      final fileSize = bytes.length;

      // Extract extension from filename
      String? extension;
      final lastDot = fileName.lastIndexOf('.');
      if (lastDot != -1 && lastDot < fileName.length - 1) {
        extension = fileName.substring(lastDot + 1).toLowerCase();
      }

      // Check if extension is allowed
      if (widget.field.allowedExtensions != null &&
          widget.field.allowedExtensions!.isNotEmpty &&
          extension != null &&
          !widget.field.allowedExtensions!.contains(extension)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('File type .$extension is not allowed. Allowed types: ${widget.field.allowedExtensions!.join(', ')}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
        return;
      }

      // Check file size
      if (widget.field.maxFileSize != null && fileSize > widget.field.maxFileSize!) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.field.fileSizeErrorMessage ?? 'File size exceeds maximum allowed size of ${_formatFileSize(widget.field.maxFileSize!)}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
        return;
      }

      // Create PlatformFile from dropped file
      final platformFile = PlatformFile(name: fileName, size: fileSize, bytes: bytes, path: droppedFile.path);

      // Create VooFile and update field
      final vooFile = VooFile.fromPlatformFile(platformFile);
      widget.fieldState.didChange(vooFile);
      widget.field.onFileSelected?.call(vooFile);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error processing dropped file: $e'), backgroundColor: Theme.of(context).colorScheme.error));
      }
    }
  }

  Future<void> _pickFile(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: widget.field.fileType,
        allowedExtensions: widget.field.fileType == FileType.custom ? widget.field.allowedExtensions : null,
        allowCompression: widget.field.allowCompression,
      );

      if (result != null && result.files.isNotEmpty) {
        final platformFile = result.files.first;

        // Check file size if specified
        if (widget.field.maxFileSize != null && platformFile.size > widget.field.maxFileSize!) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(widget.field.fileSizeErrorMessage ?? 'File size exceeds maximum allowed size of ${_formatFileSize(widget.field.maxFileSize!)}'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
          return;
        }

        // Create VooFile from PlatformFile
        final vooFile = VooFile.fromPlatformFile(platformFile);

        // Update field value
        widget.fieldState.didChange(vooFile);
        widget.field.onFileSelected?.call(vooFile);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error selecting file: $e'), backgroundColor: Theme.of(context).colorScheme.error));
      }
    }
  }

  void _removeFile(BuildContext context) {
    widget.fieldState.didChange(null);
    widget.field.onFileSelected?.call(null);
    widget.field.onFileRemoved?.call();
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch URL: $url');
        if (context.mounted) {
          // Try to show error in a safe way
          final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
          if (scaffoldMessenger != null) {
            scaffoldMessenger.showSnackBar(SnackBar(content: Text('Could not open file: $url'), backgroundColor: Theme.of(context).colorScheme.error));
          }
        }
      }
    } catch (e) {
      debugPrint('Error opening URL: $e');
    }
  }

  bool _isImageFile(String? extension) {
    if (extension == null) return false;
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'];
    return imageExtensions.contains(extension.toLowerCase());
  }

  IconData _getFileIcon(String? extension) {
    if (extension == null) return Icons.insert_drive_file;

    switch (extension.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
        return Icons.image;
      case 'mp4':
      case 'avi':
      case 'mov':
        return Icons.video_file;
      case 'mp3':
      case 'wav':
      case 'aac':
        return Icons.audio_file;
      case 'zip':
      case 'rar':
      case '7z':
        return Icons.folder_zip;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1073741824) {
      return '${(bytes / 1048576).toStringAsFixed(1)} MB';
    }
    return '${(bytes / 1073741824).toStringAsFixed(1)} GB';
  }
}
