import 'dart:convert';

import 'package:http/http.dart' as http;

class RegisterController {
  final String name;
  final int phone;
  final String password;

  RegisterController(
      {required this.name, required this.password, required this.phone});

  Future<int> register() async {
    const phpEndPoint = "https://jennyraad.000webhostapp.com/register.php";

    try {
      final response = await http.post(
        Uri.parse(phpEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'name': name,
          'password': password,
          'phone': phone,
        }),
      );
      print(response.body);
      return response.statusCode;
    } catch (error) {
      print(error);
      return 0;
    }
  }
}
