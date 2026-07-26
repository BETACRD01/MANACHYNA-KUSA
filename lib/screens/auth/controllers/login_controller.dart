import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../providers/auth_provider.dart';

class LoginController extends ChangeNotifier {
  final AuthProvider authProvider;
  bool _didNavigate = false;

  LoginController(this.authProvider);

  Future<void> signInWithProvider(OAuthProvider provider) async {
    _didNavigate = false;
    await authProvider.signInWithProvider(provider);
    notifyListeners();
  }

  bool checkNavigationAndReset() {
    if (authProvider.isAuthenticated && !_didNavigate) {
      _didNavigate = true;
      return true;
    }
    return false;
  }
}
