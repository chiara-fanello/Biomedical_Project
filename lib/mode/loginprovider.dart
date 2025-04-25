import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  String _username = 'fjUj9CGlJ5';
  String _password = '12345678!';
  String _usernameInsert = '';
  String _passwordInsert = '';
  String? _errorMessage;
  bool _loading = false;

  bool get loading => _loading;
  String? get errorMessage => _errorMessage;

  void setUsername(String value) {
    _usernameInsert = value;
    _errorMessage = null; // reset errore
    notifyListeners();
  }

  void setPassword(String value) {
    _passwordInsert = value;
    _errorMessage = null; // reset errore
    notifyListeners();
  }

  Future<bool> login() async {
    _loading = true;
    notifyListeners();
    await Future.delayed(Duration(seconds: 2));
    if (_username == _usernameInsert && _password == _passwordInsert) {
      _loading = false;
      _errorMessage = null;
      notifyListeners();
      return true;
    } else {
      _loading = false;
      _errorMessage = 'Password o Username errati';
      notifyListeners();
      return false;
    }
  }
}
