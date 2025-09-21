import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_lists/voo_lists.dart';

@Preview(name: 'Nested List')
Widget nestedListPreview() => const NestedListPreview();

@Preview(name: 'Nested Reorderable List')
Widget nestedReorderableListPreview() => const NestedReorderableListPreview();

@Preview(name: 'Expandable List')
Widget expandableListPreview() => const ExpandableListPreview();

@Preview(name: 'Searchable List')
Widget searchableListPreview() => const SearchableListPreview();

@Preview(name: 'Infinite List')
Widget infiniteListPreview() => const InfiniteListPreview();

@Preview(name: 'Paginated List')
Widget paginatedListPreview() => const PaginatedListPreview();

@Preview(name: 'All Lists')
Widget allListsShowcase() => const AllListsShowcase();

class NestedListPreview extends StatefulWidget {
  const NestedListPreview({super.key});

  @override
  State<NestedListPreview> createState() => _NestedListPreviewState();
}

class _NestedListPreviewState extends State<NestedListPreview> {
  late List<ListItem<String>> items;

  @override
  void initState() {
    super.initState();
    _initializeNestedData();
  }

  void _initializeNestedData() {
    items = [
      const ListItem<String>(
        id: 'root_1',
        data: 'Project A',
        title: 'Project A',
        subtitle: 'Main project folder',
        leading: Icon(Icons.folder, color: Colors.amber),
        isExpandable: true,
        children: [
          ListItem<String>(
            id: 'child_1_1',
            data: 'src',
            title: 'src',
            subtitle: 'Source files',
            leading: Icon(Icons.folder_open),
            isExpandable: true,
            children: [
              ListItem<String>(
                id: 'child_1_1_1',
                data: 'main.dart',
                title: 'main.dart',
                subtitle: '2.5 KB',
                leading: Icon(Icons.code),
              ),
              ListItem<String>(
                id: 'child_1_1_2',
                data: 'app.dart',
                title: 'app.dart',
                subtitle: '1.2 KB',
                leading: Icon(Icons.code),
              ),
            ],
          ),
          ListItem<String>(
            id: 'child_1_2',
            data: 'test',
            title: 'test',
            subtitle: 'Test files',
            leading: Icon(Icons.folder_open),
            isExpandable: true,
            children: [
              ListItem<String>(
                id: 'child_1_2_1',
                data: 'widget_test.dart',
                title: 'widget_test.dart',
                subtitle: '3.1 KB',
                leading: Icon(Icons.bug_report),
              ),
            ],
          ),
        ],
      ),
      const ListItem<String>(
        id: 'root_2',
        data: 'Project B',
        title: 'Project B',
        subtitle: 'Secondary project',
        leading: Icon(Icons.folder, color: Colors.blue),
        isExpandable: true,
        children: [
          ListItem<String>(
            id: 'child_2_1',
            data: 'lib',
            title: 'lib',
            subtitle: 'Library files',
            leading: Icon(Icons.folder_open),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Nested List Preview'),
        ),
        body: _buildNestedListView(items, 0),
      );

  Widget _buildNestedListView(List<ListItem<String>> items, int depth) => ListView.builder(
        padding: EdgeInsets.only(left: depth * 16.0),
        itemCount: items.length,
        physics: depth > 0 ? const NeverScrollableScrollPhysics() : null,
        shrinkWrap: depth > 0,
        itemBuilder: (context, index) {
          final item = items[index];
          if (item.isExpandable && item.children != null) {
            return ExpansionTile(
              key: ValueKey(item.id),
              leading: item.leading,
              title: Text(item.title),
              subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
              children: [
                _buildNestedListView(item.children!, depth + 1),
              ],
            );
          } else {
            return ListTile(
              leading: item.leading,
              title: Text(item.title),
              subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Selected: ${item.title}')),
                );
              },
            );
          }
        },
      );
}

class ExpandableListPreview extends StatefulWidget {
  const ExpandableListPreview({super.key});

