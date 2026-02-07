import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/api_service.dart';
import 'item_edit_screen.dart';

class ItemDetailsScreen extends StatefulWidget {
  final String itemId;

  const ItemDetailsScreen({super.key, required this.itemId});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  late Future<Item> _future;
  final ApiService _api = ApiService();

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = _api.fetchItemDetails(widget.itemId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              try {
                final item = await _api.fetchItemDetails(widget.itemId);
                if (!mounted) return;
                final didChange = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(builder: (_) => ItemEditScreen(item: item)),
                );
                if (!mounted) return;
                if (didChange == true) {
                  setState(() {
                    _load();
                  });
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
                }
              }
            },
          )
        ],
      ),
      body: FutureBuilder<Item>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                    const SizedBox(height: 12),
                    Text('Error: ${"${snapshot.error}"}'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _load();
                        });
                      },
                      child: const Text('Retry'),
                    )
                  ],
                ),
              ),
            );
          }

          final item = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Chip(label: Text(item.category)),
                    const SizedBox(width: 8),
                    Text(
                      '${item.date.year}-${item.date.month.toString().padLeft(2, '0')}-${item.date.day.toString().padLeft(2, '0')}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(item.description, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                const Text('Metadata', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('ID: ${item.id}'),
                const SizedBox(height: 6),
                Text('Status: ${item.category}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
