import 'dart:convert';
import 'package:http/http.dart' as http;

class ProviderService {
  // Android emulator  → 10.0.2.2
  // iOS simulator     → localhost
  // Physical device   → your PC's local IP e.g. 192.168.1.x
  static const String baseUrl = "http://localhost:3000";
  // REGISTER PROVIDER
  Future<Map<String, dynamic>> registerProvider(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register/provider"),
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
