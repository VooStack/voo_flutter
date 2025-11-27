/// Adaptive overlay system for Flutter that automatically shows modals,
/// bottom sheets, or side sheets based on screen size.
///
/// This package provides a single, developer-friendly API for showing
/// contextual overlays that adapt to the user's screen size.
///
/// ## Basic Usage
///
/// ```dart
/// // Simple usage - automatically picks the right overlay type
/// await VooAdaptiveOverlay.show(
///   context: context,
///   title: Text('Confirm'),
///   content: Text('Are you sure?'),
///   actions: [
///     VooOverlayAction.cancel(),
///     VooOverlayAction.confirm(onPressed: () => Navigator.pop(context, true)),
///   ],
/// );
///
/// // Or use the extension method
/// await context.showAdaptiveOverlay(
///   title: Text('Settings'),
///   content: SettingsWidget(),
/// );
/// ```
///
/// ## Responsive Behavior
///
/// - **Mobile (<600px)**: Shows as a bottom sheet
/// - **Tablet (600-1024px)**: Shows as a centered modal dialog
/// - **Desktop (>1024px)**: Shows as a side sheet or modal (configurable)
///
/// ## Overlay Types
///
/// - `bottomSheet` - Slides up from the bottom
/// - `modal` - Centered dialog
/// - `sideSheet` - Slides in from the side
/// - `fullscreen` - Covers the entire screen
/// - `drawer` - Slides in from left/right
/// - `actionSheet` - iOS-style action list
/// - `snackbar` - Bottom notification with action
///
/// ## Style Presets
///
/// - `material` - Standard Material Design 3
/// - `cupertino` - iOS-style with blur and rounded corners
/// - `glass` - Glassmorphism with frosted glass effect
/// - `minimal` - Clean, borderless design
/// - `outlined` - Modern outlined style
/// - `elevated` - Strong shadow elevation
/// - `soft` - Soft pastel colors
/// - `dark` - Dark mode optimized
/// - `gradient` - Gradient background
/// - `neumorphic` - Soft 3D shadows
/// - `custom` - Full customization
library voo_adaptive_overlay;

// Domain - Enums
export 'package:voo_adaptive_overlay/src/domain/enums/overlay_style.dart';
export 'package:voo_adaptive_overlay/src/domain/enums/overlay_type.dart';
export 'package:voo_adaptive_overlay/src/domain/enums/swipe_direction.dart';

// Domain - Entities
export 'package:voo_adaptive_overlay/src/domain/entities/overlay_action.dart';
export 'package:voo_adaptive_overlay/src/domain/entities/overlay_behavior.dart';
export 'package:voo_adaptive_overlay/src/domain/entities/overlay_breakpoints.dart';
export 'package:voo_adaptive_overlay/src/domain/entities/overlay_config.dart';
export 'package:voo_adaptive_overlay/src/domain/entities/overlay_constraints.dart';
export 'package:voo_adaptive_overlay/src/domain/entities/overlay_style_data.dart';

// Presentation - Organisms (Main widgets)
export 'package:voo_adaptive_overlay/src/presentation/organisms/voo_action_sheet.dart';
export 'package:voo_adaptive_overlay/src/presentation/organisms/voo_adaptive_overlay.dart';
export 'package:voo_adaptive_overlay/src/presentation/organisms/voo_alert.dart';
export 'package:voo_adaptive_overlay/src/presentation/organisms/voo_banner.dart';
export 'package:voo_adaptive_overlay/src/presentation/organisms/voo_bottom_sheet.dart';
export 'package:voo_adaptive_overlay/src/presentation/organisms/voo_drawer.dart';
export 'package:voo_adaptive_overlay/src/presentation/organisms/voo_fullscreen_overlay.dart';
export 'package:voo_adaptive_overlay/src/presentation/organisms/voo_modal_dialog.dart';
export 'package:voo_adaptive_overlay/src/presentation/organisms/voo_popup.dart';
export 'package:voo_adaptive_overlay/src/presentation/organisms/voo_side_sheet.dart';
export 'package:voo_adaptive_overlay/src/presentation/organisms/voo_snackbar.dart';
export 'package:voo_adaptive_overlay/src/presentation/organisms/voo_tooltip.dart';

// Presentation - Styles
export 'package:voo_adaptive_overlay/src/presentation/styles/base_overlay_style.dart';

// Presentation - Utilities
export 'package:voo_adaptive_overlay/src/presentation/utils/overlay_extensions.dart';
