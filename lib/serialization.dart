import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Serialize {
  static var key = 'qrdata';
  static List<dynamic> jsonMap = [];
  static Map<String, dynamic> jsonNewData = {};
  static String storagedata = '';
  static String newstoragedata = '';
  static List<dynamic> jsonData = [
    {"title": "res1", "amount": "350", "merchant": "UPI", "date": "jan 5 2022"},
    {"title": "res2", "amount": "350", "merchant": "UPI", "date": "jan 5 2022"},
    {"title": "res3", "amount": "350", "merchant": "UPI", "date": "jan 5 2022"},
    {"title": "res4", "amount": "350", "merchant": "UPI", "date": "jan 5 2022"},
    {"title": "res5", "amount": "350", "merchant": "UPI", "date": "jan 5 2022"},
  ];

  storeData(dynamic newdata) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Storing data called");
    if (newdata != []) {
      print("Getting data from storage");
      storagedata = prefs.getString(key) ?? "";
      print("\$storagedata var value: $storagedata");
      if (storagedata == "" || jsonMap.isEmpty) {
        print("Current storage is empty so storing newdata directly");
        print("Storing the data : $newdata in storage");
        jsonMap = newdata;
        print("Value of jsonMap : $jsonMap");
        prefs.setString(key, jsonEncode(newdata));
        print("Data stored successfully");
      } else {
        print(
            "Storage data is not empty so fetching data , appending new data and storing it in system storage");
        jsonMap = jsonDecode(storagedata);
        print("jsonNewData value: $newdata");
        print("jsonMap before adding $jsonMap");
        jsonMap.add(newdata);
        print("jsonMap after adding$jsonMap");
        print("New data added");
        newstoragedata = jsonEncode(jsonMap);
        print("New storage data $newstoragedata");
        prefs.setString(key, newstoragedata);
      }
    } else {
      print(
          "New Data that is passed to function is Empty so it can't be stored");
    }
  }
}
