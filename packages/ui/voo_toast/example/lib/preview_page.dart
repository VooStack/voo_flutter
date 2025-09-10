import 'dart:async';

import 'package:flutter/material.dart';
import 'package:voo_toast/voo_toast.dart';

/// Example page showing how to use ToastPreview widgets
/// for design tools, documentation, or static previews.
class PreviewPage extends StatelessWidget {
  const PreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Toast Previews'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: ToastPreviewCollection(),
      ),
    );
  }
}

/// Custom preview page with individual toast previews
class CustomPreviewPage extends StatelessWidget {
  const CustomPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Toast Previews'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Individual Toast Previews',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Success toast without icon
            const ToastPreview(
              type: ToastType.success,
              message: 'File uploaded successfully',
              showIcon: false,
            ),
            const SizedBox(height: 16),
            
            // Error toast with long message
            const ToastPreview(
              type: ToastType.error,
              title: 'Connection Error',
              message: 'Unable to connect to the server. Please check your internet connection and try again.',
            ),
            const SizedBox(height: 16),
            
            // Warning without close button
            const ToastPreview(
              type: ToastType.warning,
              message: 'Low battery - 10% remaining',
              showCloseButton: false,
            ),
            const SizedBox(height: 16),
            
            // Info with progress
            const ToastPreview(
              type: ToastType.info,
              message: 'Syncing data...',
              showProgressBar: true,
            ),
            const SizedBox(height: 16),
            
            // Custom styled toast
            ToastPreview(
              type: ToastType.custom,
              backgroundColor: Colors.indigo.shade900,
              textColor: Colors.white,
              message: 'Custom styled notification',
              elevation: 8,
            ),
            const SizedBox(height: 16),
            
            // Toast with custom content
            ToastPreview(
              customContent: Card(
                color: Colors.amber.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.amber.shade900),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Pro Tip',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade900,
                              ),
                            ),
                            Text(
                              'You can use keyboard shortcuts to navigate faster',
                              style: TextStyle(
                                color: Colors.amber.shade900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Compact toast
            const ToastPreview(
              type: ToastType.info,
              message: 'Saved',
              showIcon: false,
              showCloseButton: false,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ],
        ),
      ),
    );
  }
}