import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:map_based_search_task/core/constants/api_paths.dart';

class APIService {
  final String baseUrl;

  APIService() : baseUrl = APIPaths.baseUrl;

  Future<dynamic> getRequest(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'));
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Error: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }
}
