import 'package:flutter/material.dart';
import 'package:json/datafile.dart';
import 'package:json/serialization.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    print("Calling serialize");
    Serialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Data.jsonMap != [{}]
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: Data.jsonMap.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            Data.jsonMap[index]['date'],
                          ),
                          Text(
                            Data.jsonMap[index]['title'],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            Data.jsonMap[index]['amount'],
                          ),
                          Text(
                            Data.jsonMap[index]['merchant'],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              })
          : Text("NO DATA"),
    );
  }
}
