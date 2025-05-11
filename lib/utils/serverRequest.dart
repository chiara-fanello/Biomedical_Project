import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'impact.dart'; 

class ServerRequest {
  static const String _accessKey = 'access';
  static const String _refreshKey = 'refresh';

  // login, manda username e password al server, mette dentro sp access e refresh token
  static Future<bool> login(String username, String password) async {
    final url = Impact.baseUrl + Impact.tokenEndpoint;
    final body = {
      'username': username,
      'password': password,
    };

    final response = await http.post(Uri.parse(url), body: body);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      await sp.setString(_accessKey, decoded['access']);
      await sp.setString(_refreshKey, decoded['refresh']);
      return true;
    }

    return false;
  }

  // ritorna l'access token
  static Future<String?> getAccessToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_accessKey);
  }

  // ritorna il refresh token
  static Future<String?> getRefreshToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_refreshKey);
  }

  // usa il refresh token per aggiornare access e refresh
  static Future<bool> refreshTokens() async {
    final sp = await SharedPreferences.getInstance();
    final refresh = sp.getString(_refreshKey);

    if (refresh == null) return false;

    final url = Impact.baseUrl + Impact.refreshEndpoint;
    final response = await http.post(Uri.parse(url), body: {'refresh': refresh});

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      await sp.setString(_accessKey, decoded['access']);
      await sp.setString(_refreshKey, decoded['refresh']);
      return true;
    }

    return false;
  }

  //fa il log out
  static Future<void> logout() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_accessKey);
    await sp.remove(_refreshKey);
  }

  // fa il ping del server
  static Future<bool> isServerUp() async {
    final url = Impact.baseUrl + Impact.pingEndpoint;
    try {
      final response = await http.get(Uri.parse(url));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
