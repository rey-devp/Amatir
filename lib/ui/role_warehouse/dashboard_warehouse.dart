import 'package:flutter/material.dart';
import '../../config/app_constants.dart';

// --- MODELS (Private classes tetap ada) ---
class _DashboardItem {
  final String id, origin, status;
  final IconData icon;
  final bool isProcessed;
  _DashboardItem({required this.id, required this.origin, required this.status, required this.icon, this.isProcessed = false});
}
class _StatItem {
  final String title, value, trend;
  final IconData icon, trendIcon;
  final Color color;
  _StatItem({required this.title, required this.value, required this.icon, required this.color, required this.trend, required this.trendIcon});
}
class _TabItem {
  final String label, count;
  final bool isActive;
  _TabItem({required this.label, required this.count, this.isActive = false});
}

class DashboardWarehouse extends StatefulWidget {
  const DashboardWarehouse({super.key});

  @override
  State<DashboardWarehouse> createState() => _DashboardWarehouseState();
}

class _DashboardWarehouseState extends State<DashboardWarehouse> {
  // Dummy Data
  final List<_StatItem> _statItems = [
    _StatItem(title: 'Incoming', value: '142', icon: Icons.input, color: AppColors.primary, trend: '+12%', trendIcon: Icons.trending_up),
    _StatItem(title: 'Outgoing', value: '89', icon: Icons.output, color: Colors.purple, trend: 'On Track', trendIcon: Icons.trending_flat),
  ];
  final List<_TabItem> _tabItems = [
    _TabItem(label: 'Incoming', count: '12', isActive: true),
    _TabItem(label: 'Outgoing', count: '', isActive: false),
    _TabItem(label: 'History', count: '', isActive: false),
  ];
  final List<_DashboardItem> _dashboardItems = [
    _DashboardItem(id: '#LOG-9921', origin: 'Shanghai', status: 'Pending', icon: Icons.local_shipping_outlined),
    _DashboardItem(id: '#TRK-8821', origin: 'New York', status: 'Pending', icon: Icons.flight_land),
    _DashboardItem(id: '#LOG-1029', origin: 'Tokyo', status: 'Processed', icon: Icons.check_circle_outline, isProcessed: true),
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final backgroundColor = isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surfaceColor = isDarkMode ? AppColors.surfaceDark : Colors.white; // Fixed: AppColors.surfaceLight mgkn tidak ada, pakai white
    final textColor = isDarkMode ? AppColors.textLight : AppColors.textDark;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: backgroundColor.withOpacity(0.95),
            pinned: true,
            title: Text('Warehouse 4', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
            actions: [
               IconButton(onPressed: (){}, icon: const Icon(Icons.notifications_outlined))
            ],
          ),
          
          // Stats Grid
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid.count(
              crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.4,
              children: _statItems.map((stat) => _buildStatCard(stat, surfaceColor, textColor)).toList(),
            ),
          ),

          // Tabs
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _tabItems.length,
                itemBuilder: (context, index) {
                   final tab = _tabItems[index];
                   return Padding(
                     padding: const EdgeInsets.only(right: 8),
                     child: Chip(
                       label: Text(tab.label + (tab.count.isNotEmpty ? ' ${tab.count}' : '')),
                       backgroundColor: tab.isActive ? AppColors.primary : surfaceColor,
                       labelStyle: TextStyle(color: tab.isActive ? Colors.white : textColor),
                     ),
                   );
                },
              ),
            ),
          ),

          // List
          SliverPadding(
             padding: const EdgeInsets.all(16),
             sliver: SliverList(
               delegate: SliverChildBuilderDelegate(
                 (context, index) {
                    final item = _dashboardItems[index];
                    return Card(
                      color: surfaceColor,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Icon(item.icon, color: AppColors.primary),
                        title: Text(item.id, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                        subtitle: Text(item.origin, style: TextStyle(color: textColor.withOpacity(0.7))),
                        trailing: Text(item.status, style: TextStyle(color: item.isProcessed ? Colors.green : Colors.orange)),
                      ),
                    );
                 },
                 childCount: _dashboardItems.length,
               ),
             ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
      ),
    );
  }

  Widget _buildStatCard(_StatItem stat, Color surfaceColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(stat.icon, color: stat.color),
          Text(stat.value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
          Text(stat.title, style: TextStyle(color: textColor.withOpacity(0.7))),
        ],
      ),
    );
  }
}