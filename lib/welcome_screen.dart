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
  late SharedPreferences prefs;
  static Map<String, dynamic> jsonQrData = {};
  String check = '';

  void store_qr_data() {
    print("Store qr data was called");
    if (QrScan.res != null) {
      print("QrScan res is not empty");
      print("Value of QrScan.res: ${QrScan.res}");
      String? result = QrScan.res!.code;
      jsonQrData = jsonDecode(result!);
      Serialize().storeData(jsonQrData);
      check = "Qr data was not empty and is stored succesfully";
    } else {
      print("QrScan res is empty");
      print("Value of QrScan.res: ${QrScan.res}");
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
