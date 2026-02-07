import 'dart:async';
import '../models/item.dart';

/// Mock API service that returns a user profile and a list of items.
class ApiService {
  /// Fetch a mock user profile. In a real app use the token to fetch user info.
  Future<Map<String, String>> fetchUserProfile(String? token) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return {
      'name': 'Demo User',
      'email': token == 'fake_token_test_user' ? 'test@example.com' : 'user@example.com',
      'avatarUrl': '', // empty means show initials
    };
  }

  /// Fetch a list of mock items.
  Future<List<Item>> fetchItems({int count = 12}) async {
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(count, (i) => Item.mock(i + 1));
  }

  /// Fetch full details for a single item by id.
  /// Throws an exception if the id is not found (simulated).
  Future<Item> fetchItemDetails(String id) async {
    await Future.delayed(const Duration(milliseconds: 700));

    // Simulate not-found for some ids
    if (id.contains('999')) {
      throw Exception('Item not found');
    }

    // Parse index from id when possible to produce consistent details
    final match = RegExp(r'item_(\d+)').firstMatch(id);
    final i = match != null ? int.tryParse(match.group(1)!) ?? 1 : 1;

    final base = Item.mock(i);
    return Item(
      id: base.id,
      title: base.title,
      description: '${base.description} This is an extended detail view for the item. It contains more contextual information, metadata, and possible actions that could be taken on the item.',
      category: base.category,
      date: base.date,
    );
  }

  /// Create a new item (mock).
  Future<Item> createItem(Item item, {
    required String title,
    required String description,
    required String category,
    required DateTime date,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final id = 'item_${DateTime.now().millisecondsSinceEpoch}';
    return Item(id: id, title: title, description: description, category: category, date: date);
  }

  /// Update an existing item (mock).
  Future<Item> updateItem(Item item) async {
    await Future.delayed(const Duration(milliseconds: 600));

    // Simulate update failure for specific ids
    if (item.id.contains('999')) {
      throw Exception('Failed to update item');
    }

    // Return the updated item (in a real API you'd return server response)
    return item;
  }

  Future<void> deleteItem(int id) async {}
}
