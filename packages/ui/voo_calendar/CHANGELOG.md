## 0.1.3

### ✨ Major Customization Update

**Day View Customization** - Added 14 new customization parameters for VooCalendarDayView:

#### New Parameters:
- **FEAT**: `hourLineTrailingBuilder` - Add custom widgets to the trailing edge of hour lines
- **FEAT**: `hourLineLeadingBuilder` - Add custom widgets before time labels
- **FEAT**: `showOnlyHoursWithEvents` - Display only hours with scheduled events
- **FEAT**: `hourHeight` - Customize the height of each hour row (default: 60.0)
- **FEAT**: `timeLabelFormatter` - Custom time label formatting function
- **FEAT**: `initialScrollHour` - Set initial scroll position to specific hour
- **FEAT**: `scrollPhysics` - Custom scroll physics for day view
- **FEAT**: `showTimeLabels` - Toggle time label visibility
- **FEAT**: `timeColumnWidth` - Custom width for time column
- **FEAT**: `firstHour` - Set first hour to display (0-23)
- **FEAT**: `lastHour` - Set last hour to display (0-23)
- **FEAT**: `hourLineColor` - Custom color for hour separator lines
- **FEAT**: `hourLineThickness` - Custom thickness for hour separator lines
- **FEAT**: `onHourLineTap` - Callback when hour line is tapped

#### Enhanced Example App:
- **FEAT**: Interactive day view customization demos
- **FEAT**: Toggle switches for all new features
- **FEAT**: Sample events demonstrating customization options

### Bug Fixes
- **FIX**: Fixed RenderFlex overflow error in view switcher on small screens
- **FIX**: Centered alignment for time labels, hour lines, and trailing widgets in day view
- **FIX**: Event positioning now works correctly with custom hour heights
- **FIX**: Hour range filtering properly respects first/last hour settings

### UI/UX Improvements
- **IMPROVE**: View switcher now scrolls horizontally on narrow displays
- **IMPROVE**: Day view elements are now properly centered for better visual consistency
- **IMPROVE**: Hour lines are now tappable with optional callback
- **IMPROVE**: Time labels support custom formatting

### Breaking Changes
None - all new parameters are optional with sensible defaults

## 0.1.2

 - **FEAT**: add example modules and run configurations for VooFlutter packages.

## 0.1.1

 - **FIX**: ensure proper disposal of scroll controllers in VooDataGridController.
 - **FEAT**: Introduce voo_tokens package for design tokens and responsive utilities.
 - **FEAT**: Update changelog for version 0.4.0 with new features, bug fixes, and documentation improvements.
 - **FEAT**: Implement advanced filtering in VooDataGrid.
 - **FEAT**: Update LICENSE files to include full MIT License text.
 - **FEAT**: Implement Windows runner for Voo Data Grid example.

## 0.1.0

* Enhanced calendar widget with multiple view modes
* Added month, week, and day view support
* Implemented event management system with add, edit, and delete capabilities
* Added customizable event colors and categories
* Implemented drag-and-drop event rescheduling
* Added recurring event support
* Enhanced accessibility features
* Added localization support for multiple languages
* Improved performance with efficient rendering
* Added comprehensive theming and customization options

## 0.0.1

* Initial release of VooCalendar
* Basic calendar implementation with month view
* Simple event display functionality
* Date selection and navigation
