import 'package:flutter/material.dart';
import 'package:imagine_retailer/scanner/mlkit_scanner/barcode_scanner.dart';

class BarCodeActivity extends StatelessWidget {
  const BarCodeActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: Scaffold(
      body: BarcodeScannerView(),
    ));
  }
}
