import 'package:frontfile_servease/core/services/app_config.dart';
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class BookingService {
  static String get baseUrl => "${AppConfig.baseUrl}/api/customer";

  static Map<String, String> get _headers {
    final token = GetStorage().read('auth_token') ?? '';
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  // CREATE BOOKING
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

  // GET MY BOOKINGS
  static Future<List<Map<String, dynamic>>> getMyBookings(int customerId) async {
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/bookings?customer_id=$customerId"),
        headers: _headers,
      );
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return List<Map<String, dynamic>>.from(data);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // CANCEL BOOKING
  static Future<bool> cancelBooking(int bookingId) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/bookings/$bookingId/cancel"),
        headers: _headers,
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
