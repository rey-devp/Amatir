import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/routes.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/order_model.dart';
import '../widgets/order_card.dart';
import 'warehouse_scan_page.dart';
import 'update_package_location.dart';

class DashboardWarehousePage extends StatefulWidget {
  const DashboardWarehousePage({super.key});

  @override
  State<DashboardWarehousePage> createState() => _DashboardWarehousePageState();
}

class _DashboardWarehousePageState extends State<DashboardWarehousePage> {
  int _activeTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surfaceColor = isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textColor = isDarkMode ? AppColors.textLight : AppColors.textDark;
    final subTextColor = isDarkMode ? AppColors.textGrayDark : AppColors.textGray;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: StreamBuilder<List<OrderModel>>(
        stream: _activeTabIndex == 0 
           ? orderProvider.getOrdersByStatus('pending')
           : _activeTabIndex == 1
              ? orderProvider.getOrdersByStatus('at_warehouse')
              : orderProvider.getOrdersByStatus('delivered'), // Simple mapping for now
        builder: (context, snapshot) {
          final orders = snapshot.data ?? [];
          final currentCount = orders.length;

          return CustomScrollView(
            slivers: [
              // 1. Header
              SliverAppBar(
                backgroundColor: backgroundColor.withOpacity(0.95),
                pinned: true,
                elevation: 0,
                toolbarHeight: 80,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            image: const DecorationImage(
                              image: NetworkImage('https://ui-avatars.com/api/?name=Warehouse+Admin&background=random'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Operations,', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: subTextColor)),
                            Text('LogiTrack WH', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<AuthProvider>(context, listen: false).logout();
                        Navigator.pushReplacementNamed(context, AppRoutes.login);
                      },
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(color: surfaceColor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), spreadRadius: 1)]),
                        child: Icon(Icons.logout, color: subTextColor),
                      ),
                    ),
                  ],
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'LIVE UPDATES',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1.0),
                      ),
                    ),
                  ),
                ),
              ),

              // 2. Stats Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: _activeTabIndex == 0 ? 'Pending' : (_activeTabIndex == 1 ? 'In WH' : 'History'),
                          value: '$currentCount',
                          icon: _activeTabIndex == 0 ? Icons.input : (_activeTabIndex == 1 ? Icons.inventory_2 : Icons.history),
                          color: AppColors.primary,
                          surfaceColor: surfaceColor,
                          textColor: textColor,
                          subTextColor: subTextColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          title: 'Active',
                          value: '...', // Separate query needed for total context
                          icon: Icons.local_shipping,
                          color: AppColors.purple,
                          surfaceColor: surfaceColor,
                          textColor: textColor,
                          subTextColor: subTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Tab Switcher
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverTabHeaderDelegate(
                  minHeight: 60,
                  maxHeight: 60,
                  child: Container(
                    color: backgroundColor,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        _buildTabButton('Incoming', _activeTabIndex == 0, () => setState(() => _activeTabIndex = 0), surfaceColor, textColor, subTextColor),
                        const SizedBox(width: 8),
                        _buildTabButton('In Warehouse', _activeTabIndex == 1, () => setState(() => _activeTabIndex = 1), surfaceColor, textColor, subTextColor),
                        const SizedBox(width: 8),
                        _buildTabButton('History', _activeTabIndex == 2, () => setState(() => _activeTabIndex = 2), surfaceColor, textColor, subTextColor),
                      ],
                    ),
                  ),
                ),
              ),

              // 4. List Content
              if (snapshot.connectionState == ConnectionState.waiting)
                const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
              else if (orders.isEmpty)
                SliverFillRemaining(child: Center(child: Text('No packages found', style: TextStyle(color: subTextColor))))
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final order = orders[index];
                        return OrderCard(
                          order: order,
                          isDarkMode: isDarkMode,
                          onTap: () {
                             Navigator.push(
                               context,
                               MaterialPageRoute(
                                 builder: (context) => UpdatePackageLocationPage(order: order),
                               ),
                             );
                          },
                        );
                      },
                      childCount: orders.length,
                    ),
                  ),
                ),
            ],
          );
        }
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const WarehouseScanPage())),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.qr_code_scanner, color: AppColors.backgroundDark),
      ),
      
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: surfaceColor, border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.1)))),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.dashboard, 'Dash', true),
                _buildNavItem(Icons.inventory, 'Inventory', false),
                const SizedBox(width: 40),
                _buildNavItem(Icons.calendar_month, 'Schedule', false),
                _buildNavItem(Icons.settings, 'Settings', false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({required String title, required String value, required IconData icon, required Color color, required Color surfaceColor, required Color textColor, required Color subTextColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 24)),
          Text(title, style: TextStyle(color: subTextColor, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, bool isActive, VoidCallback onTap, Color surfaceColor, Color textColor, Color subTextColor) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            color: isActive ? surfaceColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isActive ? Border.all(color: AppColors.primary.withOpacity(0.3)) : null,
          ),
          alignment: Alignment.center,
          child: Text(label, style: TextStyle(color: isActive ? AppColors.primary : subTextColor, fontWeight: isActive ? FontWeight.bold : FontWeight.w500, fontSize: 13)),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isActive ? AppColors.primary : AppColors.textGray.withOpacity(0.6), size: 26),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 10, fontWeight: isActive ? FontWeight.bold : FontWeight.w500, color: isActive ? AppColors.primary : AppColors.textGray.withOpacity(0.6))),
      ],
    );
  }
}

class _SliverTabHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverTabHeaderDelegate({required this.minHeight, required this.maxHeight, required this.child});

  @override double get minExtent => minHeight;
  @override double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverTabHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}
