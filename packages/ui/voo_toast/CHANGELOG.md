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