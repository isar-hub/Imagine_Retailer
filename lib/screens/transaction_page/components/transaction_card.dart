import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:imagine_retailer/models/transactions.dart' as t;
import '../../../models/Users.dart';

class TransactionReceipt extends StatelessWidget {
  const TransactionReceipt({
    super.key,
    required this.transaction,
    required this.user,
    required this.onTapSerial,
  });

  final Function(String serialNumber) onTapSerial;
  final t.Transaction transaction;
  final Users user;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Transaction ID
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Transaction ID',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Text(
                  transaction.id,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Amount
            Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '₹',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      Text(
                        transaction.bill.toDouble().toStringAsFixed(2),
                        style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.date.toString(),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // From/To Section
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'From',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (transaction.fromDistributorId == null) ...[
                      Text(
                        transaction.from == "admin"
                            ? "RedCat"
                            : transaction.from.toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                      Text(
                        "N/A",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ] else ...[
                      FutureBuilder<DocumentSnapshot>(
                        future: transaction.fromDistributorId
                            ?.get(), // Fetch document
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text(
                              "Loading...",
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            );
                          }

                          if (snapshot.hasError ||
                              !snapshot.hasData ||
                              snapshot.data == null) {
                            return const Text("Unknown Distributor",
                                style: TextStyle(fontWeight: FontWeight.bold));
                          }

                          // Extract data

                          var userData =
                              snapshot.data!.data() as Map<String, dynamic>;
                          String userName = userData['name'] ?? "No Name";
                          String userRole = userData['role'] ?? "No Role";

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              Text(
                                userRole,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    ],
                  ],
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: Colors.blue,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'To',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      FutureBuilder<DocumentSnapshot>(
                        future: transaction.toEntityId.get(), // Fetch document
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text(
                              "Loading...",
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            );
                          }

                          if (snapshot.hasError ||
                              !snapshot.hasData ||
                              !snapshot.data!.exists) {
                            return Text(
                              "Unknown",
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            );
                          }

                          // Extract data
                          var userData =
                              snapshot.data!.data() as Map<String, dynamic>;
                          String userName = userData['name'] ?? "No Name";
                          String userRole = userData['role'] ?? "No Role";

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              Text(
                                userRole,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Serial Numbers
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Serial Numbers',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: transaction.serialNumbers.length > 0
                      ? Row(
                          children: transaction.serialNumbers
                              .map(
                                (sn) => OutlinedButton(
                                  onPressed: () {
                                    onTapSerial(sn);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        color: Colors.red
                                            .shade500), // More visible border
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          4), // Slightly rounded corners
                                    ),
                                  ),
                                  child: Text(
                                    sn,
                                    style: const TextStyle(
                                        color:
                                            Colors.black), // Better visibility
                                  ),
                                ),
                              )
                              .toList(),
                        )
                      : const Text('No Serial Number'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
