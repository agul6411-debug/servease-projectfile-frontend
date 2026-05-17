import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProviderService {
  final String baseUrl = 'http://localhost:3000/register/providers';

  Future<String> registerProvider(
    String fullName,
    String profession,
    String address,
    String providerId,
    String category,
    String yearsOfExperience,
    String bio,
    String cnic,
    String email,
    String phone,

    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body:
          '{"name": "$fullName", "profession": "$profession", "address": "$address", "provider_id": "$providerId", "category": "$category", "years_of_experience": "$yearsOfExperience", "bio": "$bio", "email": "$email", "phone": "$phone", "password": "$password"}',
    );

    if (response.statusCode == 200) {
      return 'Registration successful';
    } else {
      throw Exception('Failed to register provider');
    }
  }
}
