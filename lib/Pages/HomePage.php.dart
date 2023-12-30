import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:phonecallprice/Controllers/addCallController.dart';
import 'package:phonecallprice/Pages/BillsHistroy.dart';
import 'package:phonecallprice/Pages/CallsHistory.dart';
import 'package:phonecallprice/Pages/Go.dart';

class HomePage extends StatefulWidget {
  final String name;
  const HomePage({Key? key, required this.name}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  EncryptedSharedPreferences encryptedData = EncryptedSharedPreferences();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[900],
        actions: [
          IconButton(
            onPressed: () {
              encryptedData.clear();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (builder) => Go()));
            },
            icon: Icon(Icons.logout),
            color: Colors.white,
          )
        ],
      ),
      backgroundColor: Colors.blue[900],
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Form Container
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _key,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _phoneNumberController,
                          style:
                              const TextStyle(color: Colors.black, fontSize: 16),
                          decoration: const InputDecoration(
                            hintText: 'Phone Number',
                            hintStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                      ), // Spacer
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _durationController,
                          style:
                              const TextStyle(color: Colors.black, fontSize: 16),
                          decoration: const InputDecoration(
                            hintText: 'Duration',
                            hintStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the duration';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: !isLoading
                              ? () async {
                                  if (_key.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    String phoneNumber =
                                        _phoneNumberController.text;
                                    String duration = _durationController.text;

                                    var code = await addCall(
                                        int.parse(phoneNumber),
                                        int.parse(duration));
                                    if (code == 200) {
                                      var code2 =
                                          await updateBill(int.parse(duration));
                                      if (code2 == 200) {
                                        setState(() {
                                          _phoneNumberController.clear();
                                          _durationController.clear();
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: Text(
                                                    'Phone Call Saved Successfully'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // Close the dialog
                                                    },
                                                    child: Text('OK'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        });
                                      }
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                }
                              : () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[900],
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(color: Colors.black),
                          ),
                          child: Text('Add New Call'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Action Buttons Row
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (builder) => History()));
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue[900],
                          padding: EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.history, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'History',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (builder) => BillsHistory()));
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue[900],
                          padding: EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.money, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Money',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
