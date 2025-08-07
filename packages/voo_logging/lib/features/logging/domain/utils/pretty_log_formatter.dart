import 'dart:io';
import 'package:voo_logging/voo_logging.dart';

class PrettyLogFormatter {
  final bool enabled;
  final bool showEmojis;
  final bool showTimestamp;
  final bool showColors;
  final bool showBorders;
  final int lineLength;
  
  const PrettyLogFormatter({
    this.enabled = true,
    this.showEmojis = true,
    this.showTimestamp = true,
    this.showColors = true,
    this.showBorders = true,
    this.lineLength = 120,
  });

  String format(LogEntry entry) {
    if (!enabled) {
      return _formatSimple(entry);
    }
    
    return _formatPretty(entry);
  }

  String _formatSimple(LogEntry entry) {
    final buffer = StringBuffer();
    
    if (showTimestamp) {
      buffer.write('[${_formatTimestamp(entry.timestamp)}] ');
    }
    
    buffer.write('[${entry.level.name.toUpperCase()}] ');
    
    if (entry.category != null) {
      buffer.write('[${entry.category}] ');
    }
    
    if (entry.tag != null) {
      buffer.write('[${entry.tag}] ');
    }
    
    buffer.write(entry.message);
    
    if (entry.error != null) {
      buffer.write(' | Error: ${entry.error}');
    }
    
    return buffer.toString();
  }

  String _formatPretty(LogEntry entry) {
    final buffer = StringBuffer();
    final color = _getAnsiColor(entry.level);
    const resetColor = '\x1B[0m';
    const boldColor = '\x1B[1m';
    
    // Top border
    if (showBorders) {
      buffer.writeln(_createBorder('┌', '─', '┐', color));
    }
    
    // Header line with emoji, level, timestamp
    buffer.write(showColors ? color : '');
    
    if (showBorders) {
      buffer.write('│ ');
    }
    
    if (showEmojis) {
      buffer.write('${entry.level.icon}  ');
    }
    
    buffer.write(showColors ? boldColor : '');
    buffer.write(entry.level.name.toUpperCase().padRight(7));
    buffer.write(showColors ? resetColor : '');
    buffer.write(showColors ? color : '');
    
    if (showTimestamp) {
      buffer.write(' │ ${_formatTimestamp(entry.timestamp)}');
    }
    
    if (entry.category != null || entry.tag != null) {
      buffer.write(' │ ');
      if (entry.category != null) {
        buffer.write('[${entry.category}]');
      }
      if (entry.tag != null) {
        buffer.write('[${entry.tag}]');
      }
    }
    
    if (showBorders) {
      final headerLength = _stripAnsi(buffer.toString().split('\n').last).length;
      final padding = lineLength - headerLength - 1;
      if (padding > 0) {
        buffer.write(' ' * padding);
      }
      buffer.write('│');
    }
    
    buffer.writeln(showColors ? resetColor : '');
    
    // Message section
    if (showBorders) {
      buffer.writeln(_createBorder('├', '─', '┤', color));
    }
    
    // Wrap and format message
    final messageLines = _wrapText(entry.message, lineLength - 4);
    for (final line in messageLines) {
      buffer.write(showColors ? color : '');
      if (showBorders) {
        buffer.write('│ ');
      }
      buffer.write(line);
      if (showBorders) {
        final lineLength = _stripAnsi(line).length;
        final padding = this.lineLength - lineLength - 4;
        if (padding > 0) {
          buffer.write(' ' * padding);
        }
        buffer.write(' │');
      }
      buffer.writeln(showColors ? resetColor : '');
    }
    
    // Metadata section
    if (entry.metadata != null && entry.metadata!.isNotEmpty) {
      if (showBorders) {
        buffer.writeln(_createBorder('├', '─', '┤', color));
      }
      
      buffer.write(showColors ? color : '');
      if (showBorders) {
        buffer.write('│ ');
      }
      buffer.write('📊 Metadata:');
      if (showBorders) {
        final padding = lineLength - 14;
        if (padding > 0) {
          buffer.write(' ' * padding);
        }
        buffer.write(' │');
      }
      buffer.writeln(showColors ? resetColor : '');
      
      entry.metadata!.forEach((key, value) {
        final metadataLine = '  • $key: $value';
        final wrappedLines = _wrapText(metadataLine, lineLength - 4);
        for (final line in wrappedLines) {
          buffer.write(showColors ? color : '');
          if (showBorders) {
            buffer.write('│ ');
          }
          buffer.write(line);
          if (showBorders) {
            final lineLength = _stripAnsi(line).length;
            final padding = this.lineLength - lineLength - 4;
            if (padding > 0) {
              buffer.write(' ' * padding);
            }
            buffer.write(' │');
          }
          buffer.writeln(showColors ? resetColor : '');
        }
      });
    }
    
    // Error section
    if (entry.error != null) {
      if (showBorders) {
        buffer.writeln(_createBorder('├', '─', '┤', color));
      }
      
      final errorColor = showColors ? '\x1B[91m' : ''; // Bright red
      buffer.write(errorColor);
      if (showBorders) {
        buffer.write('│ ');
      }
      buffer.write('❗ Error: ${entry.error}');
      if (showBorders) {
        final errorMsg = 'Error: ${entry.error}';
        final padding = lineLength - errorMsg.length - 6;
        if (padding > 0) {
          buffer.write(' ' * padding);
        }
        buffer.write(' │');
      }
      buffer.writeln(showColors ? resetColor : '');
      
      if (entry.stackTrace != null) {
        final stackLines = entry.stackTrace!.split('\n').take(5);
        for (final line in stackLines) {
          final trimmedLine = line.trim();
          if (trimmedLine.isNotEmpty) {
            buffer.write(showColors ? color : '');
            if (showBorders) {
              buffer.write('│   ');
            } else {
              buffer.write('   ');
            }
            final wrappedLines = _wrapText(trimmedLine, lineLength - 6);
            for (int i = 0; i < wrappedLines.length; i++) {
              if (i > 0) {
                buffer.write(showColors ? color : '');
                if (showBorders) {
                  buffer.write('│     ');
                } else {
                  buffer.write('     ');
                }
              }
              buffer.write(wrappedLines[i]);
              if (showBorders) {
                final lineLength = _stripAnsi(wrappedLines[i]).length + (i > 0 ? 5 : 3);
                final padding = this.lineLength - lineLength - 2;
                if (padding > 0) {
                  buffer.write(' ' * padding);
                }
                buffer.write(' │');
              }
              if (i < wrappedLines.length - 1) {
                buffer.writeln(showColors ? resetColor : '');
              }
            }
            buffer.writeln(showColors ? resetColor : '');
          }
        }
      }
    }
    
    // Bottom border
    if (showBorders) {
      buffer.writeln(_createBorder('└', '─', '┘', color));
    }
    
    return buffer.toString();
  }

