import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:voo_adaptive_overlay/voo_adaptive_overlay.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
import 'package:voo_data_grid/src/domain/entities/voo_filter_operator.dart';
import 'package:voo_data_grid/src/domain/entities/voo_filter_option.dart';
import 'package:voo_data_grid/src/domain/entities/voo_filter_widget_type.dart';
import 'package:voo_data_grid/src/utils/debouncer.dart';

/// A unified filter component for data grid filtering with consistent styling.
class VooDataGridFilter<T> extends StatefulWidget {
  final VooDataColumn<T> column;
  final VooDataFilter? currentFilter;
  final void Function(dynamic) onFilterChanged;
  final VoidCallback onFilterCleared;
  final Map<String, TextEditingController> textControllers;
  final Map<String, dynamic> dropdownValues;
  final Map<String, bool> checkboxValues;
  final List<VooFilterOption> Function(VooDataColumn<T>) getFilterOptions;

  const VooDataGridFilter({
    super.key,
    required this.column,
    this.currentFilter,
    required this.onFilterChanged,
    required this.onFilterCleared,
    required this.textControllers,
    required this.dropdownValues,
    required this.checkboxValues,
    required this.getFilterOptions,
  });

  @override
  State<VooDataGridFilter<T>> createState() => _VooDataGridFilterState<T>();
}

class _VooDataGridFilterState<T> extends State<VooDataGridFilter<T>> {
  late Debouncer _debouncer;

