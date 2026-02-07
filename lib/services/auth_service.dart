import 'dart:async';

/// A simple authentication service that simulates a REST authentication call.
///
/// In a real app you'd replace this with HTTP calls to your backend.
class AuthService {
  /// Simulate a login request.
  /// Returns a token string on success, or throws on failure.
  Future<String> login(String email, String password) async {
    // Simulate network latency
    await Future.delayed(const Duration(seconds: 1));

    // Very small simulation rules. In a real app use an HTTP client and
    // proper error handling.
    if (!email.contains('@') || password.length < 6) {
      throw Exception('Invalid email or password format.');
    }

    // Accept a known test credential or any sensible credential for demo.
    if (email == 'test@example.com' && password == 'password') {
      return 'fake_token_test_user';
    }

    // Otherwise return a generated fake token to simulate success.
    return 'fake_token_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Simulate logout. (No-op for the mock.)
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return;
  }
}
