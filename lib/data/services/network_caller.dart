import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';

class NetworkCaller {
  static Future<NetworkResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      Map<String, String> headers = {
        'Authorization': 'Bearer ${AuthController.accessToken ?? ''}',
      };

      printRequest(url, null, headers);

      final Response response = await get(uri, headers: headers);
      printResponse(url, response);

      return _handleResponse(response);
    } catch (e) {
      debugPrint('GET Request Error: $e');
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<NetworkResponse> postRequest({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthController.accessToken ?? ''}',
      };

      printRequest(url, body, headers);

      final Response response = await post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );

      printResponse(url, response);
      return _handleResponse(response);
    } catch (e) {
      debugPrint('POST Request Error: $e');
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<NetworkResponse> postStreamRequest({
    required String url,
    Map<String, String>? body,
    Map<String, String>? headers,
    Map<String, String>? files,
  }) async {
    try {
      // Create a MultipartRequest
      var request = MultipartRequest('POST', Uri.parse(url));

      // Add fields to the request (if any)
      if (body != null) {
        request.fields.addAll(body);
      }

      // Add files to the request (if any)
      if (files != null) {
        files.forEach((key, value) async {
          var file = await MultipartFile.fromPath(key, value);
          request.files.add(file);
        });
      }

      // Set headers (if any)
      if (headers != null) {
        request.headers.addAll(headers);
      }

      // Send the request
      var streamedResponse = await request.send();

      // Handle the response
      if (streamedResponse.statusCode == 200) {
        var responseString = await streamedResponse.stream.bytesToString();
        return NetworkResponse(
          isSuccess: true,
          statusCode: streamedResponse.statusCode,
          errorMessage: responseString,
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: streamedResponse.statusCode,
          errorMessage: streamedResponse.reasonPhrase ?? 'Unknown error',
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static NetworkResponse _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return NetworkResponse(
        isSuccess: true,
        statusCode: response.statusCode,
        responseData: jsonDecode(response.body),
      );
    } else if (response.statusCode == 401) {
      _redirectToLogin();
      return NetworkResponse(
        isSuccess: false,
        statusCode: response.statusCode,
        errorMessage: 'Unauthorized. Please login again.',
      );
    } else {
      return NetworkResponse(
        isSuccess: false,
        statusCode: response.statusCode,
        errorMessage: 'Unexpected error occurred.',
      );
    }
  }

  static void printRequest(
      String url, Map<String, dynamic>? body, Map<String, String> headers) {
    debugPrint('Request URL: $url');
    debugPrint('Headers: $headers');
    debugPrint('Body: ${jsonEncode(body)}');
  }

  static void printResponse(String url, Response response) {
    debugPrint('Response for URL: $url');
    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');
  }

  static void _redirectToLogin() {
    AuthController.clearUserData();
    // Implement your navigation logic here
    debugPrint('Redirecting to Login Screen...');
  }

  static Future<NetworkResponse> deleteRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      Map<String, String> headers = {
        'Authorization': 'Bearer ${AuthController.accessToken ?? ''}',
      };

      printRequest(url, null, headers);

      final Response response = await delete(uri, headers: headers);
      printResponse(url, response);

      return _handleResponse(response);
    } catch (e) {
      debugPrint('DELETE Request Error: $e');
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }
}
