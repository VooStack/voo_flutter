import 'package:flutter/material.dart';
import 'package:voo_toast/voo_toast.dart';

void main() {
  // Optional: Initialize with custom configuration
  VooToastController.init(
    config: const ToastConfig(
      defaultDuration: Duration(seconds: 4),
      successColor: Colors.green,
      errorColor: Colors.red,
      warningColor: Colors.orange,
      infoColor: Colors.blue,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'VooToast Example',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const VooToastOverlay(
          child: ToastExamplePage(),
        ),
      );
}

class ToastExamplePage extends StatelessWidget {
  const ToastExamplePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('VooToast Example'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSection(
                title: 'Basic Toasts',
                children: [
                  _buildButton(
                    'Show Success',
                    Colors.green,
                    () => VooToast.showSuccess(
                      message: 'Operation completed successfully!',
                      context: context,
                    ),
                  ),
                  _buildButton(
                    'Show Error',
                    Colors.red,
                    () => VooToast.showError(
                      message: 'An error occurred. Please try again.',
                      context: context,
                    ),
                  ),
                  _buildButton(
                    'Show Warning',
                    Colors.orange,
                    () => VooToast.showWarning(
                      message: 'Please review your input before proceeding.',
                      context: context,
                    ),
                  ),
                  _buildButton(
                    'Show Info',
                    Colors.blue,
                    () => VooToast.showInfo(
                      message: 'New updates are available.',
                      context: context,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: 'Toasts with Titles',
                children: [
                  _buildButton(
                    'Success with Title',
                    Colors.green,
                    () => VooToast.showSuccess(
                      title: 'Success!',
                      message: 'Your profile has been updated.',
                      context: context,
                    ),
                  ),
                  _buildButton(
                    'Error with Title',
                    Colors.red,
                    () => VooToast.showError(
                      title: 'Error',
                      message: 'Failed to save changes. Check your connection.',
                      context: context,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: 'Future Toasts',
                children: [
                  _buildButton(
                    'Success Future (2s)',
                    Colors.green,
                    () async {
                      await VooToast.showFutureToast<String>(
                        future: Future.delayed(
                          const Duration(seconds: 2),
                          () => 'Data loaded successfully!',
                        ),
                        loadingMessage: 'Loading data...',
                        loadingTitle: 'Please wait',
                        successMessage: (result) => 'Loaded: $result',
                        successTitle: 'Success',
                        context: context,
                      );
                    },
                  ),
                  _buildButton(
                    'Error Future (2s)',
                    Colors.red,
                    () async {
                      try {
                        await VooToast.showFutureToast<void>(
                          future: Future.delayed(
                            const Duration(seconds: 2),
                            () => throw Exception('Network error occurred'),
                          ),
                          loadingMessage: 'Fetching data from server...',
                          loadingTitle: 'Loading',
                          errorMessage: (error) => 'Failed: ${error.toString().replaceAll('Exception: ', '')}',
                          errorTitle: 'Network Error',
                          context: context,
                        );
                      } catch (e) {
                        // Expected error: $e
                      }
                    },
                  ),
                  _buildButton(
                    'Silent Success Future',
                    Colors.blue,
                    () async {
                      await VooToast.showFutureToast<void>(
                        future: Future.delayed(
                          const Duration(seconds: 3),
                          () {/* Silent operation completed */},
                        ),
                        loadingMessage: 'Processing...',
                        showSuccessToast: false,
                        context: context,
                      );
                    },
                  ),
                  _buildButton(
                    'Custom Loading Icon',
                    Colors.purple,
                    () async {
                      await VooToast.showFutureToast<void>(
                        future: Future.delayed(const Duration(seconds: 2)),
                        loadingMessage: 'Uploading file...',
                        loadingIcon: const Icon(Icons.cloud_upload, color: Colors.white),
                        successMessage: (_) => 'File uploaded successfully!',
                        context: context,
                      );
                    },
                  ),
                  _buildButton(
                    'With Result Data',
                    Colors.indigo,
                    () async {
                      await VooToast.showFutureToast<Map<String, dynamic>>(
                        future: Future.delayed(
                          const Duration(seconds: 2),
                          () => {'items': 42, 'status': 'active'},
                        ),
                        loadingMessage: 'Fetching statistics...',
                        successMessage: (result) => 'Found ${result['items']} items (${result['status']})',
                        context: context,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: 'Toasts with Actions',
                children: [
                  _buildButton(
                    'Toast with Undo',
                    Colors.purple,
                    () => VooToast.showInfo(
                      message: 'Item deleted',
                      context: context,
                      actions: [
                        ToastAction(
                          label: 'UNDO',
                          onPressed: () {
                            VooToast.showSuccess(
                              message: 'Action undone',
                              context: context,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  _buildButton(
                    'Toast with Multiple Actions',
                    Colors.indigo,
                    () => VooToast.showWarning(
                      title: 'Confirm Action',
                      message: 'Are you sure you want to proceed?',
                      context: context,
                      duration: const Duration(seconds: 10),
                      actions: [
                        ToastAction(
                          label: 'YES',
                          onPressed: () {
                            VooToast.showSuccess(
                              message: 'Action confirmed',
                              context: context,
                            );
                          },
                        ),
                        ToastAction(
                          label: 'NO',
                          onPressed: () {
                            VooToast.showInfo(
                              message: 'Action cancelled',
                              context: context,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: 'Custom Toasts',
                children: [
                  _buildButton(
                    'Custom Content',
                    Colors.teal,
                    () => VooToast.showCustom(
                      context: context,
                      content: Container(
                        padding: const EdgeInsets.all(16),
                        child: const Row(
                          children: [
                            CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                            SizedBox(width: 16),
                            Text(
                              'Loading...',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      backgroundColor: Colors.black87,
                      duration: const Duration(seconds: 2),
                    ),
                  ),
                  _buildButton(
                    'Gradient Toast',
                    Colors.pink,
                    () => VooToast.showCustom(
                      context: context,
                      content: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.purple, Colors.pink],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Beautiful gradient toast!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: 'Different Positions',
                children: [
                  _buildButton(
                    'Top Center',
                    Colors.cyan,
                    () => VooToast.showInfo(
                      message: 'Toast at top center',
                      position: ToastPosition.topCenter,
                    ),
                  ),
                  _buildButton(
                    'Center',
                    Colors.amber,
                    () => VooToast.showInfo(
                      message: 'Toast at center',
                      position: ToastPosition.center,
                    ),
                  ),
                  _buildButton(
                    'Bottom Right',
                    Colors.lime,
                    () => VooToast.showInfo(
                      message: 'Toast at bottom right',
                      position: ToastPosition.bottomRight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: 'Toast Management',
                children: [
                  _buildButton(
                    'Show Multiple',
                    Colors.deepPurple,
                    () {
                      VooToast.showSuccess(
                        message: 'First toast',
                        context: context,
                      );
                      Future.delayed(const Duration(milliseconds: 500), () {
                        VooToast.showInfo(
                          message: 'Second toast',
                        );
                      });
                      Future.delayed(const Duration(seconds: 1), () {
                        VooToast.showWarning(
                          message: 'Third toast',
                        );
                      });
                    },
                  ),
                  _buildButton(
                    'Dismiss All',
                    Colors.grey,
                    () => VooToast.dismissAll(),
                  ),
                  _buildButton(
                    'Persistent Toast',
                    Colors.brown,
                    () => VooToast.showInfo(
                      message: 'This toast will stay until dismissed',
                      context: context,
                      duration: Duration.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: children,
          ),
        ],
      );

  Widget _buildButton(
    String label,
    Color color,
    VoidCallback onPressed,
  ) =>
      ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
        ),
        child: Text(label),
      );
}
