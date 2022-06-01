import 'package:flutter/material.dart';
import 'package:json/serialization.dart';

class DataEntry extends StatefulWidget {
  const DataEntry({Key? key}) : super(key: key);

  @override
  State<DataEntry> createState() => _DataEntryState();
}

class _DataEntryState extends State<DataEntry> {
  TextEditingController date = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController merchant = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                SizedBox(
                  height: 20,
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
        ),
      ),
    );
  }
}
