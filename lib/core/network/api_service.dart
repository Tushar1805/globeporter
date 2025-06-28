import 'package:http/http.dart' as http;
import '../index.dart';
import 'dart:convert';
import 'dart:async';

class ApiService {
  final String baseUrl = AppConstants.baseURL;

  Future<dynamic> getRequest(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/$endpoint'), headers: headers)
          .timeout(const Duration(seconds: 10));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<dynamic> postRequest(String endpoint, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/$endpoint'),
            headers: headers ?? {"Content-Type": "application/json"},
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: 10));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<dynamic> postFormData(String endpoint, Map<String, dynamic> data, String? filePath) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse('$baseUrl$endpoint'));
      data.forEach((key, value) {
        request.fields[key] = value;
      });
      try {
        if (filePath != null) request.files.add(await http.MultipartFile.fromPath("file", filePath));
      } catch (e) {}
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse).timeout(const Duration(seconds: 10));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  dynamic _handleResponse(http.Response response) {
    final decodedBody = json.decode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decodedBody;
    } else {
      throw ApiException(response.statusCode, decodedBody['message'] ?? 'Unknown error');
    }
  }

  dynamic _handleError(dynamic e) {
    if (e is TimeoutException) {
      throw ApiException(0, 'Request timed out');
    } else if (e is http.ClientException) {
      throw ApiException(0, 'No internet connection');
    } else {
      throw ApiException(0, 'Unexpected error: $e');
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);
}
