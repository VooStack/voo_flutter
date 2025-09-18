import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_data_grid/src/utils/debouncer.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// An optimized page input field that manages its own TextEditingController
class PageInputField extends StatefulWidget {
  final int currentPage;
  final int totalPages;
  final void Function(int page) onPageChanged;
  
  /// Whether to use debouncing for input changes (if onChanged is used in future)
  final bool useDebouncing;
  
  /// Debounce duration in milliseconds
  final Duration debounceDuration;

  const PageInputField({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.useDebouncing = true,
    this.debounceDuration = const Duration(milliseconds: 500),
  });

  @override
  State<PageInputField> createState() => _PageInputFieldState();
}

class _PageInputFieldState extends State<PageInputField> {
  late TextEditingController _controller;
  late Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${widget.currentPage + 1}');
    _debouncer = Debouncer(duration: widget.debounceDuration);
  }

  @override
  void didUpdateWidget(PageInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPage != widget.currentPage) {
      _controller.text = '${widget.currentPage + 1}';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _debouncer.dispose();
    super.dispose();
  }
  
  void _handleSubmit(String value) {
    final page = int.tryParse(value);
    if (page != null && page > 0 && page <= widget.totalPages) {
      widget.onPageChanged(page - 1);
    } else {
      // Reset to current page if invalid
      _controller.text = '${widget.currentPage + 1}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    return SizedBox(
      width: 60,
      child: TextField(
        controller: _controller,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: design.spacingSm,
            vertical: design.spacingXs,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(design.radiusSm),
          ),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onSubmitted: _handleSubmit,
      ),
    );
  }
}