import 'package:flutter/material.dart';
import 'package:imagine_retailer/screens/product_details/cards/transaction_flow_card.dart';

import '../../../config/common_methods.dart';
import '../../../models/Product.dart';

class PhoneDetailCard extends StatelessWidget {
  const PhoneDetailCard({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    print(product.history[0].timestamp);

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.smartphone,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),

                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        product.model,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Apple Inc.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                ],
              ),
              const SizedBox(height: 16),

              _buildInfoField('IMEI 1', product.imei_1),
              _buildInfoField('IMEI 2',  product.imei_2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoField('Serial Number', product.serialNumber),
                  buildVerticalLine(),
                  _buildInfoField('Condition', 'Gold',color: getStatusColor(product.condition)),
                ],
              ),
              _buildInfoField('Variant', (product.variant)),
              product.warrantyStarted != null ?
              _buildInfoField('Warranty', ('${formatDateTime(product.warrantyStarted!)}\n${formatDateTime(product.warrantyEnded!)}')) : Container(),
              const SizedBox(height: 8),

              // const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle,
                        size: 16, color: Colors.green[700]),
                    const SizedBox(width: 4),
                    Text(
                      product.status.toUpperCase(),
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Divider(
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'Status History',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              ...product.history.skip(2)
                 .map((status) => _buildStatusItem(
                    formatDateTime(status.timestamp),
                status.status.toUpperCase(),
                getRandomColor()
                  ))
                 .toList(),

              const SizedBox(height: 12),
              // _buildStatusItem('Jan 15, 2024', 'Activated', Colors.green),
              // _buildStatusItem('Jan 14, 2024', 'Sold', Colors.blue),
              // _buildStatusItem('Jan 10, 2024', 'In Stock', Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, String value,{Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String date, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            date,
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: Colors.black),
          ),
          const Spacer(),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
