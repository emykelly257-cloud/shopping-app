import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/cart_provider.dart';
import 'shop_screen.dart';
import 'cart_screen.dart';
import 'history_screen.dart';
import 'account_screen.dart';

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  
  static final List<Widget> _widgetOptions = <Widget>[
    const ShopScreen(),
    const CartScreen(),
    const HistoryScreen(),
    const AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      
      bottomNavigationBar: _buildFloatingBottomBar(context, cartProvider, themeProvider),
    );
  }

  Widget _buildFloatingBottomBar(BuildContext context, CartProvider cartProvider, ThemeProvider themeProvider) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 18.0),
      decoration: BoxDecoration(
        color: themeProvider.isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Shop Button
          _buildFloatingNavItem(
            icon: Icons.shopping_bag_outlined,
            activeIcon: Icons.shopping_bag,
            label: 'Shop',
            index: 0,
            cartProvider: cartProvider,
          ),
          
          Stack(
            children: [
              _buildFloatingNavItem(
                icon: Icons.shopping_cart_outlined,
                activeIcon: Icons.shopping_cart,
                label: 'Cart',
                index: 1,
                cartProvider: cartProvider,
              ),
              if (cartProvider.itemCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      cartProvider.itemCount > 9 
                          ? '9+' 
                          : cartProvider.itemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          
          _buildFloatingNavItem(
            icon: Icons.history_outlined,
            activeIcon: Icons.history,
            label: 'History',
            index: 2,
            cartProvider: cartProvider,
          ),
          
          _buildFloatingNavItem(
            icon: Icons.person_outlined,
            activeIcon: Icons.person,
            label: 'Account',
            index: 3,
            cartProvider: cartProvider,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required CartProvider cartProvider,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final bool isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected 
                  ? Colors.blue 
                  : (themeProvider.isDark ? Colors.grey[400] : Colors.grey[600]),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected 
                    ? Colors.blue 
                    : (themeProvider.isDark ? Colors.grey[400] : Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
