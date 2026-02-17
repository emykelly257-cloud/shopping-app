class CartItem {
  final int id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  int quantity;
  
  CartItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });
  
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] as int? ?? 0,
      title: map['title'] as String? ?? 'Unknown',
      description: map['description'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] as String? ?? '',
      quantity: map['quantity'] as int? ?? 1,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
    };
  }
  
  double get totalPrice => price * quantity;
}
