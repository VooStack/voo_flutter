import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_ui/voo_ui.dart';

// VooContainer Previews
@Preview(name: 'VooContainer - Basic')
Widget vooContainerBasic() => const MaterialApp(
      home: Scaffold(
        body: Center(
          child: VooContainer(
            paddingSize: VooSpacingSize.lg,
            child: Text('Container with padding'),
          ),
        ),
      ),
    );

@Preview(name: 'VooContainer - With Margin')
Widget vooContainerWithMargin() => MaterialApp(
      home: Scaffold(
        body: Center(
          child: VooContainer(
            paddingSize: VooSpacingSize.lg,
            marginSize: VooSpacingSize.xl,
            color: Colors.blue.shade50,
            child: const Text('Container with margin'),
          ),
        ),
      ),
    );

@Preview(name: 'VooContainer - With Border Radius')
Widget vooContainerWithBorderRadius() => MaterialApp(
      home: Scaffold(
        body: Center(
          child: VooContainer(
            paddingSize: VooSpacingSize.xl,
            borderRadiusSize: VooSpacingSize.lg,
            color: Colors.purple.shade100,
            child: const Text('Rounded container'),
          ),
        ),
      ),
    );

@Preview(name: 'VooContainer - Elevated')
Widget vooContainerElevated() => const MaterialApp(
      home: Scaffold(
        body: Center(
          child: VooContainer(
            paddingSize: VooSpacingSize.xl,
            elevation: 4,
            child: Text('Elevated container'),
          ),
        ),
      ),
    );

@Preview(name: 'VooContainer - With Border')
Widget vooContainerWithBorder() => MaterialApp(
      home: Scaffold(
        body: Center(
          child: VooContainer(
            paddingSize: VooSpacingSize.lg,
            borderRadiusSize: VooSpacingSize.md,
            border: Border.all(color: Colors.blue, width: 2),
            child: const Text('Container with border'),
          ),
        ),
      ),
    );

@Preview(name: 'VooContainer - Gradient')
Widget vooContainerGradient() => const MaterialApp(
      home: Scaffold(
        body: Center(
          child: VooContainer(
            paddingSize: VooSpacingSize.xl,
            borderRadiusSize: VooSpacingSize.lg,
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            child: Text(
              'Gradient container',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

@Preview(name: 'VooContainer - Animated')
Widget vooContainerAnimated() => const MaterialApp(
      home: Scaffold(
        body: Center(
          child: VooContainer(
            animate: true,
            paddingSize: VooSpacingSize.xl,
            width: 200,
            height: 100,
            color: Colors.teal,
            child: Center(
              child: Text(
                'Animated',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );

// VooResponsiveContainer Previews
@Preview(name: 'VooResponsiveContainer - Basic')
Widget vooResponsiveContainerBasic() => const MaterialApp(
      home: Scaffold(
        body: VooResponsiveContainer(
          maxWidth: 600,
          paddingSize: VooSpacingSize.lg,
          child: Text('Responsive container with max width'),
        ),
      ),
    );

@Preview(name: 'VooResponsiveContainer - Centered')
Widget vooResponsiveContainerCentered() => MaterialApp(
      home: Scaffold(
        body: VooResponsiveContainer(
          maxWidth: 400,
          centerContent: true,
          paddingSize: VooSpacingSize.xl,
          backgroundColor: Colors.grey.shade100,
          borderRadiusSize: VooSpacingSize.lg,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info, size: 48),
              SizedBox(height: 16),
              Text('Centered content'),
            ],
          ),
        ),
      ),
    );

@Preview(name: 'VooResponsiveContainer - With Constraints')
Widget vooResponsiveContainerWithConstraints() => MaterialApp(
      home: Scaffold(
        body: VooResponsiveContainer(
          minWidth: 300,
          maxWidth: 800,
          minHeight: 200,
          maxHeight: 400,
          paddingSize: VooSpacingSize.lg,
          backgroundColor: Colors.blue.shade50,
          child: const Center(
            child: Text('Container with min/max constraints'),
          ),
        ),
      ),
    );

// VooPageHeader Previews
@Preview(name: 'VooPageHeader - Basic')
Widget vooPageHeaderBasic() => const MaterialApp(
      home: Scaffold(
        body: VooPageHeader(
          icon: Icons.dashboard,
          title: 'Dashboard',
          subtitle: 'View your metrics',
        ),
      ),
    );

@Preview(name: 'VooPageHeader - With Actions')
Widget vooPageHeaderWithActions() => MaterialApp(
      home: Scaffold(
        body: VooPageHeader(
          icon: Icons.settings,
          title: 'Settings',
          subtitle: 'Manage your preferences',
          iconColor: Colors.blue,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );

@Preview(name: 'VooPageHeader - Custom Color')
Widget vooPageHeaderCustomColor() => const MaterialApp(
      home: Scaffold(
        body: VooPageHeader(
          icon: Icons.analytics,
          title: 'Analytics',
          subtitle: 'Track your performance',
          iconColor: Colors.green,
        ),
      ),
    );