# VooTerminal

A powerful terminal/console UI component for Flutter with multiple display modes, theming, and command support.

## Features

- **Multiple Display Modes**: Preview (read-only), Interactive (typing), and Hybrid
- **Command System**: Customizable commands with history and auto-completion
- **Theme Presets**: Classic, Modern, Retro CRT, Matrix, Amber, Ubuntu
- **Developer-Friendly API**: Factory constructors for common use cases
- **VooFlutter Integration**: Uses voo_tokens and voo_ui_core

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  voo_terminal: ^0.1.0
```

## Quick Start

### Preview Terminal (Read-only)

Display logs, outputs, or status messages:

```dart
VooTerminalPreview(
  lines: [
    TerminalLine.output('Server started on port 8080'),
    TerminalLine.success('✓ Connected to database'),
    TerminalLine.error('✗ Failed to load config'),
    TerminalLine.warning('⚠ Cache cleared'),
  ],
  theme: VooTerminalTheme.modern(),
)
```

### Interactive Terminal

Create a fully interactive command-line interface:

```dart
final controller = TerminalController();

VooTerminal(
  controller: controller,
  config: TerminalConfig(
    mode: TerminalMode.interactive,
    maxLines: 1000,
    showTimestamps: true,
  ),
  theme: VooTerminalTheme.classic(),
  commands: [
    TerminalCommand(
      name: 'greet',
      description: 'Greet a user',
      handler: (args) => 'Hello, ${args.join(' ')}!',
    ),
  ],
)
```

### Factory Constructors

```dart
// Simple preview
VooTerminal.preview(lines: [...])

// Interactive with commands
VooTerminal.interactive(commands: [...])

// Stream-based output
VooTerminal.stream(stream: logStream)
```

## Terminal Modes

| Mode | Description |
|------|-------------|
| `preview` | Read-only display of lines |
| `interactive` | Full typing with command input |
| `hybrid` | Scrollable output with fixed input |

## Theme Presets

```dart
VooTerminalTheme.classic()    // Green text on black
VooTerminalTheme.modern()     // Clean, theme-aware
VooTerminalTheme.retro()      // CRT scanline effect
VooTerminalTheme.matrix()     // Animated rain effect
VooTerminalTheme.amber()      // Amber phosphor look
VooTerminalTheme.ubuntu()     // Ubuntu terminal style
```

## Custom Theme

```dart
VooTerminalTheme(
  backgroundColor: Color(0xFF1E1E1E),
  textColor: Color(0xFF00FF00),
  cursorColor: Color(0xFF00FF00),
  errorColor: Color(0xFFFF6B6B),
  successColor: Color(0xFF4ECDC4),
  fontFamily: 'JetBrains Mono',
  fontSize: 14.0,
  enableGlow: true,
  enableScanlines: false,
)
```

## TerminalController API

```dart
final controller = TerminalController();

// Write lines
controller.writeLine('Hello');
controller.writeError('Error!');
controller.writeSuccess('Done!');
controller.writeWarning('Warning');
controller.writeSystem('System message');

// Control
controller.clear();
controller.scrollToBottom();

// History
print(controller.commandHistory);
controller.clearHistory();
```

## Line Types

```dart
TerminalLine.output('Normal output')
TerminalLine.error('Error message')
TerminalLine.success('Success message')
TerminalLine.warning('Warning message')
TerminalLine.system('System message')
TerminalLine.info('Info message')
TerminalLine.input('> command')
```

## Built-in Commands

- `clear` - Clear the terminal
- `help` - Show available commands
- `history` - Show command history
- `echo <text>` - Echo text back

## Configuration

```dart
TerminalConfig(
  mode: TerminalMode.interactive,
  maxLines: 1000,
  showTimestamps: true,
  enableHistory: true,
  historySize: 100,
  autoScroll: true,
  prompt: '$ ',
)
```

## Accessibility

- Full keyboard navigation
- Screen reader support
- High contrast themes
- Customizable text sizing

## License

MIT License - see LICENSE file for details.
