import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:map_based_search_task/core/constants/api_paths.dart';
import 'package:map_based_search_task/core/services/navigation_services.dart';

class APIService {
  final String baseUrl;
  final Duration timeoutDuration;

  APIService()
      : baseUrl = APIPaths.baseUrl,
        timeoutDuration = const Duration(seconds: 2);

  Future<dynamic> getRequest(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$endpoint')).timeout(
          timeoutDuration,
          onTimeout: () =>
              throw Exception("Request timed out. Please try again later."));
      return _handleResponse(response);
    } catch (e) {
      NavigationServices.showInfoSnackBar(
          'Unable to connect to the server. Please try again later.');
      throw Exception(e.toString());
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Server error: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }
}
