import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:frontfile_servease/routes.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';
import 'package:frontfile_servease/core/services/notification_polling_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  
  // Local Notifications initialize
  try {
    await NotificationPollingService.init();
  } catch (e) {
    debugPrint("NotificationPollingService initialization error: $e");
  }

  // Start polling safely after the widget tree is fully rendered
  WidgetsBinding.instance.addPostFrameCallback((_) {
    try {
      NotificationPollingService.startPolling();
    } catch (e) {
      debugPrint("NotificationPollingService start error: $e");
    }
  });
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ServEase',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.pages,
    );
  }
}
