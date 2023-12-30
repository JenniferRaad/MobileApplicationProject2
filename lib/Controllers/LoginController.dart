import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';


class LoginController {
  String? name;
  final int phone;
  final String password;
  EncryptedSharedPreferences encryptedData = EncryptedSharedPreferences();
  LoginController(
      { required this.password, required this.phone});

  Future<int> login() async {
    const phpEndPoint = "https://jennyraad.000webhostapp.com/login.php";

    try {
      final response = await http.post(
        Uri.parse(phpEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'phone': phone,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        // Successful login
        Map<String, dynamic> userData = json.decode(response.body);
        name = userData['name'];
        print(name);
        encryptedData.setString('key', userData['id']);
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return 0;
    }
  }
}
