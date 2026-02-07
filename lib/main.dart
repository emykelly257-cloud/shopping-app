import 'package:flutter/material.dart';
import 'package:flutter_application_3/providers/cart_provider.dart' show CartProvider;
import 'package:flutter_application_3/providers/item_provider.dart' show ItemsProvider;
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/main_tab_screen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ItemsProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: Consumer<ThemeProvider>(builder: (context, themeProvider, _) { // Fixed: Changed 'theme' to 'themeProvider'
        return MaterialApp(
          title: 'Shopping App', // Changed from 'Flutter Demo'
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          themeMode: themeProvider.themeMode,
          home: const RootScreen(),
          routes: {
            '/main': (context) => const MainTabScreen(),
            '/login': (context) => const LoginScreen(),
          },
          debugShowCheckedModeBanner: false,
        );
      }),
    );
  }

  // Moved theme methods inside the class
  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[600],
        elevation: 8,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[400],
        elevation: 8,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: const Color(0xFF2D2D2D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      dialogBackgroundColor: const Color(0xFF1E1E1E),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: const Color(0xFF2D2D2D),
      ),
    );
  }
}

/// RootScreen chooses the initial screen based on auth state.
class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, auth, _) {
      // Show a splash/loading while the provider initializes
      if (auth.isLoading && !auth.isAuthenticated) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return auth.isAuthenticated ? const MainTabScreen() : const LoginScreen();
    });
  }
}