import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_ui/voo_ui.dart';

// VooCard Previews
@Preview(name: 'VooCard - Basic')
Widget vooCardBasic() => const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: VooCard(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Card Title',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('This is a basic card with some content inside it.'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

@Preview(name: 'VooCard - Interactive')
Widget vooCardInteractive() => MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: VooCard(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Tap me!'),
              ),
            ),
          ),
        ),
      ),
    );

@Preview(name: 'VooCard - Selected')
Widget vooCardSelected() => const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: VooCard(
              selected: true,
              selectedColor: Colors.blue,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Selected Card'),
              ),
            ),
          ),
        ),
      ),
    );

@Preview(name: 'VooCard - Elevated')
Widget vooCardElevated() => const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: VooCard(
              elevation: 8,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Elevated Card'),
              ),
            ),
          ),
        ),
      ),
    );

// VooContentCard Previews
@Preview(name: 'VooContentCard - Basic')
Widget vooContentCardBasic() => const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: VooContentCard(
              header: Text(
                'Card Header',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              content: Text('This is the main content of the card.'),
              footer: Text(
                'Footer information',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ),
        ),
      ),
    );

@Preview(name: 'VooContentCard - With Actions')
Widget vooContentCardWithActions() => MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: VooContentCard(
              header: const Text('Action Card'),
              content: const Text('Card with action buttons'),
              actions: [
                TextButton(
                  onPressed: () {},
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

@Preview(name: 'VooContentCard - With Dividers')
Widget vooContentCardWithDividers() => const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: VooContentCard(
              header: Text('Divided Card'),
              content: Text('Content separated by dividers'),
              footer: Text('Footer section'),
              dividerBetweenHeaderAndContent: true,
              dividerBetweenContentAndFooter: true,
            ),
          ),
        ),
      ),
    );

// VooListTile Previews
@Preview(name: 'VooListTile - Basic')
Widget vooListTileBasic() => const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: VooListTile(
              title: Text('List Item Title'),
              subtitle: Text('Supporting text'),
            ),
          ),
        ),
      ),
    );

@Preview(name: 'VooListTile - With Icons')
Widget vooListTileWithIcons() => MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: VooListTile(
              title: const Text('Folder'),
              subtitle: const Text('12 items'),
              leading: const Icon(Icons.folder),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ),
        ),
      ),
    );

@Preview(name: 'VooListTile - Selected')
Widget vooListTileSelected() => MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: VooListTile(
              title: const Text('Selected Item'),
              subtitle: const Text('This item is selected'),
              leading: const Icon(Icons.check_circle),
              isSelected: true,
              onTap: () {},
            ),
          ),
        ),
      ),
    );

// VooTimestamp Previews
@Preview(name: 'VooTimestamp - Now')
Widget vooTimestampNow() => MaterialApp(
      home: Scaffold(
        body: Center(
          child: VooTimestamp(
            timestamp: DateTime.now(),
          ),
        ),
      ),
    );

@Preview(name: 'VooTimestamp - Past')
Widget vooTimestampPast() => MaterialApp(
      home: Scaffold(
        body: Center(
          child: VooTimestamp(
            timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          ),
        ),
      ),
    );

@Preview(name: 'VooTimestamp - Custom Style')
Widget vooTimestampCustomStyle() => MaterialApp(
      home: Scaffold(
        body: Center(
          child: VooTimestamp(
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
