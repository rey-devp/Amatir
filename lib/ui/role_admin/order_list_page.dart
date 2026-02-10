import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../models/order_model.dart';
import '../../providers/admin_provider.dart';
import '../widgets/order_card.dart';
import '../../config/routes.dart';

class OrderListPage extends StatelessWidget {
  const OrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    final backgroundColor = isDarkMode
        ? AppColors.backgroundDark
        : AppColors.backgroundLight;
    final textColor = isDarkMode ? AppColors.textLight : AppColors.textDark;
    final subTextColor = isDarkMode
        ? AppColors.textGrayDark
        : AppColors.textGray;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Manage Orders'),
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: adminProvider.getAllOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: subTextColor),
              ),
            );
          }
          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return Center(
              child: Text(
                'Belum ada pesanan',
                style: TextStyle(color: subTextColor),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return OrderCard(
                order: order,
                isDarkMode: isDarkMode,
                onTap: () {
                  // Admin can also view order detail
                  // Assuming reuse of CustomerOrderDetail or create AdminOrderDetail
                  // For now, let's reuse CustomerOrderDetail as it shows the timeline nicely
                  Navigator.pushNamed(
                    context,
                    AppRoutes.customerOrderDetail,
                    arguments: order,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
