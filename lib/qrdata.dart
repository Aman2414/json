import 'dart:convert';

QR QRFromJson(String str) => QR.fromJson(jsonDecode(str));
String QRToJson(QR qr) => json.encode(qr.toJson());

class QR {
  String? title;
  String? amount;
  String? merchant;
  String? date;

  QR({
    this.title,
    this.amount,
    this.merchant,
    this.date,
  });

  factory QR.fromJson(Map<String, dynamic> json) {
    return QR(
      title: json['title'],
      amount: json['amount'],
      merchant: json['merchant'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "amount": amount,
      "merchant": merchant,
      "date": date,
    };
  }
}
