import 'package:flutter/material.dart';
import 'package:voo_toast/voo_toast.dart';

void main() {
  // Initialize with default config - automatically uses snackbar on mobile!
  // This is the recommended setup for most apps.
  VooToastController.init(
    config: const ToastConfig(
      defaultStyle: VooToastStyle.material, // Used on tablet/web
      defaultDuration: Duration(seconds: 4),
      maxToasts: 5,
      // useSnackbarOnMobile: true (default) - mobile gets snackbar style
    ),
  );

  runApp(const VooToastExampleApp());
}

// =============================================================================
// CONFIGURATION EXAMPLES
// =============================================================================
//
// 1. DEFAULT (Adaptive Mobile) - Recommended for most apps
//    Mobile: snackbar | Tablet/Web: material
//
//    VooToastController.init(
//      config: const ToastConfig(), // or ToastConfig.material()
//    );
//
// 2. CLASSIC (Same style everywhere) - No automatic snackbar
//    Mobile/Tablet/Web: all use the same style
//
//    VooToastController.init(
//      config: const ToastConfig.classic(defaultStyle: VooToastStyle.glass),
//    );
//
// 3. SNACKBAR ONLY - Snackbar on all platforms
//    Mobile/Tablet/Web: all use snackbar
//
//    VooToastController.init(
//      config: const ToastConfig.snackbar(),
//    );
//
// 4. CUSTOM MOBILE STYLE - Different style on mobile (not snackbar)
//    Mobile: cupertino | Tablet/Web: material
//
//    VooToastController.init(
//      config: const ToastConfig.withMobileStyle(
//        defaultStyle: VooToastStyle.material,
//        mobileStyle: VooToastStyle.cupertino,
//      ),
//    );
//
// =============================================================================

class VooToastExampleApp extends StatefulWidget {
  const VooToastExampleApp({super.key});

  @override
  State<VooToastExampleApp> createState() => _VooToastExampleAppState();
}

class _VooToastExampleAppState extends State<VooToastExampleApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'VooToast Showcase',
        debugShowCheckedModeBanner: false,
        themeMode: _themeMode,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: VooToastOverlay(
          child: ToastShowcasePage(
            onToggleTheme: _toggleTheme,
            isDark: _themeMode == ThemeMode.dark,
          ),
        ),
      );
}

class ToastShowcasePage extends StatefulWidget {
  const ToastShowcasePage({
    super.key,
    required this.onToggleTheme,
    required this.isDark,
  });

  final VoidCallback onToggleTheme;
  final bool isDark;

  @override
  State<ToastShowcasePage> createState() => _ToastShowcasePageState();
}

