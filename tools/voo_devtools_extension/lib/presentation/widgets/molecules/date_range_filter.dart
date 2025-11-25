import 'package:flutter/material.dart';
import 'package:voo_devtools_extension/presentation/theme/app_theme.dart';

/// Quick date range presets for filtering
enum DateRangePreset {
  lastHour('Last hour', Duration(hours: 1)),
  last6Hours('Last 6 hours', Duration(hours: 6)),
  last24Hours('Last 24 hours', Duration(hours: 24)),
  last7Days('Last 7 days', Duration(days: 7)),
  last30Days('Last 30 days', Duration(days: 30)),
  custom('Custom', Duration.zero);

  final String label;
  final Duration duration;

  const DateRangePreset(this.label, this.duration);
}

/// A compact date range filter widget with quick presets
class DateRangeFilter extends StatefulWidget {
  final DateTimeRange? selectedRange;
  final ValueChanged<DateTimeRange?> onRangeChanged;
  final bool compact;

  const DateRangeFilter({
    super.key,
    this.selectedRange,
    required this.onRangeChanged,
    this.compact = true,
  });

  @override
  State<DateRangeFilter> createState() => _DateRangeFilterState();
}

class _DateRangeFilterState extends State<DateRangeFilter> {
  DateRangePreset? _selectedPreset;

  @override
  void initState() {
    super.initState();
    // Try to infer preset from selected range
    _inferPreset();
  }

  @override
  void didUpdateWidget(DateRangeFilter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedRange != oldWidget.selectedRange) {
      _inferPreset();
    }
  }

  void _inferPreset() {
    if (widget.selectedRange == null) {
      _selectedPreset = null;
      return;
    }

    // Check if the range matches a preset (approximately)
    final now = DateTime.now();
    final start = widget.selectedRange!.start;
    final diff = now.difference(start);

    for (final preset in DateRangePreset.values) {
      if (preset == DateRangePreset.custom) continue;
      final presetDiff = preset.duration;
      // Allow 1-minute tolerance for matching
      if ((diff - presetDiff).abs() < const Duration(minutes: 1)) {
        _selectedPreset = preset;
        return;
      }
    }

    _selectedPreset = DateRangePreset.custom;
  }

  void _applyPreset(DateRangePreset preset) {
    setState(() => _selectedPreset = preset);

    if (preset == DateRangePreset.custom) {
      _showCustomPicker();
      return;
    }

    final now = DateTime.now();
    final start = now.subtract(preset.duration);
    widget.onRangeChanged(DateTimeRange(start: start, end: now));
  }

  Future<void> _showCustomPicker() async {
    final now = DateTime.now();
    final initialRange = widget.selectedRange ??
        DateTimeRange(
          start: now.subtract(const Duration(days: 1)),
          end: now,
        );

    final result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: initialRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (result != null) {
      // Add time component - start at midnight, end at end of day
      final adjustedRange = DateTimeRange(
        start: DateTime(result.start.year, result.start.month, result.start.day),
        end: DateTime(
          result.end.year,
          result.end.month,
          result.end.day,
          23,
          59,
          59,
          999,
        ),
      );
      widget.onRangeChanged(adjustedRange);
    }
  }

  void _clearFilter() {
    setState(() => _selectedPreset = null);
    widget.onRangeChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasSelection = widget.selectedRange != null;

    if (widget.compact) {
      return _buildCompactView(theme, hasSelection);
    }

    return _buildExpandedView(theme, hasSelection);
  }

  Widget _buildCompactView(ThemeData theme, bool hasSelection) {
    return PopupMenuButton<DateRangePreset?>(
      tooltip: 'Filter by date',
      offset: const Offset(0, 40),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: AppTheme.spacingXs,
        ),
        decoration: BoxDecoration(
          color: hasSelection
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: hasSelection
                ? theme.colorScheme.primary.withValues(alpha: 0.5)
                : theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today,
              size: 16,
              color: hasSelection
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Text(
              hasSelection
                  ? _selectedPreset?.label ?? _formatRange(widget.selectedRange!)
                  : 'All time',
              style: theme.textTheme.bodySmall?.copyWith(
                color: hasSelection
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                fontWeight: hasSelection ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (hasSelection) ...[
              const SizedBox(width: AppTheme.spacingXs),
              InkWell(
                onTap: _clearFilter,
                borderRadius: BorderRadius.circular(10),
                child: Icon(
                  Icons.close,
                  size: 14,
                  color: theme.colorScheme.primary,
                ),
              ),
            ] else ...[
              const SizedBox(width: AppTheme.spacingXs),
              Icon(
                Icons.arrow_drop_down,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ],
          ],
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem<DateRangePreset?>(
          value: null,
          child: Row(
            children: [
              Icon(
                Icons.all_inclusive,
                size: 18,
                color: _selectedPreset == null ? theme.colorScheme.primary : null,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                'All time',
                style: TextStyle(
                  fontWeight: _selectedPreset == null ? FontWeight.bold : null,
                  color: _selectedPreset == null ? theme.colorScheme.primary : null,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        ...DateRangePreset.values.map(
          (preset) => PopupMenuItem<DateRangePreset>(
            value: preset,
            child: Row(
              children: [
                Icon(
                  preset == DateRangePreset.custom
                      ? Icons.date_range
                      : Icons.schedule,
                  size: 18,
                  color: _selectedPreset == preset
                      ? theme.colorScheme.primary
                      : null,
                ),
                const SizedBox(width: AppTheme.spacingSm),
                Text(
                  preset.label,
                  style: TextStyle(
                    fontWeight: _selectedPreset == preset ? FontWeight.bold : null,
                    color: _selectedPreset == preset
                        ? theme.colorScheme.primary
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      onSelected: (value) {
        if (value == null) {
          _clearFilter();
        } else {
          _applyPreset(value);
        }
      },
    );
  }

  Widget _buildExpandedView(ThemeData theme, bool hasSelection) {
    return Wrap(
      spacing: AppTheme.spacingSm,
      runSpacing: AppTheme.spacingSm,
      children: [
        // All time chip
        FilterChip(
          label: const Text('All time'),
          selected: !hasSelection,
          onSelected: (_) => _clearFilter(),
          selectedColor: theme.colorScheme.primary.withValues(alpha: 0.15),
        ),
        // Preset chips
        ...DateRangePreset.values.map(
          (preset) => FilterChip(
            label: Text(preset.label),
            selected: _selectedPreset == preset,
            onSelected: (_) => _applyPreset(preset),
            selectedColor: theme.colorScheme.primary.withValues(alpha: 0.15),
          ),
        ),
      ],
    );
  }

  String _formatRange(DateTimeRange range) {
    final start = range.start;
    final end = range.end;

    // Check if same day
    if (start.year == end.year &&
        start.month == end.month &&
        start.day == end.day) {
      return _formatDate(start);
    }

    return '${_formatDate(start)} - ${_formatDate(end)}';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    }

    return '${date.month}/${date.day}/${date.year.toString().substring(2)}';
  }
}
