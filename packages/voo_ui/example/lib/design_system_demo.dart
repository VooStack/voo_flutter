import 'package:flutter/material.dart';
import 'package:voo_ui/voo_ui.dart';

class DesignSystemDemo extends StatelessWidget {
  const DesignSystemDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Design System'),
      ),
      body: ListView(
        padding: EdgeInsets.all(design.spacingLg),
        children: [
          _Section(
            title: 'Spacing',
            child: _SpacingDemo(),
          ),
          _Section(
            title: 'Border Radius',
            child: _BorderRadiusDemo(),
          ),
          _Section(
            title: 'Typography',
            child: _TypographyDemo(),
          ),
          _Section(
            title: 'Colors',
            child: _ColorsDemo(),
          ),
          _Section(
            title: 'Icon Sizes',
            child: _IconSizesDemo(),
          ),
          _Section(
            title: 'Animation',
            child: _AnimationDemo(),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: design.spacingXl,
            bottom: design.spacingMd,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        child,
      ],
    );
  }
}

class _SpacingDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    return VooCard(
      child: Padding(
        padding: EdgeInsets.all(design.spacingLg),
        child: Column(
          children: [
            _SpacingItem(label: 'spacingXs', value: design.spacingXs),
            _SpacingItem(label: 'spacingSm', value: design.spacingSm),
            _SpacingItem(label: 'spacingMd', value: design.spacingMd),
            _SpacingItem(label: 'spacingLg', value: design.spacingLg),
            _SpacingItem(label: 'spacingXl', value: design.spacingXl),
            _SpacingItem(label: 'spacingXxl', value: design.spacingXxl),
            _SpacingItem(label: 'spacingXxxl', value: design.spacingXxxl),
          ],
        ),
      ),
    );
  }
}

class _SpacingItem extends StatelessWidget {
  final String label;
  final double value;

  const _SpacingItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: design.spacingSm),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label),
          ),
          Container(
            width: value,
            height: 20,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(design.radiusSm),
            ),
          ),
          SizedBox(width: design.spacingMd),
          Text('${value.toStringAsFixed(0)}px'),
        ],
      ),
    );
  }
}

class _BorderRadiusDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    return VooCard(
      child: Padding(
        padding: EdgeInsets.all(design.spacingLg),
        child: Column(
          children: [
            _RadiusItem(label: 'radiusXs', value: design.radiusXs),
            _RadiusItem(label: 'radiusSm', value: design.radiusSm),
            _RadiusItem(label: 'radiusMd', value: design.radiusMd),
            _RadiusItem(label: 'radiusLg', value: design.radiusLg),
            _RadiusItem(label: 'radiusXl', value: design.radiusXl),
            _RadiusItem(label: 'radiusXxl', value: design.radiusXxl),
            _RadiusItem(label: 'radiusFull', value: 50),
          ],
        ),
      ),
    );
  }
}

class _RadiusItem extends StatelessWidget {
  final String label;
  final double value;

  const _RadiusItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: design.spacingSm),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(value),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
          ),
          SizedBox(width: design.spacingMd),
          Text(value == 999 ? 'Full' : '${value.toStringAsFixed(0)}px'),
        ],
      ),
    );
  }
}

