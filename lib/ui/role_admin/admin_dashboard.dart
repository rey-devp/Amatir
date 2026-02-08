import 'package:flutter/material.dart';
import '../../config/app_constants.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // ... (Sisa kode sama persis, hanya nama class State disesuaikan)
  
  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    // Colors
    final backgroundColor = isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surfaceColor = isDarkMode ? const Color(0xFF1a2c32) : Colors.white;
    final textColor = isDarkMode ? AppColors.textLight : AppColors.textDark;
    final subTextColor = isDarkMode ? AppColors.textGrayDark : AppColors.textGray;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          // 1. Top App Bar
          SliverAppBar(
            backgroundColor: backgroundColor.withOpacity(0.9),
            pinned: true,
            floating: true,
            elevation: 0,
            toolbarHeight: 70,
            title: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary.withOpacity(0.5), width: 2),
                        image: const DecorationImage(
                          image: NetworkImage('https://lh3.googleusercontent.com/a/default-user'), // Ganti URL dummy biar aman
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Positioned(
                      bottom: 0, right: 0,
                      child: CircleAvatar(radius: 6, backgroundColor: Colors.black, child: CircleAvatar(radius: 4, backgroundColor: Colors.green)),
                    )
                  ],
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('LogiTrack', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                    Text('Admin Panel', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: subTextColor)),
                  ],
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey[200],
                      ),
                      child: Icon(Icons.notifications, color: textColor),
                    ),
                    const Positioned(
                      top: 8, right: 8,
                      child: CircleAvatar(radius: 4, backgroundColor: Colors.red),
                    )
                  ],
                ),
              )
            ],
          ),

          // 2. Greeting
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hello, Admin', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 4),
                  Text('Here is your daily logistics summary.', style: TextStyle(fontSize: 14, color: subTextColor)),
                ],
              ),
            ),
          ),

          // 3. Stats Section
          SliverToBoxAdapter(
            child: SizedBox(
               height: 160,
               child: ListView(
                 scrollDirection: Axis.horizontal,
                 padding: const EdgeInsets.symmetric(horizontal: 16),
                 children: [
                   _buildStatsCard('Total Users', '1,240', '+12%', Icons.group, surfaceColor, textColor, subTextColor, false),
                   const SizedBox(width: 12),
                   _buildStatsCard('Transactions', '8,502', '+5%', Icons.local_shipping, surfaceColor, textColor, subTextColor, false),
                   const SizedBox(width: 12),
                   _buildStatsCard('Revenue', '\$45,200', '+8%', Icons.payments, surfaceColor, textColor, subTextColor, true),
                  ],
               ),
            ),
          ),

          // 4. Quick Actions
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text('Quick Actions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
                   Text('View All', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primary)),
                ],
              ),
            ),
          ),

          // 5. Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                _buildActionCard('Kelola User', 'Couriers & Customers', Icons.manage_accounts, surfaceColor, textColor, subTextColor),
                _buildActionCard('Kelola Produk', 'Stock & Categories', Icons.inventory_2, surfaceColor, textColor, subTextColor),
                _buildActionCard('Analytics', 'Performance Reports', Icons.bar_chart, surfaceColor, textColor, subTextColor),
                _buildActionCard('Settings', 'App Configuration', Icons.settings, surfaceColor, textColor, subTextColor),
              ],
            ),
          ),
          
          // Bottom padding
          const SliverPadding(padding: EdgeInsets.only(bottom: 50)),
        ],
      ),
    );
  }

  // Widget Helpers tetap sama seperti kodemu, dicopy di sini:
  Widget _buildStatsCard(String title, String value, String growth, IconData icon, Color surfaceColor, Color textColor, Color subTextColor, bool isGradient) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isGradient ? null : surfaceColor,
        gradient: isGradient ? const LinearGradient(colors: [Color(0xFF13c8ec), Color(0xFF0b8aacee)], begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: isGradient ? AppColors.primary.withOpacity(0.3) : Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Icon(icon, color: isGradient ? Colors.white : AppColors.primary, size: 20),
               Container(
                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                 decoration: BoxDecoration(
                   color: isGradient ? Colors.white.withOpacity(0.2) : Colors.green.withOpacity(0.1),
                   borderRadius: BorderRadius.circular(12),
                 ),
                 child: Text(growth, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isGradient ? Colors.white : Colors.green)),
               )
             ],
           ),
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(title, style: TextStyle(fontSize: 12, color: isGradient ? Colors.white.withOpacity(0.9) : subTextColor)),
               const SizedBox(height: 4),
               Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isGradient ? Colors.white : textColor)),
             ],
           )
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon, Color surfaceColor, Color textColor, Color subTextColor) {
    return Container(
      padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(0, 1))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 10, color: subTextColor), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}