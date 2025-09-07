import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
import 'package:voo_forms/voo_forms.dart';

/// File field molecule that handles file selection
/// Supports mobile and web platforms via file_picker
/// Supports both URL-based files and newly uploaded files
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
  });

  @override
  Widget build(BuildContext context) {
    // Return empty widget if hidden
    if (isHidden) return const SizedBox.shrink();

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
      builder: (FormFieldState<VooFile?> fieldState) {
        final theme = Theme.of(context);
        final hasFile = fieldState.value != null;
        final effectiveReadOnly = getEffectiveReadOnly(context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // File selection area
            InkWell(
              onTap: enabled && !effectiveReadOnly
                  ? () => _pickFile(context, fieldState)
                  : null,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: error != null
                        ? theme.colorScheme.error
                        : effectiveReadOnly
                            ? theme.colorScheme.outline.withValues(alpha: 0.2)
                            : theme.colorScheme.outline.withValues(alpha: 0.3),
                    width: error != null ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: effectiveReadOnly
                      ? theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.3)
                      : theme.colorScheme.surface,
                ),
                child: hasFile
                    ? _buildFilePreview(context, fieldState)
                    : _buildPlaceholder(context, fieldState, effectiveReadOnly),
              ),
            ),

            // Action buttons (only show in edit mode)
            if (hasFile && enabled && !effectiveReadOnly) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _removeFile(context, fieldState),
                    icon: Icon(
                      Icons.delete_outline,
                      color: theme.colorScheme.error,
                    ),
                    label: Text(
                      'Remove',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () => _pickFile(context, fieldState),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Change'),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );

    // Apply standard field building pattern
    fileField = buildWithHelper(context, fileField);
    fileField = buildWithError(context, fileField);
    fileField = buildWithLabel(context, fileField);
    fileField = buildWithActions(context, fileField);

    return fileField;
  }

  Widget _buildPlaceholder(
    BuildContext context,
    FormFieldState<VooFile?> fieldState,
    bool effectiveReadOnly,
  ) {
    final theme = Theme.of(context);

    if (effectiveReadOnly) {
      return Row(
        children: [
          Icon(
            Icons.attach_file,
            size: 24,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 12),
          Text(
            'No file attached',
            style: theme.textTheme.bodyLarge?.copyWith(
              color:
                  theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          buttonIcon != null ? null : Icons.cloud_upload_outlined,
          size: 48,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
        if (buttonIcon != null) buttonIcon!,
        const SizedBox(height: 8),
        Text(
          buttonText ?? 'Click to select file',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (placeholder != null) ...[
          const SizedBox(height: 4),
          Text(
            placeholder!,
            style: theme.textTheme.bodySmall?.copyWith(
              color:
                  theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
        if (allowedExtensions != null && allowedExtensions!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            'Allowed: ${allowedExtensions!.join(', ')}',
            style: theme.textTheme.bodySmall?.copyWith(
              color:
                  theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFilePreview(
    BuildContext context,
    FormFieldState<VooFile?> fieldState,
  ) {
    final theme = Theme.of(context);
    final file = fieldState.value!;
    final isImageFile = _isImageFile(file.fileExtension);

    return Row(
      children: [
        // File icon or image preview
        if (isImageFile && showImagePreview && file.isFromUrl) ...[
          // Show image preview from URL
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              file.url!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => ColoredBox(
                    color: theme.colorScheme.primaryContainer,
                    child: Icon(
                      Icons.broken_image,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return ColoredBox(
                  color: theme.colorScheme.primaryContainer,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
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
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getFileIcon(file.fileExtension),
              color: theme.colorScheme.onPrimaryContainer,
            ),
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
                    child: Text(
                      file.name,
                      style: theme.textTheme.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (file.isFromUrl) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Uploaded',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                file.fileSize > 0
                    ? _formatFileSize(file.fileSize)
                    : 'Unknown size',
                style: theme.textTheme.bodySmall?.copyWith(
                  color:
                      theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
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

  Future<void> _pickFile(
    BuildContext context,
    FormFieldState<VooFile?> fieldState,
  ) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: fileType,
        allowedExtensions:
            fileType == FileType.custom ? allowedExtensions : null,
        allowCompression: allowCompression,
      );

      if (result != null && result.files.isNotEmpty) {
        final platformFile = result.files.first;

        // Check file size if specified
        if (maxFileSize != null && platformFile.size > maxFileSize!) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  fileSizeErrorMessage ??
                      'File size exceeds maximum allowed size of ${_formatFileSize(maxFileSize!)}',
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
          return;
        }

        // Create VooFile from PlatformFile
        final vooFile = VooFile.fromPlatformFile(platformFile);

        // Update field value
        fieldState.didChange(vooFile);
        onFileSelected?.call(vooFile);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting file: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _removeFile(
    BuildContext context,
    FormFieldState<VooFile?> fieldState,
  ) {
    fieldState.didChange(null);
    onFileSelected?.call(null);
    onFileRemoved?.call();
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        debugPrint('Could not launch URL: $url');
        if (context.mounted) {
          // Try to show error in a safe way
          final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
          if (scaffoldMessenger != null) {
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text('Could not open file: $url'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
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

  @override
  VooFileField copyWith({
    VooFile? initialValue,
    String? label,
    VooFieldLayout? layout,
    String? name,
    bool? readOnly,
  }) =>
      VooFileField(
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
      );
}