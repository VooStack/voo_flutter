import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Dropdown menu overlay widget following atomic design principles
class DropdownMenuOverlay<T> extends StatelessWidget {
  final List<VooFieldOption<T>> filteredOptions;
  final List<VooFieldOption<T>> allOptions;
  final bool isLoading;
  final bool enableSearch;
  final String? searchHint;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final T? currentValue;
  final T? initialValue;
  final ValueChanged<T?> onItemSelected;
  final VoidCallback onClearSearch;

  const DropdownMenuOverlay({
    super.key,
    required this.filteredOptions,
    required this.allOptions,
    required this.isLoading,
    required this.enableSearch,
    this.searchHint,
    required this.searchController,
    required this.onSearchChanged,
    this.currentValue,
    this.initialValue,
    required this.onItemSelected,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
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
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (enableSearch) ...[
            DropdownSearchField(
              searchController: searchController,
              searchHint: searchHint,
              onSearchChanged: onSearchChanged,
              onClearSearch: onClearSearch,
              design: design,
              theme: theme,
            ),
          ],
          Flexible(
            child: DropdownItemsList<T>(
              filteredOptions: filteredOptions,
              isLoading: isLoading,
              currentValue: currentValue ?? initialValue,
              onItemSelected: onItemSelected,
              design: design,
              theme: theme,
            ),
          ),
        ],
      ),
    );
  }
}

/// Search field for dropdown menu
class DropdownSearchField extends StatelessWidget {
  final TextEditingController searchController;
  final String? searchHint;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final VooDesignSystemData design;
  final ThemeData theme;

  const DropdownSearchField({
    super.key,
    required this.searchController,
    this.searchHint,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.design,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.all(design.spacingMd),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: TextField(
        controller: searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: searchHint ?? 'Search...',
          prefixIcon: Icon(
            Icons.search,
            size: design.iconSizeMd,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: design.iconSizeSm,
                  ),
                  onPressed: () {
                    searchController.clear();
                    onClearSearch();
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
        onChanged: onSearchChanged,
      ),
    );
}

/// List of dropdown items
class DropdownItemsList<T> extends StatelessWidget {
  final List<VooFieldOption<T>> filteredOptions;
  final bool isLoading;
  final T? currentValue;
  final ValueChanged<T?> onItemSelected;
  final VooDesignSystemData design;
  final ThemeData theme;

  const DropdownItemsList({
    super.key,
    required this.filteredOptions,
    required this.isLoading,
    this.currentValue,
    required this.onItemSelected,
    required this.design,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        padding: EdgeInsets.all(design.spacingXl),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (filteredOptions.isEmpty) {
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
      itemCount: filteredOptions.length,
      itemBuilder: (context, index) {
        final option = filteredOptions[index];
        return VooDropdownMenuItem<T>(
          option: option,
          isSelected: option.value == currentValue,
          onTap: () => onItemSelected(option.value),
          design: design,
          theme: theme,
        );
      },
    );
  }
}

/// Individual dropdown menu item
class VooDropdownMenuItem<T> extends StatelessWidget {
  final VooFieldOption<T> option;
  final bool isSelected;
  final VoidCallback onTap;
  final VooDesignSystemData design;
  final ThemeData theme;

  const VooDropdownMenuItem({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
    required this.design,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) => Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: option.enabled ? onTap : null,
        hoverColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.08),
        highlightColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.12),
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
      ),
    );
}