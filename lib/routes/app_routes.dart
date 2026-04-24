import 'package:get/get.dart';
import 'package:projectfile/screens/home_page.dart';
import 'package:projectfile/screens/register_screen.dart';
import 'package:projectfile/screens/sign_in_screen.dart';
import 'package:projectfile/screens/splash_screen.dart';
import 'package:projectfile/screens/c_registration_screen.dart';
import 'package:projectfile/screens/p_register_screen.dart';
import 'package:projectfile/screens/view_services_screen.dart';
import 'package:projectfile/routes/auth_middleware.dart';

class AppRoutes {
  static const String splash = '/';
  static const String register = '/register';
  static const String signIn = '/sign-in';
  static const String customerSignup = '/customer-signup';
  static const String providerSignup = '/provider-signup';
  static const String viewServices = '/view-services';
  static const String dashboard = '/dashboard';

  static final List<GetPage<dynamic>> pages = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: register, page: () => RegisterScreen()),
    GetPage(name: signIn, page: () => SignInScreen()),
    GetPage(name: customerSignup, page: () => CustomerSignupPage()),
    GetPage(name: providerSignup, page: () => ServiceProviderSignupPage()),
    GetPage(name: viewServices, page: () => ViewServicesPage()),
    GetPage(
      name: dashboard,
      page: () => HomePage(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}

