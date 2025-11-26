# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.2] - 2025-11-26

### Added
- Undo/redo support with configurable history size (default 50 states)
- Keyboard shortcuts: Ctrl/Cmd+Z (undo), Ctrl/Cmd+Shift+Z or Ctrl/Cmd+Y (redo)
- Marquee selection with Shift+drag to select multiple nodes and connections
- Connection clicking and selection support
- Ctrl/Cmd+A to select all nodes
- Shift+click for multi-select on nodes
- Port color customization with `highlightColor` and `connectedColor` on `NodePort`
- Port hover effects with animated visual feedback
- `portHitTolerance` and `portHighlightColor` config options
- `connectionHitTolerance` config for easier connection clicking

## [0.1.1] - 2025-11-23

### Fixed
- Snap-to-grid now works smoothly by tracking raw position during drag operations
- Connection line now follows cursor correctly at all zoom levels
- Node dragging responds correctly at all zoom levels

## [0.0.1] - 2024-11-23

### Added
- Initial release of voo_node_canvas
- Infinite canvas with pan and zoom support
- Draggable nodes with customizable content
- Input/output ports for node connections
- Bezier curve connections between nodes
- Grid background with snap-to-grid support
- Canvas configuration options
- Canvas controller for state management
