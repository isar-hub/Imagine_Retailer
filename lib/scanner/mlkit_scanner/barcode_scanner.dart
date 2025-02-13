import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'barcode_detector_painter.dart';
import 'detector_view.dart';

class BarcodeScannerView extends StatefulWidget {
  const BarcodeScannerView({super.key});

  @override
  State<BarcodeScannerView> createState() => _BarcodeScannerViewState();
}

class _BarcodeScannerViewState extends State<BarcodeScannerView> {
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.back;
  bool isDetected = false;

  @override
  void dispose() {
    _canProcess = false; // Prevent further processing
    _barcodeScanner.close(); // Clean up resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DetectorView(
      title: 'Barcode Scanner',
      customPaint: _customPaint,
      text: _text,
      onImage: _processImage,
      initialCameraLensDirection: _cameraLensDirection,
      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
      isDetected: isDetected,
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess || _isBusy) return;

    _isBusy = true; // Lock processing
    setState(() {
      _text = ''; // Clear previous text
    });

    try {
      final barcodes = await _barcodeScanner.processImage(inputImage);
      if (inputImage.metadata?.size != null &&
          inputImage.metadata?.rotation != null) {
        if (barcodes.isNotEmpty) {
          setState(() {
            isDetected = true;
          });
          _handleBarcodeDetected(
              barcodes[0]); // Move barcode handling to a separate method
        }

        // Draw detected barcodes
        final painter = BarcodeDetectorPainter(context);
        _customPaint = CustomPaint(painter: painter);
        log("Barcode Found: $barcodes");
      } else {
        _handleNoBarcodeFound(barcodes);
      }
    } catch (e) {
      log("Error processing image: $e"); // Log errors
    } finally {
      _isBusy = false; // Unlock processing
    }
  }

  // void _handleBarcodeDetected(Barcode barcode) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Get.offAll(const BarcodeView(), arguments: barcode.displayValue);
  //   });
  // }
  void _handleBarcodeDetected(Barcode barcode) {
    final scannedValue = barcode.displayValue;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.back(result: scannedValue); // Return the scanned value
    });
  }
  void _handleNoBarcodeFound(List<Barcode> barcodes) {
    String text = 'Barcodes found: ${barcodes.length}\n\n';
    for (final barcode in barcodes) {
      text += 'Barcode: ${barcode.rawValue}\n\n';
    }
    _text = text;
    log("No Barcode Found: $barcodes");
    _customPaint = null; // Clear custom painter
  }
}
