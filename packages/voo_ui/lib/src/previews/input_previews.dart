import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_ui/voo_ui.dart';

// VooTextField Previews
@Preview(name: 'VooTextField - Basic')
Widget vooTextFieldBasic() {
  return const MaterialApp(
    home: Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: VooTextField(
            label: 'Email',
            hint: 'Enter your email address',
          ),
        ),
      ),
    ),
  );
}

@Preview(name: 'VooTextField - With Icon')
Widget vooTextFieldWithIcon() {
  return const MaterialApp(
    home: Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: VooTextField(
            label: 'Email',
            hint: 'Enter your email',
            prefixIcon: Icons.email,
          ),
        ),
      ),
    ),
  );
}

@Preview(name: 'VooTextField - With Error')
Widget vooTextFieldWithError() {
  return const MaterialApp(
    home: Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: VooTextField(
            label: 'Password',
            hint: 'Enter password',
            prefixIcon: Icons.lock,
            error: 'Password is required',
          ),
        ),
      ),
    ),
  );
}

@Preview(name: 'VooTextField - Password')
Widget vooTextFieldPassword() {
  return const MaterialApp(
    home: Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: VooTextField(
            label: 'Password',
            hint: 'Enter your password',
            prefixIcon: Icons.lock,
            suffixIcon: Icons.visibility_off,
            obscureText: true,
          ),
        ),
      ),
    ),
  );
}

@Preview(name: 'VooTextField - Multiline')
Widget vooTextFieldMultiline() {
  return const MaterialApp(
    home: Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: VooTextField(
            label: 'Description',
            hint: 'Enter a description',
            maxLines: 4,
          ),
        ),
      ),
    ),
  );
}

// VooDropdown Previews
@Preview(name: 'VooDropdown - Basic')
Widget vooDropdownBasic() {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: VooDropdown<String>(
            label: 'Select Option',
            items: const [
              VooDropdownItem(value: 'option1', label: 'Option 1'),
              VooDropdownItem(value: 'option2', label: 'Option 2'),
              VooDropdownItem(value: 'option3', label: 'Option 3'),
            ],
            onChanged: (value) {},
          ),
        ),
      ),
    ),
  );
}

@Preview(name: 'VooDropdown - With Icons')
Widget vooDropdownWithIcons() {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: VooDropdown<String>(
            label: 'Select Priority',
            value: 'high',
            items: const [
              VooDropdownItem(
                value: 'high',
                label: 'High Priority',
                icon: Icons.arrow_upward,
              ),
              VooDropdownItem(
                value: 'medium',
                label: 'Medium Priority',
                icon: Icons.remove,
              ),
              VooDropdownItem(
                value: 'low',
                label: 'Low Priority',
                icon: Icons.arrow_downward,
              ),
            ],
            onChanged: (value) {},
          ),
        ),
      ),
    ),
  );
}

@Preview(name: 'VooDropdown - With Subtitles')
Widget vooDropdownWithSubtitles() {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: VooDropdown<String>(
            label: 'Select Environment',
            items: const [
              VooDropdownItem(
                value: 'dev',
                label: 'Development',
                subtitle: 'Local development environment',
              ),
              VooDropdownItem(
                value: 'staging',
                label: 'Staging',
                subtitle: 'Pre-production testing',
              ),
              VooDropdownItem(
                value: 'prod',
                label: 'Production',
                subtitle: 'Live environment',
              ),
            ],
            onChanged: (value) {},
          ),
        ),
      ),
    ),
  );
}

// VooButton Previews
@Preview(name: 'VooButton - Elevated')
Widget vooButtonElevated() {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: VooButton(
          variant: VooButtonVariant.elevated,
          onPressed: () {},
          child: const Text('Save Changes'),
        ),
      ),
    ),
  );
}

@Preview(name: 'VooButton - Outlined')
Widget vooButtonOutlined() {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: VooButton(
          variant: VooButtonVariant.outlined,
          onPressed: () {},
          child: const Text('Cancel'),
        ),
      ),
    ),
  );
}

@Preview(name: 'VooButton - Text')
Widget vooButtonText() {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: VooButton(
          variant: VooButtonVariant.text,
          onPressed: () {},
          child: const Text('Learn More'),
        ),
      ),
    ),
  );
}

@Preview(name: 'VooButton - Tonal')
Widget vooButtonTonal() {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: VooButton(
          variant: VooButtonVariant.tonal,
          onPressed: () {},
          child: const Text('Add to Cart'),
        ),
      ),
    ),
  );
}

@Preview(name: 'VooButton - With Icon')
Widget vooButtonWithIcon() {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: VooButton(
          variant: VooButtonVariant.elevated,
          icon: Icons.save,
          onPressed: () {},
          child: const Text('Save'),
        ),
      ),
    ),
  );
}

@Preview(name: 'VooButton - Loading')
Widget vooButtonLoading() {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: VooButton(
          variant: VooButtonVariant.elevated,
          loading: true,
          onPressed: () {},
          child: const Text('Processing...'),
        ),
      ),
    ),
  );
}

@Preview(name: 'VooButton - Sizes')
Widget vooButtonSizes() {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            VooButton(
              size: VooButtonSize.small,
              onPressed: () {},
              child: const Text('Small'),
            ),
            const SizedBox(height: 16),
            VooButton(
              size: VooButtonSize.medium,
              onPressed: () {},
              child: const Text('Medium'),
            ),
            const SizedBox(height: 16),
            VooButton(
              size: VooButtonSize.large,
              onPressed: () {},
              child: const Text('Large'),
            ),
          ],
        ),
      ),
    ),
  );
}

// VooIconButton Previews
@Preview(name: 'VooIconButton - Basic')
Widget vooIconButtonBasic() {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: VooIconButton(
          icon: Icons.favorite,
          onPressed: () {},
        ),
      ),
    ),
  );
}

@Preview(name: 'VooIconButton - With Tooltip')
Widget vooIconButtonWithTooltip() {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: VooIconButton(
          icon: Icons.info,
          tooltip: 'More Information',
          onPressed: () {},
        ),
      ),
    ),
  );
}

@Preview(name: 'VooIconButton - Selected')
Widget vooIconButtonSelected() {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: VooIconButton(
          icon: Icons.star,
          selected: true,
          selectedColor: Colors.amber,
          onPressed: () {},
        ),
      ),
    ),
  );
}

// VooSearchBar Previews
@Preview(name: 'VooSearchBar - Basic')
Widget vooSearchBarBasic() {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: VooSearchBar(
            hintText: 'Search...',
            onSearchChanged: (value) {},
          ),
        ),
      ),
    ),
  );
}

@Preview(name: 'VooSearchBar - With Clear')
Widget vooSearchBarWithClear() {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: VooSearchBar(
            hintText: 'Search products...',
            onSearchChanged: (value) {},
            onClear: () {},
          ),
        ),
      ),
    ),
  );
}