import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/cart_item.dart';


class CartItemCard extends StatelessWidget {
  final CartItem item; // Changed from CartItem to Map
  final VoidCallback onRemove;
  final Function(int) onQuantityChanged;
  
  const CartItemCard({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onQuantityChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    // Ensure we have valid data
    final title = item.title ;
    final description = item.description ;
    final price = item.price;
    final quantity = item.quantity;
    final totalPrice = price * quantity;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.shopping_bag, color: Colors.blue),
            ),
            
            const SizedBox(width: 12),
            
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blue,
                        ),
                      ),
                      
                      // Quantity Controls
                      Row(
                        children: [
                          IconButton(
                            onPressed: quantity > 1
                                ? () => onQuantityChanged(quantity - 1)
                                : null,
                            icon: const Icon(Icons.remove),
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                          ),
                          
                          Container(
                            width: 30,
                            alignment: Alignment.center,
                            child: Text(quantity.toString()),
                          ),
                          
                          IconButton(
                            onPressed: () => onQuantityChanged(quantity + 1),
                            icon: const Icon(Icons.add),
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                          ),
                          
                          IconButton(
                            onPressed: onRemove,
                            icon: const Icon(Icons.delete_outline),
                            color: Colors.red,
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}