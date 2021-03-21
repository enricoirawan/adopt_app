import 'package:app_adopt/utils/url.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Adopt with ChangeNotifier {
  final String email;
  final String token;

  Adopt({this.email, this.token});

  Future<List> getAllAdoption() async {
    try {
      final response = await http.get('${Url.baseUrl}/getadoptions', headers: {
        'email': email,
        'token': token,
      });
      final responseData = jsonDecode(response.body);
      return responseData;
    } catch (e) {
      throw e;
    }
  }

  Future<List> getListChild() async {
    try {
      final response = await http.get(
        '${Url.baseUrl}/list-adoption-categoriey/3',
        headers: {
          'email': email,
          'token': token,
        },
      );
      final responseData = jsonDecode(response.body);
      return responseData;
    } catch (e) {
      throw e;
    }
  }

  Future<List> getListPet() async {
    try {
      final response = await http.get(
        '${Url.baseUrl}/list-adoption-categoriey/4',
        headers: {
          'email': email,
          'token': token,
        },
      );
      final responseData = jsonDecode(response.body);
      return responseData;
    } catch (e) {
      throw e;
    }
  }

  Future<Map> findById(id) async {
    try {
      final response = await http.get(
        '${Url.baseUrl}/adoption/$id',
        headers: {
          'email': email,
          'token': token,
        },
      );
      final responseData = jsonDecode(response.body);
      return responseData;
    } catch (e) {
      throw e;
    }
  }

  Future<Map> requestAdopt(adoptionId, name, reason, phone, userId) async {
    try {
      print('reuqestAdopt func');
      print(adoptionId);
      print(userId);
      print(email);
      print(token);
      final response = await http.post(
        '${Url.baseUrl}/adoption-request',
        body: {
          'adoption_id': adoptionId.toString(),
          'name': name,
          'reason': reason,
          'phone': phone,
          'user_id': userId.toString(),
        },
        headers: {
          'email': email,
          'token': token,
        },
      );
      final responseData = jsonDecode(response.body);
      print(responseData);
      return responseData;
    } catch (e) {
      throw e;
    }
  }

  Future<List> getHistoryAdopt(userId) async {
    try {
      final response = await http.post(
        '${Url.baseUrl}/my-request-adoption',
        body: {
          'user_id': userId.toString(),
        },
        headers: {
          'email': email,
          'token': token,
        },
      );

      final responseData = jsonDecode(response.body);
      return responseData;
    } catch (e) {
      throw e;
    }
  }
}
