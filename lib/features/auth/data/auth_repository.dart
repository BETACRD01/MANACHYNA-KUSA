import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/auth_service.dart';
import '../../../models/user_model.dart';

class AuthRepository {
  Future<bool> signInWithProvider(OAuthProvider provider) {
    return AuthService.signInWithProvider(provider);
  }

  Future<void> signOut() {
    return AuthService.signOut();
  }

  Future<UserModel?> getCurrentUser() {
    return AuthService.getCurrentUserData();
  }

  Future<bool> updateProfile(UserModel user) {
    return AuthService.updateUserProfile(user);
  }

  Future<bool> updateProfileImage(String userId, String imageUrl) {
    return AuthService.updateProfileImage(userId, imageUrl);
  }
}
