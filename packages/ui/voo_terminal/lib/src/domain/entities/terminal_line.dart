import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:voo_terminal/src/domain/enums/line_type.dart';

/// Represents a single line in the terminal.
///
/// Each line has content, a type that determines styling, and optional
/// metadata like timestamps and custom styling.
class TerminalLine extends Equatable {
  /// Unique identifier for this line.
  final String id;

  /// The text content of the line.
  final String content;

  /// The type of line, which determines default styling.
  final LineType type;

  /// When this line was created.
  final DateTime timestamp;

  /// Optional custom text color override.
  final Color? textColor;

  /// Optional custom background color override.
  final Color? backgroundColor;

  /// Optional custom font weight override.
  final FontWeight? fontWeight;

  /// Whether this line should be selectable.
  final bool isSelectable;

  /// Optional custom prefix to display before content.
  final String? prefix;

  /// Creates a terminal line.
  const TerminalLine({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.textColor,
    this.backgroundColor,
    this.fontWeight,
    this.isSelectable = true,
    this.prefix,
  });

  /// Creates a terminal line with auto-generated ID and current timestamp.
  factory TerminalLine.create({
    required String content,
    required LineType type,
    Color? textColor,
    Color? backgroundColor,
    FontWeight? fontWeight,
    bool isSelectable = true,
    String? prefix,
  }) {
    return TerminalLine(
      id: '${DateTime.now().microsecondsSinceEpoch}_${content.hashCode}',
      content: content,
      type: type,
      timestamp: DateTime.now(),
      textColor: textColor,
      backgroundColor: backgroundColor,
      fontWeight: fontWeight,
      isSelectable: isSelectable,
      prefix: prefix,
    );
  }

  /// Creates a standard output line.
  factory TerminalLine.output(String content, {Color? textColor}) {
    return TerminalLine.create(
      content: content,
      type: LineType.output,
      textColor: textColor,
    );
  }

  /// Creates an input line (user command).
  factory TerminalLine.input(String content, {String? prompt}) {
    return TerminalLine.create(
      content: content,
      type: LineType.input,
      prefix: prompt,
    );
  }

  /// Creates an error line.
  factory TerminalLine.error(String content) {
    return TerminalLine.create(
      content: content,
      type: LineType.error,
    );
  }

  /// Creates a warning line.
  factory TerminalLine.warning(String content) {
    return TerminalLine.create(
      content: content,
      type: LineType.warning,
    );
  }

  /// Creates a success line.
  factory TerminalLine.success(String content) {
    return TerminalLine.create(
      content: content,
      type: LineType.success,
    );
  }

  /// Creates a system message line.
  factory TerminalLine.system(String content) {
    return TerminalLine.create(
      content: content,
      type: LineType.system,
    );
  }

  /// Creates an info line.
  factory TerminalLine.info(String content) {
    return TerminalLine.create(
      content: content,
      type: LineType.info,
    );
  }

  /// Creates a debug line.
  factory TerminalLine.debug(String content) {
    return TerminalLine.create(
      content: content,
      type: LineType.debug,
    );
  }

  /// Gets the effective prefix for this line.
  String get effectivePrefix => prefix ?? type.defaultPrefix;

  /// Gets the full display text including prefix.
  String get displayText => '$effectivePrefix$content';

  /// Creates a copy of this line with the given fields replaced.
  TerminalLine copyWith({
    String? id,
    String? content,
    LineType? type,
    DateTime? timestamp,
    Color? textColor,
    Color? backgroundColor,
    FontWeight? fontWeight,
    bool? isSelectable,
    String? prefix,
  }) {
    return TerminalLine(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fontWeight: fontWeight ?? this.fontWeight,
      isSelectable: isSelectable ?? this.isSelectable,
      prefix: prefix ?? this.prefix,
    );
  }

  @override
  List<Object?> get props => [
        id,
        content,
        type,
        timestamp,
        textColor,
        backgroundColor,
        fontWeight,
        isSelectable,
        prefix,
      ];
}
