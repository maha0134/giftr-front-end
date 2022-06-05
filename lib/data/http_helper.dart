import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class HttpHelper {
  // String domain = Platform.isAndroid ? '10.0.2.2:3030' : '127.0.0.1:3030';
  String domain = 'stark-plateau-93271.herokuapp.com';

  String? token;
  Map<String, String>? headers;

  Future<http.Response> makeRequest(
      String method, Uri uri, Map<String, String>? headers, String? body) {
    body = body ?? '';
    headers = headers ??
        {
          'Content-Type': 'application/json; charset=UTF-8',
        };

    switch (method) {
      case 'post':
        return http.post(uri, headers: headers, body: body);
      case 'put':
        return http.put(uri, headers: headers, body: body);
      case 'patch':
        return http.patch(uri, headers: headers, body: body);
      case 'delete':
        return http.delete(uri, headers: headers);
      default:
        //get
        return http.get(uri, headers: headers);
    }
  }

  //add a method for POST to add a user
  Future<bool> registerUser(Map<String, dynamic> userData) async {
    //headers to send to the server
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-api-key': 'maha0134'
    };
    //build the URL for the endpoint
    Uri uri = Uri.http(domain, '/auth/users');
    http.Response response =
        await makeRequest('post', uri, headers, jsonEncode(userData));
    switch (response.statusCode) {
      case 201:
        return true;
      case 400:
        Map<String, dynamic> msg = {
          'code': 400,
          'message': 'Email address is already registered',
        };
        throw Exception(msg);
      case 401:
        Map<String, dynamic> msg = {
          'code': 401,
          'message':
              'You must have an approved api key to perform this action.',
        };
        throw Exception(msg);
      default:
        //something else
        Map<String, dynamic> msg = {
          'code': response.statusCode,
          'message': 'Server error occurred. Please try again.',
        };
        throw Exception(msg);
    }
  }

  Future loginUser(Map<String, dynamic> userData) async {
    //headers to send to the server
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-api-key': 'maha0134'
    };
    //build the URL for the endpoint
    Uri uri = Uri.http(domain, '/auth/tokens');

    http.Response response =
        await makeRequest('post', uri, headers, jsonEncode(userData));
    switch (response.statusCode) {
      case 201:
        return jsonDecode(response.body);
      case 401:
        Map<String, dynamic> msg = {
          'code': 401,
          'message': 'Incorrect username or password',
        };
        String str = jsonEncode(msg);
        throw Exception(str);
      default:
        //something else
        Map<String, dynamic> msg = {
          'code': response.statusCode,
          'message': 'Server error occurred. Please try again.',
        };
        throw Exception(msg);
    }
  }

  Future getAllPeople(var prefs) async {
    headers = await _getHeaders(prefs);
    Uri uri = Uri.http(domain, '/api/people');
    http.Response response = await makeRequest('get', uri, headers, '');
    switch (response.statusCode) {
      case 201:
        return jsonDecode(response.body);
      case 401:
        Map<String, dynamic> msg = {
          'code': 401,
          'message': 'You must be logged in to perform this action.',
        };
        throw Exception(msg);
      default:
        //something else
        Map<String, dynamic> msg = {
          'code': response.statusCode,
          'message': 'Server error occurred. Please try again.',
        };
        throw Exception(msg);
    }
  }

  Future<bool> createPerson(var prefs, Map<String, dynamic> userData) async {
    headers = await _getHeaders(prefs);
    //build the URL for the endpoint
    Uri uri = Uri.http(domain, '/api/people');
    http.Response response =
        await makeRequest('post', uri, headers, jsonEncode(userData));
    switch (response.statusCode) {
      case 201:
        return true;
      case 401:
        Map<String, dynamic> msg = {
          'code': 401,
          'message': 'You must be logged in to perform this action.',
        };
        throw Exception(msg);
      default:
        //something else
        Map<String, dynamic> msg = {
          'code': response.statusCode,
          'message': 'Server error occurred. Please try again.',
        };
        throw Exception(msg);
    }
  }

  Future<bool> updatePerson(
      var prefs, Map<String, dynamic> userData, String personId) async {
    headers = await _getHeaders(prefs);
    //build the URL for the endpoint
    Uri uri = Uri.http(domain, '/api/people/$personId');
    http.Response response =
        await makeRequest('patch', uri, headers, jsonEncode(userData));
    switch (response.statusCode) {
      case 200:
        return true;
      case 404:
        Map<String, dynamic> msg = {
          'code': 404,
          'message': 'No such person found.',
        };
        throw Exception(msg);
      case 403:
        Map<String, dynamic> msg = {
          'code': 403,
          'message': 'You are not authorized to edit this person.',
        };
        throw Exception(msg);
      default:
        //something else
        Map<String, dynamic> msg = {
          'code': response.statusCode,
          'message': 'Server error occurred. Please try again.',
        };
        throw Exception(msg);
    }
  }

  Future deletePerson(var prefs, String personId) async {
    headers = await _getHeaders(prefs);
    //build the URL for the endpoint
    Uri uri = Uri.http(domain, '/api/people/$personId');
    http.Response response = await makeRequest('delete', uri, headers, null);
    switch (response.statusCode) {
      case 200:
      case 201:
        return;
      case 404:
        Map<String, dynamic> msg = {
          'code': 404,
          'message': 'No such person found.',
        };
        throw Exception(msg);
      case 403:
        Map<String, dynamic> msg = {
          'code': 403,
          'message': 'You are not authorized to delete this person.',
        };
        throw Exception(msg);
      default:
        //something else
        Map<String, dynamic> msg = {
          'code': response.statusCode,
          'message': 'Server error occurred. Please try again.',
        };
        throw Exception(msg);
    }
  }

  Future getPersonFromId(var prefs, String id) async {
    headers = await _getHeaders(prefs);
    Uri uri = Uri.http(domain, '/api/people/$id');
    http.Response response = await makeRequest('get', uri, headers, '');
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 404:
        Map<String, dynamic> msg = {
          'code': 404,
          'message': 'No such person found.',
        };
        throw Exception(msg);
      case 403:
        Map<String, dynamic> msg = {
          'code': 403,
          'message': 'You are not authorized to view this person.',
        };
        throw Exception(msg);
      default:
        //something else
        Map<String, dynamic> msg = {
          'code': response.statusCode,
          'message': 'Server error occurred. Please try again.',
        };
        throw Exception(msg);
    }
  }

  Future<bool> createGift(
      var prefs, Map<String, dynamic> giftData, personId) async {
    headers = await _getHeaders(prefs);
    //build the URL for the endpoint
    Uri uri = Uri.http(domain, '/api/people/$personId/gifts');
    http.Response response =
        await makeRequest('post', uri, headers, jsonEncode(giftData));
    switch (response.statusCode) {
      case 201:
        return true;
      case 404:
        Map<String, dynamic> msg = {
          'code': 404,
          'message': 'No such person/gift found.',
        };
        throw Exception(msg);
      case 403:
        Map<String, dynamic> msg = {
          'code': 403,
          'message': 'You are not authorized to create a gift.',
        };
        throw Exception(msg);
      default:
        //something else
        Map<String, dynamic> msg = {
          'code': response.statusCode,
          'message': 'Server error occurred. Please try again.',
        };
        throw Exception(msg);
    }
  }

  Future<bool> deleteGift(var prefs, String personId, String giftId) async {
    headers = await _getHeaders(prefs);
    //build the URL for the endpoint
    Uri uri = Uri.http(domain, '/api/people/$personId/gifts/$giftId');
    http.Response response = await makeRequest('delete', uri, headers, null);
    switch (response.statusCode) {
      case 200:
        return true;
      case 404:
        Map<String, dynamic> msg = {
          'code': 404,
          'message': 'No such person/gift found.',
        };
        throw Exception(msg);
      case 403:
        Map<String, dynamic> msg = {
          'code': 403,
          'message': 'You are not authorized to delete this gift.',
        };
        throw Exception(msg);
      default:
        //something else
        Map<String, dynamic> msg = {
          'code': response.statusCode,
          'message': 'Server error occurred. Please try again.',
        };
        throw Exception(msg);
    }
  }

  Future<bool> updateGift(var prefs, Map<String, dynamic> giftData,
      String personId, String giftId) async {
    headers = await _getHeaders(prefs);
    //build the URL for the endpoint
    Uri uri = Uri.http(domain, '/api/people/$personId/gifts/$giftId');
    http.Response response =
        await makeRequest('patch', uri, headers, jsonEncode(giftData));
    switch (response.statusCode) {
      case 200:
        return true;
      case 404:
        Map<String, dynamic> msg = {
          'code': 404,
          'message': 'No such person/gift found.',
        };
        throw Exception(msg);
      case 403:
        Map<String, dynamic> msg = {
          'code': 403,
          'message': 'You are not authorized to edit this gift.',
        };
        throw Exception(msg);
      default:
        //something else
        Map<String, dynamic> msg = {
          'code': response.statusCode,
          'message': 'Server error occurred. Please try again.',
        };
        throw Exception(msg);
    }
  }

  Future fetchOwner(var prefs) async {
    headers = await _getHeaders(prefs);
    Uri uri = Uri.http(domain, '/auth/users/me');
    http.Response response =
        await makeRequest('get', uri, headers,null);
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 401:
        Map<String, dynamic> msg = {
          'code': 401,
          'message': 'You must be logged in to perform this action.',
        };
        throw Exception(msg);
      default:
        //something else
        Map<String, dynamic> msg = {
          'code': response.statusCode,
          'message': 'Server error occurred. Please try again.',
        };
        throw Exception(msg);
    }
  }

  Future<Map<String, String>> _getHeaders(var prefs) async {
    token = await prefs.getString('JWT');
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': 'Bearer $token',
      'x-api-key': 'maha0134'
    };
    return headers;
  }
}
