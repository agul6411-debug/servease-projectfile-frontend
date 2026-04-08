import 'package:get/get.dart';
import 'package:projectfile/screens/dashboard_screen.dart';
import 'package:projectfile/screens/home_page_new.dart';
import 'package:projectfile/screens/login_screen.dart';
import 'package:projectfile/screens/register_screen.dart';
import 'package:projectfile/screens/splash_screen.dart';
import 'package:projectfile/screens/c_registration_screen.dart';
import 'package:projectfile/screens/p_register_screen.dart';
import 'package:projectfile/routes/auth_middleware.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String customerSignup = '/customer-signup';
  static const String providerSignup = '/provider-signup';
  static const String dashboard = '/dashboard';

  static final List<GetPage<dynamic>> pages = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: home, page: () => HomePage()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: register, page: () => RegisterScreen()),
    GetPage(name: customerSignup, page: () => CustomerSignupPage()),
    GetPage(name: providerSignup, page: () => ServiceProviderSignupPage()),
    GetPage(
      name: dashboard,
      page: () => DashboardScreen(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}

