import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../config/app_colors.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/location_service.dart';
import '../../services/storage_service.dart';
import '../../utils/ui_utils.dart';

class DeliveryExecutionPage extends StatefulWidget {
  const DeliveryExecutionPage({super.key});

  @override
  State<DeliveryExecutionPage> createState() => _DeliveryExecutionPageState();
}

class _DeliveryExecutionPageState extends State<DeliveryExecutionPage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final LocationService _locationService = LocationService();
  final StorageService _storageService = StorageService();
  
  Position? _currentPosition;
  bool _isUploading = false;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final hasPermission = await _locationService.checkPermission();
    if (hasPermission) {
      final pos = await _locationService.getCurrentPosition();
      setState(() => _currentPosition = pos);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitDelivery(OrderModel order) async {
    if (_imageFile == null) {
      UiUtils.showErrorSnackBar(context, "Foto bukti wajib diambil!");
      return;
    }

    setState(() => _isUploading = true);

    try {
      // 1. Upload Proof Image
      final imageUrl = await _storageService.uploadImage(_imageFile!, 'proofs');

      // 2. Get current location string
      String locationStr = "Lokasi Tidak Diketahui";
      if (_currentPosition != null) {
        locationStr = "${_currentPosition!.latitude}, ${_currentPosition!.longitude}";
      }

      // 3. Update Order Status
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      final success = await Provider.of<OrderProvider>(context, listen: false).updateStatus(
        orderId: order.orderId,
        status: 'delivered',
        location: locationStr,
        description: _noteController.text.isNotEmpty ? _noteController.text : 'Paket telah sampai di tujuan',
        updaterName: user?.name ?? 'Kurir',
        proofUrl: imageUrl,
      );

      if (context.mounted) {
        if (success) {
          Navigator.pop(context);
          UiUtils.showSuccessSnackBar(context, "Pengiriman berhasil dikonfirmasi!");
        } else {
          UiUtils.showErrorSnackBar(context, "Gagal mengupdate status pesanan");
        }
      }
    } catch (e) {
      if (context.mounted) {
        UiUtils.showErrorSnackBar(context, "Error: $e");
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)!.settings.arguments as OrderModel;
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surfaceColor = isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textColor = isDarkMode ? AppColors.textLight : AppColors.textDark;
    final subTextColor = isDarkMode ? AppColors.textGrayDark : AppColors.textGray;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: textColor)),
                   Text('Konfirmasi Pengiriman', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                   const SizedBox(width: 48), // Spacer for center alignment
                ],
              ),
            ),
            
            // 2. Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Camera / Viewfinder
                    AspectRatio(
                      aspectRatio: 4/5,
                      child: Container(
                        color: Colors.black,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            if (_imageFile != null)
                              Image.file(_imageFile!, fit: BoxFit.cover)
                            else
                              const Center(child: Icon(Icons.camera_alt, color: Colors.white, size: 64)),
                            
                            // Viewfinder Guides
                            Positioned(top: 32, left: 32, child: _buildCornerGuide(true, true)),
                            Positioned(top: 32, right: 32, child: _buildCornerGuide(true, false)),
                            Positioned(bottom: 32, left: 32, child: _buildCornerGuide(false, true)),
                            Positioned(bottom: 32, right: 32, child: _buildCornerGuide(false, false)),
                            
                            // Camera Controls
                            Positioned(
                              bottom: 0, left: 0, right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withOpacity(0.8), Colors.transparent]),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                     IconButton(onPressed: () => _pickImage(ImageSource.gallery), icon: const Icon(Icons.photo_library, color: Colors.white)),
                                     const SizedBox(width: 32),
                                     GestureDetector(
                                       onTap: () => _pickImage(ImageSource.camera),
                                       child: Container(
                                         width: 70, height: 70,
                                         decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4)),
                                         padding: const EdgeInsets.all(4),
                                         child: Container(decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                                       ),
                                     ),
                                     const SizedBox(width: 32),
                                     IconButton(onPressed: () => setState(() => _imageFile = null), icon: const Icon(Icons.refresh, color: Colors.white)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Details
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(order.productName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
                          Text(order.trackingId, style: TextStyle(fontSize: 14, color: subTextColor)),
                          const SizedBox(height: 20),
                          
                          // Location Entry
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.withOpacity(0.1))),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on, color: AppColors.primary),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Lokasi Terkini', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
                                      Text(_currentPosition != null ? '${_currentPosition!.latitude}, ${_currentPosition!.longitude}' : 'Mencari lokasi...', style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          Text('Catatan Tambahan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: subTextColor)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _noteController,
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: 'Contoh: Paket ditaruh di depan pintu...',
                              filled: true,
                              fillColor: surfaceColor,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomSheet: Container(
        color: backgroundColor,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isUploading ? null : () => _submitDelivery(order),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
            child: _isUploading 
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
              : const Text('Kirim Konfirmasi Delivery', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ),
    );
  }

  Widget _buildCornerGuide(bool isTop, bool isLeft) {
    return Container(
      width: 16, height: 16,
      decoration: BoxDecoration(
        border: Border(
           top: isTop ? const BorderSide(color: AppColors.primary, width: 2) : BorderSide.none,
           bottom: !isTop ? const BorderSide(color: AppColors.primary, width: 2) : BorderSide.none,
           left: isLeft ? const BorderSide(color: AppColors.primary, width: 2) : BorderSide.none,
           right: !isLeft ? const BorderSide(color: AppColors.primary, width: 2) : BorderSide.none,
        )
      ),
    );
  }
}
