import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = []; // Changed from List<Map> to List<CartItem>
  
  List<CartItem> get cartItems => _cartItems;
  int get itemCount => _cartItems.length;
  
  double get totalAmount {
    return _cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }
  
  void addToCart(CartItem item) { // Changed parameter type
    final index = _cartItems.indexWhere((cartItem) => cartItem.id == item.id);
    if (index != -1) {
      _cartItems[index].quantity += 1;
    } else {
      _cartItems.add(item);
    }
    notifyListeners();
  }
  
  void addToCartFromMap(Map<String, dynamic> map) {
    final item = CartItem.fromMap(map);
    addToCart(item);
  }
  
  void removeFromCart(int id) {
    _cartItems.removeWhere((item) => item.id == id);
    notifyListeners();
  }
  
  void updateQuantity(int id, int quantity) {
    final index = _cartItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      if (quantity > 0) {
        _cartItems[index].quantity = quantity;
      } else {
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }
  
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
  
  bool isInCart(int id) {
    return _cartItems.any((item) => item.id == id);
  }
}
