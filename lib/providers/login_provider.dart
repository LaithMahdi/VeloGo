import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/constant/app_router.dart';
import '../data/service/auth_service.dart';
import '../core/utils/snackbar_utils.dart';
import 'auth_provider.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  // Getters
  TextEditingController get email => _email;
  TextEditingController get password => _password;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isLoading => _isLoading;
  GlobalKey<FormState> get loginFormKey => _loginFormKey;

  Future<void> onSubmit(BuildContext context) async {
    if (_loginFormKey.currentState!.validate()) {
      _isLoading = true;
      notifyListeners();

      try {
        final user = await _authService.signIn(
          email: _email.text.trim(),
          password: _password.text,
        );

        if (user != null && context.mounted) {
          // Update global auth state
          context.read<AuthProvider>().setCurrentUser(user);

          SnackbarUtils.showSuccess(
            context,
            "Welcome back, ${(user.fullName?.isNotEmpty ?? false) ? user.fullName : user.email}!",
          );

          _clearForm();

          // Navigate to home
          GoRouter.of(context).go(AppRouter.home);
        } else if (context.mounted) {
          SnackbarUtils.showError(
            context,
            "Login failed. Please check your credentials and try again.",
          );
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

  void _clearForm() {
    _email.clear();
    _password.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
