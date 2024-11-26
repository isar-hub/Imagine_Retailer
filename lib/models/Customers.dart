import 'package:imagine_retailer/models/Product.dart';

class CustomerInfo {
  String name;
  String phone;
  String email;
  String imageUrl;
  String sellingPrice;
  String state;
  String address;
  String signatureUrl;
  String warrantyStarted;
  ProductStatus status;
  String warrantyEnded;

  CustomerInfo({
    required this.name,
    required this.phone,
    required this.email,
    required this.sellingPrice,
    required this.address,
    required this.state,
    required this.signatureUrl,
    required this.imageUrl,
    required this.warrantyEnded,
    required this.warrantyStarted,
    required this.status,
  });

  // Named constructor for creating from JSON
  factory CustomerInfo.fromJson(Map<String, dynamic> json) {
    return CustomerInfo(
      warrantyEnded: json['warrantyEnded'],
      warrantyStarted: json['warrantyStarted'],
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      sellingPrice: json['sellingPrice'] ?? '',
      address: json['address'],
      state: json['state'] ?? '',
      signatureUrl: json['signatureUrl'] ?? '',
      status: json['status'] ?? '',
    );
  }

  // Convert to JSON for API or storage
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'imageUrl': imageUrl,
      'sellingPrice': sellingPrice,
      'address': address,
      'state': state,
      'warrantyStarted': warrantyStarted,
      'warrantyEnded': warrantyEnded,
      'signatureUrl': signatureUrl,
    };
  }

  // Named constructor for creating from a Map (optional)
  factory CustomerInfo.fromMap(Map<String, dynamic> map) =>
      CustomerInfo.fromJson(map);

  Map<String, dynamic> toMap() => toJson();
}