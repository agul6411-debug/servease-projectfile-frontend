import 'dart:convert';
import 'package:frontfile_servease/models/customer/customer_model.dart';
import 'package:http/http.dart' as http;

class CustomerApiService {
  static const String baseUrl = "http://localhost:3000/api/customer";

  static Map<String, String> get _headers => {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  // GET home data
  static Future<CustomerHomeData?> fetchHomeData(int userId) async {
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/home?user_id=$userId"),
        headers: _headers,
      );
      if (res.statusCode == 200)
        return CustomerHomeData.fromJson(jsonDecode(res.body));
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // GET providers by category
  static Future<List<TopProvider>> fetchProvidersByCategory(
    String category,
  ) async {
    try {
      final res = await http.get(
        Uri.parse(
          "$baseUrl/providers?category=${Uri.encodeComponent(category)}",
        ),
        headers: _headers,
      );
      if (res.statusCode == 200) {
        return List<Map<String, dynamic>>.from(
          jsonDecode(res.body),
        ).map((e) => TopProvider.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // GET all providers
  static Future<List<TopProvider>> fetchAllProviders() async {
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/providers"),
        headers: _headers,
      );
      if (res.statusCode == 200) {
        return List<Map<String, dynamic>>.from(
          jsonDecode(res.body),
        ).map((e) => TopProvider.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
