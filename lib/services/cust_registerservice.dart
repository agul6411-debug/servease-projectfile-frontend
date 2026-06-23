import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomerService {
  static const String baseUrl = 'http://localhost:3000/api/auth';

  Future<Map<String, dynamic>> registerCustomer(
    String name,
    String email,
    String phone,
    String cnic,
    String address,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register/customer'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'full_name': name.trim(),
          'email': email.trim(),
          'phone': phone.trim(),
          'cnic': cnic.trim(),
          'address': address.trim(),
          'password': password,
        }),
      );

      print('CUSTOMER REGISTER STATUS: ${response.statusCode}');
      print('CUSTOMER REGISTER BODY: ${response.body}');

      // Agar backend HTML error return kare
      if (response.body.trim().startsWith('<')) {
        return {
          'success': false,
          'message': 'Server route not found (${response.statusCode})',
        };
      }

      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data['success'] == true) {
        return {
          'success': true,
          'message': data['message'] ?? 'Customer registered successfully',
          'data': data,
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Registration failed',
      };
    } catch (e) {
      print('CUSTOMER REGISTER ERROR: $e');

      return {
        'success': false,
        'message': 'An error occurred. Please try again.',
      };
    }
  }
}