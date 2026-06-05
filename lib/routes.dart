// App routes

import 'package:projectfile/screens/admin/addservices.dart';
import 'package:projectfile/screens/admin/admindashboard.dart';
import 'package:projectfile/screens/admin/adminnotification.dart';
import 'package:projectfile/screens/admin/adminprofile.dart';
import 'package:projectfile/screens/admin/allusers.dart';
import 'package:projectfile/screens/admin/provider_verificationscreen.dart';
import 'package:projectfile/screens/admin/userdetail.dart';
import 'package:projectfile/screens/auth/splashscreen.dart';
import 'package:projectfile/screens/auth/homepageview.dart';
import 'package:get/get.dart';
import 'package:projectfile/screens/auth/login_screen.dart';
import 'package:projectfile/screens/auth/register_screen.dart';
import 'package:projectfile/screens/customer/customer_home_screen.dart';
import 'package:projectfile/screens/admin/verify_page.dart';
import 'package:projectfile/screens/provider/provider_home_screen.dart';
import 'package:projectfile/screens/auth/customerpagereg.dart';
import 'package:projectfile/screens/auth/providerpagereg.dart';
import 'package:projectfile/screens/admin/admindrawer.dart';
import 'package:projectfile/screens/admin/CNIC__view.dart';
import 'package:projectfile/screens/admin/acceptance.dart';
import 'package:projectfile/screens/admin/blockorunblock.dart';
import 'package:projectfile/screens/admin/complainhandling.dart';
import 'package:projectfile/screens/admin/complaindetail.dart';
import 'package:projectfile/screens/admin/complainresolution.dart';
import 'package:projectfile/screens/admin/serviesmanagement.dart';

class AppRoutes {
  static const String splash = '/';
  static const String homepageview = '/homepageview';
  static const String loginScreen = '/login_screen';
  static const String registerScreen = '/register_screen';
  static const String adminDashboard = '/admin_dashboard';
  static const String addserviceScreen = '/addservice_screen';
  static const String adminprofile = '/adminprofile';
  static const String adminnotification = '/adminnotification';
  static const String customerHomeScreen = '/customer_home_screen';
  static const String providerHomeScreen = '/provider_home_screen';
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

  static final List<GetPage<dynamic>> pages = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: homepageview, page: () => HomePage()),
    GetPage(name: loginScreen, page: () => LoginScreen()),
    GetPage(name: registerScreen, page: () => RegisterScreen()),
    GetPage(name: adminDashboard, page: () => AdminDashboard()),
    GetPage(name: adminprofile, page: () => AdminProfile()),
    GetPage(name: adminnotification, page: () => AdminNotification()),
    GetPage(name: addserviceScreen, page: () => Addservices()),
    GetPage(name: verifyPage, page: () => VerifyPage()),
    GetPage(name: customerHomeScreen, page: () => CustomerHomeScreen()),
    GetPage(name: providerHomeScreen, page: () => ProviderHomeScreen()),
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
    GetPage(name: servicemanagement, page: () => Serviesmanagement()),

    GetPage(
      name: providerverficationpage,
      page: () => ProviderVerificationPage(),
    ),
  ];
}

