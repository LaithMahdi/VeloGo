import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/constant/app_router.dart';
import '../data/service/auth_service.dart';
import '../core/utils/snackbar_utils.dart';
import 'auth_provider.dart';

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

  GlobalKey<FormState> get signupFormKey => _signupFormKey;

  Future<void> onSubmit(BuildContext context) async {
    if (_signupFormKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        if (context.mounted) {
          SnackbarUtils.showError(
            context,
            "You must agree to the terms and conditions",
          );
        }
        return;
      }

      _isLoading = true;
      notifyListeners();

      try {
        final user = await _authService.signUp(
          email: _email.text.trim(),
          password: _password.text,
          fullName: _fullName.text.trim(),
          phoneNumber: _phoneNumber.text.trim(),
        );

        if (user != null && context.mounted) {
          // Update global auth state
          context.read<AuthProvider>().setCurrentUser(user);

          SnackbarUtils.showSuccess(
            context,
            "Account created successfully! Welcome, ${user.fullName ?? user.email}!",
          );

          // Navigate to home
          GoRouter.of(context).go(AppRouter.mainNavigation);
        } else if (context.mounted) {
          SnackbarUtils.showError(context, "Signup failed. Please try again.");
        }
      } catch (e) {
        if (context.mounted) {
          SnackbarUtils.showError(context, e.toString());
        }
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
