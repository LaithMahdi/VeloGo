import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/constant/app_router.dart';
import '../data/service/auth_service.dart';
import '../data/model/user_model.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _currentUser;

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  // Getters
  TextEditingController get email => _email;
  TextEditingController get password => _password;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;
  GlobalKey<FormState> get loginFormKey => _loginFormKey;

  void onSubmit(BuildContext context) async {
    if (_loginFormKey.currentState!.validate()) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      try {
        final user = await _authService.signIn(
          email: _email.text.trim(),
          password: _password.text,
        );

        if (user != null) {
          _currentUser = user;
          debugPrint("✅ Login successful: ${user.email}");
          GoRouter.of(context).go(AppRouter.home);
        } else {
          _errorMessage = "Login failed. Please try again.";
        }
      } catch (e) {
        _errorMessage = e.toString();
        debugPrint("❌ Login failed: $e");
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void clearFields() {
    _email.clear();
    _password.clear();
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
