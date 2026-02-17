import 'dart:async';
import '../models/item.dart';

class ApiService {
  Future<Map<String, String>> fetchUserProfile(String? token) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return {
      'name': 'Demo User',
      'email': token == 'fake_token_test_user' ? 'test@example.com' : 'user@example.com',
      'avatarUrl': '', 
    };
  }

  Future<List<Item>> fetchItems({int count = 12}) async {
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(count, (i) => Item.mock(i + 1));
  }

  Future<Item> fetchItemDetails(String id) async {
    await Future.delayed(const Duration(milliseconds: 700));

    if (id.contains('999')) {
      throw Exception('Item not found');
    }

    final match = RegExp(r'item_(\d+)').firstMatch(id);
    final i = match != null ? int.tryParse(match.group(1)!) ?? 1 : 1;

    final base = Item.mock(i);
    return Item(
      id: base.id,
      title: base.title,
      description: '${base.description},
      category: base.category,
      date: base.date,
    );
  }

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

  Future<Item> updateItem(Item item) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (item.id.contains('999')) {
      throw Exception('Failed to update item');
    }

    return item;
  }

  Future<void> deleteItem(int id) async {}
}
