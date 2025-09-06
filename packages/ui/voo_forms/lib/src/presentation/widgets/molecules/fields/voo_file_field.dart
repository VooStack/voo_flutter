import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_read_only_field.dart';
import 'package:voo_forms/voo_forms.dart';

/// File field molecule that handles file selection
/// Supports mobile and web platforms via file_picker
/// Follows atomic design and KISS principle
class VooFileField extends VooFieldBase<PlatformFile?> {
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
  final void Function(PlatformFile?)? onFileSelected;

  /// Callback when file is removed
  final VoidCallback? onFileRemoved;

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
  });

  @override
  Widget build(BuildContext context) {
    // Return empty widget if hidden
    if (isHidden) return const SizedBox.shrink();

    Widget fileField = FormField<PlatformFile?>(
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
      builder: (FormFieldState<PlatformFile?> fieldState) {
        final theme = Theme.of(context);
        final hasFile = fieldState.value != null;
        final effectiveReadOnly = getEffectiveReadOnly(context);

        // If read-only, show VooReadOnlyField for better UX
        if (effectiveReadOnly) {
          String displayValue = '';
          if (fieldState.value != null) {
            displayValue = fieldState.value!.name;
            if (fieldState.value!.size > 0) {
              displayValue += ' (${_formatFileSize(fieldState.value!.size)})';
            }
          }
          
          Widget readOnlyContent = VooReadOnlyField(
            value: displayValue,
            icon: const Icon(Icons.attach_file),
          );
          
          // Apply standard field building pattern
          readOnlyContent = buildWithHelper(context, readOnlyContent);
          readOnlyContent = buildWithError(context, readOnlyContent);
          readOnlyContent = buildWithLabel(context, readOnlyContent);
          readOnlyContent = buildWithActions(context, readOnlyContent);
          
          return readOnlyContent;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // File selection area
            InkWell(
              onTap: enabled && !effectiveReadOnly ? () => _pickFile(context, fieldState) : null,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: error != null ? theme.colorScheme.error : theme.colorScheme.outline.withValues(alpha: 0.3),
                    width: error != null ? 2 : 1,
                    style: hasFile ? BorderStyle.solid : BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: enabled && !effectiveReadOnly ? theme.colorScheme.surface : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                ),
                child: hasFile ? _buildFilePreview(context, fieldState) : _buildPlaceholder(context, fieldState),
              ),
            ),

            // Action buttons
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

  Widget _buildPlaceholder(BuildContext context, FormFieldState<PlatformFile?> fieldState) {
    final theme = Theme.of(context);

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
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
        if (allowedExtensions != null && allowedExtensions!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            'Allowed: ${allowedExtensions!.join(', ')}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFilePreview(BuildContext context, FormFieldState<PlatformFile?> fieldState) {
    final theme = Theme.of(context);
    final file = fieldState.value!;

    return Row(
      children: [
        // File icon
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getFileIcon(file.extension),
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 12),

        // File info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                file.name,
                style: theme.textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                _formatFileSize(file.size),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pickFile(BuildContext context, FormFieldState<PlatformFile?> fieldState) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: fileType,
        allowedExtensions: fileType == FileType.custom ? allowedExtensions : null,
        allowCompression: allowCompression,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        // Check file size if specified
        if (maxFileSize != null && file.size > maxFileSize!) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  fileSizeErrorMessage ?? 'File size exceeds maximum allowed size of ${_formatFileSize(maxFileSize!)}',
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
          return;
        }

        // Update field value
        fieldState.didChange(file);
        onFileSelected?.call(file);
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

  void _removeFile(BuildContext context, FormFieldState<PlatformFile?> fieldState) {
    fieldState.didChange(null);
    onFileSelected?.call(null);
    onFileRemoved?.call();
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
    if (bytes < 1073741824) return '${(bytes / 1048576).toStringAsFixed(1)} MB';
    return '${(bytes / 1073741824).toStringAsFixed(1)} GB';
  }

  @override
  VooFileField copyWith({
    PlatformFile? initialValue,
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
      );
}
