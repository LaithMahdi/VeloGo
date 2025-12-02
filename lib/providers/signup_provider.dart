import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/constant/app_router.dart';
import '../data/service/auth_service.dart';
import '../data/model/user_model.dart';

class SignupProvider extends ChangeNotifier {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreeToTerms = false;
  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _currentUser;

  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();

  // Getters
  TextEditingController get fullName => _fullName;
  TextEditingController get email => _email;
  TextEditingController get phoneNumber => _phoneNumber;
  TextEditingController get password => _password;
  TextEditingController get confirmPassword => _confirmPassword;

  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  bool get agreeToTerms => _agreeToTerms;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;

  GlobalKey<FormState> get signupFormKey => _signupFormKey;

  void onSubmit(BuildContext context) async {
    if (_signupFormKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        _errorMessage = "You must agree to the terms and conditions";
        notifyListeners();
        return;
      }

      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      try {
        final user = await _authService.signUp(
          email: _email.text.trim(),
          password: _password.text,
          fullName: _fullName.text.trim(),
          phoneNumber: _phoneNumber.text.trim(),
        );

        if (user != null) {
          _currentUser = user;
          debugPrint("✅ Signup successful: ${user.email}");
          GoRouter.of(context).go(AppRouter.home);
        } else {
          _errorMessage = "Signup failed. Please try again.";
        }
      } catch (e) {
        _errorMessage = e.toString();
        debugPrint("❌ Signup failed: $e");
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

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  void toggleAgreeToTerms(bool? value) {
    _agreeToTerms = value ?? false;
    _errorMessage = null;
    notifyListeners();
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password";
    }
    if (value != _password.text) {
      return "Passwords do not match";
    }
    return null;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _phoneNumber.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }
}
