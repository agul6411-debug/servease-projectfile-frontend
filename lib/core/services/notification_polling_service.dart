import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontfile_servease/core/services/app_config.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';

class NotificationPollingService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static Timer? _timer;

  static Future<void> init() async {
    // Guard for web compatibility
    if (kIsWeb) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
    );

    // Request notifications permission on Android 13+
    final androidImplementation = _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }
  }

  static void startPolling() {
    debugPrint("[NotificationPolling] Service started polling every 15s");
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) async {
      await _checkNotifications();
    });
  }

  static void stopPolling() {
    debugPrint("[NotificationPolling] Service stopped polling");
    _timer?.cancel();
  }

  static Future<void> _checkNotifications() async {
    try {
      final box = GetStorage();
      final token = box.read('auth_token') ?? '';
      final role = box.read('user_role') ?? '';
      final userId = box.read('user_id') ?? 0;

      debugPrint("[NotificationPolling] Checking... loggedIn=${token.isNotEmpty}, role=$role, userId=$userId");

      if (token.isEmpty || role.isEmpty || userId == 0) return;

      String url = '';
      if (role == 'customer') {
        url = "${AppConfig.baseUrl}/api/customer/notifications?customer_id=$userId";
      } else if (role == 'provider') {
        url = "${AppConfig.baseUrl}/api/providerside/notifications?provider_id=$userId";
      } else if (role == 'admin') {
        url = "${AppConfig.baseUrl}/api/admin/notifications";
      } else {
        debugPrint("[NotificationPolling] Unknown user role: $role");
        return;
      }

      debugPrint("[NotificationPolling] Fetching from URL: $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint("[NotificationPolling] Response Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        List<dynamic> notificationsList = [];
        if (decoded is List) {
          notificationsList = decoded;
        } else if (decoded is Map && decoded['data'] is List) {
          notificationsList = decoded['data'];
        }

        debugPrint("[NotificationPolling] Fetched ${notificationsList.length} total notifications from DB");

        List<int> shownIds = List<int>.from(box.read('shown_notif_ids') ?? []);
        debugPrint("[NotificationPolling] Cached shown IDs list: $shownIds");

        bool triggeredAny = false;
        for (var notif in notificationsList) {
          final int notifId = notif['id'] ?? 0;
          final int isRead = notif['is_read'] ?? (notif['isRead'] == true ? 1 : 0);
          final String title = notif['title'] ?? 'New Alert';
          final String message = notif['message'] ?? '';

          debugPrint("[NotificationPolling] Evaluating notifId=$notifId, isRead=$isRead, isCached=${shownIds.contains(notifId)}");

          if (isRead == 0 && !shownIds.contains(notifId) && notifId != 0) {
            debugPrint("[NotificationPolling] Triggering notification display for notifId=$notifId ('$title')");
            await _showSystemNotification(notifId, title, message);
            shownIds.add(notifId);
            triggeredAny = true;
          }
        }

        if (triggeredAny) {
          // Keep local cache size optimized
          if (shownIds.length > 200) {
            shownIds = shownIds.sublist(shownIds.length - 200);
          }
          await box.write('shown_notif_ids', shownIds);
          debugPrint("[NotificationPolling] Saved updated shown IDs cache: $shownIds");
        }
      } else {
        debugPrint("[NotificationPolling] Request failed. Response: ${response.body}");
      }
    } catch (e) {
      debugPrint("[NotificationPolling] Exception in polling loop: $e");
    }
  }

  static Future<void> _showSystemNotification(int id, String title, String body) async {
    // If testing on Web browser, use elegant Get.snackbar fallback
    if (kIsWeb) {
      debugPrint("[NotificationPolling] Web Browser: Rendering Get.snackbar for '$title'");
      Get.snackbar(
        title,
        body,
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 5),
        icon: const Icon(Icons.notifications_active_rounded, color: Colors.white, size: 22),
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );
      return;
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'servease_channel_id',
      'ServEase Notifications',
      channelDescription: 'Alerts for ServEase bookings and requests',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