  @override
  State<ExpandableListPreview> createState() => _ExpandableListPreviewState();
}

class _ExpandableListPreviewState extends State<ExpandableListPreview> {
  final Set<String> expandedItems = {};

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Expandable List Preview'),
          actions: [
            IconButton(
              icon: const Icon(Icons.unfold_more),
              onPressed: () {
                setState(() {
                  expandedItems.clear();
                  for (int i = 0; i < 10; i++) {
                    expandedItems.add('expand_$i');
                  }
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.unfold_less),
              onPressed: () {
                setState(expandedItems.clear);
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            final id = 'expand_$index';
            final isExpanded = expandedItems.contains(id);

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                    ),
                    title: Text('Expandable Item ${index + 1}'),
                    subtitle: Text('Tap to ${isExpanded ? 'collapse' : 'expand'}'),
                    trailing: Chip(
                      label: Text('${index * 3 + 5} items'),
                    ),
                    onTap: () {
                      setState(() {
                        if (isExpanded) {
                          expandedItems.remove(id);
                        } else {
                          expandedItems.add(id);
                        }
                      });
                    },
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: isExpanded ? null : 0,
                    child: isExpanded
                        ? Column(
                            children: List.generate(
                              3,
                              (subIndex) => ListTile(
                                contentPadding: const EdgeInsets.only(left: 72, right: 16),
                                leading: const Icon(Icons.subdirectory_arrow_right),
                                title: Text('Sub-item ${subIndex + 1}'),
                                subtitle: Text('Detail for item ${index + 1}.${subIndex + 1}'),
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Selected sub-item ${subIndex + 1}'),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            );
          },
        ),
      );
}

class SearchableListPreview extends StatefulWidget {
  const SearchableListPreview({super.key});

  @override
  State<SearchableListPreview> createState() => _SearchableListPreviewState();
}

class _SearchableListPreviewState extends State<SearchableListPreview> {
  final TextEditingController searchController = TextEditingController();
  List<ListItem<String>> allItems = [];
  List<ListItem<String>> filteredItems = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
    searchController.addListener(_onSearchChanged);
  }

  void _initializeData() {
    allItems = List.generate(
      50,
      (index) => ListItem<String>(
        id: 'search_$index',
        data: 'Data $index',
        title: 'Item ${index + 1}',
        subtitle: 'Category: ${['Electronics', 'Books', 'Clothing', 'Food', 'Sports'][index % 5]}',
        leading: Icon(
          [
            Icons.computer,
            Icons.book,
            Icons.checkroom,
            Icons.restaurant,
            Icons.sports_basketball,
          ][index % 5],
        ),
      ),
    );
    filteredItems = List.from(allItems);
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = searchController.text.toLowerCase();
      if (searchQuery.isEmpty) {
        filteredItems = List.from(allItems);
      } else {
        filteredItems = allItems
            .where(
              (item) => item.title.toLowerCase().contains(searchQuery) || (item.subtitle?.toLowerCase().contains(searchQuery) ?? false),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Searchable List Preview'),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search items...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: searchController.clear,
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${filteredItems.length} items found',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (searchQuery.isNotEmpty)
                    TextButton(
                      onPressed: searchController.clear,
                      child: const Text('Clear filter'),
                    ),
                ],
              ),
            ),
            Expanded(
              child: filteredItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            'No items match "$searchQuery"',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          const Text('Try a different search term'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return ListTile(
                          leading: item.leading,
                          title: Text(item.title),
                          subtitle: Text(item.subtitle ?? ''),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Selected: ${item.title}')),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      );

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

class InfiniteListPreview extends StatefulWidget {
  const InfiniteListPreview({super.key});

  @override
  State<InfiniteListPreview> createState() => _InfiniteListPreviewState();
}

class _InfiniteListPreviewState extends State<InfiniteListPreview> {
  final ScrollController scrollController = ScrollController();
  List<ListItem<String>> items = [];
  bool isLoading = false;
  int currentPage = 0;
  final int itemsPerPage = 20;

  @override
  void initState() {
    super.initState();
    _loadMoreItems();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    await Future<void>.delayed(const Duration(seconds: 1));

    setState(() {
      final startIndex = currentPage * itemsPerPage;
      final newItems = List.generate(
        itemsPerPage,
        (index) {
          final itemIndex = startIndex + index;
          return ListItem<String>(
            id: 'infinite_$itemIndex',
            data: 'Data $itemIndex',
            title: 'Item ${itemIndex + 1}',
            subtitle: 'Loaded in page ${currentPage + 1}',
            leading: CircleAvatar(
              child: Text('${itemIndex + 1}'),
            ),
          );
        },
      );
      items.addAll(newItems);
      currentPage++;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Infinite List Preview'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  items.clear();
                  currentPage = 0;
                });
                _loadMoreItems();
              },
            ),
          ],
        ),
        body: ListView.builder(
          controller: scrollController,
          itemCount: items.length + (isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == items.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final item = items[index];
            return ListTile(
              leading: item.leading,
              title: Text(item.title),
              subtitle: Text(item.subtitle ?? ''),
              trailing: Text(
                '#${index + 1}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            );
          },
        ),
      );

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

class PaginatedListPreview extends StatefulWidget {
  const PaginatedListPreview({super.key});

  @override
  State<PaginatedListPreview> createState() => _PaginatedListPreviewState();
}

class _PaginatedListPreviewState extends State<PaginatedListPreview> {
  List<ListItem<String>> currentPageItems = [];
  bool isLoading = false;
  int currentPage = 1;
  final int totalPages = 10;
  final int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _loadPage(1);
  }

  Future<void> _loadPage(int page) async {
    setState(() {
      isLoading = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 500));

    setState(() {
      currentPage = page;
      final startIndex = (page - 1) * itemsPerPage;
      currentPageItems = List.generate(
        itemsPerPage,
        (index) {
          final itemIndex = startIndex + index;
          return ListItem<String>(
            id: 'page_${page}_item_$index',
            data: 'Data $itemIndex',
            title: 'Item ${itemIndex + 1}',
            subtitle: 'Page $page of $totalPages',
            leading: const Icon(Icons.article),
          );
        },
      );
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Paginated List Preview'),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.first_page),
                    onPressed: currentPage > 1 && !isLoading ? () => _loadPage(1) : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: currentPage > 1 && !isLoading ? () => _loadPage(currentPage - 1) : null,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Page $currentPage of $totalPages',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: currentPage < totalPages && !isLoading ? () => _loadPage(currentPage + 1) : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.last_page),
                    onPressed: currentPage < totalPages && !isLoading ? () => _loadPage(totalPages) : null,
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      itemCount: currentPageItems.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = currentPageItems[index];
                        return ListTile(
                          leading: item.leading,
                          title: Text(item.title),
                          subtitle: Text(item.subtitle ?? ''),
                          trailing: Text(
                            '${(currentPage - 1) * itemsPerPage + index + 1}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Selected: ${item.title}')),
                            );
                          },
                        );
                      },
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Wrap(
                spacing: 4,
                alignment: WrapAlignment.center,
                children: List.generate(
                  totalPages,
                  (index) {
                    final page = index + 1;
                    return ActionChip(
                      label: Text('$page'),
                      onPressed: !isLoading && page != currentPage ? () => _loadPage(page) : null,
                      backgroundColor: page == currentPage ? Theme.of(context).colorScheme.primary : null,
                      labelStyle: TextStyle(
                        color: page == currentPage ? Theme.of(context).colorScheme.onPrimary : null,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
}

class NestedReorderableListPreview extends StatefulWidget {
  const NestedReorderableListPreview({super.key});

  @override
  State<NestedReorderableListPreview> createState() => _NestedReorderableListPreviewState();
}

class _NestedReorderableListPreviewState extends State<NestedReorderableListPreview> {
  late List<ListItem<String>> items;
  bool showDepthIndicator = true;
  bool startExpanded = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    items = [
      const ListItem<String>(
        id: 'task_1',
        data: 'Task Group 1',
        title: '📋 Project Planning',
        subtitle: 'Q1 2024 Goals',
        leading: Icon(Icons.folder_special, color: Colors.blue),
        isReorderable: true,
        isExpandable: true,
        children: [
          ListItem<String>(
            id: 'task_1_1',
            data: 'Define Requirements',
            title: '📝 Define Requirements',
            subtitle: 'Gather all requirements',
            leading: Icon(Icons.description),
            isReorderable: true,
          ),
          ListItem<String>(
            id: 'task_1_2',
            data: 'Design Phase',
            title: '🎨 Design Phase',
            subtitle: 'Create mockups and prototypes',
            leading: Icon(Icons.palette),
            isReorderable: true,
            isExpandable: true,
            children: [
              ListItem<String>(
                id: 'task_1_2_1',
                data: 'Wireframes',
                title: '📐 Wireframe',
                subtitle: 'Low-fidelity designs',
                leading: Icon(Icons.grid_on),
                isReorderable: true,
              ),
              ListItem<String>(
                id: 'task_1_2_2',
                data: 'High-fidelity',
                title: '✨ High-fidelity Mockups',
                subtitle: 'Detailed designs',
                leading: Icon(Icons.auto_awesome),
                isReorderable: true,
              ),
            ],
          ),
          ListItem<String>(
            id: 'task_1_3',
            data: 'Development',
            title: '💻 Development',
            subtitle: 'Implementation phase',
            leading: Icon(Icons.code),
            isReorderable: true,
          ),
        ],
      ),
      const ListItem<String>(
        id: 'task_2',
        data: 'Task Group 2',
        title: '🚀 Sprint Tasks',
        subtitle: 'Current sprint items',
        leading: Icon(Icons.rocket_launch, color: Colors.orange),
        isReorderable: true,
        isExpandable: true,
        children: [
          ListItem<String>(
            id: 'task_2_1',
            data: 'Bug Fixes',
            title: '🐛 Bug Fixes',
            subtitle: 'Critical bugs',
            leading: Icon(Icons.bug_report, color: Colors.red),
            isReorderable: true,
          ),
          ListItem<String>(
            id: 'task_2_2',
            data: 'Features',
            title: '⭐ New Features',
            subtitle: 'Feature development',
            leading: Icon(Icons.star, color: Colors.yellow),
            isReorderable: true,
          ),
          ListItem<String>(
            id: 'task_2_3',
            data: 'Testing',
            title: '✅ Testing',
            subtitle: 'QA and testing',
            leading: Icon(Icons.check_circle, color: Colors.green),
            isReorderable: true,
          ),
        ],
      ),
      const ListItem<String>(
        id: 'task_3',
        data: 'Task Group 3',
        title: '📚 Documentation',
        subtitle: 'Update docs and guides',
        leading: Icon(Icons.book, color: Colors.purple),
        isReorderable: true,
      ),
    ];
  }

  void _handleReorder(List<ListItem<String>> reorderedItems) {
    setState(() {
      items = reorderedItems;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('List reordered'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _handleItemMoved(ListItem<String> item, ListItem<String>? newParent) {
    final parentTitle = newParent?.title ?? 'root level';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Moved "${item.title}" to $parentTitle'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Enhanced Nested Reorderable List'),
          actions: [
            IconButton(
              icon: const Icon(Icons.shuffle),
              onPressed: () {
                setState(() {
                  items.shuffle();
                });
              },
              tooltip: 'Shuffle root items',
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _initializeData,
              tooltip: 'Reset list',
            ),
          ],
        ),
        body: Column(
          children: [
            // Info banner
            Container(
              padding: const EdgeInsets.all(12),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '✨ Enhanced UX: Drag items by the handle. Drop zones appear when hovering. Color-coded depth levels show hierarchy.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Feature toggles
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Text('Depth Indicators'),
                      Switch(
                        value: showDepthIndicator,
                        onChanged: (value) {
                          setState(() {
                            showDepthIndicator = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Start Expanded'),
                      Switch(
                        value: startExpanded,
                        onChanged: (value) {
                          setState(() {
                            startExpanded = value;
                            _initializeData();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: VooNestedReorderableList<String>(
                key: ValueKey('$showDepthIndicator-$startExpanded'),
                items: items,
                config: const ListConfig(
                  enableReordering: true,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  itemSpacing: 8,
                  animationType: ListAnimationType.slideIn,
                ),
                onNestedReorder: _handleReorder,
                onItemMoved: _handleItemMoved,
                startExpanded: startExpanded,
                showTreeLines: false,
                showDepthIndicator: showDepthIndicator,
                maxNestingDepth: 4,
                onItemTap: (item) {
                  if (item.children == null || item.children!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Selected: ${item.title}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      );
}

class AllListsShowcase extends StatelessWidget {
  const AllListsShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final listTypes = [
      ('Simple List', 'Basic scrollable list', Icons.list),
      ('Grouped List', 'Lists with sections', Icons.view_agenda),
      ('Reorderable List', 'Drag to reorder', Icons.drag_handle),
      ('Nested List', 'Hierarchical structure', Icons.account_tree),
      ('Nested Reorderable', 'Drag nested items', Icons.swap_vert),
      ('Expandable List', 'Expand/collapse items', Icons.expand_more),
      ('Searchable List', 'Built-in search', Icons.search),
      ('Infinite List', 'Endless scrolling', Icons.all_inclusive),
      ('Paginated List', 'Page navigation', Icons.pages),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('VooLists Showcase'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: listTypes.length,
        itemBuilder: (context, index) {
          final (title, subtitle, icon) = listTypes[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: Icon(icon, size: 32),
              title: Text(title),
              subtitle: Text(subtitle),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Navigate to $title preview'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
