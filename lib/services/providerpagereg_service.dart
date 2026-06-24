import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ProviderService {
  static const String baseUrl = "http://localhost:3000";

  // REGISTER PROVIDER — Web (Uint8List)
  Future<Map<String, dynamic>> registerProviderWeb(
    Map<String, dynamic> data, {
    required Uint8List cnicFrontBytes,
    required String cnicFrontName,
    required Uint8List cnicBackBytes,
    required String cnicBackName,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/api/auth/register/provider"),
      );

      data.forEach((key, value) {
        if (value != null) request.fields[key] = value.toString();
      });

      request.files.add(
        http.MultipartFile.fromBytes(
          'cnic_front',
          cnicFrontBytes,
          filename: cnicFrontName,
        ),
      );
      request.files.add(
        http.MultipartFile.fromBytes(
          'cnic_back',
          cnicBackBytes,
          filename: cnicBackName,
        ),
      );

      final streamed = await request.send();
      final res = await http.Response.fromStream(streamed);
      return jsonDecode(res.body);
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }
}
