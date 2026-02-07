import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/cart_item.dart';
import 'package:flutter_application_3/models/item.dart' show Item;
import 'package:flutter_application_3/providers/item_provider.dart' show ItemsProvider;
import 'package:provider/provider.dart';
import '../providers/item_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  CartItem? get cartItemCard => null;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<Item> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    
    // Load products when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ItemsProvider>(context, listen: false).fetchItems();
    });
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _isSearching = false;
        _filteredItems.clear();
      });
    } else {
      setState(() {
        _isSearching = true;
      });
    }
  }

  void _toggleSearch() {
    setState(() {
      if (_isSearching) {
        _searchController.clear();
        _isSearching = false;
      } else {
        _isSearching = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(FocusNode());
        });
      }
    });
  }

  void _addToCart(Item product) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    
    // Since we're using Map in CartProvider, create a Map instead of CartItem object
    final cartItem = {
      'id': product.id,
      'title': product.title,
      'description': product.description,
      'price': 19.99, // Mock price
      'imageUrl': 'https://via.placeholder.com/150',
      'quantity': 1,
    };
    
    // cartProvider.addToCart(cartItemCard!);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.title} added to cart'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CartScreen()),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Theme.of(context).hintColor,
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
                onChanged: (value) {
                  setState(() {});
                },
              )
            : const Text('Shop'),
        centerTitle: true,
        leading: _isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                  });
                },
              )
            : IconButton(
                icon: const Icon(Icons.search),
                onPressed: _toggleSearch,
              ),
        actions: [
          if (!_isSearching)
            Consumer<CartProvider>(
              builder: (context, cart, _) {
                return Badge(
                  label: Text(cart.itemCount.toString()),
                  child: IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const CartScreen()),
                      );
                    },
                  ),
                );
              },
            ),
          const SizedBox(width: 10),
        ],
      ),
      body: Consumer<ItemsProvider>(
        builder: (context, itemsProvider, _) {
          // Filter items based on search
          final List<Item> itemsToDisplay = _isSearching && _searchController.text.isNotEmpty
              ? itemsProvider.items.where((item) {
                  final query = _searchController.text.toLowerCase();
                  return item.title.toLowerCase().contains(query) ||
                      item.description.toLowerCase().contains(query) ||
                      item.id.toString().contains(query);
                }).toList()
              : itemsProvider.items;

          return RefreshIndicator(
            onRefresh: () => itemsProvider.fetchItems(),
            child: _buildBody(context, itemsProvider, itemsToDisplay),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ItemsProvider itemsProvider, List<Item> itemsToDisplay) {
    if (itemsProvider.isLoading && itemsProvider.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (itemsProvider.error != null && itemsProvider.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${itemsProvider.error}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => itemsProvider.fetchItems(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    if (itemsToDisplay.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isSearching ? Icons.search_off : Icons.shopping_basket_outlined,
              size: 60,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            Text(
              _isSearching ? 'No products found' : 'No products available',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            if (_isSearching)
              TextButton(
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _isSearching = false;
                  });
                },
                child: const Text('Clear search'),
              ),
          ],
        ),
      );
    }
    
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 26,
        childAspectRatio: 0.75,
      ),
      itemCount: itemsToDisplay.length,
      itemBuilder: (context, index) {
        final product = itemsToDisplay[index];
        return ProductCard(
          product: product,
          onTap: () {
            _showProductDetails(context, product);
          },
          onAddToCart: () => _addToCart(product),
        );
      },
    );
  }

  void _showProductDetails(BuildContext context, Item product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                product.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                product.description,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(120, 50),
                    ),
                    child: const Text('Close'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _addToCart(product);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(120, 50),
                    ),
                    child: const Text('Add to Cart'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}