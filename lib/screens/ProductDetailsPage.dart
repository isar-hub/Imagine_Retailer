// import 'package:flutter/material.dart';
// import 'package:imagine_retailer/models/Product.dart';
//
// class ProductDetailsPage extends StatelessWidget {
//   final Product productDetails;
//
//   ProductDetailsPage({required this.productDetails});
//
//   @override
//   Widget build(BuildContext context) {
//     final String name = productDetails.brand;
//     final String phone = productDetails;
//     final String email = productDetails['email'] ?? '';
//     final String address = productDetails['address'] ?? '';
//     final String state = productDetails['state'] ?? '';
//     final String sellingPrice = productDetails['sellingPrice'] ?? '';
//     final String warrantyStarted = productDetails['warrantyStarted'] ?? '';
//     final String warrantyEnded = productDetails['warrantyEnded'] ?? '';
//     final String imageUrl = productDetails['imageUrl'] ?? '';
//     final String signatureUrl = productDetails['signatureUrl'] ?? '';
//     final bool isSold = productDetails['isSold'] ?? false;
//
//     final Map<String, dynamic> status = productDetails['status'] ?? {};
//     final DateTime? billed = status['BILLED']?.toDate();
//     final DateTime? inventory = status['INVENTORY']?.toDate();
//     final DateTime? sold = status['SOLD']?.toDate();
//     final DateTime? warranty = status['WARRANTY']?.toDate();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Product Details'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Profile Image
//             Center(
//               child: ClipOval(
//                 child: Image.network(
//                   imageUrl,
//                   height: 100,
//                   width: 100,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) => Icon(
//                     Icons.image_not_supported,
//                     size: 100,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//
//             // Personal Details
//             Text('Name: $name', style: TextStyle(fontSize: 16)),
//             Text('Phone: $phone', style: TextStyle(fontSize: 16)),
//             Text('Email: $email', style: TextStyle(fontSize: 16)),
//             Text('Address: $address', style: TextStyle(fontSize: 16)),
//             Text('State: $state', style: TextStyle(fontSize: 16)),
//             SizedBox(height: 16),
//
//             // Selling Details
//             Text('Is Sold: ${isSold ? "Yes" : "No"}', style: TextStyle(fontSize: 16)),
//             Text('Selling Price: ${sellingPrice.isEmpty ? "Not Available" : sellingPrice}', style: TextStyle(fontSize: 16)),
//             SizedBox(height: 16),
//
//             // Warranty Details
//             Text('Warranty Started: $warrantyStarted', style: TextStyle(fontSize: 16)),
//             Text('Warranty Ends: $warrantyEnded', style: TextStyle(fontSize: 16)),
//             SizedBox(height: 16),
//
//             // Status Timestamps
//             Text(
//               'Timestamps:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text('Billed: ${billed != null ? billed.toLocal() : "N/A"}', style: TextStyle(fontSize: 16)),
//             Text('Inventory: ${inventory != null ? inventory.toLocal() : "N/A"}', style: TextStyle(fontSize: 16)),
//             Text('Sold: ${sold != null ? sold.toLocal() : "N/A"}', style: TextStyle(fontSize: 16)),
//             Text('Warranty: ${warranty != null ? warranty.toLocal() : "N/A"}', style: TextStyle(fontSize: 16)),
//             SizedBox(height: 16),
//
//             // Signature
//             Center(
//               child: Column(
//                 children: [
//                   Text(
//                     'Customer Signature',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8),
//                   Image.network(
//                     signatureUrl,
//                     height: 80,
//                     width: 200,
//                     fit: BoxFit.contain,
//                     errorBuilder: (context, error, stackTrace) => Icon(
//                       Icons.image_not_supported,
//                       size: 100,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