  // Consistent filter sizing for all filter types
  static const double _filterHeight = 36.0;
  static const double _fontSize = 13.0;
  static const double _iconSize = 16.0;
  static const double _borderRadius = 6.0;
  static const double _horizontalPadding = 10.0;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer();
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.column.filterBuilder != null) {
      return widget.column.filterBuilder!(
        context,
        widget.column,
        widget.currentFilter?.value,
        widget.onFilterChanged,
      );
    }

    switch (widget.column.effectiveFilterWidgetType) {
      case VooFilterWidgetType.textField:
        return _buildTextFilter(context);
      case VooFilterWidgetType.numberField:
        return _buildNumberFilter(context);
      case VooFilterWidgetType.numberRange:
        return _buildNumberRangeFilter(context);
      case VooFilterWidgetType.datePicker:
        return _buildDateFilter(context);
      case VooFilterWidgetType.dateRange:
        return _buildDateRangeFilter(context);
      case VooFilterWidgetType.dropdown:
        return _buildDropdownFilter(context);
      case VooFilterWidgetType.multiSelect:
        return _buildMultiSelectFilter(context);
      case VooFilterWidgetType.checkbox:
        return _buildCheckboxFilter(context);
      case VooFilterWidgetType.custom:
        return const SizedBox();
    }
  }

  /// Unified filter container that wraps all filter types
  Widget _filterContainer({
    required BuildContext context,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    return Container(
      height: _filterHeight,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: child,
    );
  }

  /// Consistent text style for all filter types
  TextStyle _filterTextStyle(BuildContext context, {bool isHint = false}) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: _fontSize,
      color: isHint ? theme.hintColor : theme.textTheme.bodyMedium?.color,
    );
  }

  Widget _buildClearButton(BuildContext context, VoidCallback onClear) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onClear,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Icon(Icons.clear, size: _iconSize, color: theme.hintColor),
      ),
    );
  }

  Widget _buildTextFilter(BuildContext context) {
    final controller = widget.textControllers.putIfAbsent(
      widget.column.field,
      () => TextEditingController(text: widget.currentFilter?.value?.toString() ?? ''),
    );

    return _filterContainer(
      context: context,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: widget.column.filterHint ?? 'Filter...',
                hintStyle: _filterTextStyle(context, isHint: true),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 8),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              style: _filterTextStyle(context),
              onChanged: (value) {
                _debouncer.run(() {
                  widget.onFilterChanged(value.isEmpty ? null : value);
                });
              },
            ),
          ),
          if (widget.currentFilter != null)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: _buildClearButton(context, () {
                controller.clear();
                widget.onFilterCleared();
              }),
            ),
        ],
      ),
    );
  }

  Widget _buildNumberFilter(BuildContext context) {
    final controller = widget.textControllers.putIfAbsent(
      widget.column.field,
      () => TextEditingController(text: widget.currentFilter?.value?.toString() ?? ''),
    );

    return _filterContainer(
      context: context,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: widget.column.filterHint ?? 'Filter...',
                hintStyle: _filterTextStyle(context, isHint: true),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 8),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              style: _filterTextStyle(context),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.-]'))],
              onChanged: (value) {
                _debouncer.run(() {
                  if (value.isEmpty) {
                    widget.onFilterChanged(null);
                  } else {
                    widget.onFilterChanged(num.tryParse(value));
                  }
                });
              },
            ),
          ),
          if (widget.currentFilter != null)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: _buildClearButton(context, () {
                controller.clear();
                widget.onFilterCleared();
              }),
            ),
        ],
      ),
    );
  }

  Widget _buildNumberRangeFilter(BuildContext context) {
    final minController = widget.textControllers.putIfAbsent(
      '${widget.column.field}_min',
      () => TextEditingController(text: widget.currentFilter?.value?.toString() ?? ''),
    );
    final maxController = widget.textControllers.putIfAbsent(
      '${widget.column.field}_max',
      () => TextEditingController(text: widget.currentFilter?.valueTo?.toString() ?? ''),
    );

    return Row(
      children: [
        Expanded(
          child: _filterContainer(
            context: context,
            child: TextField(
              controller: minController,
              decoration: InputDecoration(
                hintText: 'Min',
                hintStyle: _filterTextStyle(context, isHint: true),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 8),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              style: _filterTextStyle(context),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.-]'))],
              onChanged: (value) {
                widget.onFilterChanged({
                  'operator': VooFilterOperator.between,
                  'value': num.tryParse(value),
                  'valueTo': num.tryParse(maxController.text),
                });
              },
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: _filterContainer(
            context: context,
            child: TextField(
              controller: maxController,
              decoration: InputDecoration(
                hintText: 'Max',
                hintStyle: _filterTextStyle(context, isHint: true),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 8),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              style: _filterTextStyle(context),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.-]'))],
              onChanged: (value) {
                widget.onFilterChanged({
                  'operator': VooFilterOperator.between,
                  'value': num.tryParse(minController.text),
                  'valueTo': num.tryParse(value),
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateFilter(BuildContext context) {
    final theme = Theme.of(context);
    final controller = widget.textControllers.putIfAbsent(
      widget.column.field,
      () => TextEditingController(
        text: widget.currentFilter?.value != null ? _formatDate(widget.currentFilter!.value as DateTime) : '',
      ),
    );

    return _filterContainer(
      context: context,
      child: InkWell(
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate:
                widget.currentFilter?.value is DateTime ? widget.currentFilter!.value as DateTime : DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (date != null) {
            controller.text = _formatDate(date);
            widget.onFilterChanged(date);
          }
        },
        borderRadius: BorderRadius.circular(_borderRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  controller.text.isEmpty ? widget.column.filterHint ?? 'Filter...' : controller.text,
                  style: _filterTextStyle(context, isHint: controller.text.isEmpty),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.currentFilter != null)
                _buildClearButton(context, () {
                  controller.clear();
                  widget.onFilterCleared();
                })
              else
                Icon(Icons.calendar_today, size: _iconSize, color: theme.hintColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateRangeFilter(BuildContext context) {
    final theme = Theme.of(context);
    final displayText = widget.currentFilter?.value != null && widget.currentFilter?.valueTo != null
        ? '${_formatDate(widget.currentFilter!.value as DateTime)} - ${_formatDate(widget.currentFilter!.valueTo as DateTime)}'
        : '';

    return _filterContainer(
      context: context,
      child: InkWell(
        onTap: () async {
          final range = await showDateRangePicker(
            context: context,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (range != null) {
            widget.onFilterChanged({
              'operator': VooFilterOperator.between,
              'value': range.start,
              'valueTo': range.end,
            });
          }
        },
        borderRadius: BorderRadius.circular(_borderRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  displayText.isEmpty ? widget.column.filterHint ?? 'Filter...' : displayText,
                  style: _filterTextStyle(context, isHint: displayText.isEmpty),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.currentFilter != null)
                _buildClearButton(context, widget.onFilterCleared)
              else
                Icon(Icons.date_range, size: _iconSize, color: theme.hintColor),
            ],
          ),
        ),
      ),
    );
  }

  /// Get the anchor rect for popup positioning
  Rect _getAnchorRect(BuildContext context) {
    final box = context.findRenderObject();
    if (box is! RenderBox) return Rect.zero;
    final position = box.localToGlobal(Offset.zero);
    return Rect.fromLTWH(position.dx, position.dy, box.size.width, box.size.height);
  }

  Widget _buildDropdownFilter(BuildContext context) {
    final theme = Theme.of(context);
    final options = widget.getFilterOptions(widget.column);

    if (!widget.dropdownValues.containsKey(widget.column.field) && widget.currentFilter != null) {
      widget.dropdownValues[widget.column.field] = widget.currentFilter!.value;
    }

    final hasValue = widget.dropdownValues[widget.column.field] != null;
    final selectedLabel = hasValue
        ? options.where((o) => o.value == widget.dropdownValues[widget.column.field]).map((o) => o.label).firstOrNull
        : null;

    return _filterContainer(
      context: context,
      child: Builder(
        builder: (buttonContext) => InkWell(
          onTap: () async {
            final result = await VooAdaptiveOverlay.showPopup<dynamic>(
              context: buttonContext,
              anchorRect: _getAnchorRect(buttonContext),
              position: VooPopupPosition.below,
              maxHeight: 300,
              showArrow: false,
              actions: options
                  .map((option) => VooOverlayAction(
                        label: option.label,
                        onPressed: () => Navigator.pop(buttonContext, option.value),
                      ))
                  .toList(),
            );

            if (result != null) {
              setState(() {
                widget.dropdownValues[widget.column.field] = result;
              });
              widget.onFilterChanged(result);
            }
          },
          borderRadius: BorderRadius.circular(_borderRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedLabel ?? widget.column.filterHint ?? 'Filter...',
                    style: _filterTextStyle(context, isHint: !hasValue),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasValue)
                  _buildClearButton(context, () {
                    setState(() {
                      widget.dropdownValues.remove(widget.column.field);
                    });
                    widget.onFilterCleared();
                  })
                else
                  Icon(Icons.arrow_drop_down, size: 20, color: theme.hintColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMultiSelectFilter(BuildContext context) {
    final theme = Theme.of(context);
    final options = widget.getFilterOptions(widget.column);
    final selectedValues =
        widget.currentFilter?.value is List ? List<dynamic>.from(widget.currentFilter!.value as List) : <dynamic>[];

    final hasValue = selectedValues.isNotEmpty;

    return _filterContainer(
      context: context,
      child: Builder(
        builder: (buttonContext) => InkWell(
          onTap: () async {
            // Show multi-select popup with checkboxes
            await VooAdaptiveOverlay.show(
              context: buttonContext,
              title: Text(widget.column.label),
              config: const VooOverlayConfig(
                forceType: VooOverlayType.popup,
              ),
              builder: (ctx, scrollController) => SizedBox(
                width: 200,
                child: StatefulBuilder(
                  builder: (context, setDialogState) => ListView(
                    controller: scrollController,
                    shrinkWrap: true,
                    children: options
                        .map((option) => CheckboxListTile(
                              dense: true,
                              title: Text(option.label, style: _filterTextStyle(context)),
                              value: selectedValues.contains(option.value),
                              onChanged: (checked) {
                                setDialogState(() {
                                  if (checked == true) {
                                    selectedValues.add(option.value);
                                  } else {
                                    selectedValues.remove(option.value);
                                  }
                                });
                                setState(() {});
                                widget.onFilterChanged(selectedValues.isEmpty ? null : selectedValues);
                              },
                            ))
                        .toList(),
                  ),
                ),
              ),
              actions: [
                VooOverlayAction(
                  label: 'Done',
                  isPrimary: true,
                  onPressed: () => Navigator.pop(buttonContext),
                ),
              ],
            );
          },
          borderRadius: BorderRadius.circular(_borderRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    hasValue ? '${selectedValues.length} selected' : widget.column.filterHint ?? 'Filter...',
                    style: _filterTextStyle(context, isHint: !hasValue),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasValue)
                  _buildClearButton(context, widget.onFilterCleared)
                else
                  Icon(Icons.arrow_drop_down, size: 20, color: theme.hintColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckboxFilter(BuildContext context) {
    final theme = Theme.of(context);

    if (!widget.checkboxValues.containsKey(widget.column.field) && widget.currentFilter != null) {
      widget.checkboxValues[widget.column.field] = widget.currentFilter!.value == true;
    }

    final hasValue = widget.checkboxValues[widget.column.field] == true;

    return _filterContainer(
      context: context,
      child: InkWell(
        onTap: () {
          setState(() {
            if (hasValue) {
              widget.checkboxValues.remove(widget.column.field);
            } else {
              widget.checkboxValues[widget.column.field] = true;
            }
          });
          widget.onFilterChanged(hasValue ? null : true);
        },
        borderRadius: BorderRadius.circular(_borderRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  hasValue ? 'Yes' : widget.column.filterHint ?? 'Filter...',
                  style: _filterTextStyle(context, isHint: !hasValue),
                ),
              ),
              if (hasValue)
                _buildClearButton(context, () {
                  setState(() {
                    widget.checkboxValues.remove(widget.column.field);
                  });
                  widget.onFilterCleared();
                })
              else
                Icon(Icons.check_box_outline_blank, size: _iconSize, color: theme.hintColor),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
}
