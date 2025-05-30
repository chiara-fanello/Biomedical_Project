import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:io';

class ImpactRequest {
  static String baseUrl = 'https://impact.dei.unipd.it/bwthw/';
  static String pingEndpoint = 'gate/v1/ping/';
  static String tokenEndpoint = 'gate/v1/token/';
  static String refreshEndpoint = 'gate/v1/refresh/';

  //static String username = '<YOUR_USERNAME>';
  //static String password = '<YOUR_PASSWORD>';

  static const String _accessKey = 'access';
  static const String _refreshKey = 'refresh';

  static String patientUsername = 'Jpefaq6m58';  //username to use to extract data, not to access to server
  static String stepsEndpoint = 'data/v1/steps/patients/';
  static String caloriesEndpoint = 'data/v1/calories/patients/';
  static String sleepEndpoint = 'data/v1/sleep/patients/';
  static String rhrEndpoint = 'data/v1/resting_heart_rate/patients/';
  static String distanceEndpoint = 'data/v1/distance/patients/';

  //to be simple as possible we are not interested in giving the user or using more than one response code
  //just need to know if it is 200 or not

  //LOGIN, send username e password to server, store in sp access and refresh token
  static Future<bool> login(String username, String password) async {
    final url = ImpactRequest.baseUrl + ImpactRequest.tokenEndpoint;
    final body = {'username': username, 'password': password};

    //try {
      final response = await http.post(Uri.parse(url), body: body);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final sp = await SharedPreferences.getInstance();
        await sp.setString(_accessKey, decoded['access']);
        await sp.setString(_refreshKey, decoded['refresh']);
        return true;
      }

      return false; // login fallito debug
    //} catch (e) {
      //print('Login error: $e');
      //return false;
    //}
  }


  //return access token, if needed
  static Future<String?> getAccessToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_accessKey);
  }

  //return refresh token, if needed
  static Future<String?> getRefreshToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_refreshKey);
  }

  //UPDATE TOKEN
  static Future<bool> refreshTokens() async {
    final sp = await SharedPreferences.getInstance();
    final refresh = sp.getString(_refreshKey);
    //if no existing token, don't continue
    if (refresh == null) return false;

    final url = ImpactRequest.baseUrl + ImpactRequest.refreshEndpoint;
    final response = await http.post(
      Uri.parse(url),
      body: {'refresh': refresh},
    );
    //if it's ok, update tokens and return true
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
    await sp.remove(_refreshKey); //only remove tokens
  }

  //PING, if needed
  static Future<bool> isServerUp() async {
    final url = ImpactRequest.baseUrl + ImpactRequest.pingEndpoint;
    try {
      final response = await http.get(Uri.parse(url));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  //FETCH STEP DATA DAY
  static Future<dynamic> fetchStepDataDay(String day) async {
    //Get the stored access token (Note that this code does not work if the tokens are null)
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    //If access token is expired, refresh it
    if (JwtDecoder.isExpired(access!)) {
      await ImpactRequest.refreshTokens();
      access = sp.getString('access');
    } //if

    //Create the (representative) request
    final url =
        ImpactRequest.baseUrl +
        ImpactRequest.stepsEndpoint +
        ImpactRequest.patientUsername +
        '/day/$day/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    //Get the response
    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);

    //if OK parse the response, otherwise return null
    var result = null;
    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
    } //if

    //Return the result
    return result;
  }

  //FETCH STEP DATA RANGE
  static Future<dynamic> fetchStepDataRange(String startDate, String endDate) async {
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    if (access == null || JwtDecoder.isExpired(access)) {
      await ImpactRequest.refreshTokens();
      access = sp.getString('access');
    }

    final url = '${ImpactRequest.baseUrl}${ImpactRequest.stepsEndpoint}'
        '${ImpactRequest.patientUsername}/daterange/start_date/$startDate/end_date/$endDate/';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $access',
    };

    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error ${response.statusCode}: ${response.body}');
      return null;
    }
  }

  //FETCH CALORIES DATA DAY
  static Future<dynamic> fetchCaloriesDataDay(String day) async {
    
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    
    if (JwtDecoder.isExpired(access!)) {
      await ImpactRequest.refreshTokens();
      access = sp.getString('access');
    }

    final url =
        ImpactRequest.baseUrl +
        ImpactRequest.caloriesEndpoint +
        ImpactRequest.patientUsername +
        '/day/$day/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    // Get the response
    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);

    // If OK, parse the response, otherwise return null
    var result;
    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
    }

    return result;
  }

  // FETCH CALORIES DATA RANGE
  static Future<dynamic> fetchCaloriesDataRange(String startDate, String endDate) async {
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    if (access == null || JwtDecoder.isExpired(access)) {
      await ImpactRequest.refreshTokens();
      access = sp.getString('access');
    }

    final url = '${ImpactRequest.baseUrl}${ImpactRequest.caloriesEndpoint}' // <-- modificato
        '${ImpactRequest.patientUsername}/daterange/start_date/$startDate/end_date/$endDate/';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $access',
    };

    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error ${response.statusCode}: ${response.body}');
      return null;
    }
  }

  // FETCH DISTANCE DATA DAY
  static Future<dynamic> fetchDistanceDataDay(String day) async {
    
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    
    if (JwtDecoder.isExpired(access!)) {
      await ImpactRequest.refreshTokens();
      access = sp.getString('access');
    }

    
    final url =
        ImpactRequest.baseUrl +
        ImpactRequest.distanceEndpoint + 
        ImpactRequest.patientUsername +
        '/day/$day/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    
    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);

    
    var result;
    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
    }

    return result;
  }

  // FETCH DISTANCE DATA RANGE
  static Future<dynamic> fetchDistanceDataRange(String startDate, String endDate) async {
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    if (access == null || JwtDecoder.isExpired(access)) {
      await ImpactRequest.refreshTokens();
      access = sp.getString('access');
    }

    final url = '${ImpactRequest.baseUrl}${ImpactRequest.distanceEndpoint}' 
        '${ImpactRequest.patientUsername}/daterange/start_date/$startDate/end_date/$endDate/';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $access',
    };

    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error ${response.statusCode}: ${response.body}');
      return null;
    }
  }


  //FETCH SLEEP DATA DAY
  static Future<dynamic> fetchSleepData(String day) async {
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    // Refresh token if expired
    if (JwtDecoder.isExpired(access!)) {
      await ImpactRequest.refreshTokens();
      access = sp.getString('access');
    }

    final url =
        ImpactRequest.baseUrl +
        sleepEndpoint +
        ImpactRequest.patientUsername +
        '/day/$day/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    var result;
    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
    }

    return result;
  }

  // FETCH HR
  static Future<dynamic> fetchRestingHeartRateData(String day) async {
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    // Refresh token if expired
    if (JwtDecoder.isExpired(access!)) {
      await ImpactRequest.refreshTokens();
      access = sp.getString('access');
    }

    final url =
        ImpactRequest.baseUrl +
        rhrEndpoint +
        ImpactRequest.patientUsername +
        '/day/$day/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    var result;
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return result;
  }
  

}//ImpactRequest