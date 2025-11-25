import 'package:flutter/material.dart';
import 'package:voo_navigation/voo_navigation.dart';

/// Navigation style options for the showcase
enum NavStyleOption {
  adaptive,
  bottomNav,
  floatingBottomNav,
  rail,
  drawer,
}

/// Theme showcase demonstrating all 4 navigation theme presets
class ThemeShowcaseExample extends StatefulWidget {
  const ThemeShowcaseExample({super.key});

  @override
  State<ThemeShowcaseExample> createState() => _ThemeShowcaseExampleState();
}

class _ThemeShowcaseExampleState extends State<ThemeShowcaseExample> {
  String _selectedId = 'home';
  VooNavigationPreset _currentPreset = VooNavigationPreset.glassmorphism;
  NavStyleOption _navStyle = NavStyleOption.adaptive;

  List<VooNavigationItem> get _navigationItems => [
    VooNavigationItem(
      id: 'home',
      label: 'Home',
      mobilePriority: true,
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      onTap: () {},
    ),
    VooNavigationItem(
      id: 'explore',
      label: 'Explore',
      mobilePriority: true,
      icon: Icons.explore_outlined,
      selectedIcon: Icons.explore,
      badgeCount: 5,
      onTap: () {},
    ),
    VooNavigationItem(
      id: 'favorites',
      label: 'Favorites',
      mobilePriority: true,
      icon: Icons.favorite_outline,
      selectedIcon: Icons.favorite,
      showDot: true,
      onTap: () {},
    ),
    VooNavigationItem(
      id: 'profile',
      label: 'Profile',
      mobilePriority: true,
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      onTap: () {},
    ),
  ];

  VooNavigationTheme _getThemeForPreset() {
    switch (_currentPreset) {
      case VooNavigationPreset.glassmorphism:
        return VooNavigationTheme.glassmorphism();
      case VooNavigationPreset.neomorphism:
        return VooNavigationTheme.neomorphism();
      case VooNavigationPreset.material3Enhanced:
        return VooNavigationTheme.material3Enhanced();
      case VooNavigationPreset.minimalModern:
        return VooNavigationTheme.minimalModern();
    }
  }

  String _getPresetName() {
    switch (_currentPreset) {
      case VooNavigationPreset.glassmorphism:
        return 'Glassmorphism';
      case VooNavigationPreset.neomorphism:
        return 'Neomorphism';
      case VooNavigationPreset.material3Enhanced:
        return 'Material 3 Enhanced';
      case VooNavigationPreset.minimalModern:
        return 'Minimal Modern';
    }
  }

  String _getPresetDescription() {
    switch (_currentPreset) {
      case VooNavigationPreset.glassmorphism:
        return 'Frosted glass effect with blur and translucent surfaces';
      case VooNavigationPreset.neomorphism:
        return 'Soft embossed effect with dual shadow system';
      case VooNavigationPreset.material3Enhanced:
        return 'Enhanced Material 3 with polished animations';
      case VooNavigationPreset.minimalModern:
        return 'Clean flat design with minimal styling';
    }
  }

  IconData _getPresetIcon() {
    switch (_currentPreset) {
      case VooNavigationPreset.glassmorphism:
        return Icons.blur_on;
      case VooNavigationPreset.neomorphism:
        return Icons.layers;
      case VooNavigationPreset.material3Enhanced:
        return Icons.auto_awesome;
      case VooNavigationPreset.minimalModern:
        return Icons.crop_square;
    }
  }

  String _getNavStyleName(NavStyleOption style) {
    switch (style) {
      case NavStyleOption.adaptive:
        return 'Adaptive';
      case NavStyleOption.bottomNav:
        return 'Bottom Nav';
      case NavStyleOption.floatingBottomNav:
        return 'Floating';
      case NavStyleOption.rail:
        return 'Rail';
      case NavStyleOption.drawer:
        return 'Drawer';
    }
  }

  IconData _getNavStyleIcon(NavStyleOption style) {
    switch (style) {
      case NavStyleOption.adaptive:
        return Icons.devices;
      case NavStyleOption.bottomNav:
        return Icons.horizontal_rule;
      case NavStyleOption.floatingBottomNav:
        return Icons.crop_16_9;
      case NavStyleOption.rail:
        return Icons.view_sidebar_outlined;
      case NavStyleOption.drawer:
        return Icons.menu;
    }
  }

