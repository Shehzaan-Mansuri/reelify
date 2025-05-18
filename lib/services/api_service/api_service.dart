import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart'; // For the compute function

/// ApiService handles all network requests to the backend API.
/// This service is responsible for making HTTP requests and processing responses.
class ApiService {
  // Base URL for the API endpoints
  final String _baseUrl = 'https://backend-cj4o057m.fctl.app';

  /// Helper method that fetches data from a given URI and decodes the JSON response.
  /// 
  /// This method is designed to be run in a separate isolate via the compute function.
  /// It handles the HTTP GET request and processes the JSON response structure.
  /// 
  /// @param uri The URI to make the GET request to
  /// @return A List of dynamic objects from the nested data structure in the response
  /// @throws Exception if the HTTP request fails or if the response format is unexpected
  static Future<List<dynamic>> _fetchAndDecode(Uri uri) async {
    // Make the HTTP GET request
    final response = await http.get(uri);
    
    if (response.statusCode == 200) {
      // Decode the JSON response
      final jsonData = jsonDecode(response.body);
      
      // Our API returns data in a nested format: { "data": { "data": [...] } }
      if (jsonData['data'] != null && jsonData['data']['data'] != null) {
        return jsonData['data']['data'] as List<dynamic>;
      } else {
        throw Exception(
            'Invalid API response format: Missing "data" or "data.data"');
      }
    } else {
      throw Exception(
          'Failed to load bytes: HTTP status ${response.statusCode}');
    }
  }

  /// Fetches byte data with pagination support.
  /// 
  /// @param page The page number to fetch (for pagination)
  /// @param limit The number of items per page
  /// @return A Future that resolves to a List of byte objects
  /// @throws Exception if the fetch operation fails
  Future<List<dynamic>> fetchBytes(int page, int limit) async {
    // Construct the URI with query parameters for pagination
    final Uri uri = Uri.parse('$_baseUrl/bytes/scroll').replace(
      queryParameters: {'page': '$page', 'limit': '$limit'},
    );

    try {
      // Use the compute function to run _fetchAndDecode in a separate isolate
      // This prevents blocking the main UI thread during network operations
      return await compute(_fetchAndDecode, uri);
    } catch (e) {
      throw Exception('Failed to fetch bytes: $e');
    }
  }
}
