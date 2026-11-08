import 'dart:convert';
import 'package:http/http.dart' as http;

class ToDoService {
  static const String baseUrl = 'https://api.nstack.in/v1/todos';

  static Future<bool> deleteById(String id) async {
    final url = '$baseUrl/$id';
    final uri = Uri.parse(url);
    try {
      final response = await http.delete(uri);
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Future<List?> fetchTodo() async {
    const url = '$baseUrl?page=1&limit=20';
    final uri = Uri.parse(url);
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final dynamic json = jsonDecode(response.body);
        if (json is Map) {
          final result = (json['items'] ?? json['data']) as List?;
          return result;
        } else if (json is List) {
          return json;
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<bool> addToDo(Map body) async {
    final uri = Uri.parse(baseUrl);
    try {
      final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> updateToDo(String id, Map body) async {
    final url = '$baseUrl/$id';
    final uri = Uri.parse(url);
    try {
      final response = await http.put(
        uri,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
