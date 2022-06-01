import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScan extends StatefulWidget {
  static Barcode? res;

  const QrScan({Key? key}) : super(key: key);

  @override
  State<QrScan> createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  static Barcode? barcode;
  QRViewController? controller;

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            buildQrView(context),
            Positioned(
                bottom: 10,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                  ),
                  child: Column(
                    children: [
                      Text(
                        barcode != null
                            ? "Result : ${barcode!.code}"
                            : "Scan a code",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "",
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.cyanAccent,
          borderWidth: 10,
          borderLength: 20,
          borderRadius: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      );

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    // setState(() => this.controller = controller);
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        barcode = scanData;
        QrScan.res = scanData;
      });
    });
    //
    // setState(() {
    //   store_qr_data();
    // });
  }
}
