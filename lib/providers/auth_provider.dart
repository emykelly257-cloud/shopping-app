import 'package:flutter/foundation.dart';
import 'package:flutter_application_3/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service;
  bool isLoading = false;
  bool isAuthenticated = false;
  String? token;

  AuthProvider([AuthService? service]) : _service = service ?? AuthService();

  User? get user => null;

  /// Loads stored login state from SharedPreferences.
  Future<void> loadLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('auth_token');
    isAuthenticated = token != null;
    notifyListeners();
  }

  /// Attempts to login using the service. Saves token to prefs on success.
  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await _service.login(email, password);
      token = result;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token!);
      isAuthenticated = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Logout and clear stored login state.
  Future<void> logout() async {
    isLoading = true;
    notifyListeners();
    try {
      await _service.logout();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      token = null;
      isAuthenticated = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
