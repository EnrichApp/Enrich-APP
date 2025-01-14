import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiBaseClient {
  static const String _baseUrl = 'http://127.0.0.1:8000/api/v1/';

  Uri buildUri(String endpoint) {
    return Uri.parse(_baseUrl + endpoint);
  }

  Future<Map<String, String>> getAuthHeaders() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('authToken');
  if (token != null) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
  return {'Content-Type': 'application/json'};
}


  Future<http.Response> get(String endpoint, {Map<String, String>? headers}) async {
    final uri = buildUri(endpoint);
    return await http.get(uri, headers: await getAuthHeaders());
  }

  Future<http.Response> post(String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final uri = buildUri(endpoint);
    return await http.post(uri, headers: await getAuthHeaders(), body: body);
  }

  Future<http.Response> put(String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final uri = buildUri(endpoint);
    return await http.put(uri, headers: await getAuthHeaders(), body: body);
  }
}
