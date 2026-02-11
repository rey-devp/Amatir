import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/ui_utils.dart';
import '../widgets/tracking_timeline.dart';

class OrderDetailCustomerPage extends StatefulWidget {
  const OrderDetailCustomerPage({super.key});

  @override
  State<OrderDetailCustomerPage> createState() => _OrderDetailCustomerPageState();
}

class _OrderDetailCustomerPageState extends State<OrderDetailCustomerPage> {
  OrderModel? _order;
  bool _isConfirming = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is OrderModel) {
      _order = args;
    }
  }

  Future<void> _confirmReceived() async {
    if (_order == null) return;
    
    setState(() => _isConfirming = true);
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    
    final success = await orderProvider.confirmReceived(
      orderId: _order!.orderId,
      customerName: authProvider.user?.name ?? 'Customer',
    );

    if (mounted) {
      setState(() => _isConfirming = false);
      if (success) {
        UiUtils.showSuccessSnackBar(context, 'Pesanan berhasil dikonfirmasi!');
        Navigator.pop(context);
      } else {
        UiUtils.showErrorSnackBar(context, 'Gagal mengkonfirmasi pesanan');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Details')),
        body: const Center(child: Text('Data pesanan tidak ditemukan')),
      );
    }

    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textColor = isDarkMode ? AppColors.textLight : AppColors.textDark;
    final subTextColor = isDarkMode ? AppColors.textGrayDark : AppColors.textGray;
    final borderColor = isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                        ),
                        child: Icon(Icons.arrow_back, color: textColor),
                      ),
                    ),
                  ),
                  Text('Detail Pesanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                    ),
                    child: Icon(Icons.support_agent, color: subTextColor),
                  ),
                ],
              ),
            ),
            
            // 2. Main Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Hero Status Card
                    Container(
                      decoration: BoxDecoration(
                        color: isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text('TRACKING ID', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: subTextColor, letterSpacing: 0.5)),
                                     const SizedBox(height: 4),
                                     Text(_order!.trackingId, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                                   ],
                                 ),
                                 Container(
                                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                   decoration: BoxDecoration(
                                     color: AppColors.primary.withOpacity(0.1),
                                     borderRadius: BorderRadius.circular(8),
                                   ),
                                   child: Text(_order!.status.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                 )
                               ],
                             ),
                             const SizedBox(height: 16),
                             Row(
                               children: [
                                 const Icon(Icons.inventory_2_outlined, size: 16, color: AppColors.primary),
                                 const SizedBox(width: 8),
                                 Text(_order!.productName, style: TextStyle(fontSize: 14, color: textColor, fontWeight: FontWeight.w500)),
                               ],
                             ),
                             const SizedBox(height: 8),
                             Row(
                               children: [
                                 const Icon(Icons.location_on_outlined, size: 16, color: AppColors.primary),
                                 const SizedBox(width: 8),
                                 Expanded(child: Text(_order!.destination, style: TextStyle(fontSize: 14, color: subTextColor))),
                               ],
                             ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),

                    // Timeline Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Riwayat Pengiriman', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                    ),
                    const SizedBox(height: 16),
                    TrackingTimeline(
                      history: _order!.trackingHistory,
                      isDarkMode: isDarkMode,
                    ),

                    const SizedBox(height: 80), 
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _order!.status == 'delivered' ? Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor.withOpacity(0.95),
          border: Border(top: BorderSide(color: borderColor)),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isConfirming ? null : _confirmReceived,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.backgroundDark,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: _isConfirming
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
              : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text('Konfirmasi Terima Barang', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                   SizedBox(width: 8),
                   Icon(Icons.check_circle, size: 20),
                ],
              ),
          ),
        ),
      ) : null,
    );
  }
}
