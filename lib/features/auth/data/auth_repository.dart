import '../../../core/services/auth_service.dart';
import '../../../models/user_model.dart';

class AuthRepository {
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) {
    return AuthService.signInUser(email: email, password: password);
  }

  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String address,
    required String city,
    required UserType userType,
  }) {
    return AuthService.registerUser(
      email: email,
      password: password,
      name: name,
      phone: phone,
      address: address,
      city: city,
      userType: userType,
    );
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

  Future<bool> resetPassword(String email) {
    return AuthService.resetPassword(email);
  }
}