  VooNavigationConfig get _config => VooNavigationConfig(
    items: _navigationItems,
    selectedId: _selectedId,
    navigationTheme: _getThemeForPreset(),
    isAdaptive: true,
    enableAnimations: true,
    enableHapticFeedback: true,
    showNotificationBadges: true,
    onNavigationItemSelected: (itemId) {
      setState(() => _selectedId = itemId);
    },
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use adaptive scaffold or manual layout based on selection
    if (_navStyle == NavStyleOption.adaptive) {
      return VooAdaptiveScaffold(
        config: _config,
        body: _buildContent(context, theme),
      );
    }

    return _buildManualLayout(context, theme);
  }

  Widget _buildManualLayout(BuildContext context, ThemeData theme) {
    final body = _buildContent(context, theme);

    switch (_navStyle) {
      case NavStyleOption.bottomNav:
        return Scaffold(
          body: body,
          bottomNavigationBar: VooAdaptiveBottomNavigation(
            config: _config,
            selectedId: _selectedId,
            onNavigationItemSelected: (id) => setState(() => _selectedId = id),
          ),
        );

      case NavStyleOption.floatingBottomNav:
        return Scaffold(
          body: body,
          extendBody: true,
          bottomNavigationBar: VooFloatingBottomNavigation(
            config: _config,
            selectedId: _selectedId,
            onNavigationItemSelected: (id) => setState(() => _selectedId = id),
            horizontalMargin: 16,
            bottomMargin: 24,
            borderRadius: 28,
          ),
        );

      case NavStyleOption.rail:
        return Scaffold(
          body: Row(
            children: [
              VooAdaptiveNavigationRail(
                config: _config,
                selectedId: _selectedId,
                onNavigationItemSelected: (id) => setState(() => _selectedId = id),
                extended: false,
              ),
              const VerticalDivider(width: 1),
              Expanded(child: body),
            ],
          ),
        );

      case NavStyleOption.drawer:
        return Scaffold(
          body: Row(
            children: [
              SizedBox(
                width: 280,
                child: VooAdaptiveNavigationDrawer(
                  config: _config,
                  selectedId: _selectedId,
                  onNavigationItemSelected: (id) => setState(() => _selectedId = id),
                ),
              ),
              Expanded(child: body),
            ],
          ),
        );

      case NavStyleOption.adaptive:
        // Handled above
        return const SizedBox.shrink();
    }
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    // Show theme showcase only on home, other pages show placeholder
    if (_selectedId != 'home') {
      return _buildPagePlaceholder(context, theme);
    }

    return Stack(
      children: [
        // Background gradient based on preset
        _buildBackground(theme),

        // Main content
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(theme),
                const SizedBox(height: 24),
                _buildNavStyleSelector(theme),
                const SizedBox(height: 24),
                _buildThemeSelector(theme),
                const SizedBox(height: 24),
                _buildPresetInfo(theme),
                const SizedBox(height: 24),
                _buildThemeControls(theme),
                const SizedBox(height: 24),
                _buildFeatureShowcase(theme),
                const SizedBox(height: 100), // Bottom padding for floating nav
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPagePlaceholder(BuildContext context, ThemeData theme) {
    final selectedItem = _navigationItems.firstWhere(
      (item) => item.id == _selectedId,
      orElse: () => _navigationItems.first,
    );

    return Stack(
      children: [
        _buildBackground(theme),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selectedItem.selectedIcon ?? selectedItem.icon,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                selectedItem.label,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Theme: ${_getPresetName()}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Style: ${_getNavStyleName(_navStyle)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () => setState(() => _selectedId = 'home'),
                icon: const Icon(Icons.palette),
                label: const Text('Back to Theme Showcase'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackground(ThemeData theme) {
    switch (_currentPreset) {
      case VooNavigationPreset.glassmorphism:
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withValues(alpha: 0.3),
                theme.colorScheme.secondary.withValues(alpha: 0.2),
                theme.colorScheme.tertiary.withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        );
      case VooNavigationPreset.neomorphism:
        return Container(
          color: theme.colorScheme.surface,
        );
      case VooNavigationPreset.material3Enhanced:
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.surface,
                theme.colorScheme.surfaceContainerLow,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        );
      case VooNavigationPreset.minimalModern:
        return Container(
          color: theme.colorScheme.surface,
        );
    }
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Icon(
          _getPresetIcon(),
          size: 32,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Theme Showcase',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Explore navigation visual styles',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavStyleSelector(ThemeData theme) {
    return Card(
      elevation: _currentPreset == VooNavigationPreset.neomorphism ? 0 : 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Navigation Style',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: NavStyleOption.values.map((style) {
                final isSelected = style == _navStyle;
                return ChoiceChip(
                  label: Text(_getNavStyleName(style)),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _navStyle = style);
                    }
                  },
                  avatar: Icon(
                    _getNavStyleIcon(style),
                    size: 18,
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSelector(ThemeData theme) {
    return Card(
      elevation: _currentPreset == VooNavigationPreset.neomorphism ? 0 : 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme Preset',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: VooNavigationPreset.values.map((preset) {
                final isSelected = preset == _currentPreset;
                return ChoiceChip(
                  label: Text(_getPresetNameFor(preset)),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _currentPreset = preset);
                    }
                  },
                  avatar: Icon(
                    _getPresetIconFor(preset),
                    size: 18,
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _getPresetNameFor(VooNavigationPreset preset) {
    switch (preset) {
      case VooNavigationPreset.glassmorphism:
        return 'Glass';
      case VooNavigationPreset.neomorphism:
        return 'Neumorphism';
      case VooNavigationPreset.material3Enhanced:
        return 'Material 3';
      case VooNavigationPreset.minimalModern:
        return 'Minimal';
    }
  }

  IconData _getPresetIconFor(VooNavigationPreset preset) {
    switch (preset) {
      case VooNavigationPreset.glassmorphism:
        return Icons.blur_on;
      case VooNavigationPreset.neomorphism:
        return Icons.layers;
      case VooNavigationPreset.material3Enhanced:
        return Icons.auto_awesome;
      case VooNavigationPreset.minimalModern:
        return Icons.crop_square;
    }
  }

  Widget _buildPresetInfo(ThemeData theme) {
    final navTheme = _getThemeForPreset();

    return Card(
      elevation: _currentPreset == VooNavigationPreset.neomorphism ? 0 : 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getPresetIcon(),
                    color: theme.colorScheme.onPrimaryContainer,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getPresetName(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _getPresetDescription(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            _buildThemeProperty(theme, 'Surface Opacity',
                '${(navTheme.surfaceOpacity * 100).toInt()}%'),
            _buildThemeProperty(
                theme, 'Blur Sigma', navTheme.blurSigma.toString()),
            _buildThemeProperty(
                theme, 'Indicator Style', navTheme.indicatorStyle.name),
            _buildThemeProperty(theme, 'Animation',
                '${navTheme.animationDuration.inMilliseconds}ms'),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeProperty(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeControls(ThemeData theme) {
    return Card(
      elevation: _currentPreset == VooNavigationPreset.neomorphism ? 0 : 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Usage Example',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant,
                ),
              ),
              child: SelectableText(
                _getCodeExample(),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  color: theme.colorScheme.onSurface,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCodeExample() {
    final factoryName = switch (_currentPreset) {
      VooNavigationPreset.glassmorphism => 'glassmorphism',
      VooNavigationPreset.neomorphism => 'neomorphism',
      VooNavigationPreset.material3Enhanced => 'material3Enhanced',
      VooNavigationPreset.minimalModern => 'minimalModern',
    };

    return '''VooNavigationConfig.$factoryName(
  items: navigationItems,
  selectedId: selectedId,
);''';
  }

  Widget _buildFeatureShowcase(ThemeData theme) {
    final features = [
      ('Adaptive', Icons.devices, 'Auto-switches layout'),
      ('Animated', Icons.animation, 'Smooth transitions'),
      ('Badges', Icons.notifications_active, 'Counts & dots'),
      ('Themed', Icons.palette, 'Light/dark aware'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Features',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: features.map((feature) {
            return Expanded(
              child: Card(
                elevation: _currentPreset == VooNavigationPreset.neomorphism ? 0 : 1,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Icon(
                        feature.$2,
                        size: 24,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        feature.$1,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        feature.$3,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
