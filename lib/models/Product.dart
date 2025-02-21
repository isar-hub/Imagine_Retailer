import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String brand;
  String condition;
  DateTime createdAt;
  String imei_1;
  String imei_2;
  String model;
  String variant;
  String mrp;
  String retailerPrice;
  String serialNumber;
  String retailerOrDistributorId;
  String transactionId;
  DateTime? warrantyStarted;
  DateTime? warrantyEnded;
  String status;

  Product({
    required this.brand,
    required this.condition,
    required this.model,
    required this.variant,
    required this.retailerPrice,
    required this.serialNumber,
    required this.retailerOrDistributorId,
    required this.transactionId,
    required this.imei_1,
    required this.imei_2,
    required this.createdAt,
    required this.mrp,
    this.warrantyStarted,
    this.warrantyEnded,
    required this.status,
  });

  // Named constructor for creating from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      brand: json['brand'] ?? 'Unknown Brand',
      condition: json['condition'] ?? 'Unknown Condition',
      model: json['model'] ?? 'Unknown Model',
      variant: json['variant'] ?? 'Unknown Variant',
      retailerPrice: json['retailerPrice'] ?? '0',
      serialNumber: json['serialNumber'] ?? 'Unknown Serial',
      retailerOrDistributorId: json['retailerOrDistributorId'] ?? 'Unknown',
      transactionId: json['transactionId'] ?? 'Unknown',
      imei_1: json['imei_1'] ?? 'Unknown IMEI1',
      imei_2: json['imei_2'] ?? 'Unknown IMEI2',
      createdAt: (json['warrantyStarted'] as Timestamp?)?.toDate() ??
          DateTime(0), // ✅ Correct field and safe null check
      warrantyStarted: (json['warrantyStarted'] as Timestamp?)
          ?.toDate(), // ✅ Null-safe conversion
      warrantyEnded: (json['warrantyEnded'] as Timestamp?)?.toDate(), //
      status: json['status'],
      mrp: json['mrp'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'condition': condition,
      'model': model,
      'variant': variant,
      'retailerPrice': retailerPrice,
      'serialNumber': serialNumber,
      'retailerOrDistributorId': retailerOrDistributorId,
      'transactionId': transactionId,
      'imei_1': imei_1,
      'imei_2': imei_2,
      'createdAt': createdAt,
      'warrantyStarted': warrantyStarted,
      'warrantyEnded': warrantyEnded,
      'status': status,
    };
  }
}

// ProductStatus class to parse the status map
class ProductStatus {
  Timestamp? billed;
  Timestamp? inventory;
  Timestamp? warranty;
  Timestamp? sold;

  ProductStatus({this.billed, this.inventory, this.warranty, this.sold});

  factory ProductStatus.fromMap(Map<String, dynamic> map) {
    return ProductStatus(
        billed: parseTimestamp(map['BILLED']),
        inventory: parseTimestamp(map['INVENTORY']),
        warranty: parseTimestamp(map['WARRANTY']),
        sold: parseTimestamp(map['SOLD']));
  }

  Map<String, dynamic> toMap() {
    return {
      'BILLED': billed,
      'INVENTORY': inventory,
      'WARRANTY': billed,
      'SOLD': sold,
    };
  }
}

Timestamp parseTimestamp(dynamic value) {
  if (value is Timestamp) {
    return value;
  } else if (value is String) {
    return Timestamp.fromDate(DateTime.parse(value));
  } else {
    throw Exception("Invalid type for Timestamp field");
  }
}