class _TypographyDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return VooCard(
      child: Padding(
        padding: EdgeInsets.all(context.vooDesign.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Display Large', style: theme.textTheme.displayLarge),
            Text('Display Medium', style: theme.textTheme.displayMedium),
            Text('Display Small', style: theme.textTheme.displaySmall),
            const Divider(),
            Text('Headline Large', style: theme.textTheme.headlineLarge),
            Text('Headline Medium', style: theme.textTheme.headlineMedium),
            Text('Headline Small', style: theme.textTheme.headlineSmall),
            const Divider(),
            Text('Title Large', style: theme.textTheme.titleLarge),
            Text('Title Medium', style: theme.textTheme.titleMedium),
            Text('Title Small', style: theme.textTheme.titleSmall),
            const Divider(),
            Text('Body Large', style: theme.textTheme.bodyLarge),
            Text('Body Medium', style: theme.textTheme.bodyMedium),
            Text('Body Small', style: theme.textTheme.bodySmall),
            const Divider(),
            Text('Label Large', style: theme.textTheme.labelLarge),
            Text('Label Medium', style: theme.textTheme.labelMedium),
            Text('Label Small', style: theme.textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}

class _ColorsDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final colorScheme = Theme.of(context).colorScheme;

    return VooCard(
      child: Padding(
        padding: EdgeInsets.all(design.spacingLg),
        child: Column(
          children: [
            _ColorRow('Primary', colorScheme.primary, colorScheme.onPrimary),
            _ColorRow('Primary Container', colorScheme.primaryContainer, colorScheme.onPrimaryContainer),
            _ColorRow('Secondary', colorScheme.secondary, colorScheme.onSecondary),
            _ColorRow('Secondary Container', colorScheme.secondaryContainer, colorScheme.onSecondaryContainer),
            _ColorRow('Tertiary', colorScheme.tertiary, colorScheme.onTertiary),
            _ColorRow('Tertiary Container', colorScheme.tertiaryContainer, colorScheme.onTertiaryContainer),
            _ColorRow('Error', colorScheme.error, colorScheme.onError),
            _ColorRow('Error Container', colorScheme.errorContainer, colorScheme.onErrorContainer),
            _ColorRow('Surface', colorScheme.surface, colorScheme.onSurface),
            _ColorRow('Surface Variant', colorScheme.surfaceContainerHighest, colorScheme.onSurfaceVariant),
            _ColorRow('Outline', colorScheme.outline, null),
            _ColorRow('Outline Variant', colorScheme.outlineVariant, null),
          ],
        ),
      ),
    );
  }
}

class _ColorRow extends StatelessWidget {
  final String label;
  final Color color;
  final Color? onColor;

  const _ColorRow(this.label, this.color, this.onColor);

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: design.spacingSm),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(design.radiusSm),
              border: Border.all(color: Colors.black12),
            ),
            child: onColor != null
                ? Center(
                    child: Text(
                      'Aa',
                      style: TextStyle(
                        color: onColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : null,
          ),
          SizedBox(width: design.spacingMd),
          Expanded(
            child: Text(label),
          ),
          Text(
            '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _IconSizesDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    return VooCard(
      child: Padding(
        padding: EdgeInsets.all(design.spacingLg),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _IconSizeItem('Sm', design.iconSizeSm),
            _IconSizeItem('Md', design.iconSizeMd),
            _IconSizeItem('Lg', design.iconSizeLg),
            _IconSizeItem('Xl', design.iconSizeXl),
            _IconSizeItem('Xxl', design.iconSizeXxl),
          ],
        ),
      ),
    );
  }
}

class _IconSizeItem extends StatelessWidget {
  final String label;
  final double size;

  const _IconSizeItem(this.label, this.size);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.star, size: size),
        const SizedBox(height: 8),
        Text(label),
        Text(
          '${size.toStringAsFixed(0)}px',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _AnimationDemo extends StatefulWidget {
  @override
  State<_AnimationDemo> createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<_AnimationDemo> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    return VooCard(
      child: Padding(
        padding: EdgeInsets.all(design.spacingLg),
        child: Column(
          children: [
            VooButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              child: const Text('Toggle Animation'),
            ),
            SizedBox(height: design.spacingLg),
            AnimatedContainer(
              duration: design.animationDuration,
              curve: design.animationCurve,
              width: _expanded ? 200 : 100,
              height: _expanded ? 100 : 50,
              decoration: BoxDecoration(
                color: _expanded ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(
                  _expanded ? design.radiusXl : design.radiusMd,
                ),
              ),
              child: Center(
                child: Text(
                  _expanded ? 'Expanded' : 'Collapsed',
                  style: TextStyle(
                    color: _expanded ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
            SizedBox(height: design.spacingMd),
            Text(
              'Duration: ${design.animationDuration.inMilliseconds}ms',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
