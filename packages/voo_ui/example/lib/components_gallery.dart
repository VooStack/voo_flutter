import 'package:flutter/material.dart';
import 'package:voo_ui/voo_ui.dart';

class ComponentsGallery extends StatelessWidget {
  const ComponentsGallery({super.key});

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Components Gallery'),
      ),
      body: ListView(
        padding: EdgeInsets.all(design.spacingLg),
        children: [
          _SectionHeader(title: 'Buttons'),
          _ButtonsSection(),
          
          _SectionHeader(title: 'Input Fields'),
          _InputFieldsSection(),
          
          _SectionHeader(title: 'Cards & Containers'),
          _CardsSection(),
          
          _SectionHeader(title: 'Status & Badges'),
          _StatusSection(),
          
          _SectionHeader(title: 'Lists'),
          _ListsSection(),
          
          _SectionHeader(title: 'Empty States'),
          _EmptyStatesSection(),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  
  const _SectionHeader({required this.title});
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    return Padding(
      padding: EdgeInsets.only(
        top: design.spacingXl,
        bottom: design.spacingMd,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}

class _ButtonsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    return Wrap(
      spacing: design.spacingMd,
      runSpacing: design.spacingMd,
      children: [
        VooButton(
          onPressed: () {},
          variant: VooButtonVariant.elevated,
          child: const Text('Elevated'),
        ),
        VooButton(
          onPressed: () {},
          variant: VooButtonVariant.tonal,
          child: const Text('Filled'),
        ),
        VooButton(
          onPressed: () {},
          variant: VooButtonVariant.tonal,
          child: const Text('Tonal'),
        ),
        VooButton(
          onPressed: () {},
          variant: VooButtonVariant.outlined,
          child: const Text('Outlined'),
        ),
        VooButton(
          onPressed: () {},
          variant: VooButtonVariant.text,
          child: const Text('Text'),
        ),
        VooButton(
          onPressed: () {},
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 18),
              SizedBox(width: 8),
              Text('With Icon'),
            ],
          ),
        ),
        VooButton(
          onPressed: () {},
          loading: true,
          child: const Text('Loading'),
        ),
        VooButton(
          onPressed: null,
          child: const Text('Disabled'),
        ),
      ],
    );
  }
}

class _InputFieldsSection extends StatefulWidget {
  @override
  State<_InputFieldsSection> createState() => _InputFieldsSectionState();
}

class _InputFieldsSectionState extends State<_InputFieldsSection> {
  String? _dropdownValue;
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VooTextField(
          label: 'Text Field',
          hint: 'Enter some text...',
          onChanged: (value) {},
        ),
        SizedBox(height: design.spacingMd),
        VooTextField(
          label: 'Password Field',
          hint: 'Enter password...',
          obscureText: true,
          onChanged: (value) {},
        ),
        SizedBox(height: design.spacingMd),
        VooTextField(
          label: 'With Prefix Icon',
          hint: 'Search...',
          prefixIcon: Icons.search,
          onChanged: (value) {},
        ),
        SizedBox(height: design.spacingMd),
        VooDropdown<String>(
          label: 'Dropdown',
          value: _dropdownValue,
          items: [
            VooDropdownItem(value: 'option1', label: 'Option 1'),
            VooDropdownItem(value: 'option2', label: 'Option 2'),
            VooDropdownItem(value: 'option3', label: 'Option 3'),
          ],
          onChanged: (value) {
            setState(() {
              _dropdownValue = value;
            });
          },
        ),
        SizedBox(height: design.spacingMd),
        VooSearchBar(
          hintText: 'Search...',
          onSearchChanged: (value) {},
        ),
      ],
    );
  }
}

class _CardsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    return Column(
      children: [
        VooCard(
          child: Padding(
            padding: EdgeInsets.all(design.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Basic Card',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: design.spacingSm),
                Text(
                  'This is a basic card with some content inside.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: design.spacingMd),
        VooCard(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Card tapped!'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(design.spacingLg),
            child: Row(
              children: [
                Icon(
                  Icons.touch_app,
                  size: design.iconSizeLg,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: design.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Interactive Card',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Tap me!',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    return Wrap(
      spacing: design.spacingMd,
      runSpacing: design.spacingMd,
      children: [
        const VooStatusBadge(statusCode: 200),
        const VooStatusBadge(statusCode: 201),
        const VooStatusBadge(statusCode: 400),
        const VooStatusBadge(statusCode: 401),
        const VooStatusBadge(statusCode: 404),
        const VooStatusBadge(statusCode: 500),
        const VooStatusBadge(statusCode: 503),
        const VooStatusBadge(statusCode: 200, compact: true),
        const VooStatusBadge(statusCode: 400, compact: true),
        const VooStatusBadge(statusCode: 500, compact: true),
      ],
    );
  }
}

class _ListsSection extends StatefulWidget {
  @override
  State<_ListsSection> createState() => _ListsSectionState();
}

class _ListsSectionState extends State<_ListsSection> {
  final Set<int> _selectedItems = {};
  
  @override
  Widget build(BuildContext context) {
    return VooCard(
      child: Column(
        children: List.generate(3, (index) {
          final isSelected = _selectedItems.contains(index);
          return VooListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
            title: Text('List Item ${index + 1}'),
            subtitle: Text('Subtitle for item ${index + 1}'),
            trailing: Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? Theme.of(context).colorScheme.primary : null,
            ),
            onTap: () {
              setState(() {
                if (_selectedItems.contains(index)) {
                  _selectedItems.remove(index);
                } else {
                  _selectedItems.add(index);
                }
              });
            },
          );
        }),
      ),
    );
  }
}

class _EmptyStatesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: VooEmptyState(
            icon: Icons.search,
            title: 'No Results Found',
            message: 'Try adjusting your search or filters',
            action: VooButton(
              onPressed: () {},
              variant: VooButtonVariant.tonal,
              child: const Text('Clear Filters'),
            ),
          ),
        ),
        SizedBox(height: design.spacingXl),
        SizedBox(
          height: 300,
          child: VooEmptyState(
            icon: Icons.inbox,
            title: 'No Messages',
            message: 'Your inbox is empty',
          ),
        ),
      ],
    );
  }
}