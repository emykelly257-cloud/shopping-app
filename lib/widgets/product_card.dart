import 'package:flutter/material.dart';

import '../models/item.dart';

class ProductCard extends StatelessWidget {
  final Item product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;
  final String heroTag;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAddToCart,
    this.heroTag = '',
  });

  @override
  Widget build(BuildContext context) {
    final uniqueHeroTag = '${product.id}_$heroTag';
    // Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 221,
          // padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    product.imageUrl ?? 'https://via.placeholder.com/150',
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image,
                          size: 150,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              // Product Title


              //   height: 120,
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     color: Colors.grey[200],
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   child: Center(
              //     child: Icon(
              //       Icons.shopping_bag,
              //       size: 60,
              //       color: Colors.grey[400],
              //     ),
              //   ),
              // ),
              const SizedBox(height: 12),

              // Product Title
              Expanded(
                child: Text(
                product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              ),
              const SizedBox(height: 8),

              // Product Description
              Text(
                product.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),

              const Spacer(),

              // Price and Add to Cart
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '\$19.99',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                  IconButton(
                    onPressed: onAddToCart,
                    icon: const Icon(Icons.add_shopping_cart),
                    color: Colors.blue,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ), 
        ),
      ),
    );
  }
}

