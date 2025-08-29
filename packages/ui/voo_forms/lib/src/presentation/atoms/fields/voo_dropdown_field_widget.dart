import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

typedef AsyncOptionsLoader<T> = Future<List<VooFieldOption<T>>> Function(String query);

class VooDropdownFieldWidget<T> extends StatefulWidget {
  final VooFormField<T> field;
  final ValueChanged<T?>? onChanged;
  final String? error;
  final bool showError;

  const VooDropdownFieldWidget({
    super.key,
    required this.field,
    this.onChanged,
    this.error,
    this.showError = true,
  });

  @override
  State<VooDropdownFieldWidget<T>> createState() => _VooDropdownFieldWidgetState<T>();
}

class _VooDropdownFieldWidgetState<T> extends State<VooDropdownFieldWidget<T>> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _isOpen = false;
  final TextEditingController _searchController = TextEditingController();
  List<VooFieldOption<T>> _filteredOptions = [];
  List<VooFieldOption<T>> _allOptions = [];
  bool _isLoading = false;
  String _lastQuery = '';
  DateTime _lastSearchTime = DateTime.now();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _focusNode = widget.field.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    _allOptions = widget.field.options ?? [];
    _filteredOptions = _allOptions;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _removeOverlay();
    if (widget.field.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_handleFocusChange);
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isOpen = false;
    });
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _removeOverlay,
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 8),
                child: _buildDropdownMenu(),
              ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });

    if (widget.field.asyncOptionsLoader != null && _allOptions.isEmpty) {
      _loadAsyncOptions('');
    }
  }

  Widget _buildDropdownMenu() {
    final design = context.vooDesign;
    final theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(
        maxHeight: 300,
        maxWidth: 400,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(design.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.field.enableSearch) ...[
            Container(
              padding: EdgeInsets.all(design.spacingMd),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: widget.field.searchHint ?? 'Search...',
                  prefixIcon: Icon(
                    Icons.search,
                    size: design.iconSizeMd,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            size: design.iconSizeSm,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(design.radiusSm),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(design.radiusSm),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: design.spacingMd,
                    vertical: design.spacingSm,
                  ),
                  isDense: true,
                ),
                onChanged: _onSearchChanged,
              ),
            ),
          ],
          Flexible(
            child: _buildItemsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    final design = context.vooDesign;
    final theme = Theme.of(context);

    if (_isLoading) {
      return Container(
        padding: EdgeInsets.all(design.spacingXl),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_filteredOptions.isEmpty) {
      return Container(
        padding: EdgeInsets.all(design.spacingXl),
        child: Center(
          child: Text(
            'No results found',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: design.spacingSm),
      itemCount: _filteredOptions.length,
      itemBuilder: (context, index) {
        final option = _filteredOptions[index];
        final isSelected = option.value == widget.field.value;

        return InkWell(
          onTap: option.enabled
              ? () {
                  widget.onChanged?.call(option.value);
                  widget.field.onChanged?.call(option.value);
                  _removeOverlay();
                  _searchController.clear();
                }
              : null,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: design.spacingLg,
              vertical: design.spacingMd,
            ),
            color: isSelected
                ? theme.colorScheme.primaryContainer.withValues(alpha: 0.2)
                : null,
            child: Row(
              children: [
                if (option.icon != null) ...[
                  Icon(
                    option.icon,
                    size: design.iconSizeMd,
                    color: option.enabled
                        ? (isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface)
                        : theme.colorScheme.onSurface.withValues(alpha: 0.38),
                  ),
                  SizedBox(width: design.spacingSm),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        option.label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: option.enabled
                              ? (isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface)
                              : theme.colorScheme.onSurface.withValues(alpha: 0.38),
                          fontWeight: isSelected ? FontWeight.w500 : null,
                        ),
                      ),
                      if (option.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          option.subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check,
                    size: design.iconSizeMd,
                    color: theme.colorScheme.primary,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onSearchChanged(String query) {
    if (widget.field.asyncOptionsLoader != null) {
      final now = DateTime.now();
      final searchDebounce = widget.field.searchDebounce ?? const Duration(milliseconds: 300);
      final minSearchLength = widget.field.minSearchLength ?? 0;
      
      if (now.difference(_lastSearchTime) < searchDebounce && query.length >= minSearchLength) {
        Future.delayed(searchDebounce).then((_) {
          if (_searchController.text == query && query != _lastQuery) {
            _loadAsyncOptions(query);
          }
        });
      } else if (query.length >= minSearchLength) {
        _loadAsyncOptions(query);
      }
      _lastSearchTime = now;
    } else {
      setState(() {
        if (query.isEmpty) {
          _filteredOptions = _allOptions;
        } else {
          _filteredOptions = _allOptions.where((option) {
            return option.label.toLowerCase().contains(query.toLowerCase()) ||
                (option.subtitle?.toLowerCase().contains(query.toLowerCase()) ?? false);
          }).toList();
        }
      });
    }
  }

  Future<void> _loadAsyncOptions(String query) async {
    if (_isLoading && query == _lastQuery) return;

    setState(() {
      _isLoading = true;
      _lastQuery = query;
    });

    try {
      final options = await widget.field.asyncOptionsLoader!(query);
      if (mounted) {
        setState(() {
          _allOptions = options;
          _filteredOptions = options;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _filteredOptions = [];
          _isLoading = false;
        });
      }
    }
  }

  VooFieldOption<T>? _getSelectedOption() {
    if (widget.field.value == null) return null;
    try {
      return _allOptions.firstWhere((option) => option.value == widget.field.value);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);
    final errorText = widget.showError ? (widget.error ?? widget.field.error) : null;
    final hasError = errorText != null && errorText.isNotEmpty;

    // Use searchable dropdown if search is enabled or async loader is provided
    if (widget.field.enableSearch || widget.field.asyncOptionsLoader != null) {
      final selectedOption = _getSelectedOption();

      Color borderColor;
      if (!widget.field.enabled) {
        borderColor = theme.colorScheme.outline.withValues(alpha: 0.3);
      } else if (hasError) {
        borderColor = theme.colorScheme.error;
      } else if (_isFocused || _isOpen) {
        borderColor = theme.colorScheme.primary;
      } else {
        borderColor = theme.colorScheme.outline;
      }

      return CompositedTransformTarget(
        link: _layerLink,
        child: AnimatedContainer(
          duration: design.animationDurationFast,
          curve: design.animationCurve,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.field.label != null) ...[
                Text(
                  widget.field.label!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: hasError
                        ? theme.colorScheme.error
                        : (_isFocused || _isOpen)
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                    fontWeight: (_isFocused || _isOpen) ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
                SizedBox(height: design.spacingXs),
              ],
              InkWell(
                onTap: widget.field.enabled && !widget.field.readOnly
                    ? () {
                        if (_isOpen) {
                          _removeOverlay();
                        } else {
                          _showOverlay();
                        }
                      }
                    : null,
                borderRadius: BorderRadius.circular(design.radiusMd),
                child: Container(
                  height: design.inputHeight,
                  padding: EdgeInsets.symmetric(
                    horizontal: design.spacingLg,
                  ),
                  decoration: BoxDecoration(
                    color: widget.field.enabled
                        ? theme.colorScheme.surface
                        : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(design.radiusMd),
                    border: Border.all(
                      color: borderColor,
                      width: (_isFocused || _isOpen) ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      if (widget.field.prefixIcon != null) ...[
                        Icon(
                          widget.field.prefixIcon,
                          size: design.iconSizeMd,
                          color: (_isFocused || _isOpen)
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(width: design.spacingMd),
                      ],
                      Expanded(
                        child: selectedOption != null
                            ? Row(
                                children: [
                                  if (selectedOption.icon != null) ...[
                                    Icon(
                                      selectedOption.icon,
                                      size: design.iconSizeMd,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                    SizedBox(width: design.spacingSm),
                                  ],
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          selectedOption.label,
                                          style: theme.textTheme.bodyMedium,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (selectedOption.subtitle != null) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            selectedOption.subtitle!,
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: theme.colorScheme.onSurfaceVariant,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                widget.field.hint ?? '',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                                ),
                              ),
                      ),
                      Icon(
                        _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                        color: widget.field.enabled
                            ? theme.colorScheme.onSurfaceVariant
                            : theme.colorScheme.onSurface.withValues(alpha: 0.38),
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.field.helper != null || errorText != null) ...[
                SizedBox(height: design.spacingXs),
                Text(
                  errorText ?? widget.field.helper ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: hasError ? theme.colorScheme.error : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // Regular dropdown without search - use VooDropdown from voo_ui_core
    final items = widget.field.options?.map<VooDropdownItem<T>>((option) {
          return VooDropdownItem<T>(
            value: option.value,
            label: option.label,
            subtitle: option.subtitle,
            icon: option.icon,
            enabled: option.enabled,
          );
        }).toList() ??
        [];

    return VooDropdown<T>(
      value: widget.field.value,
      items: items,
      onChanged: widget.field.enabled && !widget.field.readOnly
          ? (value) {
              widget.onChanged?.call(value);
              widget.field.onChanged?.call(value);
            }
          : null,
      label: widget.field.label,
      hint: widget.field.hint,
      helper: widget.field.helper,
      error: errorText,
      prefixIcon: widget.field.prefixIcon,
      enabled: widget.field.enabled && !widget.field.readOnly,
    );
  }
}