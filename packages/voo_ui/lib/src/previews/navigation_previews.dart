import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_ui/voo_ui.dart';

// VooAppBar Previews
@Preview(name: 'VooAppBar - Basic')
Widget vooAppBarBasic() => const MaterialApp(
      home: Scaffold(
        appBar: VooAppBar(
          title: Text('Page Title'),
        ),
        body: Center(
          child: Text('Page content'),
        ),
      ),
    );

@Preview(name: 'VooAppBar - With Actions')
Widget vooAppBarWithActions() => MaterialApp(
      home: Scaffold(
        appBar: VooAppBar(
          title: const Text('App Bar'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
        body: const Center(
          child: Text('Page content'),
        ),
      ),
    );

@Preview(name: 'VooAppBar - With Leading')
Widget vooAppBarWithLeading() => MaterialApp(
      home: Scaffold(
        appBar: VooAppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
          title: const Text('Custom Leading'),
        ),
        body: const Center(
          child: Text('Page content'),
        ),
      ),
    );

@Preview(name: 'VooAppBar - Centered Title')
Widget vooAppBarCenteredTitle() => const MaterialApp(
      home: Scaffold(
        appBar: VooAppBar(
          title: Text('Centered Title'),
          centerTitle: true,
        ),
        body: Center(
          child: Text('Page content'),
        ),
      ),
    );

@Preview(name: 'VooAppBar - Custom Colors')
Widget vooAppBarCustomColors() => MaterialApp(
      home: Scaffold(
        appBar: VooAppBar(
          title: const Text('Custom Colors'),
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {},
            ),
          ],
        ),
        body: const Center(
          child: Text('Page content'),
        ),
      ),
    );

@Preview(name: 'VooAppBar - With Bottom')
Widget vooAppBarWithBottom() => MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: VooAppBar(
            title: const Text('With Tabs'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Tab 1'),
                Tab(text: 'Tab 2'),
                Tab(text: 'Tab 3'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              Center(child: Text('Tab 1 content')),
              Center(child: Text('Tab 2 content')),
              Center(child: Text('Tab 3 content')),
            ],
          ),
        ),
      ),
    );

@Preview(name: 'VooAppBar - Elevated')
Widget vooAppBarElevated() => const MaterialApp(
      home: Scaffold(
        appBar: VooAppBar(
          title: Text('Elevated App Bar'),
          elevation: 8,
        ),
        body: Center(
          child: Text('Page content'),
        ),
      ),
    );