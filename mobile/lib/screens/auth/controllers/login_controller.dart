import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../providers/auth_provider.dart';

class LoginController extends ChangeNotifier {
  final AuthProvider authProvider;
  bool _didNavigate = false;
  bool _isDisposed = false;

  LoginController(this.authProvider);

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> signInWithProvider(OAuthProvider provider) async {
    _didNavigate = false;
    await authProvider.signInWithProvider(provider);
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  bool checkNavigationAndReset() {
    if (authProvider.isAuthenticated && !_didNavigate) {
      _didNavigate = true;
      return true;
    }
    return false;
  }
}
