import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_lists/src/presentation/previews/additional_list_previews.dart';
import 'package:voo_lists/src/presentation/previews/list_preview.dart';

@Preview(name: 'All VooLists Showcase')
Widget allVooListsPreview() => const VooListsShowcasePage();

class VooListsShowcasePage extends StatelessWidget {
  const VooListsShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final listPreviews = [
      ('Simple List', 'Basic scrollable list with standard features', Icons.list, const ListPreview()),
      ('Grouped List', 'Lists organized in sections', Icons.view_agenda, const GroupedListPreview()),
      ('Reorderable List', 'Drag and drop to reorder items', Icons.drag_handle, const ReorderableListPreview()),
      ('Nested List', 'Hierarchical tree-like structure', Icons.account_tree, const NestedListPreview()),
      ('Expandable List', 'Expand/collapse individual items', Icons.expand_more, const ExpandableListPreview()),
      ('Searchable List', 'Built-in search functionality', Icons.search, const SearchableListPreview()),
      ('Infinite List', 'Endless scrolling with lazy loading', Icons.all_inclusive, const InfiniteListPreview()),
      ('Paginated List', 'Navigate through pages of items', Icons.pages, const PaginatedListPreview()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('VooLists Showcase'),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(
                    Icons.list_alt,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'VooLists Package',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Comprehensive list widgets for Flutter',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatistic(context, '8', 'List Types'),
                        Container(
                          height: 40,
                          width: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                        _buildStatistic(context, '15+', 'Features'),
                        Container(
                          height: 40,
                          width: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                        _buildStatistic(context, '∞', 'Possibilities'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.5,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final (title, subtitle, icon, preview) = listPreviews[index];
                  return Card(
                    elevation: 2,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => preview,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(height: 12),
                            Text(
                              title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'View',
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: listPreviews.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistic(BuildContext context, String value, String label) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
        ],
      );
}
