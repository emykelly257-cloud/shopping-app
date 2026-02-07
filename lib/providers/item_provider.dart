import 'package:flutter/material.dart';

import '../models/item.dart';
import '../services/api_service.dart';

class ItemsProvider with ChangeNotifier {
  List<Item> _items = [];
  bool _isLoading = false;
  String? _error;
  Item? _selectedItem;

  List<Item> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Item? get selectedItem => _selectedItem;

  Future<void> fetchItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiService = ApiService();
      _items = await apiService.fetchItems();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createItem(Item item) async {
    _isLoading = true;
    notifyListeners();

    try {
      final apiService = ApiService();
      final newItem = await apiService.createItem(
        item,
        category: item.category,
        date: item.date,
        description: item.description,
        title: item.title,
      );
      _items.insert(0, newItem);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateItem(Item item) async {
    _isLoading = true;
    notifyListeners();

    try {
      final apiService = ApiService();
      final updatedItem = await apiService.updateItem(item);
      final index = _items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _items[index] = updatedItem;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteItem(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final apiService = ApiService();
      await apiService.deleteItem(id);
      _items.removeWhere((item) => item.id == id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void selectItem(Item item) {
    _selectedItem = item;
    notifyListeners();
  }

  void clearSelectedItem() {
    _selectedItem = null;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
