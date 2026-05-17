import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomerService {
  final String baseUrl = 'http://localhost:3000/register/customers';

  Future<String> registerCustomer(
    String name,
    String email,
    String phone,
    String cnic,
    String address,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body:
          '{"name": "$name", "email": "$email", "phone": "$phone", "cnic": "$cnic", "address": "$address", "password": "$password"}',
    );

    if (response.statusCode == 200) {
      return 'Registration successful';
    } else {
      throw Exception('Failed to register customer');
    }
  }
}
