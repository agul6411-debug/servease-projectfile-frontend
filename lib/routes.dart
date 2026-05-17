// App routes

import 'package:frontfile_servease/screens/admin/addservices.dart';
import 'package:frontfile_servease/screens/admin/admindashboard.dart';
import 'package:frontfile_servease/screens/admin/providers.dart';
import 'package:frontfile_servease/screens/auth/providerpagereg.dart';
import 'package:frontfile_servease/screens/auth/splashscreen.dart';
import 'package:frontfile_servease/screens/auth/homepageview.dart';
import 'package:get/get.dart';
import 'package:frontfile_servease/screens/auth/login_screen.dart';
import 'package:frontfile_servease/screens/auth/register_screen.dart';
import 'package:frontfile_servease/screens/admin/verify_page.dart';
import 'package:frontfile_servease/screens/customer/customer_home_screen.dart';
import 'package:frontfile_servease/screens/provider/provider_home_screen.dart';
import 'package:frontfile_servease/screens/auth/customerpagereg.dart';

class AppRoutes {
  static const String splash = '/';
  static const String homepageview = '/homepageview';
  static const String loginScreen = '/login_screen';
  static const String registerScreen = '/register_screen';
  static const String adminDashboard = '/admin_dashboard';
  static const String homescreen = '/home_screen';
  static const String providersScreen = '/providers_screen';
  static const String addserviceScreen = '/addservice_screen';
  static const String adminprofile = '/admin_profile';
  static const String customerHomeScreen = '/customer_home_screen';
  static const String providerHomeScreen = '/provider_home_screen';
  static const String customerPage = '/customer_page';
  static const String providerPage = '/provider_page';
  static const String verifyPage = '/verify';

  static final List<GetPage<dynamic>> pages = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: homepageview, page: () => HomePage()),
    GetPage(name: loginScreen, page: () => LoginScreen()),
    GetPage(name: registerScreen, page: () => RegisterScreen()),
    GetPage(name: adminDashboard, page: () => Admindashboard()),
    GetPage(name: providersScreen, page: () => ProvidersScreen()),
    GetPage(name: addserviceScreen, page: () => Addservices()),
    GetPage(name: verifyPage, page: () => VerifyPage()),
    GetPage(name: customerHomeScreen, page: () => CustomerHomeScreen()),
    GetPage(name: providerHomeScreen, page: () => ProviderHomeScreen()),
    GetPage(name: customerPage, page: () => CustomerPagereg()),
    GetPage(name: providerPage, page: () => ProviderPagereg()),
    GetPage(name: adminprofile, page: () => Admindashboard()),
  ];
}

//middlewares: [AuthMiddleware()],
