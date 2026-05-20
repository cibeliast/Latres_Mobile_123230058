import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api.tvmaze.com';

  Future<List<dynamic>> fetchShows() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/shows'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load shows');
      }
    } catch (e) {
      throw Exception('Error fetching shows: $e');
    }
  }

  Future<Map<String, dynamic>> fetchShowDetails(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/shows/$id'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load show details');
      }
    } catch (e) {
      throw Exception('Error fetching show details: $e');
    }
  }
}
