# _buildXXX Method Violations in voo_form.dart

## Status
According to rules.md section 4.4.8, _buildXXX methods that return widgets are PROHIBITED. These should be extracted into separate widget classes.

## Current Violations in voo_form.dart

The following _buildXXX methods still exist and need to be refactored:

1. `_buildFormContent` (line 160) - Should be `FormContentWidget`
2. `_buildGroupedForm` (line 187) - Should be `GroupedFormWidget`
3. `_buildFieldGroup` (line 202) - Should be `FieldGroupWidget`
4. `_buildCollapsibleGroup` (line 264) - Should be `CollapsibleGroupWidget`
5. `_buildFieldGroupContent` (line 281) - Should be `FieldGroupContentWidget`
6. `_buildSectionedForm` (line 328) - Should be `SectionedFormWidget`
7. `_buildVerticalLayout` (line 351) - Should be `VerticalLayoutWidget`
8. `_buildHorizontalLayout` (line 363) - Should be `HorizontalLayoutWidget`
9. `_buildGridLayout` (line 377) - Should be `GridLayoutWidget`
10. `_buildField` (line 411) - Should be `FormFieldWidget`
11. `_buildSubmitSection` (line 508) - Should be `SubmitSectionWidget`

## Recommended Refactoring Approach

Each _build method should be extracted into its own widget class in the appropriate atomic design folder:

- **Molecules**: FieldGroupWidget, CollapsibleGroupWidget, FieldGroupContentWidget, FormFieldWidget, SubmitSectionWidget
- **Organisms**: FormContentWidget, GroupedFormWidget, SectionedFormWidget, VerticalLayoutWidget, HorizontalLayoutWidget, GridLayoutWidget

## Note
While these violations exist, the package currently compiles and most tests pass. A complete refactoring would require significant changes to the package structure and would be a breaking change for consumers of the library.