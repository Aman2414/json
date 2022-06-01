import 'package:flutter/material.dart';
import 'package:json/data_input.dart';
import 'package:json/qr_scan_page.dart';
import 'package:json/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int pageIndex = 0;

  final pages = [
    const WelcomeScreen(),
    const QrScan(),
    const DataEntry(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: pages[pageIndex],
        bottomNavigationBar: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    pageIndex = 0;
                  });
                },
                icon: pageIndex == 0
                    ? Icon(
                        Icons.home_filled,
                        color: Colors.white,
                        size: 35,
                      )
                    : Icon(
                        Icons.home_outlined,
                        color: Colors.black,
                        size: 35,
                      ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    pageIndex = 1;
                  });
                },
                icon: pageIndex == 1
                    ? Icon(
                        Icons.qr_code_scanner_rounded,
                        color: Colors.white,
                        size: 35,
                      )
                    : Icon(
                        Icons.qr_code_scanner_rounded,
                        color: Colors.black,
                        size: 35,
                      ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    pageIndex = 2;
                  });
                },
                icon: pageIndex == 2
                    ? Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 35,
                      )
                    : Icon(
                        Icons.settings,
                        color: Colors.black,
                        size: 35,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
