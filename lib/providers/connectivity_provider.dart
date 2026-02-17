import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../services/connectivity_service.dart';

class ConnectivityProvider with ChangeNotifier {
  final ConnectivityService _service = ConnectivityService();
  bool _isOnline = true;
  
  bool get isOnline => _isOnline;
  bool get isOffline => !_isOnline;
  
  ConnectivityProvider() {
    _initConnectivity();
    _setupListener();
  }
  
  Future<void> _initConnectivity() async {
    _isOnline = await _service.hasInternetConnection();
    notifyListeners();
  }
  
  void _setupListener() {
    _service.connectivityStream.listen((result) {
      _isOnline = result != ConnectivityResult.none;
      notifyListeners();
    });
  }
  
  Future<bool> checkConnection() async {
    _isOnline = await _service.hasInternetConnection();
    notifyListeners();
    return _isOnline;
  }
}
