import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json/qr_scan_page.dart';
import 'package:json/serialization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<WelcomeScreen> {
  TextEditingController date = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController merchant = TextEditingController();
  late SharedPreferences prefs;
  static Map<String, dynamic> jsonQrData = {};
  String check = '';

  void store_qr_data() {
    if (QrScan.res != null) {
      String? result = QrScan.res!.code;
      jsonQrData = jsonDecode(result!);
      Serialize().storeData(jsonQrData);
      check = "Qr data was not empty and is stored succesfully";
    } else {
      check = "Qr data was empty";
    }
  }

  void sharedpref_init() async {
    prefs = await SharedPreferences.getInstance();
    Serialize.storagedata = prefs.getString(Serialize.key) ?? "";
    print("Value of storagedata: ${Serialize.storagedata}");
    if (Serialize.storagedata != "") {
      setState(() {
        print("Storage data is not empty");
        Serialize.jsonMap = jsonDecode(Serialize.storagedata);
      });
    } else {
      //storing sample data right now
      print("Storage data is empty");
      if (Serialize.jsonData.isNotEmpty) {
        setState(() {
          Serialize().storeData(Serialize.jsonData);
        });
      } else {
        print("jsonData to be stored is empty");
      }
    }
    store_qr_data();
  }

  @override
  void initState() {
    super.initState();
    sharedpref_init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Column(
                children: [
                  TextField(
                    controller: date,
                    decoration: InputDecoration(
                      hintText: "Enter Date",
                    ),
                  ),
                  TextField(
                    controller: title,
                    decoration: InputDecoration(
                      hintText: "Enter Title",
                    ),
                  ),
                  TextField(
                    controller: amount,
                    decoration: InputDecoration(
                      hintText: "Enter Amount",
                    ),
                  ),
                  TextField(
                    controller: merchant,
                    decoration: InputDecoration(
                      hintText: "Enter Merchant",
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (date.text.isNotEmpty &&
                          title.text.isNotEmpty &&
                          amount.text.isNotEmpty &&
                          merchant.text.isNotEmpty) {
                        Serialize.jsonNewData = {
                          "title": title.text,
                          "amount": amount.text,
                          "merchant": merchant.text,
                          "date": date.text,
                        };

                        setState(() {
                          var isPresent = false;
                          for (var i = 0; i < Serialize.jsonMap.length; i++) {
                            if (Serialize.jsonMap[i]['title'] !=
                                Serialize.jsonNewData['title']) {
                              print("Data is not same so adding it in storage");
                            } else {
                              isPresent = true;
                              print(
                                  "jsonMap already contains the new data that is given");
                            }
                          }

                          if (!isPresent) {
                            Serialize().storeData(Serialize.jsonNewData);
                          }
                        });
                      }
                    },
                    child: Text("Submit"),
                  ),
                  Text(
                    check,
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              child: Serialize.jsonMap.isNotEmpty
                  ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: Serialize.jsonMap.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Serialize.jsonMap[index]['date'],
                                  ),
                                  Text(
                                    Serialize.jsonMap[index]['title'],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Serialize.jsonMap[index]['amount'],
                                  ),
                                  Text(
                                    Serialize.jsonMap[index]['merchant'],
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () async {
                                  print("jsonMap after removing index :$index");
                                  print("jsonMap ${Serialize.jsonMap}");
                                  Serialize.storagedata = "";
                                  Serialize.jsonMap.removeAt(index);
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  pref.setString(Serialize.key, "");

                                  setState(() {
                                    Serialize().storeData(Serialize.jsonMap);
                                  });
                                  print("jsonMap ${Serialize.jsonMap}");
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Container(
                      height: 100,
                      width: 10,
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
