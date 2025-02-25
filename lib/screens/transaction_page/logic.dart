
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:imagine_retailer/controller/controllers.dart';
import '../../models/transactions.dart' as t;

class Transaction_pageLogic extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  final BarCodeController barCodeController = Get.put(BarCodeController());


  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();  // Add this

  // Observables
  var transactions = <t.Transaction>[].obs; // List of transactions
  var filteredTransactions = <t.Transaction>[].obs; // Filtered transactions
  var searchTerm = ''.obs; // Search term
  var isLoading = false.obs; // Loading state
  var error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();

  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();  // Don't forget to dispose
    super.dispose();
  }
  Future<void> fetchProduct(String serialNumber) async {
    await barCodeController.fetchProduct(serialNumber);
  }

  // Fetch Transactions
  Future<void> fetchTransactions() async {
    isLoading.value = true; // Start loading
    try {
      final DocumentReference userRef = _firestore.collection('users').doc(user?.uid);

      final snapshot = await _firestore
          .collection('transactions')
          .where('toEntityId', isEqualTo: userRef) // Firestore requires DocumentReference here
          .get();

      // Map the documents to Transaction objects
      final transactionList = snapshot.docs.map((doc) {
        // print(doc.data());
        return t.Transaction(
          id: doc.id,
          bill: (doc['bill'] ?? 0).toDouble(),
          date: (doc['date'] as Timestamp).toDate(),
          from: doc['from'] ?? '',
          fromDistributorId: doc['fromDistributorId'] as DocumentReference?, // Handle null case properly
          serialNumbers: List<String>.from(doc['serialNumbers'] ?? []),
          to: doc['to'] ?? '',
          toEntityId: doc['toEntityId'] as DocumentReference ,
        );
      }).toList();
       transactions.value = transactionList;
      transactions.sort((a, b) => b.id.compareTo(a.id));
      filteredTransactions.value = transactionList;
    } catch (e) {
      error.value = 'Error fetching transactions: $e';
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  void clearSearch() {
    searchTerm.value = '';
    filteredTransactions.value = transactions;
    searchController.clear();
    searchFocusNode.unfocus();
  }

  // Filter Transactions Based on Search Term
  void filterTransactions(String value) {
    searchTerm.value = value; // Update search term
    if (value.isEmpty) {
      // Reset to original transactions if search is cleared
      filteredTransactions.value = transactions;
    } else {
      // Filter transactions based on the search term
      filteredTransactions.value = transactions.where((transaction) {
        final search = value.toLowerCase();
        return transaction.id.toLowerCase().contains(search) ||
            transaction.serialNumbers.any((serial) => serial.toLowerCase().contains(search)) ||
            transaction.from.toLowerCase().contains(search) ||
            transaction.to.toLowerCase().contains(search);

      }).toList();
    }
  }
}