class _ToastShowcasePageState extends State<ToastShowcasePage> {
  VooToastStyle _selectedStyle = VooToastStyle.material;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('VooToast Showcase'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
              onPressed: widget.onToggleTheme,
              tooltip: 'Toggle theme',
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Adaptive Mobile Section (NEW DEFAULT BEHAVIOR)
              _SectionHeader(
                title: 'Adaptive Mobile (Default)',
                subtitle: 'Toasts automatically use snackbar style on mobile',
              ),
              const SizedBox(height: 12),
              const _AdaptiveMobileShowcase(),
              const SizedBox(height: 32),

              // Style Selector Section
              _SectionHeader(
                title: 'Style Presets',
                subtitle: 'Select a style and tap toast types below',
              ),
              const SizedBox(height: 12),
              _StyleSelector(
                selectedStyle: _selectedStyle,
                onStyleSelected: (style) => setState(() => _selectedStyle = style),
              ),
              const SizedBox(height: 32),

              // Snackbar Section (Mobile-optimized)
              _SectionHeader(
                title: 'Snackbar Style',
                subtitle: 'Full-width notifications (default on mobile)',
              ),
              const SizedBox(height: 12),
              const _SnackbarShowcase(),
              const SizedBox(height: 32),

              // Toast Types Section
              _SectionHeader(
                title: 'Toast Types',
                subtitle: 'Different notification purposes',
              ),
              const SizedBox(height: 12),
              _ToastTypeGrid(style: _selectedStyle),
              const SizedBox(height: 32),

              // Features Section
              _SectionHeader(
                title: 'Features',
                subtitle: 'Advanced toast capabilities',
              ),
              const SizedBox(height: 12),
              _FeatureGrid(style: _selectedStyle),
              const SizedBox(height: 32),

              // Positions Section
              _SectionHeader(
                title: 'Positions',
                subtitle: 'Toast placement options',
              ),
              const SizedBox(height: 12),
              _PositionGrid(style: _selectedStyle),
              const SizedBox(height: 32),

              // Animations Section
              _SectionHeader(
                title: 'Animations',
                subtitle: 'Entry animation styles',
              ),
              const SizedBox(height: 12),
              _AnimationGrid(style: _selectedStyle),
              const SizedBox(height: 40),

              // Quick Actions
              Center(
                child: FilledButton.tonal(
                  onPressed: () => VooToast.dismissAll(),
                  child: const Text('Dismiss All Toasts'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _StyleSelector extends StatelessWidget {
  const _StyleSelector({
    required this.selectedStyle,
    required this.onStyleSelected,
  });

  final VooToastStyle selectedStyle;
  final ValueChanged<VooToastStyle> onStyleSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: VooToastStyle.values
          .where((style) => style != VooToastStyle.custom)
          .map(
            (style) => FilterChip(
              label: Text(style.displayName),
              selected: selectedStyle == style,
              onSelected: (_) => onStyleSelected(style),
              selectedColor: theme.colorScheme.primaryContainer,
              checkmarkColor: theme.colorScheme.onPrimaryContainer,
            ),
          )
          .toList(),
    );
  }
}

class _ToastTypeGrid extends StatelessWidget {
  const _ToastTypeGrid({required this.style});

  final VooToastStyle style;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _ToastButton(
            label: 'Success',
            icon: Icons.check_circle,
            color: Colors.green,
            onPressed: () => VooToast.showSuccess(
              title: 'Success!',
              message: 'Your changes have been saved successfully.',
              style: style,
              context: context,
            ),
          ),
          _ToastButton(
            label: 'Error',
            icon: Icons.error,
            color: Colors.red,
            onPressed: () => VooToast.showError(
              title: 'Error',
              message: 'Something went wrong. Please try again.',
              style: style,
              context: context,
            ),
          ),
          _ToastButton(
            label: 'Warning',
            icon: Icons.warning,
            color: Colors.orange,
            onPressed: () => VooToast.showWarning(
              title: 'Warning',
              message: 'Please review your input before continuing.',
              style: style,
              context: context,
            ),
          ),
          _ToastButton(
            label: 'Info',
            icon: Icons.info,
            color: Colors.blue,
            onPressed: () => VooToast.showInfo(
              title: 'Information',
              message: 'A new version is available for download.',
              style: style,
              context: context,
            ),
          ),
        ],
      );
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid({required this.style});

  final VooToastStyle style;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _ToastButton(
            label: 'With Actions',
            icon: Icons.touch_app,
            color: Colors.purple,
            onPressed: () => VooToast.showInfo(
              title: 'File Deleted',
              message: 'The file has been moved to trash.',
              style: style,
              duration: const Duration(seconds: 8),
              actions: [
                ToastAction(
                  label: 'Undo',
                  onPressed: () => VooToast.showSuccess(
                    message: 'File restored!',
                    style: style,
                  ),
                ),
              ],
            ),
          ),
          _ToastButton(
            label: 'With Progress',
            icon: Icons.hourglass_empty,
            color: Colors.teal,
            onPressed: () => VooToast.showInfo(
              title: 'Uploading...',
              message: 'Your file is being uploaded.',
              style: style,
              showProgressBar: true,
              duration: const Duration(seconds: 5),
            ),
          ),
          _ToastButton(
            label: 'Loading State',
            icon: Icons.sync,
            color: Colors.indigo,
            onPressed: () async {
              await VooToast.showFutureToast<String>(
                future: Future.delayed(
                  const Duration(seconds: 2),
                  () => 'Operation completed!',
                ),
                loadingTitle: 'Processing',
                loadingMessage: 'Please wait...',
                successTitle: 'Done!',
                successMessage: (result) => result,
                style: style,
                context: context,
              );
            },
          ),
          _ToastButton(
            label: 'Persistent',
            icon: Icons.push_pin,
            color: Colors.brown,
            onPressed: () => VooToast.showWarning(
              title: 'Important',
              message: 'This notification will stay until dismissed.',
              style: style,
              duration: Duration.zero,
            ),
          ),
        ],
      );
}

class _PositionGrid extends StatelessWidget {
  const _PositionGrid({required this.style});

  final VooToastStyle style;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _ToastButton(
            label: 'Top',
            icon: Icons.vertical_align_top,
            color: Colors.cyan,
            onPressed: () => VooToast.showInfo(
              message: 'Toast at the top',
              style: style,
              position: ToastPosition.topCenter,
            ),
          ),
          _ToastButton(
            label: 'Center',
            icon: Icons.center_focus_strong,
            color: Colors.amber,
            onPressed: () => VooToast.showInfo(
              message: 'Toast at the center',
              style: style,
              position: ToastPosition.center,
            ),
          ),
          _ToastButton(
            label: 'Bottom',
            icon: Icons.vertical_align_bottom,
            color: Colors.lime,
            onPressed: () => VooToast.showInfo(
              message: 'Toast at the bottom',
              style: style,
              position: ToastPosition.bottomCenter,
            ),
          ),
          _ToastButton(
            label: 'Top Right',
            icon: Icons.north_east,
            color: Colors.pink,
            onPressed: () => VooToast.showInfo(
              message: 'Toast at top right',
              style: style,
              position: ToastPosition.topRight,
            ),
          ),
        ],
      );
}

class _AnimationGrid extends StatelessWidget {
  const _AnimationGrid({required this.style});

