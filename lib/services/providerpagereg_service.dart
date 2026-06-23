import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ProviderService {
  static const String baseUrl = "http://localhost:3000/api/auth";

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
        Uri.parse("$baseUrl/register/provider"),
      );

      data.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
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
      final response = await http.Response.fromStream(streamed);

      print('PROVIDER REGISTER STATUS: ${response.statusCode}');
      print('PROVIDER REGISTER BODY: ${response.body}');

      final result = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return result;
      }

      return {
        "success": false,
        "message": result['message'] ?? 'Provider registration failed',
      };
    } catch (e) {
      print('PROVIDER REGISTER ERROR: $e');
      return {"success": false, "message": e.toString()};
    }
  }
}