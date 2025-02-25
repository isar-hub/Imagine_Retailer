import 'package:flutter/material.dart';
import 'package:imagine_retailer/models/warranty_model.dart';

class WarrantyInfoCard extends StatelessWidget {
  const WarrantyInfoCard({Key? key, required this.warranty}) : super(key: key);

  final List<Warranty>? warranty;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Warranty Claims',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildClaimCard(
              claimId: 'CLM-001',
              date: 'Feb 1, 2024',
              status: 'Processing',
              statusColor: Colors.amber,
              issueTitle: 'Display Malfunction',
              issueDescription: 'Screen showing flickering and dead pixels',
              imageCount: 3,
            ),
            const SizedBox(height: 12),
            _buildClaimCard(
              claimId: 'CLM-002',
              date: 'Jan 25, 2024',
              status: 'Approved',
              statusColor: Colors.green,
              issueTitle: 'Battery Issue',
              issueDescription: 'Battery draining too quickly',
              imageCount: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClaimCard({
    required String claimId,
    required String date,
    required String status,
    required Color statusColor,
    required String issueTitle,
    required String issueDescription,
    required int imageCount,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Claim header with ID, date and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      claimId,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Issue details
            Text(
              issueTitle,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              issueDescription,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            // Images row
            Row(
              children: List.generate(
                imageCount,
                    (index) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.image,
                      color: Colors.grey[400],
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
