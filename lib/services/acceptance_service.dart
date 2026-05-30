import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/acceptance_model.dart';

class AcceptanceService {
  static const String baseUrl = "http://localhost:3000/api/provider";

  Future<List<AcceptanceModel>> getAcceptanceList() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/acceptance-list"));

      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List list = data['data'];

        return list.map((e) => AcceptanceModel.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      print(e);

      return [];
    }
  }
}
