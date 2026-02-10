import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';

class CourierScannerPage extends StatefulWidget {
  const CourierScannerPage({super.key});

  @override
  State<CourierScannerPage> createState() => _CourierScannerPageState();
}

class _CourierScannerPageState extends State<CourierScannerPage> {
  bool _isScanCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Paket'),
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
                  _handleJobTake(code);
                }
              }
            },
          ),
          
          // Overlay Frame
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
              'Arahkan kamera ke QR Code Paket untuk mengambil tugas',
              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  Future<void> _handleJobTake(String trackingId) async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Show processing dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
    );

    try {
      // Logic: Update status to 'on_delivery'
      final success = await orderProvider.updateStatus(
        orderId: trackingId, // Assuming trackingId is used as orderId for simplicity or can be mapped
        status: 'on_delivery',
        location: 'Pos Logistik',
        description: 'Kurir telah mengambil paket dan mulai mengantar',
        updaterName: authProvider.user?.name ?? 'Kurir',
      );

      if (mounted) {
        Navigator.pop(context); // Close loading
        
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tugas berhasil diambil!'), backgroundColor: Colors.green),
          );
          Navigator.pop(context); // Back to dashboard
        } else {
           _showError('Gagal mengambil tugas. Pastikan ID paket benar.');
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        _showError('Terjadi kesalahan: $e');
      }
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gagal'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _isScanCompleted = false);
              Navigator.pop(context);
            }, 
            child: const Text('Coba Lagi')
          ),
        ],
      ),
    );
  }
}
