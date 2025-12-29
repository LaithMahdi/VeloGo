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
        await _createUserProfile(
          userId: response.user!.id,
          email: email,
          fullName: fullName,
          phoneNumber: phoneNumber,
        );

        debugPrint('✅ Sign up successful: ${response.user!.email}');
        return UserModel.fromJson(response.user!.toJson());
      }

      return null;
    } on AuthException catch (e) {
      debugPrint('❌ Auth error during sign up: ${e.message}');
      throw _handleAuthError(e);
    } catch (e) {
      debugPrint('❌ Unexpected error during sign up: $e');
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Create user profile in 'profiles' table
  Future<void> _createUserProfile({
    required String userId,
    required String email,
    String? fullName,
    String? phoneNumber,
  }) async {
    try {
      await _supabaseService.client.from('profiles').insert({
        'id': userId,
        'email': email,
        'full_name': fullName ?? '',
        'phone_number': phoneNumber ?? '',
      });
      debugPrint('✅ User profile created for: $email');
    } catch (e) {
      debugPrint('❌ Error creating user profile: $e');
      // Don't throw here to allow signup to succeed even if profile creation fails
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

        // Try to get user profile
        final profile = await _getUserProfile(response.user!.id);

        return UserModel(
          id: response.user!.id,
          email: response.user!.email ?? email,
          fullName: profile?['full_name'] ?? '',
          phoneNumber: profile?['phone_number'] ?? '',
          createdAt: DateTime.now(),
        );
      }

      return null;
    } on AuthException catch (e) {
      debugPrint('❌ Auth error during sign in: ${e.message}');
      throw _handleAuthError(e);
    } catch (e) {
      debugPrint('❌ Unexpected error during sign in: $e');
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Get user profile from 'profiles' table
  Future<Map<String, dynamic>?> _getUserProfile(String userId) async {
    try {
      final response = await _supabaseService.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      if (response['error'] != null) {
        debugPrint('❌ Error fetching user profile: ${response['error']}');
        return null;
      }

      return response['data'] as Map<String, dynamic>?;
    } catch (e) {
      debugPrint('❌ Error fetching user profile: $e');
      return null;
    }
  }

  // Handle auth errors with user-friendly messages
  String _handleAuthError(AuthException e) {
    switch (e.message) {
      case 'User already registered':
        return 'This email is already registered. Please try logging in.';
      case 'Invalid login credentials':
        return 'Invalid email or password. Please try again.';
      case 'Email not confirmed':
        return 'Please verify your email address before logging in.';
      case 'Weak password':
        return 'Password is too weak. Please use a stronger password.';
      case 'Password should be at least 6 characters':
        return 'Password must be at least 6 characters long.';
      case 'Database error saving new user':
        return 'Unable to create account. Please try again.';
      case 'Signup disabled':
        return 'New signups are currently disabled. Please contact support.';
      default:
        return e.message;
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
      return UserModel(
        id: user.id,
        email: user.email ?? '',
        fullName: user.userMetadata?['full_name'] ?? '',
        phoneNumber: user.userMetadata?['phone_number'] ?? '',
        createdAt: DateTime.now(),
      );
    }
    return null;
  }

  // Check if user is authenticated
  bool get isAuthenticated => _supabaseService.isAuthenticated;

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _supabaseService.auth.resetPasswordForEmail(
        email,
        redirectTo: 'velogo://reset-password',
      );
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
      // Update auth metadata
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
        // Also update the profiles table
        final currentUser = _supabaseService.currentUser;
        if (currentUser != null) {
          await _supabaseService.client
              .from('profiles')
              .update({
                if (fullName != null) 'full_name': fullName,
                if (phoneNumber != null) 'phone_number': phoneNumber,
                if (avatarUrl != null) 'avatar_url': avatarUrl,
                'updated_at': DateTime.now().toIso8601String(),
              })
              .eq('id', currentUser.id);
        }

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
