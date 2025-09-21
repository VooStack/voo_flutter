import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_lists/voo_lists.dart';

@Preview(name: 'Simple List Preview')
Widget simpleListPreview() => const ListPreview();

@Preview(name: 'Grouped List Preview')
Widget groupedListPreview() => const GroupedListPreview();

@Preview(name: 'Reorderable List Preview')
Widget reorderableListPreview() => const ReorderableListPreview();

class ListPreview extends StatefulWidget {
  const ListPreview({super.key});

  @override
  State<ListPreview> createState() => _ListPreviewState();
}

class _ListPreviewState extends State<ListPreview> {
  final VooListController<String> controller = VooListController<String>();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    final items = List.generate(
      20,
      (index) => ListItem<String>(
        id: 'item_$index',
        data: 'Data $index',
        title: 'Item ${index + 1}',
        subtitle: 'This is item number ${index + 1}',
        isSelectable: true,
        isDismissible: index % 2 == 0,
        leading: const Icon(Icons.folder),
        trailing: index % 3 == 0 ? const Icon(Icons.arrow_forward_ios) : null,
      ),
    );
    controller.setItems(items);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Simple List Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.setItems([]);
              controller.setLoading(true);
              Future.delayed(const Duration(seconds: 1), () {
                _initializeData();
                controller.setLoading(false);
              });
            },
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return VooSimpleList<String>(
            items: controller.items,
            config: const ListConfig(
              enableSelection: true,
              enableMultiSelection: true,
              enablePullToRefresh: true,
              padding: EdgeInsets.all(8),
              itemSpacing: 4,
              emptyStateWidget: VooListEmptyState(
                icon: Icon(Icons.inbox, size: 64, color: Colors.grey),
                title: 'No Items',
                message: 'There are no items to display',
              ),
            ),
            onItemTap: (item) {
              log('Tapped: ${item.title}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped: ${item.title}')),
              );
            },
            onItemLongPress: (item) {
              log('Long pressed: ${item.title}');
            },
            onSelectionChanged: (selectedItems) {
              log('Selected ${selectedItems.length} items');
            },
            onRefresh: () async {
              await Future<void>.delayed(const Duration(seconds: 1));
              _initializeData();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newId = DateTime.now().millisecondsSinceEpoch.toString();
          controller.addItem(
            ListItem<String>(
              id: newId,
              data: 'New Data',
              title: 'New Item',
              subtitle: 'Added at ${DateTime.now()}',
              isSelectable: true,
              leading: const Icon(Icons.add_circle),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class GroupedListPreview extends StatefulWidget {
  const GroupedListPreview({super.key});

  @override
  State<GroupedListPreview> createState() => _GroupedListPreviewState();
}

class _GroupedListPreviewState extends State<GroupedListPreview> {
  final List<ListGroup<String>> groups = [
    ListGroup<String>(
      id: 'favorites',
      title: 'Favorites',
      subtitle: 'Your favorite items',
      items: List.generate(
        5,
        (index) => ListItem<String>(
          id: 'fav_$index',
          data: 'Favorite $index',
          title: 'Favorite ${index + 1}',
          subtitle: 'This is a favorite item',
          leading: const Icon(Icons.star, color: Colors.amber),
        ),
      ),
    ),
    ListGroup<String>(
      id: 'recent',
      title: 'Recent',
      subtitle: 'Recently accessed items',
      items: List.generate(
        8,
        (index) => ListItem<String>(
          id: 'recent_$index',
          data: 'Recent $index',
          title: 'Recent ${index + 1}',
          subtitle: 'Accessed ${index + 1} hours ago',
          leading: const Icon(Icons.access_time),
        ),
      ),
    ),
    ListGroup<String>(
      id: 'archived',
      title: 'Archived',
      subtitle: 'Archived items',
      isExpanded: false,
      items: List.generate(
        3,
        (index) => ListItem<String>(
          id: 'archive_$index',
          data: 'Archive $index',
          title: 'Archived ${index + 1}',
          subtitle: 'Archived on ${DateTime.now().subtract(Duration(days: index + 1))}',
          leading: const Icon(Icons.archive),
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Grouped List Preview'),
      ),
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, groupIndex) {
          final group = groups[groupIndex];
          return ExpansionTile(
            key: ValueKey(group.id),
            title: Text(group.title),
            subtitle: group.subtitle != null ? Text(group.subtitle!) : null,
            initiallyExpanded: group.isExpanded,
            children: [
              VooListSectionHeader(
                title: group.title,
                subtitle: '${group.items.length} items',
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              ),
              ...group.items.map((item) => VooListTile(
                item: item,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tapped: ${item.title}')),
                  );
                },
              ),
            ),
            ],
          );
        },
      ),
    );
}

class ReorderableListPreview extends StatefulWidget {
  const ReorderableListPreview({super.key});

  @override
  State<ReorderableListPreview> createState() => _ReorderableListPreviewState();
}

class _ReorderableListPreviewState extends State<ReorderableListPreview> {
  List<ListItem<String>> items = List.generate(
    10,
    (index) => ListItem<String>(
      id: 'reorder_$index',
      data: 'Data $index',
      title: 'Item ${index + 1}',
      subtitle: 'Drag to reorder',
      isReorderable: true,
      leading: const Icon(Icons.drag_handle),
      trailing: Text('Position: ${index + 1}'),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Reorderable List Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: () {
              setState(() {
                items.shuffle();
              });
            },
          ),
        ],
      ),
      body: VooReorderableList<String>(
        items: items,
        config: const ListConfig(
          enableReordering: true,
          showDividers: false,
          padding: EdgeInsets.all(8),
          animationType: ListAnimationType.slideIn,
        ),
        onReorder: (newIndex) {
          log('Item moved to position: $newIndex');
        },
      ),
    );
}