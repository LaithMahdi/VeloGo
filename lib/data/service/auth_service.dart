import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/user_model.dart';
import '../../core/service/supabase_service.dart';

class AuthService {
  final SupabaseService _supabaseService = SupabaseService();

  // Sign up with email and password
  Future<UserModel?> signUp({
    required String email,
    required String password,
    String? fullName,
    String? phoneNumber,
  }) async {
    try {
      final response = await _supabaseService.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName, 'phone_number': phoneNumber},
      );

      if (response.user != null) {
        debugPrint('✅ Sign up successful: ${response.user!.email}');
        return UserModel.fromJson(response.user!.toJson());
      }

      return null;
    } on AuthException catch (e) {
      debugPrint('❌ Auth error during sign up: ${e.message}');
      throw e.message;
    } catch (e) {
      debugPrint('❌ Unexpected error during sign up: $e');
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Sign in with email and password
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseService.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        debugPrint('✅ Sign in successful: ${response.user!.email}');
        return UserModel.fromJson(response.user!.toJson());
      }

      return null;
    } on AuthException catch (e) {
      debugPrint('❌ Auth error during sign in: ${e.message}');
      throw e.message;
    } catch (e) {
      debugPrint('❌ Unexpected error during sign in: $e');
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabaseService.signOut();
      debugPrint('✅ Sign out successful');
    } on AuthException catch (e) {
      debugPrint('❌ Auth error during sign out: ${e.message}');
      throw e.message;
    } catch (e) {
      debugPrint('❌ Unexpected error during sign out: $e');
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Get current user
  UserModel? getCurrentUser() {
    final user = _supabaseService.currentUser;
    if (user != null) {
      return UserModel.fromJson(user.toJson());
    }
    return null;
  }

  // Check if user is authenticated
  bool get isAuthenticated => _supabaseService.isAuthenticated;

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _supabaseService.auth.resetPasswordForEmail(email);
      debugPrint('✅ Password reset email sent to: $email');
    } on AuthException catch (e) {
      debugPrint('❌ Auth error during password reset: ${e.message}');
      throw e.message;
    } catch (e) {
      debugPrint('❌ Unexpected error during password reset: $e');
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Update user profile
  Future<UserModel?> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    try {
      final response = await _supabaseService.auth.updateUser(
        UserAttributes(
          data: {
            if (fullName != null) 'full_name': fullName,
            if (phoneNumber != null) 'phone_number': phoneNumber,
            if (avatarUrl != null) 'avatar_url': avatarUrl,
          },
        ),
      );

      if (response.user != null) {
        debugPrint('✅ Profile updated successfully');
        return UserModel.fromJson(response.user!.toJson());
      }

      return null;
    } on AuthException catch (e) {
      debugPrint('❌ Auth error during profile update: ${e.message}');
      throw e.message;
    } catch (e) {
      debugPrint('❌ Unexpected error during profile update: $e');
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Listen to auth state changes
  Stream<AuthState> get authStateChanges =>
      _supabaseService.auth.onAuthStateChange;
}
