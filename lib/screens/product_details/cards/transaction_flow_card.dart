import 'package:flutter/material.dart';
import 'package:imagine_retailer/config/constants.dart';
import 'package:imagine_retailer/models/transactions.dart';

class TransactionFlowCard extends StatelessWidget {
  const TransactionFlowCard({Key? key, required this.transaction}) : super(key: key);

  final Transaction? transaction;
  @override
  Widget build(BuildContext context) {

    if(transaction == null){
      return SizedBox.shrink();
    }
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
              const Text(
                'Transaction Flow',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              // Admin
              _buildParticipantRow(
                icon: Icons.admin_panel_settings,
                title: transaction!.from == 'admin' ? "Redcat": transaction!.from ,
                subtitle: 'Apple Inc.',
              ),
              buildVerticalLine(),
              _buildParticipantRow(
                icon: Icons.inventory_2,
                title: 'Distributor',
                subtitle: 'TechWorld Distribution',

              ),
              buildVerticalLine(),

              Padding(
                padding: const EdgeInsets.only(left: 36),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow('Name', 'John Smith'),
                      const SizedBox(height: 8),
                      _buildDetailRow('Role', 'Regional Manager'),
                      const SizedBox(height: 8),
                      _buildDetailRow('City', 'New York'),
                      const SizedBox(height: 8),
                      _buildDetailRow('Transaction ID', 'TXN-78945'),
                      const SizedBox(height: 8),
                      _buildDetailRow('Amount', '\$999.00'),
                    ],
                  ),
                ),
              ),
              buildVerticalLine(),
              // Retailer
              _buildParticipantRow(
                icon: Icons.store,
                title: 'Retailer',
                subtitle: 'Apple Store Fifth Avenue',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParticipantRow({
    required IconData icon,
    required String title,
    required String subtitle,

  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color:  Colors.black,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: ImagineColors.red,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }



  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
Widget buildVerticalLine() {
  return Padding(
    padding: const EdgeInsets.only(left: 18),
    child: Container(
      width: 1,
      height: 24,
      color: Colors.grey[300],
    ),
  );
}