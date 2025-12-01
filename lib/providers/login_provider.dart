import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  // Getters
  TextEditingController get email => _email;
  TextEditingController get password => _password;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isLoading => _isLoading;
  GlobalKey<FormState> get loginFormKey => _loginFormKey;

  void onSubmit() async {
    if (_loginFormKey.currentState!.validate()) {
      _isLoading = true;
      notifyListeners();

      try {
        // Perform login action
        await Future.delayed(const Duration(seconds: 2)); // Simulate API call

        // Handle successful login
        print("Login successful");
        print("Email: ${_email.text}");
      } catch (e) {
        // Handle error
        print("Login failed: $e");
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
    notifyListeners();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
