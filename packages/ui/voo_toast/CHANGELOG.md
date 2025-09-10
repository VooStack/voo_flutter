## [0.0.3] - 2024-01-10

### Added
- **FutureToast feature**: New `showFutureToast` method that accepts a Future and displays loading/success/error toasts
  - Shows loading toast while Future is executing
  - Optionally shows success toast on completion with access to result data
  - Shows error toast on failure with access to error object
  - Returns the Future's result
  - Success/error message callbacks receive the actual result/error for dynamic messages
  - All parameters are optional with sensible defaults (follows KISS principle)
- Loading indicator support in toast cards with new `isLoading` property
- `VooLoadingIndicator` atom component for displaying loading state
- Multiple example implementations showing Future toast with success and error cases

### Fixed
- Fixed production error where dismissing non-existent toasts would throw an exception
  - `dismiss` method now fails silently when toast ID not found
  - Prevents race conditions when timers try to dismiss already-dismissed toasts

### Changed
- Updated `Toast` entity to support loading state
- Enhanced `VooToastCard` to display loading indicators
- Updated repository implementation for more robust toast dismissal

## [0.0.2] - 2024-01-09

### Added
- Initial published version with complete toast functionality
- Platform-aware positioning system
- Rich customization options
- Queue management
- Multiple animation types

## [0.0.1] - 2024-01-09

### Added
- Initial release of VooToast package
- Global toast notification system with `VooToast` singleton
- Clean architecture implementation with Domain, Data, and Presentation layers
- Atomic design pattern for UI components
- Multiple toast types: success, error, warning, info, and custom
- Rich customization options:
  - Custom colors, icons, and styling
  - Configurable duration and animations
  - Action buttons for interactive toasts
  - Custom content support
- Platform-aware positioning:
  - Mobile: Bottom position by default
  - Tablet/Web: Top-right position by default
  - Automatic responsive adjustments based on screen size
- Smart queue management with configurable max toasts
- Multiple animation types:
  - Fade in/out
  - Slide from top/bottom/left/right
  - Scale animation
  - Bounce effect
  - Rotation animation
- Toast features:
  - Titles and messages
  - Progress bars for timed toasts
  - Dismissible toasts with swipe/tap
  - Priority-based ordering
  - Duplicate prevention option
- `VooToastOverlay` widget for app-wide integration
- `ToastConfig` for global configuration
- Comprehensive example application
- Full documentation with CLAUDE.md
- MIT License

### Dependencies
- flutter SDK
- equatable: ^2.0.5
- flutter_hooks: ^0.20.5
- collection: ^1.18.0
- rxdart: ^0.28.0