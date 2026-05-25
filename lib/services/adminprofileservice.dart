import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:frontfile_servease/models/adminprofilemodel.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AdminProfileService {
  static const String baseUrl = "http://localhost:3000/api/admin";

  // GET PROFILE
  Future<AdminProfileModel?> getProfile(int id) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/profile/3"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return AdminProfileModel.fromJson(data['data']);
      }

      return null;
    } catch (e) {
      print(e);

      return null;
    }
  }

  //update profile
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
        Uri.parse("$baseUrl/profile/update/3"),
      );

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

      var response = await request.send();

      print(response.statusCode);

      return response.statusCode == 200;
    } catch (e) {
      print(e);

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
      final response = await http.put(
        Uri.parse("$baseUrl/profile/reset-password/3"),

        headers: {"Content-Type": "application/json"},

        body: jsonEncode({
          "oldPassword": oldPassword,

          "newPassword": newPassword,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print(e);

      return false;
    }
  }
}
