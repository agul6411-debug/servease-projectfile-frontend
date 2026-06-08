// App routes

import 'package:frontfile_servease/screens/admin/admin_commission_screen.dart';
import 'package:frontfile_servease/screens/admin/adminbookingscreen.dart';
import 'package:frontfile_servease/screens/admin/servicemanagement.dart';
import 'package:frontfile_servease/screens/admin/admindashboard.dart';
import 'package:frontfile_servease/screens/admin/adminnotification.dart';
import 'package:frontfile_servease/screens/admin/adminprofile.dart';
import 'package:frontfile_servease/screens/admin/allusers.dart';
import 'package:frontfile_servease/screens/admin/provider_verificationscreen.dart';
import 'package:frontfile_servease/screens/admin/userdetail.dart';
import 'package:frontfile_servease/screens/auth/splashscreen.dart';
import 'package:frontfile_servease/screens/auth/homepageview.dart';
import 'package:get/get.dart';
import 'package:frontfile_servease/screens/auth/login_screen.dart';
import 'package:frontfile_servease/screens/auth/register_screen.dart';
import 'package:frontfile_servease/screens/customer/customer_home_screen.dart';
import 'package:frontfile_servease/screens/auth/customerpagereg.dart';
import 'package:frontfile_servease/screens/auth/providerpagereg.dart';
import 'package:frontfile_servease/screens/admin/admindrawer.dart';
import 'package:frontfile_servease/screens/admin/CNIC__view.dart';
import 'package:frontfile_servease/screens/admin/acceptance.dart';
import 'package:frontfile_servease/screens/admin/admin_navbar.dart';
import 'package:frontfile_servease/screens/admin/adminsettings.dart';
import 'package:frontfile_servease/screens/admin/blockorunblock.dart';
import 'package:frontfile_servease/screens/admin/complainhandling.dart';
import 'package:frontfile_servease/screens/admin/complaindetail.dart';
import 'package:frontfile_servease/screens/admin/complainresolution.dart';
import 'package:frontfile_servease/screens/provider/provider_home_screen.dart';
import 'package:get_storage/get_storage.dart';

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
  static const String cnicview = '/CNICview';
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
    GetPage(name: cnicview, page: () => CNICview()),
    GetPage(name: acceptance, page: () => Acceptance()),
    GetPage(name: allusers, page: () => AllUsers()),
    GetPage(name: userdetail, page: () => UserDetail()),
    GetPage(name: blockorunblock, page: () => BlockOrUnblock()),
    GetPage(name: complainhandling, page: () => Complainhandling()),
    GetPage(name: complaindetail, page: () => Complaindetail()),
    GetPage(name: complainresolution, page: () => Complainresolution()),
    GetPage(name: servicemanagement, page: () => Servicemanagement()),
    GetPage(
      name: providerHomeScreen,
      page: () {
        final box = GetStorage();
        final userId = box.read('user_id') ?? 0;
        return ProviderHomeScreen(providerId: userId);
      },
    ),
    GetPage(
      name: providerverficationpage,
      page: () => ProviderVerificationPage(),
    ),
    GetPage(name: adminCommissions, page: () => const AdminCommissionScreen()),
    GetPage(name: adminBookings, page: () => const AdminBookingsScreen()),
  ];
}
