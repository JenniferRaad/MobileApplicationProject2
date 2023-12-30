import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
EncryptedSharedPreferences encryptedData = EncryptedSharedPreferences();

Future<int> addCall(int phone,int duration) async {
    const phpEndPoint = "https://jennyraad.000webhostapp.com/addCall.php";
    String myKey = await encryptedData.getString('key');
    try {
      final response = await http.post(
        Uri.parse(phpEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'id':myKey,
          'phone': phone,
          'duration': duration,
          'date':DateTime.now().toString()
        }),
      );

      if (response.statusCode == 200) {
        
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return 0;
    }
  }

  Future<int> updateBill(int duration) async {
    const phpEndPoint = "https://jennyraad.000webhostapp.com/updateTotalBill.php";
    String myKey = await encryptedData.getString('key');
    try {
      final response = await http.post(
        Uri.parse(phpEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'id':myKey,
          'duration': duration,
          'date':DateTime.now().toString()
        }),
      );

      if (response.statusCode == 200) {

      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return 0;
    }
  }