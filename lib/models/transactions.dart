import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  final String id;
  final double bill;
  final DateTime date;
  final String from;
  final DocumentReference? fromDistributorId;
  final List<String> serialNumbers;
  final String to;
  final DocumentReference toEntityId;

  Transaction({
    required this.id,
    required this.bill,
    required this.date,
    required this.from,
    this.fromDistributorId,
    required this.serialNumbers,
    required this.to,
    required this.toEntityId,
  });


  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? 'id',
      bill: (json['bill'] ?? 0).toDouble(),
      date: (json['date'] as Timestamp).toDate(),
      from: json['from'] ?? '',
      fromDistributorId: json['fromDistributorId'] is DocumentReference ? json['fromDistributorId'] :  FirebaseFirestore.instance.doc(json['fromDistributorId'] ?? 'users/default')     ,
      serialNumbers: List<String>.from(json['serialNumbers'] ?? []),
      to: json['to'] ?? '',  // Default for to
      toEntityId: json['toEntityId'] is DocumentReference
          ? json['toEntityId'] as DocumentReference
          : FirebaseFirestore.instance.doc(json['toEntityId'] ?? 'users/default'),
    );
  }
}
