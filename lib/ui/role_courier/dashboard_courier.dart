import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/routes.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/ui_utils.dart';

class DashboardCourierPage extends StatefulWidget {
  const DashboardCourierPage({super.key});

  @override
  State<DashboardCourierPage> createState() => _DashboardCourierPageState();
}

class _DashboardCourierPageState extends State<DashboardCourierPage> {
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surfaceColor = isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textColor = isDarkMode ? AppColors.textLight : AppColors.textDark;
    final subTextColor = isDarkMode ? AppColors.textGrayDark : AppColors.textGray;

    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          // 1. Header
          SliverAppBar(
            backgroundColor: backgroundColor.withOpacity(0.95),
            pinned: true,
            elevation: 0,
            title: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.withOpacity(0.3), width: 2),
                    image: const DecorationImage(
                      image: NetworkImage('https://i.pravatar.cc/150?u=courier'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('LogiTrack', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                    Text('Driver App', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: subTextColor)),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                   authProvider.logout();
                   Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
                icon: Icon(Icons.logout, color: subTextColor),
              )
            ],
          ),

          // 2. Status Toggle
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF234248) : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isOnline = true),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _isOnline ? (isDarkMode ? const Color(0xFF111f22) : Colors.white) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text('Online', style: TextStyle(fontWeight: FontWeight.w600, color: _isOnline ? AppColors.primary : subTextColor)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isOnline = false),
                        child: Container(
                          decoration: BoxDecoration(
                            color: !_isOnline ? (isDarkMode ? const Color(0xFF111f22) : Colors.white) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text('Offline', style: TextStyle(fontWeight: FontWeight.w600, color: !_isOnline ? textColor : subTextColor)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Active Tasks (Assigned to this Courier)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Tugas Sedang Berjalan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            ),
          ),
          StreamBuilder<List<OrderModel>>(
            stream: orderProvider.getOrdersByCourier(user?.uid ?? ''),
            builder: (context, snapshot) {
              final orders = snapshot.data?.where((o) => o.status == 'on_delivery').toList() ?? [];
              if (orders.isEmpty) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildActiveTaskCard(orders[index], surfaceColor, textColor, subTextColor, isDarkMode),
                  childCount: orders.length,
                ),
              );
            },
          ),

          // 4. Available Jobs (Pending Orders)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Pekerjaan Tersedia', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            ),
          ),
          StreamBuilder<List<OrderModel>>(
            stream: orderProvider.getAvailableJobs(),
            builder: (context, snapshot) {
              final jobs = snapshot.data ?? [];
              if (jobs.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(child: Padding(padding: const EdgeInsets.all(32), child: Text("Tidak ada tugas baru.", style: TextStyle(color: subTextColor)))),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildPendingTaskCard(jobs[index], surfaceColor, textColor, subTextColor, isDarkMode),
                  childCount: jobs.length,
                ),
              );
            },
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }

  Widget _buildActiveTaskCard(OrderModel order, Color surfaceColor, Color textColor, Color subTextColor, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: UiUtils.getStatusColor(order.status).withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: UiUtils.getStatusColor(order.status)),
                      const SizedBox(width: 6),
                      Text(order.status == 'on_delivery' ? 'Sedang Diantar' : order.status.toUpperCase(), 
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: UiUtils.getStatusColor(order.status))),
                    ],
                  ),
                ),
                 Text(order.trackingId, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 12),
            Text(order.productName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF111f22) : Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const Icon(Icons.location_on, color: AppColors.primary, size: 20),
                   const SizedBox(width: 8),
                   Expanded(child: Text(order.destination, style: TextStyle(fontSize: 13, color: textColor, height: 1.4))),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.courierDelivery, arguments: order),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Lanjut Antar', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPendingTaskCard(OrderModel order, Color surfaceColor, Color textColor, Color subTextColor, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order.productName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
              Text(order.trackingId, style: TextStyle(fontSize: 12, color: subTextColor)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: subTextColor),
              const SizedBox(width: 4),
              Expanded(child: Text(order.destination, style: TextStyle(fontSize: 12, color: subTextColor), maxLines: 1, overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Consumer<OrderProvider>(
              builder: (context, provider, child) {
                return ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.courierScan), 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? const Color(0xFF234248) : Colors.black87,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Ambil Tugas', style: TextStyle(fontWeight: FontWeight.bold)),
                );
              }
            ),
          )
        ],
      ),
    );
  }
}
