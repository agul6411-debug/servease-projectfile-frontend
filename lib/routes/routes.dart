import 'package:get/get.dart';
import 'package:projectfile/screens/auth/c_register_screen.dart';
import 'package:projectfile/screens/auth/p_register_screen.dart';
import 'package:projectfile/screens/auth/signin_screen.dart';
import 'package:projectfile/screens/auth/signup_screen.dart';
import 'package:projectfile/screens/auth/splash_screen.dart';



class AppRoutes {
  static const String splash = '/';
  static const String register = '/register';
  static const String signIn = '/sign-in';
  static const String customerSignup = '/customer-signup';
  static const String providerSignup = '/provider-signup';
  static const String dashboard = '/dashboard';

  static final List<GetPage<dynamic>> pages = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: register, page: () => RegisterScreen()),
    GetPage(name: signIn, page: () => SignInScreen()),
    GetPage(name: customerSignup, page: () => CustomerSignupPage()),
    GetPage(name: providerSignup, page: () => ServiceProviderSignupPage()),
    
    
  ];
}