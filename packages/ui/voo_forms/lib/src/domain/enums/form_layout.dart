enum FormLayout {
  vertical,
  horizontal,
  grid,
  stepped,
  tabbed,
}

extension FormLayoutExtension on FormLayout {
  String get label {
    switch (this) {
      case FormLayout.vertical:
        return 'Vertical';
      case FormLayout.horizontal:
        return 'Horizontal';
      case FormLayout.grid:
        return 'Grid';
      case FormLayout.stepped:
        return 'Stepped';
      case FormLayout.tabbed:
        return 'Tabbed';
    }
  }
}