  String _createBorder(String left, String middle, String right, String color) {
    const resetColor = '\x1B[0m';
    final borderLine = '$left${middle * (lineLength - 2)}$right';
    return showColors ? '$color$borderLine$resetColor' : borderLine;
  }

  List<String> _wrapText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return [text];
    }
    
    final lines = <String>[];
    final words = text.split(' ');
    var currentLine = '';
    
    for (final word in words) {
      if (currentLine.isEmpty) {
        currentLine = word;
      } else if ((currentLine.length + word.length + 1) <= maxLength) {
        currentLine += ' $word';
      } else {
        lines.add(currentLine);
        currentLine = word;
      }
    }
    
    if (currentLine.isNotEmpty) {
      lines.add(currentLine);
    }
    
    return lines;
  }

  String _stripAnsi(String text) => text.replaceAll(RegExp(r'\x1B\[[0-9;]*m'), '');

  String _getAnsiColor(LogLevel level) {
    if (!showColors || !_supportsAnsiColors()) {
      return '';
    }
    
    switch (level) {
      case LogLevel.verbose:
        return '\x1B[90m'; // Bright black (gray)
      case LogLevel.debug:
        return '\x1B[36m'; // Cyan
      case LogLevel.info:
        return '\x1B[32m'; // Green
      case LogLevel.warning:
        return '\x1B[33m'; // Yellow
      case LogLevel.error:
        return '\x1B[31m'; // Red
      case LogLevel.fatal:
        return '\x1B[35m'; // Magenta
    }
  }

  bool _supportsAnsiColors() {
    if (Platform.isAndroid || Platform.isIOS) {
      return false;
    }
    
    // Check if we're in a terminal that supports colors
    final term = Platform.environment['TERM'];
    if (term == null || term == 'dumb') {
      return false;
    }
    
    // Check for common CI environments that might not support colors
    final ci = Platform.environment['CI'];
    if (ci == 'true') {
      return false;
    }
    
    return stdout.supportsAnsiEscapes;
  }

  String _formatTimestamp(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final second = timestamp.second.toString().padLeft(2, '0');
    final millisecond = timestamp.millisecond.toString().padLeft(3, '0');
    return '$hour:$minute:$second.$millisecond';
  }
}