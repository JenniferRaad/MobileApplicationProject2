import 'dart:convert';

import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BillsHistory extends StatefulWidget {
  const BillsHistory({super.key});

  @override
  State<BillsHistory> createState() => _BillsHistoryState();
}

class _BillsHistoryState extends State<BillsHistory> {
  List<Map<String, dynamic>> bills = [];
  EncryptedSharedPreferences encryptedData = EncryptedSharedPreferences();
  Future<void> getHistory() async {
    const phpEndPoint = "https://jennyraad.000webhostapp.com/getBills.php";
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
      print(response.body);
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> history =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        setState(() {
          bills = history;
        });
        print(bills);
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
          title: Text('Monthly Bills', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.blue[900],
        ),
        backgroundColor: Colors.blue[900],
        body: ListView.builder(
            itemCount: bills.length,
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
                              'Phone Calls Count:${bills[index]['Count']} Calls',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Total Duration: ${bills[index]['TotalDuration']} min',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Total Price: ${bills[index]['totalPrice']}\$',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Month: ${DateTime.parse(bills[index]['date']).month}-${DateTime.parse(bills[index]['date']).year}',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.money_off,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }));
  }
}
