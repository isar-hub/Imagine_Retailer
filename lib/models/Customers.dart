
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerInfo {
  String name;
  String phone;
  String email;
  String imageUrl;
  String retailerSellingPrice;
  String state;
  String address;
  String signatureUrl;
  Timestamp warrantyStarted;
  // ProductStatus status;
  Timestamp warrantyEnded;

  CustomerInfo({
    required this.name,
    required this.phone,
    required this.email,
    required this.retailerSellingPrice,
    required this.address,
    required this.state,
    required this.signatureUrl,
    required this.imageUrl,
    required this.warrantyEnded,
    required this.warrantyStarted,
    // required this.status,
  });

  // Named constructor for creating from JSON
  factory CustomerInfo.fromJson(Map<String, dynamic> json) {
    return CustomerInfo(
      warrantyEnded: json['warrantyEnded'],
      warrantyStarted: json['warrantyStarted'],
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      imageUrl: json['imageUrl'],
      retailerSellingPrice: json['retailerSellingPrice'] ?? "0.0",
      address: json['address'],
      state: json['state'] ?? '',
      signatureUrl: json['signatureUrl'],
      // status: ProductStatus.fromMap(json['status']),
    );
  }

  // Convert to JSON for API or storage
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'imageUrl': imageUrl,
      'retailerSellingPrice': retailerSellingPrice,
      'address': address,
      'state': state,
      'warrantyStarted': warrantyStarted,
      'warrantyEnded': warrantyEnded,
      'signatureUrl': signatureUrl,
      // 'status':status.toMap(),
    };
  }

  // Named constructor for creating from a Map (optional)
  factory CustomerInfo.fromMap(Map<String, dynamic> map) =>
      CustomerInfo.fromJson(map);

  Map<String, dynamic> toMap() => toJson();
}
