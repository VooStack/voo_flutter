import 'package:flutter/material.dart';
import 'package:voo_lists/src/domain/entities/list_item.dart';

class VooListController<T> extends ChangeNotifier {
  List<ListItem<T>> _items = [];
  final Set<String> _selectedItems = {};
  bool _isLoading = false;
  String? _error;

  List<ListItem<T>> get items => _items;
  Set<String> get selectedItems => _selectedItems;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setItems(List<ListItem<T>> items) {
    _items = items;
    notifyListeners();
  }

  void addItem(ListItem<T> item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    _selectedItems.remove(itemId);
    notifyListeners();
  }

  void toggleSelection(String itemId) {
    if (_selectedItems.contains(itemId)) {
      _selectedItems.remove(itemId);
    } else {
      _selectedItems.add(itemId);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedItems.clear();
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void reorderItems(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = _items.removeAt(oldIndex);
    _items.insert(newIndex, item);
    notifyListeners();
  }
}
