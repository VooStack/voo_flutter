# Replace EmptyStateWidget with VooEmptyState

## Plan

This task involves replacing all occurrences of the custom EmptyStateWidget with VooEmptyState from the voo_ui package in the DevTools extension.

## Todo Items

- [ ] Update analytics_list.dart to use VooEmptyState
- [ ] Update network_list.dart to use VooEmptyState  
- [ ] Update performance_list.dart to use VooEmptyState
- [ ] Update logs_list.dart to use VooEmptyState
- [ ] Update adaptive_voo_page.dart to use VooEmptyState
- [ ] Delete the empty_state_widget.dart file

## Changes Required

1. Replace import statements from `import 'package:voo_logging_devtools_extension/presentation/widgets/molecules/empty_state_widget.dart';` to `import 'package:voo_ui/voo_ui.dart';`
2. Replace all `EmptyStateWidget(` occurrences with `VooEmptyState(`
3. Remove the custom empty_state_widget.dart file

## Files to Modify

- `/Users/coltonbristow/Documents/GitHub/DevStack/VooFlutter/tools/voo_devtools_extension/lib/presentation/widgets/organisms/analytics_list.dart`
- `/Users/coltonbristow/Documents/GitHub/DevStack/VooFlutter/tools/voo_devtools_extension/lib/presentation/widgets/organisms/network_list.dart`
- `/Users/coltonbristow/Documents/GitHub/DevStack/VooFlutter/tools/voo_devtools_extension/lib/presentation/widgets/organisms/performance_list.dart`
- `/Users/coltonbristow/Documents/GitHub/DevStack/VooFlutter/tools/voo_devtools_extension/lib/presentation/widgets/organisms/logs_list.dart`
- `/Users/coltonbristow/Documents/GitHub/DevStack/VooFlutter/tools/voo_devtools_extension/lib/presentation/pages/adaptive_voo_page.dart`

## File to Delete

- `/Users/coltonbristow/Documents/GitHub/DevStack/VooFlutter/tools/voo_devtools_extension/lib/presentation/widgets/molecules/empty_state_widget.dart`

## Review Section

_To be completed after implementation_