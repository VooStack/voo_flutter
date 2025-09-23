# VooTokens

A design token system for VooFlutter that provides responsive spacing, typography, radius, elevation, and animation tokens. Works seamlessly with all screen sizes and adapts automatically.

## Features

- **Responsive Scaling**: Tokens automatically adapt based on screen width
- **Typography Tokens**: Consistent text styles with scale factors
- **Spacing Tokens**: Generic spacing values (xxs to xxxl)
- **Margin Tokens**: Specific margins for pages, cards, dialogs, sections
- **Padding Tokens**: Padding presets for buttons, cards, inputs, chips, etc.
- **Gap Tokens**: Spacing for flex containers, grids, and component groups
- **Size Tokens**: Standardized sizes for icons, avatars, buttons, inputs
- **Component Radius**: Specific border radius for UI components
- **Radius Tokens**: Generic border radius values
- **Elevation Tokens**: Standardized shadow definitions
- **Animation Tokens**: Consistent animation durations and curves
- **ThemeExtension Integration**: Access all tokens via BuildContext

## Usage

### Setup

VooTokens works out of the box with default values. You can optionally customize the theme:

```dart
import 'package:voo_tokens/voo_tokens.dart';

MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
    // Optional: Customize token scaling (defaults to 1.0 if not specified)
    extensions: [
      VooTokensTheme.standard(scaleFactor: 1.2), // Optional
    ],
  ),
);
```

**Note:** VooTokensTheme is optional. If not provided, default tokens will be used automatically.

### Responsive Setup

For responsive token scaling based on screen width:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Theme(
      data: theme.copyWith(
        extensions: [
          VooTokensTheme.responsive(
            screenWidth: constraints.maxWidth,
            isDark: isDark,
          ),
        ],
      ),
      child: YourContent(),
    );
  },
);
```

### Accessing Tokens

Use the BuildContext extensions to access all token types:

```dart
// Generic Spacing
SizedBox(height: context.vooSpacing.md);
Gap(context.vooSpacing.lg); // If using the gap package

// Specific Margins
Container(
  margin: context.vooMargin.page, // Page-level margins
  child: Card(
    margin: EdgeInsets.only(bottom: context.vooMargin.sectionBottom),
  ),
);

// Component-Specific Padding
ElevatedButton(
  style: ElevatedButton.styleFrom(
    padding: context.vooPadding.button, // Button-specific padding
  ),
  onPressed: () {},
  child: Text('Click Me'),
);

// Input field with proper padding
TextField(
  decoration: InputDecoration(
    contentPadding: context.vooPadding.input,
  ),
);

// Gap tokens for flex containers
Column(
  children: [
    Widget1(),
    SizedBox(height: context.vooGap.formFields), // Gap between form fields
    Widget2(),
    SizedBox(height: context.vooGap.stackedElements), // Gap between stacked elements
  ],
);

// Component-specific radius
Container(
  decoration: BoxDecoration(
    borderRadius: context.vooComponentRadius.cardRadius, // Card-specific radius
  ),
  child: ...,
);

// Dialog with proper radius
Dialog(
  shape: RoundedRectangleBorder(
    borderRadius: context.vooComponentRadius.dialogRadius,
  ),
);

// Size tokens
Icon(
  Icons.star,
  size: context.vooSize.iconMedium, // Standardized icon size
);

CircleAvatar(
  radius: context.vooSize.avatarLarge / 2, // Avatar size
);

// Typography
Text(
  'Title',
  style: context.vooTypography.headlineLarge,
);

// Generic Radius (for custom components)
Container(
  decoration: BoxDecoration(
    borderRadius: context.vooRadius.card,
  ),
);

// Elevation
Container(
  decoration: BoxDecoration(
    boxShadow: context.vooElevation.shadow2(),
  ),
);

// Animation
AnimatedContainer(
  duration: context.vooAnimation.durationNormal,
  curve: context.vooAnimation.curveEaseInOut,
);
```

## Token Values

### Spacing Tokens
- `xxs`: 2px
- `xs`: 4px
- `sm`: 8px
- `md`: 16px
- `lg`: 24px
- `xl`: 32px
- `xxl`: 48px
- `xxxl`: 64px

### Component-specific spacing:
- `buttonPadding`: 12px
- `cardPadding`: 16px
- `listItemPadding`: 12px
- `inputPadding`: 12px
- `dialogPadding`: 24px

### Radius Tokens
- `none`: 0px
- `xs`: 2px
- `sm`: 4px
- `md`: 8px
- `lg`: 12px
- `xl`: 16px
- `xxl`: 24px
- `full`: 9999px (pill shape)

### Responsive Scale Factors
- < 360px: 0.85x
- 360-414px: 0.9x
- 414-600px: 1.0x
- 600-768px: 1.1x
- 768-1024px: 1.15x
- 1024-1440px: 1.2x
- > 1440px: 1.25x

## Integration with VooResponsive

This package works seamlessly with `voo_responsive` to provide a complete responsive design system. The tokens automatically scale based on screen size while maintaining visual harmony across all breakpoints.