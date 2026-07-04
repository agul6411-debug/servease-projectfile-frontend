// App routes

import 'package:frontfile_servease/features/admin/screens/admin_commission_screen.dart';
import 'package:frontfile_servease/features/admin/screens/adminbookingscreen.dart';
import 'package:frontfile_servease/features/admin/screens/servicemanagement.dart';
import 'package:frontfile_servease/features/admin/screens/admindashboard.dart';
import 'package:frontfile_servease/features/admin/screens/adminnotification.dart';
import 'package:frontfile_servease/features/admin/screens/adminprofile.dart';
import 'package:frontfile_servease/features/admin/screens/allusers.dart';
import 'package:frontfile_servease/features/admin/screens/provider_verificationscreen.dart';
import 'package:frontfile_servease/features/admin/screens/userdetail.dart';
import 'package:frontfile_servease/features/auth/screens/splashscreen.dart';
import 'package:frontfile_servease/features/auth/screens/forgot_password_screen.dart';
import 'package:frontfile_servease/features/admin/screens/admin_service_requests_screen.dart';
import 'package:frontfile_servease/features/auth/screens/reset_password_screen.dart';
import 'package:frontfile_servease/features/auth/screens/otp_verify_screen.dart';
import 'package:frontfile_servease/features/auth/screens/homepageview.dart';
import 'package:get/get.dart';
import 'package:frontfile_servease/features/auth/screens/login_screen.dart';
import 'package:frontfile_servease/features/auth/screens/register_screen.dart';
import 'package:frontfile_servease/features/customer/screens/customerscreen.dart';
import 'package:frontfile_servease/features/auth/screens/customerpagereg.dart';
import 'package:frontfile_servease/features/auth/screens/providerpagereg.dart';
import 'package:frontfile_servease/features/admin/screens/admindrawer.dart';
import 'package:frontfile_servease/features/admin/screens/acceptance.dart';
import 'package:frontfile_servease/features/admin/screens/admin_navbar.dart';
import 'package:frontfile_servease/features/admin/screens/adminsettings.dart';
import 'package:frontfile_servease/features/admin/screens/blockorunblock.dart';
import 'package:frontfile_servease/features/admin/screens/admin_complaints.dart';
import 'package:frontfile_servease/features/provider/screens/provider_home_screen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:frontfile_servease/features/admin/screens/admin_security_deposits_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String homepageview = '/homepageview';
  static const String loginScreen = '/login_screen';
  static const String registerScreen = '/register_screen';
  static const String adminDashboard = '/admin_dashboard';
  static const String adminNavbar = '/admin_navbar';
  static const String adminsettings = '/adminsettings';
  static const String addserviceScreen = '/addservice_screen';
  static const String adminprofile = '/adminprofile';
  static const String adminnotification = '/adminnotification';
  static const String customerHomeScreen = '/customer_home_screen';
  static const String customerPage = '/customer_page';
  static const String providerPagereg = '/providerPagereg';
  static const String verifyPage = '/verify';
  static const String providerverficationpage = '/provider_verficationscreen';
  static const String admindrawer = '/admindrawer';
  static const String acceptance = '/acceptance';
  static const String allusers = '/allusers';
  static const String userdetail = '/userdetail';
  static const String blockorunblock = '/blockorunblock';
  static const String complainhandling = '/complainhandling';
  static const String complaindetail = '/complaindetail';
  static const String complainresolution = '/complainresolution';
  static const String servicemanagement = '/servicemanagement';
  static const String providerHomeScreen = '/provider_home_screen';
  static const String adminCommissions = '/admin_commissions';
  static const String adminBookings = '/admin_bookings';
  static const String adminSecurityDeposits = '/admin_security_deposits';
  static const String forgotPassword = '/forgot_password';
  static const String adminServiceRequests = '/admin_service_requests';
  static const String resetPassword = '/reset_password';
  static final List<GetPage<dynamic>> pages = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: homepageview, page: () => HomePage()),
    GetPage(name: loginScreen, page: () => LoginScreen()),
    GetPage(name: registerScreen, page: () => RegisterScreen()),
    GetPage(name: adminDashboard, page: () => AdminDashboard()),
    GetPage(name: adminprofile, page: () => AdminProfile()),
    GetPage(name: adminnotification, page: () => AdminNotification()),
    GetPage(name: adminNavbar, page: () => const AdminNavBarPage()),
    GetPage(name: adminsettings, page: () => const AdminSettingsPage()),
    GetPage(name: customerHomeScreen, page: () => CustomerHomeScreen()),
    GetPage(name: customerPage, page: () => CustomerPagereg()),
    GetPage(name: providerPagereg, page: () => ProviderPagereg()),
    GetPage(name: admindrawer, page: () => AdminDrawer()),

    GetPage(name: acceptance, page: () => Acceptance()),
    GetPage(name: allusers, page: () => AllUsers()),
    GetPage(name: userdetail, page: () => UserDetail()),
    GetPage(name: blockorunblock, page: () => BlockOrUnblock()),
    GetPage(name: complainhandling, page: () => AdminComplaintsScreen()),
    GetPage(name: servicemanagement, page: () => Servicemanagement()),
    GetPage(
      name: adminSecurityDeposits,
      page: () => const AdminSecurityDepositsScreen(),
    ),
    GetPage(
      name: providerHomeScreen,
      page: () {
        final box = GetStorage();
        final userId = (box.read('user_id') ?? 0) is int
            ? box.read('user_id') as int
            : int.tryParse(box.read('user_id').toString()) ?? 0;
        return ProviderHomeScreen(providerId: userId);
      },
    ),
    GetPage(
      name: providerverficationpage,
      page: () => ProviderVerificationPage(),
    ),
    GetPage(name: adminCommissions, page: () => const AdminCommissionScreen()),
    GetPage(name: adminBookings, page: () => const AdminBookingsScreen()),
    GetPage(name: forgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(
      name: adminServiceRequests,
      page: () => const AdminServiceRequestsScreen(),
    ),
    GetPage(
      name: resetPassword,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        final token = args?['token'] ?? '';
        return ResetPasswordScreen(token: token);
      },
    ),
  ];
}

