import 'package:flutter/material.dart';

class PasswordVisibilityProvider extends ChangeNotifier {
  bool _isObscure = true;

  bool get isObscure => _isObscure;

  void toggleVisibility() {
    _isObscure = !_isObscure;
    notifyListeners(); // Notify listeners to update the UI
  }
}

class FormValidationProvider extends ChangeNotifier {
  String _email = '';
  String _password = '';
  String? _emailError;
  String? _passwordError;
  bool _isLoading = false; // Add loading state

  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  bool get isLoading => _isLoading; // Add getter for loading state

  void updateEmail(String email) {
    _email = email;
    _emailError = _validateEmail(email);
    notifyListeners();
  }


  void setLoading(bool loading) {
    _isLoading = loading; // Method to update loading state
    print("Loading state changed: $_isLoading"); // Debug print
    notifyListeners(); // Notify listeners to update the UI
  }
  void updatePassword(String password) {
    _password = password;
    _passwordError = _validatePassword(password);
    notifyListeners();
  }

  String? _validateEmail(String email) {
    // Basic email validation logic
    if (email.isEmpty) return 'Email cannot be empty';
    if (!email.contains('@')) return 'Invalid email address';
    return null;
  }

  String? _validatePassword(String password) {
    // Basic password validation logic
    if (password.isEmpty) return 'Password cannot be empty';
    if (password.length < 6) return 'Password too short';
    return null;
  }
}