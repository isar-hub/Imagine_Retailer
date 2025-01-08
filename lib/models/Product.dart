
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String brand;
  String condition;
  Timestamp createdAt;
  String imei_1;
  String imei_2;
  String model;
  String variant;
  String sellingPrice;
  String serialNumber;
  String retailerOrDistributorId;
  String transactionId;
  Timestamp warrantyStarted;
  Timestamp warrantyEnded;
  ProductStatus status;

  Product({
    required this.brand,
    required this.condition,
    required this.model,
    required this.variant,
    required this.sellingPrice,
    required this.serialNumber,
    required this.retailerOrDistributorId,
    required this.transactionId,
    required this.imei_1,
    required this.imei_2,
    required this.createdAt,
    required this.warrantyStarted,
    required this.warrantyEnded,
    required this.status,
  });

  // Named constructor for creating from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      brand: json['brand'] ?? 'Unknown Brand',
      condition: json['condition'] ?? 'Unknown Condition',
      model: json['model'] ?? 'Unknown Model',
      variant: json['variant'] ?? 'Unknown Variant',
      sellingPrice: json['sellingPrice'] ?? '0',
      serialNumber: json['serialNumber'] ?? 'Unknown Serial',
      retailerOrDistributorId: json['retailerOrDistributorId'] ?? 'Unknown',
      transactionId: json['transactionId'] ?? 'Unknown',
      imei_1: json['imei_1'] ?? 'Unknown IMEI1',
      imei_2: json['imei_2'] ?? 'Unknown IMEI2',
      createdAt: json['createdAt'],
      warrantyStarted: json['warrantyStarted'],
      warrantyEnded: json['warrantyEnded'],
      status: ProductStatus.fromMap(json['status']),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'condition': condition,
      'model': model,
      'variant': variant,
      'sellingPrice': sellingPrice,
      'serialNumber': serialNumber,
      'retailerOrDistributorId': retailerOrDistributorId,
      'transactionId': transactionId,
      'imei_1': imei_1,
      'imei_2': imei_2,
      'createdAt': createdAt,
      'warrantyStarted': warrantyStarted,
      'warrantyEnded': warrantyEnded,
      'status': status.toMap(),
    };
  }
}

// ProductStatus class to parse the status map
class ProductStatus {
  Timestamp? billed;
  Timestamp? inventory;
  Timestamp? warranty;
  Timestamp? sold;

  ProductStatus({this.billed, this.inventory,this.warranty,this
  .sold});

  factory ProductStatus.fromMap(Map<String, dynamic> map) {
    return ProductStatus(
      billed: map['BILLED'],
      inventory: map['INVENTORY'],
      warranty: map['WARRANTY'],
      sold:map['SOLD']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'BILLED': billed,
      'INVENTORY': inventory,
      'WARRANTY': billed,
      'SOLD':sold,
    };
  }
}