  final VooToastStyle style;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _ToastButton(
            label: 'Slide',
            icon: Icons.arrow_downward,
            color: Colors.deepPurple,
            onPressed: () => VooToast.showInfo(
              message: 'Slide animation',
              style: style,
              animation: ToastAnimation.slideIn,
            ),
          ),
          _ToastButton(
            label: 'Fade',
            icon: Icons.gradient,
            color: Colors.blueGrey,
            onPressed: () => VooToast.showInfo(
              message: 'Fade animation',
              style: style,
              animation: ToastAnimation.fade,
            ),
          ),
          _ToastButton(
            label: 'Scale',
            icon: Icons.zoom_in,
            color: Colors.deepOrange,
            onPressed: () => VooToast.showInfo(
              message: 'Scale animation',
              style: style,
              animation: ToastAnimation.scale,
            ),
          ),
          _ToastButton(
            label: 'Bounce',
            icon: Icons.sports_basketball,
            color: Colors.green,
            onPressed: () => VooToast.showInfo(
              message: 'Bounce animation',
              style: style,
              animation: ToastAnimation.bounce,
            ),
          ),
        ],
      );
}

/// Showcase for the new default adaptive mobile behavior.
///
/// On mobile (< 600px), toasts automatically use snackbar style.
/// On tablet/web, they use the selected style preset.
class _AdaptiveMobileShowcase extends StatelessWidget {
  const _AdaptiveMobileShowcase();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Info card showing current mode
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                isMobile ? Icons.phone_android : Icons.desktop_windows,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isMobile ? 'Mobile detected (${screenWidth.toInt()}px) - Using snackbar style' : 'Tablet/Web detected (${screenWidth.toInt()}px) - Using selected style',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _ToastButton(
              label: 'Auto Style',
              icon: Icons.auto_awesome,
              color: Colors.deepPurple,
              onPressed: () => VooToast.showSuccess(
                title: 'Adaptive Toast',
                message: isMobile ? 'This toast uses snackbar style on mobile!' : 'This toast uses material style on tablet/web!',
                context: context,
                // No style specified - uses automatic platform detection
              ),
            ),
            _ToastButton(
              label: 'With Action',
              icon: Icons.touch_app,
              color: Colors.teal,
              onPressed: () => VooToast.showInfo(
                title: 'File Moved',
                message: 'Document moved to archive',
                context: context,
                duration: const Duration(seconds: 6),
                actions: [
                  ToastAction(
                    label: 'Undo',
                    onPressed: () => VooToast.showSuccess(
                      message: 'File restored to original location',
                      context: context,
                    ),
                  ),
                ],
              ),
            ),
            _ToastButton(
              label: 'Error',
              icon: Icons.error_outline,
              color: Colors.red,
              onPressed: () => VooToast.showError(
                title: 'Connection Failed',
                message: 'Unable to reach the server',
                context: context,
                actions: [
                  ToastAction(
                    label: 'Retry',
                    onPressed: () => VooToast.showInfo(
                      message: 'Retrying connection...',
                      context: context,
                    ),
                  ),
                ],
              ),
            ),
            _ToastButton(
              label: 'Classic Mode',
              icon: Icons.style,
              color: Colors.orange,
              onPressed: () {
                // Example of forcing a specific style (bypassing adaptive)
                VooToast.showInfo(
                  title: 'Classic Style',
                  message: 'This uses glass style regardless of screen size',
                  style: VooToastStyle.glass, // Force specific style
                  context: context,
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _SnackbarShowcase extends StatelessWidget {
  const _SnackbarShowcase();

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _ToastButton(
            label: 'Simple',
            icon: Icons.message,
            color: Colors.blueGrey,
            onPressed: () => VooToast.showInfo(
              message: 'This is a snackbar message',
              style: VooToastStyle.snackbar,
              context: context,
            ),
          ),
          _ToastButton(
            label: 'With Title',
            icon: Icons.title,
            color: Colors.indigo,
            onPressed: () => VooToast.showSuccess(
              title: 'Saved',
              message: 'Your changes have been saved',
              style: VooToastStyle.snackbar,
              context: context,
            ),
          ),
          _ToastButton(
            label: 'With Action',
            icon: Icons.touch_app,
            color: Colors.teal,
            onPressed: () => VooToast.showInfo(
              message: 'Item deleted',
              style: VooToastStyle.snackbar,
              duration: const Duration(seconds: 6),
              context: context,
              actions: [
                ToastAction(
                  label: 'Undo',
                  onPressed: () => VooToast.showSuccess(
                    message: 'Item restored',
                    style: VooToastStyle.snackbar,
                    context: context,
                  ),
                ),
              ],
            ),
          ),
          _ToastButton(
            label: 'Error',
            icon: Icons.error,
            color: Colors.red,
            onPressed: () => VooToast.showError(
              message: 'Failed to connect to server',
              style: VooToastStyle.snackbar,
              context: context,
              actions: [
                ToastAction(
                  label: 'Retry',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      );
}

class _ToastButton extends StatelessWidget {
  const _ToastButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 100,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
