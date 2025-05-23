import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ImpactRequest{

  static String baseUrl = 'https://impact.dei.unipd.it/bwthw/';
  static String pingEndpoint = 'gate/v1/ping/';
  static String tokenEndpoint = 'gate/v1/token/';
  static String refreshEndpoint = 'gate/v1/refresh/';
  
  //static String username = '<YOUR_USERNAME>';
  //static String password = '<YOUR_PASSWORD>';

  static const String _accessKey = 'access';
  static const String _refreshKey = 'refresh';

  //per semplicità non siamo interessati a dare l'utente o a usare più di un codice di risposta
  //basta solo sapere se è 200 o meno

  //LOGIN, manda username e password al server, mette dentro sp access e refresh token
  static Future<bool> login(String username, String password) async {
    final url = ImpactRequest.baseUrl + ImpactRequest.tokenEndpoint;
    final body = {
      'username': username,
      'password': password,
    };

    final response = await http.post(Uri.parse(url), body: body);
    //restituisce solo se è andato bene o male 
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      await sp.setString(_accessKey, decoded['access']);
      await sp.setString(_refreshKey, decoded['refresh']);
      return true;
    }

    return false;
  }

  // ritorna l'access token, se serve
  static Future<String?> getAccessToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_accessKey);
  }

  // ritorna il refresh token, se serve
  static Future<String?> getRefreshToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_refreshKey);
  }

  //AGGIORNAMENTO TOKEN
  static Future<bool> refreshTokens() async {
    final sp = await SharedPreferences.getInstance();
    final refresh = sp.getString(_refreshKey);
    //se non esiste il refresh inutile proseguire
    if (refresh == null) return false;

    final url = ImpactRequest.baseUrl + ImpactRequest.refreshEndpoint;
    final response = await http.post(Uri.parse(url), body: {'refresh': refresh});
    //se tutto va bene si prosegue con l'aggiornamento e restituisce vero
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      await sp.setString(_accessKey, decoded['access']);
      await sp.setString(_refreshKey, decoded['refresh']);
      return true;
    }

    return false;
  }

  //LOGOUT
  static Future<void> logout() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_accessKey);
    await sp.remove(_refreshKey); //rimuovo solo i token
  }

  //PING AL SERVER, se serve
  static Future<bool> isServerUp() async {
    final url = ImpactRequest.baseUrl + ImpactRequest.pingEndpoint;
    try {
      final response = await http.get(Uri.parse(url));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

}//ImpactRequest