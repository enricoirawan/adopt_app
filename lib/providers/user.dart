import 'dart:convert';
import 'package:app_adopt/utils/url.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class User with ChangeNotifier {
  String _fullName, _email, _token;
  int _userId;

  Map<String, dynamic> get userInfo {
    if (_token != null) {
      return {
        'full_name': _fullName,
        'email': _email,
        'userId': _userId,
      };
    }
    return null;
  }

  String get userName {
    return _fullName;
  }

  String get token {
    return _token;
  }

  String get email {
    return _email;
  }

  int get userId {
    return _userId;
  }

  Future<Map> register(String name, email, password) async {
    var body = {
      'full_name': name,
      'email': email,
      'password': password,
    };
    try {
      final response = await http.post('${Url.baseUrl}/register', body: body);
      final responseData = jsonDecode(response.body);
      return responseData;
    } catch (e) {
      throw e;
    }
  }

  void _setUserInfo(email) async {
    final response2 = await http.get(
      '${Url.baseUrl}/user-info',
      headers: {
        'email': email,
        'token': _token,
      },
    );
    final responseData2 = jsonDecode(response2.body);
    print(responseData2);
    _email = responseData2['email'];
    _fullName = responseData2['full_name'];
    _userId = responseData2['id'];
    notifyListeners();
  }

  Future<Map> login(String email, password) async {
    var body = {
      'email': email,
      'password': password,
    };
    try {
      final response = await http.post('${Url.baseUrl}/login', body: body);
      final responseData = jsonDecode(response.body);
      _token = responseData['return_token'];

      _setUserInfo(email);

      return responseData;
    } catch (e) {
      throw e;
    }
  }

  void logout() {
    _token = null;
    _email = null;
    _fullName = null;
    _userId = null;
    print(_token);
  }
}
