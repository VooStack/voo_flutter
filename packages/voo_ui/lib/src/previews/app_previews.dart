import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_ui/voo_ui.dart';

// VooMaterialApp Previews
@Preview(name: 'VooMaterialApp - Light Theme')
Widget vooMaterialAppLight() => VooMaterialApp(
      title: 'Voo App',
      theme: ThemeData.light(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(title: const Text('Voo App')),
        body: Center(
          child: Builder(
            builder: (context) {
              final design = context.vooDesign;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('VooMaterialApp with Light Theme'),
                  const SizedBox(height: 16),
                  Text('Spacing MD: ${design.spacingMd}'),
                  Text('Radius MD: ${design.radiusMd}'),
                  const SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(design.spacingLg),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(design.radiusMd),
                    ),
                    child: const Text('Container using design system'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );

@Preview(name: 'VooMaterialApp - Dark Theme')
Widget vooMaterialAppDark() => VooMaterialApp(
      title: 'Voo App Dark',
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(title: const Text('Voo App Dark')),
        body: Center(
          child: Builder(
            builder: (context) {
              final design = context.vooDesign;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('VooMaterialApp with Dark Theme'),
                  const SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(design.spacingLg),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(design.radiusMd),
                    ),
                    child: const Text('Dark theme container'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );

@Preview(name: 'VooMaterialApp - Custom Design System')
Widget vooMaterialAppCustomDesign() => VooMaterialApp(
      title: 'Custom Design',
      theme: ThemeData.light(useMaterial3: true),
      designSystem: const VooDesignSystemData.custom(
        spacingUnit: 10.0,
        radiusUnit: 6.0,
        buttonHeight: 48.0,
        inputHeight: 56.0,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Custom Design System')),
        body: Center(
          child: Builder(
            builder: (context) {
              final design = context.vooDesign;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Custom spacing unit: ${design.spacingUnit}'),
                  Text('Custom radius unit: ${design.radiusUnit}'),
                  const SizedBox(height: 24),
                  VooContainer(
                    paddingSize: VooSpacingSize.lg,
                    borderRadiusSize: VooSpacingSize.lg,
                    color: Colors.blue.shade100,
                    child: const Text('Using custom design values'),
                  ),
                  const SizedBox(height: 16),
                  VooButton(
                    onPressed: () {},
                    child: const Text('Custom button height'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );

@Preview(name: 'VooDesignSystem - Spacing Demo')
Widget vooDesignSystemSpacingDemo() => VooMaterialApp(
      title: 'Spacing Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Spacing Demo')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Builder(
            builder: (context) {
              final design = context.vooDesign;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SpacingRow('XS', design.spacingXs, Colors.red.shade100),
                  _SpacingRow('SM', design.spacingSm, Colors.orange.shade100),
                  _SpacingRow('MD', design.spacingMd, Colors.yellow.shade100),
                  _SpacingRow('LG', design.spacingLg, Colors.green.shade100),
                  _SpacingRow('XL', design.spacingXl, Colors.blue.shade100),
                  _SpacingRow('XXL', design.spacingXxl, Colors.indigo.shade100),
                  _SpacingRow('XXXL', design.spacingXxxl, Colors.purple.shade100),
                ],
              );
            },
          ),
        ),
      ),
    );

@Preview(name: 'VooDesignSystem - Radius Demo')
Widget vooDesignSystemRadiusDemo() => VooMaterialApp(
      title: 'Radius Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Radius Demo')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Builder(
            builder: (context) {
              final design = context.vooDesign;
              return Column(
                children: [
                  _RadiusBox('XS', design.radiusXs),
                  const SizedBox(height: 16),
                  _RadiusBox('SM', design.radiusSm),
                  const SizedBox(height: 16),
                  _RadiusBox('MD', design.radiusMd),
                  const SizedBox(height: 16),
                  _RadiusBox('LG', design.radiusLg),
                  const SizedBox(height: 16),
                  _RadiusBox('XL', design.radiusXl),
                  const SizedBox(height: 16),
                  _RadiusBox('XXL', design.radiusXxl),
                ],
              );
            },
          ),
        ),
      ),
    );

// Helper widgets for demos
class _SpacingRow extends StatelessWidget {
  final String label;
  final double spacing;
  final Color color;

  const _SpacingRow(this.label, this.spacing, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(label),
          ),
          Container(
            height: 40,
            width: spacing,
            color: color,
          ),
          const SizedBox(width: 8),
          Text('${spacing.toStringAsFixed(1)}px'),
        ],
      ),
    );
  }
}

class _RadiusBox extends StatelessWidget {
  final String label;
  final double radius;

  const _RadiusBox(this.label, this.radius);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Center(
        child: Text('$label - ${radius.toStringAsFixed(1)}px'),
      ),
    );
  }
}
