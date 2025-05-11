import 'package:flutter/material.dart';
import '../utils/serverRequest.dart';

class LoginProvider with ChangeNotifier {
  String _usernameInsert = '';
  String _passwordInsert = '';
  String? _errorMessage;
  bool _loading = false;

  bool get loading => _loading;
  String? get errorMessage => _errorMessage;

  // Set username
  void setUsername(String value) {
    _usernameInsert = value;
    _errorMessage = null; // error reset
    notifyListeners();
  }

  // Set password
  void setPassword(String value) {
    _passwordInsert = value;
    _errorMessage = null; // error reset
    notifyListeners();
  }

  // effettua il login usando il server
  Future<bool> login() async {
    _loading = true;
    notifyListeners();

    final success = await ServerRequest.login(
      _usernameInsert,
      _passwordInsert,
    );

    _loading = false;
    _errorMessage = success ? null : 'Wrong username or password\n    Check also server status ';
    notifyListeners();

    return success;
  }

  // Logout
  Future<void> logout() async {
    await ServerRequest.logout();
    _usernameInsert = '';
    _passwordInsert = '';
    _errorMessage = null;
    notifyListeners();
  }
}

