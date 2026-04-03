import 'package:get/get.dart';
import 'package:projectfile/screens/dashboard_screen.dart';
import 'package:projectfile/screens/login_screen.dart';
import 'package:projectfile/screens/register_screen.dart';
import 'package:projectfile/screens/splash_screen.dart';
import 'package:projectfile/routes/auth_middleware.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';

  static final List<GetPage<dynamic>> pages = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: register, page: () => RegisterScreen()),
    GetPage(
      name: dashboard,
      page: () => DashboardScreen(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
