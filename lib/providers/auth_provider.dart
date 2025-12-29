import 'package:flutter/material.dart';
import '../data/service/auth_service.dart';
import '../data/model/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  bool _isLoading = true;

  AuthProvider() {
    _initializeAuth();
  }

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;

  // Initialize auth and listen to auth state changes
  void _initializeAuth() async {
    _currentUser = await _authService.getCurrentUser();
    _isLoading = false;
    notifyListeners();

    // Listen to auth state changes
    _authService.authStateChanges.listen((authState) async {
      final user = authState.session?.user;
      if (user != null) {
        _currentUser = await _authService.getCurrentUser();
      } else {
        _currentUser = null;
      }
      notifyListeners();
    });
  }

  // Update current user
  void setCurrentUser(UserModel? user) {
    _currentUser = user;
    notifyListeners();
  }

  // Update current user data
  void updateCurrentUser(UserModel updatedUser) {
    _currentUser = updatedUser;
    notifyListeners();
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error signing out: $e');
      rethrow;
    }
  }

  // Refresh current user
  Future<void> refreshUser() async {
    _currentUser = await _authService.getCurrentUser();
    notifyListeners();
  }
}
