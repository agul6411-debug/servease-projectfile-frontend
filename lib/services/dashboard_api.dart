import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardApi {
  static const String baseUrl = 'http://localhost:3000/dashboard';

  static Future<Map<String, dynamic>> getStats() async {
    final response = await http.get(Uri.parse(baseUrl));

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(response.body);
  }
}
