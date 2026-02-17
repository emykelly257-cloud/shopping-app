import 'package:flutter/foundation.dart';
import '../models/item.dart';
import '../services/api_service.dart';

class DashboardProvider extends ChangeNotifier {
  final ApiService _api;
  final String? token;

  bool isLoading = false;
  Map<String, String>? profile;
  List<Item> items = [];
  String? error;

  DashboardProvider({this.token, ApiService? api}) : _api = api ?? ApiService();

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      profile = await _api.fetchUserProfile(token);
      items = await _api.fetchItems();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createItem({
    required Item item,
    required String title,
    required String description,
    required String category,
    required DateTime date,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final created = await _api.createItem(
        item,
        title: title,
        description: description,
        category: category,
        date: date,
      );
      items.insert(0, created);
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateItem(Item updated) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final result = await _api.updateItem(updated);
      final idx = items.indexWhere((it) => it.id == result.id);
      if (idx >= 0) {
        items[idx] = result;
      }
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
