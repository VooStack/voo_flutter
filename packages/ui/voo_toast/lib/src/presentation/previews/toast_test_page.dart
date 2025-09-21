import 'package:flutter/material.dart';
import 'package:voo_toast/voo_toast.dart';

/// A test page with interactive buttons to trigger various toast notifications.
/// Perfect for testing and demonstrating toast functionality.
class ToastTestPage extends StatelessWidget {
  const ToastTestPage({super.key});

  @override
  Widget build(BuildContext context) => VooToastOverlay(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('Toast Test Page'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSection(
                  title: 'Basic Toasts',
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => VooToast.showSuccess(
                        message: 'Operation completed successfully!',
                        context: context,
                      ),
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Success Toast'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => VooToast.showError(
                        message: 'An error occurred. Please try again.',
                        context: context,
                      ),
                      icon: const Icon(Icons.error),
                      label: const Text('Error Toast'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => VooToast.showWarning(
                        message: 'Please review your input before proceeding.',
                        context: context,
                      ),
                      icon: const Icon(Icons.warning),
                      label: const Text('Warning Toast'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => VooToast.showInfo(
                        message: 'New updates are available.',
                        context: context,
                      ),
                      icon: const Icon(Icons.info),
                      label: const Text('Info Toast'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: 'Toasts with Titles',
                  children: [
                    ElevatedButton(
                      onPressed: () => VooToast.showSuccess(
                        title: 'Success!',
                        message: 'Your profile has been updated.',
                        context: context,
                      ),
                      child: const Text('Success with Title'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => VooToast.showError(
                        title: 'Connection Error',
                        message: 'Unable to connect to server.',
                        context: context,
                      ),
                      child: const Text('Error with Title'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: 'Interactive Toasts',
                  children: [
                    ElevatedButton(
                      onPressed: () => VooToast.showInfo(
                        message: 'Item has been deleted',
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
                      child: const Text('Toast with Undo Action'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => VooToast.showWarning(
                        title: 'Confirm',
                        message: 'Do you want to proceed?',
                        context: context,
                        duration: const Duration(seconds: 10),
                        actions: [
                          ToastAction(
                            label: 'YES',
                            onPressed: () {
                              VooToast.showSuccess(
                                message: 'Confirmed',
                                context: context,
                              );
                            },
                          ),
                          ToastAction(
                            label: 'NO',
                            onPressed: () {
                              VooToast.showInfo(
                                message: 'Cancelled',
                                context: context,
                              );
                            },
                          ),
                        ],
                      ),
                      child: const Text('Confirmation Toast'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: 'Custom Toasts',
                  children: [
                    ElevatedButton(
                      onPressed: () => VooToast.showCustom(
                        context: context,
                        content: Container(
                          padding: const EdgeInsets.all(16),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
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
                      child: const Text('Loading Toast'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => VooToast.showCustom(
                        context: context,
                        content: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.purple, Colors.pink],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.celebration, color: Colors.white),
                              SizedBox(width: 12),
                              Text(
                                'Congratulations!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                      child: const Text('Gradient Toast'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: 'Different Positions',
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        OutlinedButton(
                          onPressed: () => VooToast.showInfo(
                            message: 'Top Center',
                            position: ToastPosition.topCenter,
                          ),
                          child: const Text('Top Center'),
                        ),
                        OutlinedButton(
                          onPressed: () => VooToast.showInfo(
                            message: 'Top Right',
                            position: ToastPosition.topRight,
                          ),
                          child: const Text('Top Right'),
                        ),
                        OutlinedButton(
                          onPressed: () => VooToast.showInfo(
                            message: 'Center',
                            position: ToastPosition.center,
                          ),
                          child: const Text('Center'),
                        ),
                        OutlinedButton(
                          onPressed: () => VooToast.showInfo(
                            message: 'Bottom',
                            position: ToastPosition.bottom,
                          ),
                          child: const Text('Bottom'),
                        ),
                        OutlinedButton(
                          onPressed: () => VooToast.showInfo(
                            message: 'Bottom Left',
                            position: ToastPosition.bottomLeft,
                          ),
                          child: const Text('Bottom Left'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: 'Toast Management',
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        VooToast.showSuccess(
                          message: 'First toast',
                          context: context,
                        );
                        Future.delayed(const Duration(milliseconds: 500), () {
                          if (!context.mounted) return;
                          VooToast.showInfo(
                            message: 'Second toast',
                            context: context,
                          );
                        });
                        Future.delayed(const Duration(seconds: 1), () {
                          if (!context.mounted) return;
                          VooToast.showWarning(
                            message: 'Third toast',
                            context: context,
                          );
                        });
                      },
                      child: const Text('Show Multiple Toasts'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => VooToast.showInfo(
                        message: 'This will stay until dismissed',
                        context: context,
                        duration: Duration.zero,
                      ),
                      child: const Text('Persistent Toast'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => VooToast.dismissAll(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: const Text('Dismiss All'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      );
}
