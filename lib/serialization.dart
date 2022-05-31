import 'dart:convert';

import 'package:json/datafile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Serialize {
  var key = 'qrdata';
  List<Map<String, dynamic>> jsonData = [
    {"title": "res", "amount": "350", "merchant": "UPI", "date": "jan 5 2022"},
    {"title": "abx", "amount": "350", "merchant": "paytm", "date": "jan 9 2022"},
    {"title": "xyc", "amount": "350", "merchant": "phonepe", "date": "Feb 10 2022"},
    {"title": "hello", "amount": "450", "merchant": "Google Pay", "date": "March 5 2022"},
  ];

  Map<String, dynamic> jsonNewData = {
    "title": "new res",
    "amount": "500",
    "merchant": "paytm",
    "date": "march 10 2022",
  };

  Serialize() {
    storeData(jsonData);
    getData();
    addnewdata();
  }

  getData() async {
    print("Getting data");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Data.storagedata = prefs.getString(key)!;
  }

  addnewdata(){
    print("adding new data");
    Data.jsonMap = jsonDecode(Data.storagedata);
    Data.jsonMap.add(jsonNewData);
    storeData(jsonEncode(Data.jsonMap));
  }

  storeData(Object ob) async {
    print("Storing data");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(ob));
  }
}
