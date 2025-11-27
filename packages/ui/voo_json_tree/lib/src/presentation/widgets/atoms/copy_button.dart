import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A small button for copying content to clipboard.
class CopyButton extends StatefulWidget {
  /// Creates a new [CopyButton].
  const CopyButton({super.key, required this.content, this.color, this.size = 14.0, this.tooltip = 'Copy to clipboard', this.onCopied});

  /// The content to copy to clipboard.
  final String content;

  /// The color of the icon.
  final Color? color;

  /// The size of the icon.
  final double size;

  /// Tooltip text.
  final String tooltip;

  /// Callback when content is copied.
  final VoidCallback? onCopied;

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  bool _copied = false;

  Future<void> _handleCopy() async {
    await Clipboard.setData(ClipboardData(text: widget.content));

    setState(() => _copied = true);
    widget.onCopied?.call();

    await Future<void>.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _copied = false);
    }
  }

  @override
  Widget build(BuildContext context) => Tooltip(
    message: _copied ? 'Copied!' : widget.tooltip,
    child: InkWell(
      onTap: _handleCopy,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Icon(
          _copied ? Icons.check : Icons.copy,
          size: widget.size,
          color: _copied ? Colors.green : (widget.color ?? Theme.of(context).iconTheme.color?.withOpacity(0.6)),
        ),
      ),
    ),
  );
}
