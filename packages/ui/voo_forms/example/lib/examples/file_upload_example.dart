import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Example demonstrating file upload fields with drag and drop
class FileUploadExample extends StatefulWidget {
  const FileUploadExample({super.key});

  @override
  State<FileUploadExample> createState() => _FileUploadExampleState();
}

class _FileUploadExampleState extends State<FileUploadExample> {
  final _controller = VooFormController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.vooSpacing;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('File Uploads')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info banner
            Container(
              padding: EdgeInsets.all(spacing.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: theme.colorScheme.primary),
                  SizedBox(width: spacing.sm),
                  Expanded(
                    child: Text(
                      'Drag and drop files or click to browse. '
                      'Supports file size limits and type restrictions.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing.lg),

            // Document Upload Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(spacing.md),
                child: VooForm(
                  controller: _controller,
                  fields: [
                    VooFormSectionDivider(
                      name: 'documents_section',
                      label: 'Document Upload',
                      subtitle: 'Upload PDF, Word, or Excel documents',
                    ),
                    VooFileField(
                      name: 'resume',
                      label: 'Resume / CV',
                      placeholder: 'PDF or Word document, max 5MB',
                      fileType: FileType.custom,
                      allowedExtensions: const ['pdf', 'doc', 'docx'],
                      maxFileSize: 5 * 1024 * 1024, // 5MB
                      fileSizeErrorMessage: 'File must be under 5MB',
                      validators: [RequiredValidation()],
                      onFileSelected: (file) {
                        if (file != null) {
                          _showSnackBar('Resume uploaded: ${file.name}');
                        }
                      },
                    ),
                    VooFileField(
                      name: 'coverLetter',
                      label: 'Cover Letter (Optional)',
                      placeholder: 'PDF or Word document',
                      fileType: FileType.custom,
                      allowedExtensions: const ['pdf', 'doc', 'docx'],
                      maxFileSize: 2 * 1024 * 1024, // 2MB
                    ),

                    VooFormSectionDivider(
                      name: 'images_section',
                      label: 'Image Upload',
                      subtitle: 'Upload profile photo or portfolio images',
                    ),
                    VooFileField(
                      name: 'profilePhoto',
                      label: 'Profile Photo',
                      placeholder: 'JPG or PNG, max 2MB',
                      fileType: FileType.image,
                      showImagePreview: true,
                      maxFileSize: 2 * 1024 * 1024, // 2MB
                      onFileSelected: (file) {
                        if (file != null) {
                          _showSnackBar('Photo uploaded: ${file.name}');
                        }
                      },
                    ),

                    VooFormSectionDivider(
                      name: 'any_section',
                      label: 'General Upload',
                      subtitle: 'Upload any file type',
                    ),
                    VooFileField(
                      name: 'attachment',
                      label: 'Additional Attachment',
                      placeholder: 'Any file type, max 10MB',
                      fileType: FileType.any,
                      maxFileSize: 10 * 1024 * 1024, // 10MB
                      enableDragDrop: true,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: spacing.md),
            FilledButton(
              onPressed: _submitForm,
              child: const Text('Submit Application'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_controller.validate()) {
      final values = _controller.values;
      final resumeFile = values['resume'] as VooFile?;
      _showSnackBar(
        resumeFile != null
            ? 'Application submitted with ${resumeFile.name}'
            : 'Please upload a resume',
      );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
