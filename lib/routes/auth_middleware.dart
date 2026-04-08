import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  final box = GetStorage();

  @override
  RouteSettings? redirect(String? route) {
    // Check if user has a valid token stored
    final token = box.read('token');

    // If no token exists, redirect to login
    if (token == null) {
      return const RouteSettings(name: AppRoutes.login);
    }

    // Optional: Verify token is still valid (commented for performance)
    // You can uncomment this if you want to verify token on every route access
    // _verifyToken();

    return null;
  }
}
