# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-11-24

### Added
- Initial release of voo_terminal package
- `VooTerminal` widget for interactive terminal interfaces
- `VooTerminalPreview` widget for read-only terminal displays
- Multiple terminal modes: preview, interactive, and hybrid
- `TerminalController` for programmatic control
- `TerminalLine` entity with factory constructors for different line types
- `TerminalCommand` entity for registering custom commands
- `TerminalConfig` for terminal configuration
- `VooTerminalTheme` with preset themes:
  - Classic (green on black)
  - Modern (clean, theme-aware)
  - Retro (CRT scanline effect)
  - Matrix (animated rain effect)
  - Amber (amber phosphor)
  - Ubuntu (Ubuntu terminal style)
- Built-in commands: clear, help, history, echo
- Command history with arrow key navigation
- Auto-scroll behavior
- Accessibility support with semantic labels
