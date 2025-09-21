import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_responsive/voo_responsive.dart';

@Preview(name: 'Responsive Builder Preview')
Widget responsiveBuilderPreview() => const ResponsivePreview();

@Preview(name: 'Breakpoint Preview')
Widget breakpointPreview() => const BreakpointPreview();

@Preview(name: 'Responsive Layout Preview')
Widget responsiveLayoutPreview() => const ResponsiveLayoutPreview();

class ResponsivePreview extends StatelessWidget {
  const ResponsivePreview({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Responsive Builder Preview'),
          ),
          body: VooResponsiveBuilder(
            builder: (context, screenInfo) => Center(
              child: Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildInfoRow('Device Type', screenInfo.deviceType.name),
                      _buildInfoRow('Screen Size', screenInfo.screenSize.name),
                      _buildInfoRow('Width', '${screenInfo.width.toStringAsFixed(0)}px'),
                      _buildInfoRow('Height', '${screenInfo.height.toStringAsFixed(0)}px'),
                      _buildInfoRow('Orientation', screenInfo.orientation.name),
                      _buildInfoRow('Pixel Ratio', screenInfo.pixelRatio.toStringAsFixed(2)),
                      _buildInfoRow('Text Scale', screenInfo.textScaler.toString()),
                      const Divider(height: 32),
                      _buildLayoutInfo(screenInfo),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildInfoRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(value),
          ],
        ),
      );

  Widget _buildLayoutInfo(ScreenInfo screenInfo) {
    final layout = screenInfo.isMobileLayout
        ? 'Mobile Layout'
        : screenInfo.isTabletLayout
            ? 'Tablet Layout'
            : 'Desktop Layout';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getColorForDevice(screenInfo.deviceType),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        layout,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getColorForDevice(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return Colors.blue;
      case DeviceType.tablet:
        return Colors.green;
      case DeviceType.desktop:
        return Colors.orange;
      case DeviceType.widescreen:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

class BreakpointPreview extends StatelessWidget {
  const BreakpointPreview({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Breakpoint Preview'),
          ),
          body: VooResponsiveBuilder(
            builder: (context, screenInfo) {
              final currentBreakpoint = ResponsiveConfig.defaultConfig.getBreakpointForWidth(screenInfo.width);

              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Column(
                      children: [
                        Text(
                          'Current Breakpoint',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentBreakpoint?.name ?? 'Unknown',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: Breakpoint.defaults.map((breakpoint) {
                        final isActive = currentBreakpoint?.name == breakpoint.name;
                        return Card(
                          color: isActive ? Theme.of(context).colorScheme.primaryContainer : null,
                          child: ListTile(
                            leading: Icon(
                              _getIconForDeviceType(breakpoint.deviceType),
                              color: isActive ? Theme.of(context).colorScheme.primary : null,
                            ),
                            title: Text(
                              breakpoint.name.toUpperCase(),
                              style: TextStyle(
                                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            subtitle: Text(
                              'Min: ${breakpoint.minWidth}px${breakpoint.maxWidth != null ? ' - Max: ${breakpoint.maxWidth}px' : '+'}',
                            ),
                            trailing: isActive
                                ? Icon(
                                    Icons.check_circle,
                                    color: Theme.of(context).colorScheme.primary,
                                  )
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );

  IconData _getIconForDeviceType(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return Icons.smartphone;
      case DeviceType.tablet:
        return Icons.tablet;
      case DeviceType.desktop:
        return Icons.desktop_windows;
      case DeviceType.widescreen:
        return Icons.tv;
      default:
        return Icons.devices;
    }
  }
}

class ResponsiveLayoutPreview extends StatefulWidget {
  const ResponsiveLayoutPreview({super.key});

  @override
  State<ResponsiveLayoutPreview> createState() => _ResponsiveLayoutPreviewState();
}

class _ResponsiveLayoutPreviewState extends State<ResponsiveLayoutPreview> {
  bool showGrid = true;

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Responsive Layout Preview'),
            actions: [
              IconButton(
                icon: Icon(showGrid ? Icons.grid_view : Icons.view_list),
                onPressed: () {
                  setState(() {
                    showGrid = !showGrid;
                  });
                },
              ),
            ],
          ),
          body: VooResponsiveBuilder(
            builder: (context, screenInfo) {
              final columns = ResponsiveHelper.getResponsiveColumns(
                context,
                mobileColumns: 2,
                tabletColumns: 3,
                desktopColumns: 4,
                widescreenColumns: 6,
              );

              final padding = ResponsiveHelper.getResponsiveValue<int>(
                context,
                mobile: 8,
                tablet: 16,
                desktop: 24,
                widescreen: 32,
              );

              if (!showGrid) {
                return ListView.builder(
                  padding: EdgeInsets.all(padding),
                  itemCount: 20,
                  itemBuilder: (context, index) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('${index + 1}'),
                      ),
                      title: Text('Item ${index + 1}'),
                      subtitle: Text('Responsive padding: ${padding.toInt()}px'),
                    ),
                  ),
                );
              }

              return GridView.builder(
                padding: EdgeInsets.all(padding),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 24,
                itemBuilder: (context, index) => Card(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${index + 1}',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          '$columns columns',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
}
