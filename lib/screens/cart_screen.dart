import 'package:flutter/material.dart';
import 'package:flutter_application_3/widgets/cart_item_card.dart' show CartItemCard;
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_card.dart';

class CartScreen extends StatefulWidget {
  final bool showBackArrow; 

const CartScreen({super.key, this.showBackArrow = false});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.showBackArrow
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
      ),
      // appBar: AppBar(
      //   title: const Text('Your Cart'),
      //   centerTitle: false,
      // ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.itemCount == 0) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Add some items to get started',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.itemCount,
                  itemBuilder: (context, index) {
                    final item = cart.cartItems[index];
                    return CartItemCard(
                      item: item,
                      onRemove: () => cart.removeFromCart(item.id),
                      onQuantityChanged: (quantity) {
                        cart.updateQuantity(item.id, quantity);
                      },
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey[300]!)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${cart.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          _checkout(cart);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Checkout',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        cart.clearCart();
                      },
                      child: const Text(
                        'Clear Cart',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _checkout(CartProvider cart) {
    if (cart.itemCount == 0) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Items: ${cart.itemCount}'),
            const SizedBox(height: 8),
            Text('Total Amount: \$${cart.totalAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text('Proceed with checkout?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processCheckout(cart);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _processCheckout(CartProvider cart) {
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order placed successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    
    
    cart.clearCart();
  }
}
