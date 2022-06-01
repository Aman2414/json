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

  void store_qr_data() {
    print("Store qr data was called");
    if (QrScan.res != null) {
      print("QrScan res is not empty");
      print("Value of QrScan.res: ${QrScan.res?.code}");
      String? result = QrScan.res!.code;
      print("result value: $result");
      print("result type ${result.runtimeType}");
      jsonQrData = jsonDecode(result!);
      print("jsonQrData value: $jsonQrData");
      print("jsonQrData type: ${jsonQrData.runtimeType}");
      setState(() {
        storedata(jsonQrData);
      });
    } else {
      print("QrScan res is empty");
      print("Value of QrScan.res: ${QrScan.res}");
    }
  }

  void storedata(Map<String, dynamic> data) async {
    print("Store data called");
    print("Getting data from storage");
    Serialize.storagedata = prefs.getString(Serialize.key) ?? "";
    print("\$storagedata var value: ${Serialize.storagedata}");
    if (Serialize.storagedata == "") {
      print("Current storage is empty so storing scanned data directly");
      print("Storing the data : $Serialize.newdata in storage");
      Serialize.jsonMap.add(data);
      print("Value of jsonMap : ${Serialize.jsonMap}");
      prefs.setString(Serialize.key, jsonEncode(data));
      print("Data stored successfully");
    } else {
      print(
          "Storage data is not empty so fetching data , appending new data and storing it in system storage");
      Serialize.jsonMap = jsonDecode(Serialize.storagedata);
      print("jsonNewData value: $data");
      print("jsonMap before adding ${Serialize.jsonMap}");
      Serialize.jsonMap.add(data);
      print("jsonMap after adding${Serialize.jsonMap}");
      print("New data added");
      Serialize.newstoragedata = jsonEncode(Serialize.jsonMap);
      print("New storage data ${Serialize.newstoragedata}");
      prefs.setString(Serialize.key, Serialize.newstoragedata);
    }
  }

  void sharedpref_init() async {
    prefs = await SharedPreferences.getInstance();
    Serialize.storagedata = prefs.getString(Serialize.key) ?? "";
    print("Value of storagedata: ${Serialize.storagedata}");
    if (Serialize.storagedata != "") {
      setState(() {
        print("Storage data is not empty");
        // Serialize.jsonMap = jsonDecode(Serialize.storagedata);
        Serialize.jsonMap.add(jsonDecode(Serialize.storagedata));
      });
    } else {
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
    return Material(
      child: SafeArea(
        child: Scaffold(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      print(
                                          "jsonMap after removing index :$index");
                                      print("jsonMap ${Serialize.jsonMap}");
                                      Serialize.storagedata = "";
                                      Serialize.jsonMap.removeAt(index);
                                      SharedPreferences pref =
                                          await SharedPreferences.getInstance();
                                      pref.setString(Serialize.key, "");

                                      setState(() {
                                        Serialize()
                                            .storeData(Serialize.jsonMap);
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
                          margin: EdgeInsets.only(top: 300),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(
                                height: 15,
                              ),
                              Text("Loading..."),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
