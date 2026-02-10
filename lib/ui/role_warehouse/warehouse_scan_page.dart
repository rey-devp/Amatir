import 'package:flutter/material.dart';
import '../../config/app_constants.dart';
import 'update_package_location.dart';

class WarehouseScanPage extends StatefulWidget {
  const WarehouseScanPage({super.key});

  @override
  State<WarehouseScanPage> createState() => _WarehouseScanPageState();
}

class _WarehouseScanPageState extends State<WarehouseScanPage> {
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    // Simulate finding a code after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isScanning = false);
        _showResultDialog();
      }
    });
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Barcode Detected'),
        content: const Text('Resi ID: JP-882190'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close scan page
            }, 
            child: const Text('Cancel')
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close scan page
              // Navigate to Update Page with data (simulated)
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UpdatePackageLocationPage()),
              );
            }, 
            child: const Text('Process')
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _isScanning 
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : const Center(child: Icon(Icons.qr_code, color: Colors.white, size: 80)),
            ),
          ),
          Positioned(
            top: 50, left: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Positioned(
            bottom: 50, left: 0, right: 0,
            child: Text(
              'Align QR Code / Barcode within frame',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
