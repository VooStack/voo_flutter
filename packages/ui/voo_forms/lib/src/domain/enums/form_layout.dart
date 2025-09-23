enum FormLayout { vertical, horizontal, grid, wrapped, stepped, tabbed, dynamic }

extension FormLayoutExtension on FormLayout {
  String get label {
    switch (this) {
      case FormLayout.vertical:
        return 'Vertical';
      case FormLayout.horizontal:
        return 'Horizontal';
      case FormLayout.grid:
        return 'Grid';
      case FormLayout.wrapped:
        return 'Wrapped';
      case FormLayout.stepped:
        return 'Stepped';
      case FormLayout.tabbed:
        return 'Tabbed';
      case FormLayout.dynamic:
        return 'Dynamic';
    }
  }
}
