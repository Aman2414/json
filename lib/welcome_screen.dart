import 'dart:convert';

import 'package:flutter/material.dart';
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

  void sharedpref_init() async {
    prefs = await SharedPreferences.getInstance();
    Serialize.storagedata = prefs.getString(Serialize.key) ?? "";
    print("Value of storagedata: ${Serialize.storagedata}");
    if (Serialize.storagedata != "") {
      setState(() {
        print("Storage data is not empty so fetching data");
        Serialize.jsonMap = jsonDecode(Serialize.storagedata);
      });
    } else {
      //storing sample data right now
      if (Serialize.jsonData.isNotEmpty) {
        setState(() {
          Serialize().storeData(Serialize.jsonData);
        });
      }
    }
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
                          onPressed: () {
                            setState(() {
                              Serialize.jsonMap.removeAt(index);
                              // for (var i = 0;
                              //     i < Serialize.jsonMap.length;
                              //     i++) {
                              //   if (Serialize.jsonMap[i]['title'] !=) {
                              //   } else {}
                              // }
                            });
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              )
                  : Text("No Data"),
            ),
          ],
        ),
      ),
    );
  }
}
