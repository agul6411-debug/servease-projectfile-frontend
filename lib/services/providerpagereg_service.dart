import 'dart:convert';

import 'package:http/http.dart' as http;

class ProviderService {
  // WEB / DESKTOP
  static const String baseUrl = "http://localhost:3000/api/provider";

  // REGISTER PROVIDER
  Future<Map<String, dynamic>> registerProvider(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"),

        headers: {"Content-Type": "application/json"},

        body: jsonEncode(data),
      );

      final result = jsonDecode(response.body);

      return result;
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }
}
