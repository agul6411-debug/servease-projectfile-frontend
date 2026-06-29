import 'package:frontfile_servease/core/services/app_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomerService {
  final String baseUrl = AppConfig.baseUrl;

  Future<String> registerCustomer(
    String name,
    String email,
    String phone,
    String cnic,
    String address,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/register/customer');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "full_name": name,
        "email": email,
        "phone": phone,
        "cnic": cnic,
        "address": address,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201 && data['success'] == true) {
      return 'Registration successful';
    } else {
      return data['message'] ?? 'Registration failed';
    }
  }
}
