import 'package:frontfile_servease/core/services/app_config.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:frontfile_servease/features/admin/models/adminprofilemodel.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AdminProfileService {
  static String get baseUrl => "${AppConfig.baseUrl}/api/admin";

  static Map<String, String> get _headers {
    final token = GetStorage().read('auth_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // GET PROFILE
  Future<AdminProfileModel?> getProfile(int id) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/profile/$id"),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AdminProfileModel.fromJson(data['data']);
      }

      return null;
    } catch (e) {
      debugPrint('AdminProfileService.getProfile error: $e');
      return null;
    }
  }

  // UPDATE PROFILE
  Future<bool> updateProfile({
    required int id,
    required String fullName,
    required String email,
    required String phone,
    XFile? image,
  }) async {
    try {
      var request = http.MultipartRequest(
        "PUT",
        Uri.parse("$baseUrl/profile/update/$id"),
      );

      final token = GetStorage().read('auth_token') ?? '';
      if (token.isNotEmpty) {
        request.headers["Authorization"] = "Bearer $token";
      }

      request.fields["full_name"] = fullName;
      request.fields["email"] = email;
      request.fields["phone"] = phone;

      if (image != null) {
        final bytes = await image.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            "profile_image",
            bytes,
            filename: image.name,
          ),
        );
      }

      final response = await request.send();
      debugPrint(
        'AdminProfileService.updateProfile status: ${response.statusCode}',
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('AdminProfileService.updateProfile error: $e');
      return false;
    }
  }

  // RESET PASSWORD
  Future<bool> resetPassword({
    required int id,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final token = GetStorage().read('auth_token') ?? '';
      final response = await http.put(
        Uri.parse("$baseUrl/profile/reset-password/$id"),
        headers: {
          "Content-Type": "application/json",
          if (token.isNotEmpty) "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('AdminProfileService.resetPassword error: $e');
      return false;
    }
  }
}
