import 'package:flutter/material.dart';
import 'package:imagine_retailer/models/Customers.dart';

class CustomerInfoCard extends StatelessWidget {
  const CustomerInfoCard({Key? key, required this.customerInfo}) : super(key: key);

  final CustomerInfo? customerInfo;
  @override
  Widget build(BuildContext context) {

    if(customerInfo == null){
      return Text('No customer information available');
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
                'Customer Information',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Customer header with profile picture
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey[300],
                      child: Image.network(
                        customerInfo!.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        customerInfo!.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      // Text(
                      //   'Customer ID: CUS-78945',
                      //   style: TextStyle(
                      //     color: Colors.grey[600],
                      //     fontSize: 14,
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Contact information
              // Email
              _buildContactInfoRow(
                icon: Icons.email_outlined,
                text: customerInfo!.email,
                iconColor: Colors.blue,
              ),
              const SizedBox(height: 12),
              // Phone
              _buildContactInfoRow(
                icon: Icons.phone_outlined,
                text: customerInfo!.phone,
                iconColor: Colors.blue,
              ),
              const SizedBox(height: 12),
              // Address
              _buildContactInfoRow(
                icon: Icons.location_on_outlined,
                text:customerInfo!.address+customerInfo!.state,
                iconColor: Colors.blue,
              ),
              const SizedBox(height: 24),
              // Signature section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Signature',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 1,
                      ),
                    ),

                    child: Center(
                      child: Image.network(
                        customerInfo!.signatureUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfoRow({
    required IconData icon,
    required String text,
    required Color iconColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: iconColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}