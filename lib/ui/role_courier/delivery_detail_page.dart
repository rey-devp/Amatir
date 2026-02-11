import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/app_colors.dart';
import '../../models/order_model.dart';

/// Page showing completed delivery details for the courier.
///
/// Displays proof photo, GPS location, notes, and full tracking timeline.
class DeliveryDetailPage extends StatelessWidget {
  const DeliveryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)!.settings.arguments as OrderModel;
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surfaceColor = isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textColor = isDarkMode ? AppColors.textLight : AppColors.textDark;
    final subTextColor = isDarkMode ? AppColors.textGrayDark : AppColors.textGray;

    // Find the delivery tracking entry (with proof)
    final deliveryEntry = order.trackingHistory
        .where((h) => h.status == 'delivered' && h.proofUrl != null)
        .toList();

    final proofPath = deliveryEntry.isNotEmpty ? deliveryEntry.last.proofUrl : null;
    final deliveryLocation = deliveryEntry.isNotEmpty ? deliveryEntry.last.location : null;
    final deliveryTime = deliveryEntry.isNotEmpty ? deliveryEntry.last.timestamp : null;
    final deliveryNote = deliveryEntry.isNotEmpty ? deliveryEntry.last.description : null;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: textColor),
        ),
        title: Text('Detail Pengiriman', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Status Banner
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getStatusBannerColor(order.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _getStatusBannerColor(order.status).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    order.status == 'completed' ? Icons.check_circle : Icons.local_shipping,
                    color: _getStatusBannerColor(order.status),
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getStatusLabel(order.status),
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _getStatusBannerColor(order.status)),
                        ),
                        Text(order.trackingId, style: TextStyle(fontSize: 12, color: subTextColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. Order Info
            _buildSection(
              title: 'Informasi Pesanan',
              surfaceColor: surfaceColor,
              textColor: textColor,
              children: [
                _buildInfoRow(Icons.shopping_bag, 'Produk', order.productName, textColor, subTextColor),
                _buildInfoRow(Icons.location_on, 'Tujuan', order.destination, textColor, subTextColor),
                _buildInfoRow(Icons.calendar_today, 'Dibuat', DateFormat('dd MMM yyyy, HH:mm').format(order.createdAt), textColor, subTextColor),
              ],
            ),

            // 3. Proof Photo
            if (proofPath != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text('📸 Bukti Pengiriman', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
                ),
                clipBehavior: Clip.antiAlias,
                child: _buildProofImage(proofPath),
              ),
            ],

            // 4. Delivery Info
            if (deliveryLocation != null || deliveryTime != null)
              _buildSection(
                title: '📍 Detail Pengiriman',
                surfaceColor: surfaceColor,
                textColor: textColor,
                children: [
                  if (deliveryLocation != null)
                    _buildInfoRow(Icons.my_location, 'Lokasi GPS', deliveryLocation, textColor, subTextColor),
                  if (deliveryTime != null)
                    _buildInfoRow(Icons.access_time, 'Waktu Antar', DateFormat('dd MMM yyyy, HH:mm:ss').format(deliveryTime), textColor, subTextColor),
                  if (deliveryNote != null)
                    _buildInfoRow(Icons.note, 'Catatan', deliveryNote, textColor, subTextColor),
                ],
              ),

            // 5. Tracking Timeline
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('📋 Riwayat Tracking', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
            ),
            ...order.trackingHistory.reversed.map(
              (entry) => _buildTimelineEntry(entry, surfaceColor, textColor, subTextColor),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProofImage(String path) {
    final file = File(path);
    if (file.existsSync()) {
      return AspectRatio(
        aspectRatio: 4 / 3,
        child: Image.file(file, fit: BoxFit.cover),
      );
    } else {
      return Container(
        height: 200,
        color: Colors.grey[300],
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image, size: 48, color: Colors.grey),
              SizedBox(height: 8),
              Text('Foto tidak ditemukan', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildSection({
    required String title,
    required Color surfaceColor,
    required Color textColor,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color textColor, Color subTextColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          SizedBox(width: 80, child: Text(label, style: TextStyle(fontSize: 13, color: subTextColor))),
          Expanded(child: Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: textColor))),
        ],
      ),
    );
  }

  Widget _buildTimelineEntry(TrackingHistory entry, Color surfaceColor, Color textColor, Color subTextColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(Icons.circle, size: 10, color: _getStatusBannerColor(entry.status)),
              Container(width: 2, height: 30, color: Colors.grey.withOpacity(0.3)),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_getStatusLabel(entry.status), style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor)),
                    Text(DateFormat('dd/MM HH:mm').format(entry.timestamp), style: TextStyle(fontSize: 11, color: subTextColor)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(entry.description, style: TextStyle(fontSize: 12, color: subTextColor)),
                if (entry.location.isNotEmpty)
                  Text('📍 ${entry.location}', style: TextStyle(fontSize: 11, color: subTextColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusBannerColor(String status) {
    switch (status) {
      case 'completed': return Colors.green;
      case 'delivered': return Colors.blue;
      case 'on_delivery': return Colors.orange;
      case 'at_warehouse': return Colors.purple;
      default: return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'completed': return 'Selesai';
      case 'delivered': return 'Telah Diantar';
      case 'on_delivery': return 'Sedang Diantar';
      case 'at_warehouse': return 'Di Gudang';
      case 'pending': return 'Menunggu';
      default: return status;
    }
  }
}
