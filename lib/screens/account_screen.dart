import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart'; // Add this import
import '../models/user.dart';
import 'history_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final User? user = authProvider.user;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false); // Add theme provider
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Section
              Container(
                padding: const EdgeInsets.all(10),
                color: Colors.blue.withOpacity(0.05),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: user?.avatarUrl != null
                          ? NetworkImage(user!.avatarUrl!)
                          : null,
                      child: user?.avatarUrl == null
                          ? const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'Guest User',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            user?.email ?? 'Not logged in',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton(
                            onPressed: () {
                              // Edit profile
                              _editProfile(context, user);
                            },
                            child: const Text('Edit Profile'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Menu Items
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.shopping_bag_outlined,
                      title: 'My Orders',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const HistoryScreen(showBackArrow: true),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.location_on_outlined,
                      title: 'Shipping Address',
                      onTap: () {
                        _showAddresses(context);
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.payment_outlined,
                      title: 'Payment Methods',
                      onTap: () {
                        _showPaymentMethods(context);
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      onTap: () {
                        _showNotificationSettings(context);
                      },
                    ),
                    
                    // THEME SETTINGS - ADDED HERE
                    Consumer<ThemeProvider>(
                      builder: (context, themeProvider, child) {
                        return ListTile(
                          leading: Icon(
                            themeProvider.isDark ? Icons.dark_mode : Icons.light_mode,
                          ),
                          title: const Text('App Theme'),
                          trailing: Switch(
                            value: themeProvider.isDark,
                            onChanged: (value) {
                              themeProvider.toggleTheme();
                            },
                            activeColor: Colors.blue,
                          ),
                          onTap: () {
                            // Optional: Show theme options dialog
                            _showThemeOptions(context, themeProvider);
                          },
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        );
                      },
                    ),
                    
                    _buildMenuItem(
                      icon: Icons.security_outlined,
                      title: 'Privacy & Security',
                      onTap: () {
                        _showPrivacySettings(context);
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      onTap: () {
                        _showHelp(context);
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.info_outline,
                      title: 'About App',
                      onTap: () {
                        _showAbout(context);
                      },
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _logout(context, authProvider);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.1),
                            foregroundColor: Colors.red,
                            elevation: 0,
                          ),
                          child: const Text('Logout'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }

  // NEW: Show Theme Options Dialog
  void _showThemeOptions(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text('Light Theme'),
              trailing: themeProvider.isDark == false
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                if (themeProvider.isDark) {
                  themeProvider.toggleTheme();
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark Theme'),
              trailing: themeProvider.isDark == true
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                if (!themeProvider.isDark) {
                  themeProvider.toggleTheme();
                }
                Navigator.pop(context);
              },
            ),
            // If you want to add system theme option later:
            /*
            ListTile(
              leading: const Icon(Icons.phone_iphone),
              title: const Text('System Default'),
              trailing: themeProvider.themeMode == ThemeMode.system
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                themeProvider.setThemeMode(ThemeMode.system);
                Navigator.pop(context);
              },
            ),
            */
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _editProfile(BuildContext context, User? user) {
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
                'Edit Profile',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              const Text('Profile editing feature coming soon!'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _showAddresses(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Shipping Address'),
        content: const Text('Shipping address feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethods(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Methods'),
        content: const Text('Payment methods feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: const Text('Notification settings feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPrivacySettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy & Security'),
        content: const Text('Privacy settings feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Text('Help center feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About App'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Shopping App v1.0.0'),
            SizedBox(height: 10),
            Text('A complete shopping experience app.'),
            SizedBox(height: 10),
            Text('Built with Flutter & ❤️'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}