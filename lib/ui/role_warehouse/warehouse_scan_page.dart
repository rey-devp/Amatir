import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../config/app_colors.dart';
import 'update_package_location.dart';

class WarehouseScanPage extends StatefulWidget {
  const WarehouseScanPage({super.key});

  @override
  State<WarehouseScanPage> createState() => _WarehouseScanPageState();
}

class _WarehouseScanPageState extends State<WarehouseScanPage> {
  bool _isScanCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Package Barcode'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          MobileScanner(
            onDetect: (capture) {
              if (_isScanCompleted) return;
              
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String? code = barcodes.first.rawValue;
                if (code != null) {
                  setState(() => _isScanCompleted = true);
                  _onCodeDetected(code);
                }
              }
            },
          ),
          
          // Overlay Scanner Frame
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          
          Positioned(
            bottom: 100,
            child: Text(
              'Arahkan kamera ke Barcode / QR Code Paket',
              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
            ),
          )
        ],
      ),
    );
  }

  void _onCodeDetected(String code) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Paket Terdeteksi'),
        content: Text('ID Tracking: $code'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _isScanCompleted = false);
              Navigator.pop(context);
            },
            child: const Text('Scan Ulang'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdatePackageLocationPage(trackingId: code),
                ),
              );
            },
            child: const Text('Proses Paket'),
          ),
        ],
      ),
    );
  }
}
