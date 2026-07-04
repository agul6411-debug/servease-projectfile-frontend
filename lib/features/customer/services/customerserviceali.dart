import 'package:frontfile_servease/core/services/app_config.dart';
import 'dart:convert';
import 'package:frontfile_servease/models/customer/customer_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class CustomerApiService {
  static String get baseUrl => "${AppConfig.baseUrl}/api/customer";

  static Map<String, String> get _headers {
    final token = GetStorage().read('auth_token') ?? '';
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }

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

  // GET all providers
  static Future<List<TopProvider>> fetchAllProviders() async {
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/providers"),
        headers: _headers,
      );
      if (res.statusCode == 200)
        return List<Map<String, dynamic>>.from(
          jsonDecode(res.body),
        ).map((e) => TopProvider.fromJson(e)).toList();
      return [];
    } catch (e) {
      return [];
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
      if (res.statusCode == 200)
        return List<Map<String, dynamic>>.from(
          jsonDecode(res.body),
        ).map((e) => TopProvider.fromJson(e)).toList();
      return [];
    } catch (e) {
      return [];
    }
  }

  // GET provider detail
  static Future<ProviderDetail?> fetchProviderDetail(int providerId) async {
    try {
      final token = GetStorage().read('auth_token') ?? '';
      final url = token.isNotEmpty
          ? "$baseUrl/provider/$providerId"
          : "${AppConfig.baseUrl}/api/auth/public-provider/$providerId";

      final res = await http.get(
        Uri.parse(url),
        headers: _headers,
      );
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        final data = decoded['success'] == true ? decoded['data'] : decoded;
        return ProviderDetail.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // POST create booking
  static Future<Map<String, dynamic>?> createBooking({
    required int customerId,
    required int providerId,
    required int serviceId,
    required String scheduledDate,
    required String scheduledTime,
    required String location,
    required double totalPrice,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/bookings"),
        headers: _headers,
        body: jsonEncode({
          'customer_id': customerId,
          'provider_id': providerId,
          'service_id': serviceId,
          'scheduled_date': scheduledDate,
          'scheduled_time': scheduledTime,
          'location': location,
          'total_price': totalPrice,
        }),
      );
      if (res.statusCode == 200 || res.statusCode == 201)
        return jsonDecode(res.body);
      return null;
    } catch (e) {
      return null;
    }
  }

  // GET customer bookings
  static Future<List<CustomerBooking>> fetchMyBookings(int customerId) async {
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/bookings?customer_id=$customerId"),
        headers: _headers,
      );
      if (res.statusCode == 200)
        return List<Map<String, dynamic>>.from(
          jsonDecode(res.body),
        ).map((e) => CustomerBooking.fromJson(e)).toList();
      return [];
    } catch (e) {
      return [];
    }
  }

  // GET notifications
  static Future<List<CustomerNotification>> fetchNotifications(
    int customerId,
  ) async {
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/notifications?customer_id=$customerId"),
        headers: _headers,
      );
      if (res.statusCode == 200)
        return List<Map<String, dynamic>>.from(
          jsonDecode(res.body),
        ).map((e) => CustomerNotification.fromJson(e)).toList();
      return [];
    } catch (e) {
      return [];
    }
  }

  // PUT mark as read
  static Future<bool> markNotificationRead(int notifId) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/notifications/$notifId/read"),
        headers: _headers,
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // CLEAR ALL NOTIFICATIONS
  static Future<bool> clearNotifications(int customerId) async {
    try {
      final res = await http.delete(
        Uri.parse("$baseUrl/notifications/clear?customer_id=$customerId"),
        headers: _headers,
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // SUBMIT RATING
  static Future<bool> submitRating({
    required int bookingId,
    required int customerId,
    required int providerId,
    required int rating,
    String? note,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/ratings"),
        headers: _headers,
        body: jsonEncode({
          'booking_id': bookingId,
          'customer_id': customerId,
          'provider_id': providerId,
          'rating': rating,
          'note': note,
        }),
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // SUBMIT COMPLAINT (against provider)
  static Future<bool> submitComplaint({
    required int customerId,
    required int bookingId,
    required String title,
    required String message,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/complaints"),
        headers: _headers,
        body: jsonEncode({
          'customer_id': customerId,
          'booking_id': bookingId,
          'title': title,
          'message': message,
        }),
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // GET customer profile
  static Future<Map<String, dynamic>?> fetchProfile(int userId) async {
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/profile?user_id=$userId"),
        headers: _headers,
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
      return null;
    } catch (e) {
      return null;
    }
  }

  // PUT update profile
  static Future<bool> updateProfile({
    required int userId,
    required String fullName,
    required String phone,
    required String address,
    dynamic image,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/profile?user_id=$userId");
      final token = GetStorage().read('auth_token') ?? '';
      
      final request = http.MultipartRequest('PUT', uri);
      request.headers.addAll({
        if (token.isNotEmpty) "Authorization": "Bearer $token",
      });
      
      request.fields['full_name'] = fullName;
      request.fields['phone'] = phone;
      request.fields['address'] = address;
      
      if (image != null) {
        // If it is a File from dart:io or a custom path
        final bytes = await image.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'profile_image',
          bytes,
          filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ));
      }
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // PUT change password
  static Future<Map<String, dynamic>> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/change-password?user_id=$userId"),
        headers: _headers,
        body: jsonEncode({
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );
      final data = jsonDecode(res.body);
      return {
        'success': res.statusCode == 200,
        'message': data['message'] ?? '',
      };
    } catch (e) {
      return {'success': false, 'message': 'Server error'};
    }
  }

  // POST forgot password
  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      // Auth route use karo — /api/auth/forgot-password
      final res = await http.post(
        Uri.parse("${AppConfig.baseUrl}/api/auth/forgot-password"),
        headers: _headers,
        body: jsonEncode({'email': email}),
      );
      final data = jsonDecode(res.body);
      return {
        'success': res.statusCode == 200,
        'message': data['message'] ?? '',
      };
    } catch (e) {
      return {'success': false, 'message': 'Server error'};
    }
  }
}
