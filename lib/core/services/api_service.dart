import 'package:frontfile_servease/core/services/app_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = AppConfig.baseUrl;

  Future login(String email, String password, String role) async {
    final res = await http.post(
      Uri.parse("$baseUrl/api/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password, "role": role}),
    );

    print("STATUS: ${res.statusCode}");
    print("BODY: ${res.body}");

    return jsonDecode(res.body);
  }
}
