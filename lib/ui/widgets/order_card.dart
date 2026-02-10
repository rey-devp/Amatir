import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../models/order_model.dart';
import '../../utils/formatter.dart';
import '../../utils/ui_utils.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final bool isDarkMode;
  final VoidCallback? onTap;

  const OrderCard({
    super.key,
    required this.order,
    this.isDarkMode = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textColor = isDarkMode ? AppColors.textLight : AppColors.textDark;
    final subTextColor = isDarkMode ? AppColors.textGrayDark : AppColors.textGray;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(order.trackingId, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: UiUtils.getStatusColor(order.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.status.toUpperCase(), 
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: UiUtils.getStatusColor(order.status))
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(order.productName, style: TextStyle(fontSize: 14, color: textColor)),
            const SizedBox(height: 4),
            Text(
              AppFormatter.formatDate(order.createdAt), 
              style: TextStyle(fontSize: 12, color: subTextColor)
            ),
          ],
        ),
      ),
    );
  }
}
