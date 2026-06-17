import 'package:frontfile_servease/services/app_config.dart';
import 'dart:convert';

import 'package:frontfile_servease/models/admin_drawer_model.dart';
import 'package:http/http.dart' as http;

class AdminDrawerService {
  String get baseUrl => "${AppConfig.baseUrl}/api/admin/dashboard";

  Future<AdminDrawerModel?> getDrawerData() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return AdminDrawerModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print(e);

      return null;
    }
  }
}
