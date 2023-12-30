import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<Map<String, dynamic>> calls = [];
  EncryptedSharedPreferences encryptedData = EncryptedSharedPreferences();

  Future<void> getHistory() async {
    const phpEndPoint = "https://jennyraad.000webhostapp.com/getHistory.php";
    String myKey = await encryptedData.getString('key');

    try {
      final response = await http.post(
        Uri.parse(phpEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'id': myKey,
        }),
      );
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> history =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        setState(() {
          calls = history;
        });
        print(calls);
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    getHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
          ),
        title: Text('History', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      backgroundColor: Colors.blue[900],
      body: ListView.builder(
        itemCount: calls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Phone Number: ${calls[index]['receiverNumber']}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16, // Adjust the font size as needed
                            fontWeight: FontWeight
                                .bold, // Adjust the font weight as needed
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Duration: ${calls[index]['duration']} min',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16, // Adjust the font size as needed
                            fontWeight: FontWeight
                                .bold, // Adjust the font weight as needed
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Date: ${calls[index]['date']}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16, // Adjust the font size as needed
                            fontWeight: FontWeight
                                .bold, // Adjust the font weight as needed
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.phone,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
