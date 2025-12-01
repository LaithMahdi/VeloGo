import 'package:flutter/material.dart';

class SignupProvider extends ChangeNotifier {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreeToTerms = false;

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

  GlobalKey<FormState> get signupFormKey => _signupFormKey;

  void onSubmit() {
    if (_signupFormKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        // Show error - must agree to terms
        return;
      }
      // Perform signup action
      print("Signup submitted");
      print("Name: ${_fullName.text}");
      print("Email: ${_email.text}");
      print("Phone: ${_phoneNumber.text}");
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
