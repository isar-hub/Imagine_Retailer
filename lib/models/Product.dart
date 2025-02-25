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
  List<ProductStatusHistory> history;

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
    required this.history,
  });

  // Named constructor for creating from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    var historyList = json['history'] as List<dynamic>? ?? [];
    List<ProductStatusHistory> statusHistoryList = historyList
        .map((item) => ProductStatusHistory.fromJson(item as Map<String, dynamic>))
        .toList();

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
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime(0),
      warrantyStarted: (json['warrantyStarted'] as Timestamp?)?.toDate(),
      warrantyEnded: (json['warrantyEnded'] as Timestamp?)?.toDate(),
      status: json['status'] ?? 'Unknown',
      mrp: json['mrp'] ?? '0',
      history: statusHistoryList,
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
      'history': history.map((history) => history.toJson()).toList(),    };
  }
}



class ProductStatusHistory {
  String status;
  DateTime timestamp;

  ProductStatusHistory({
    required this.status,
    required this.timestamp,
  });

  factory ProductStatusHistory.fromJson(Map<String, dynamic> map) {
    return ProductStatusHistory(
      status: map['status'] as String? ?? 'UNKNOWN',
      timestamp:(map['timestamp'] as Timestamp?)?.toDate() ?? DateTime(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'timestamp': timestamp,
    };
  }

  static Timestamp _parseTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value;
    }
    if (value is String) {
      final dateTime = DateTime.tryParse(value);
      return dateTime != null
          ? Timestamp.fromDate(dateTime)
          : Timestamp.now();
    }
    if (value is int) {
      return Timestamp.fromMillisecondsSinceEpoch(value);
    }
    if (value is Map) {
      return Timestamp(
        value['_seconds'] as int? ?? 0,
        value['_nanoseconds'] as int? ?? 0,
      );
    }
    return Timestamp.now();
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
