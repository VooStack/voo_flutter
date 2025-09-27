import 'package:flutter/material.dart';
import 'package:voo_tokens/voo_tokens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'VooTokens Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          // VooTokensTheme is optional - will use defaults if not provided
          // Uncomment to use custom scaling:
          // extensions: [
          //   VooTokensTheme.standard(scaleFactor: 1.2),
          // ],
        ),
        home: const TokensDemoPage(),
      );
}

class TokensDemoPage extends StatelessWidget {
  const TokensDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final responsiveTokens = VooTokensTheme.responsive(
      screenWidth: mediaQuery.size.width,
      isDark: Theme.of(context).brightness == Brightness.dark,
    );

    return Theme(
      data: Theme.of(context).copyWith(extensions: [responsiveTokens]),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(
              'VooTokens Demo',
              style: context.vooTypography.titleLarge,
            ),
          ),
          body: SingleChildScrollView(
            padding: context.vooMargin.page,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSpacingSection(context),
                SizedBox(height: context.vooMargin.betweenSections),
                _buildMarginPaddingSection(context),
                SizedBox(height: context.vooMargin.betweenSections),
                _buildComponentSection(context),
                SizedBox(height: context.vooMargin.betweenSections),
                _buildTypographySection(context),
                SizedBox(height: context.vooMargin.betweenSections),
                _buildRadiusSection(context),
                SizedBox(height: context.vooMargin.betweenSections),
                _buildElevationSection(context),
                SizedBox(height: context.vooMargin.betweenSections),
                _buildAnimationSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpacingSection(BuildContext context) {
    final spacing = context.vooSpacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Spacing Tokens',
          style: context.vooTypography.headlineSmall,
        ),
        SizedBox(height: spacing.md),
        _buildSpacingBox(context, 'xxs', spacing.xxs),
        _buildSpacingBox(context, 'xs', spacing.xs),
        _buildSpacingBox(context, 'sm', spacing.sm),
        _buildSpacingBox(context, 'md', spacing.md),
        _buildSpacingBox(context, 'lg', spacing.lg),
        _buildSpacingBox(context, 'xl', spacing.xl),
        _buildSpacingBox(context, 'xxl', spacing.xxl),
        _buildSpacingBox(context, 'xxxl', spacing.xxxl),
      ],
    );
  }

  Widget _buildSpacingBox(BuildContext context, String label, double value) =>
      Padding(
        padding: EdgeInsets.symmetric(vertical: context.vooSpacing.xs),
        child: Row(
          children: [
            SizedBox(
              width: 60,
              child: Text(label, style: context.vooTypography.labelMedium),
            ),
            Container(
              width: value,
              height: 24,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: context.vooSpacing.sm),
            Text('${value.toStringAsFixed(0)}px',
                style: context.vooTypography.caption),
          ],
        ),
      );

  Widget _buildTypographySection(BuildContext context) {
    final typography = context.vooTypography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Typography Tokens',
          style: typography.headlineSmall,
        ),
        SizedBox(height: context.vooSpacing.md),
        Text('Display Large', style: typography.displayLarge),
        Text('Display Medium', style: typography.displayMedium),
        Text('Display Small', style: typography.displaySmall),
        Text('Headline Large', style: typography.headlineLarge),
        Text('Headline Medium', style: typography.headlineMedium),
        Text('Headline Small', style: typography.headlineSmall),
        Text('Title Large', style: typography.titleLarge),
        Text('Title Medium', style: typography.titleMedium),
        Text('Title Small', style: typography.titleSmall),
        Text('Body Large', style: typography.bodyLarge),
        Text('Body Medium', style: typography.bodyMedium),
        Text('Body Small', style: typography.bodySmall),
        Text('Label Large', style: typography.labelLarge),
        Text('Label Medium', style: typography.labelMedium),
        Text('Label Small', style: typography.labelSmall),
        Text('Code', style: typography.code),
        Text('Caption', style: typography.caption),
        Text('Overline', style: typography.overline),
        Text('Button', style: typography.button),
      ],
    );
  }

  Widget _buildRadiusSection(BuildContext context) {
    final radius = context.vooRadius;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Radius Tokens',
          style: context.vooTypography.headlineSmall,
        ),
        SizedBox(height: context.vooSpacing.md),
        Wrap(
          spacing: context.vooSpacing.md,
          runSpacing: context.vooSpacing.md,
          children: [
            _buildRadiusBox(context, 'none', radius.none),
            _buildRadiusBox(context, 'xs', radius.xs),
            _buildRadiusBox(context, 'sm', radius.sm),
            _buildRadiusBox(context, 'md', radius.md),
            _buildRadiusBox(context, 'lg', radius.lg),
            _buildRadiusBox(context, 'xl', radius.xl),
            _buildRadiusBox(context, 'xxl', radius.xxl),
          ],
        ),
      ],
    );
  }

  Widget _buildRadiusBox(BuildContext context, String label, double value) =>
      Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(value),
            ),
          ),
          SizedBox(height: context.vooSpacing.xs),
          Text(label, style: context.vooTypography.labelSmall),
          Text('${value.toStringAsFixed(0)}px',
              style: context.vooTypography.caption),
        ],
      );

  Widget _buildElevationSection(BuildContext context) {
    final elevation = context.vooElevation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Elevation Tokens',
          style: context.vooTypography.headlineSmall,
        ),
        SizedBox(height: context.vooSpacing.md),
        Wrap(
          spacing: context.vooSpacing.md,
          runSpacing: context.vooSpacing.md,
          children: [
            _buildElevationBox(
                context, 'Level 0', elevation.level0, elevation.shadow0()),
            _buildElevationBox(
                context, 'Level 1', elevation.level1, elevation.shadow1()),
            _buildElevationBox(
                context, 'Level 2', elevation.level2, elevation.shadow2()),
            _buildElevationBox(
                context, 'Level 3', elevation.level3, elevation.shadow3()),
            _buildElevationBox(
                context, 'Level 4', elevation.level4, elevation.shadow4()),
            _buildElevationBox(
                context, 'Level 5', elevation.level5, elevation.shadow5()),
          ],
        ),
      ],
    );
  }

  Widget _buildElevationBox(BuildContext context, String label, double value,
          List<BoxShadow> shadows) =>
      Column(
        children: [
          Container(
            width: 100,
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(context.vooRadius.md),
              boxShadow: shadows,
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: context.vooTypography.labelMedium,
            ),
          ),
        ],
      );

  Widget _buildAnimationSection(BuildContext context) {
    final animation = context.vooAnimation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Animation Tokens',
          style: context.vooTypography.headlineSmall,
        ),
        SizedBox(height: context.vooSpacing.md),
        _buildAnimationInfo(
            context, 'Instant', animation.durationInstant.inMilliseconds),
        _buildAnimationInfo(
            context, 'Fast', animation.durationFast.inMilliseconds),
        _buildAnimationInfo(
            context, 'Normal', animation.durationNormal.inMilliseconds),
        _buildAnimationInfo(
            context, 'Slow', animation.durationSlow.inMilliseconds),
        _buildAnimationInfo(
            context, 'Slowest', animation.durationSlowest.inMilliseconds),
      ],
    );
  }

  Widget _buildAnimationInfo(BuildContext context, String label, int ms) =>
      Padding(
        padding: EdgeInsets.symmetric(vertical: context.vooSpacing.xs),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: Text(label, style: context.vooTypography.labelMedium),
            ),
            Text('${ms}ms', style: context.vooTypography.bodyMedium),
          ],
        ),
      );

  Widget _buildMarginPaddingSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Margin & Padding Tokens',
          style: context.vooTypography.headlineSmall,
        ),
        SizedBox(height: context.vooGap.stackedElements),
        Card(
          child: Padding(
            padding: context.vooPadding.card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Card with Card Padding',
                    style: context.vooTypography.labelLarge),
                SizedBox(height: context.vooGap.inlineElements),
                Text(
                  'This card uses context.vooPadding.card for consistent padding.',
                  style: context.vooTypography.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: context.vooGap.stackedElements),
        Container(
          padding: context.vooPadding.button,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: context.vooComponentRadius.buttonRadius,
          ),
          child: Text(
            'Button Padding Example',
            style: context.vooTypography.button.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComponentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Component-Specific Tokens',
          style: context.vooTypography.headlineSmall,
        ),
        SizedBox(height: context.vooGap.stackedElements),
        Wrap(
          spacing: context.vooGap.chipGroup,
          runSpacing: context.vooGap.chipGroup,
          children: [
            Container(
              height: context.vooSize.chipHeight,
              padding: context.vooPadding.chip,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: context.vooComponentRadius.chipRadius,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star,
                    size: context.vooSize.iconSmall,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  SizedBox(width: context.vooGap.iconText),
                  Text(
                    'Chip Example',
                    style: context.vooTypography.labelMedium,
                  ),
                ],
              ),
            ),
            Container(
              width: context.vooSize.avatarMedium,
              height: context.vooSize.avatarMedium,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: context.vooComponentRadius.avatarRadius,
              ),
              child: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.onSecondary,
                size: context.vooSize.iconMedium,
              ),
            ),
          ],
        ),
        SizedBox(height: context.vooGap.stackedElements),
        Container(
          height: context.vooSize.inputHeight,
          padding: context.vooPadding.input,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: context.vooComponentRadius.inputRadius,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Input Field Example',
              style: context.vooTypography.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }
}
