import 'package:flutter/material.dart';
import '../../config/app_constants.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedIndex = 0; // "Home" selected

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    // Colors
    final backgroundColor = isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surfaceColor = isDarkMode ? const Color(0xFF1a2c32) : Colors.white;
    final textColor = isDarkMode ? AppColors.textLight : AppColors.textDark;
    final subTextColor = isDarkMode ? AppColors.textGrayDark : AppColors.textGray;
    final borderColor = isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05);

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
                          image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuAmDJErD5lzPtMFDGHsigaJnZ8LXs5nPhNaMDPH-pzkfVWm6NOiq_4DDT92oDAfIs2bR8Zd-IFW09R84SJdwsBXsP5AKpq6J0gK4K_-CXD1amDJfDFcD3qWk1_BVWqIDFVwh7Obg1pW-wohQduIpSZLARGnxxWhI8wRq_bJK-PD9D515nu09UAlI0p3v8yim9w4FCUhK-0pU7dZIGSrug-1ub2So5SYz5KhFBPDuOb8oBiN04vu0jG-7gynxTY--q73x8JDfStie6A'),
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
               height: 160, // Fixed height for horizontal scroll or grid
               child: ListView(
                 scrollDirection: Axis.horizontal,
                 padding: const EdgeInsets.symmetric(horizontal: 16),
                 children: [
                    _buildStatsCard(
                      'Total Users', '1,240', '+12%', Icons.group, 
                      surfaceColor, textColor, subTextColor, false
                    ),
                    const SizedBox(width: 12),
                    _buildStatsCard(
                      'Total Transactions', '8,502', '+5%', Icons.local_shipping, 
                      surfaceColor, textColor, subTextColor, false
                    ),
                    const SizedBox(width: 12),
                    _buildStatsCard(
                      'Total Revenue', '\$45,200', '+8%', Icons.payments, 
                      surfaceColor, textColor, subTextColor, true // Gradient card
                    ),
                 ],
               ),
            ),
          ),

          // 4. Quick Actions Title
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

          // 5. Quick Actions Grid
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
          
          // 6. Recent Alert
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text('Recent Alert', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: Colors.orange.withOpacity(0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.warning, color: Colors.orange),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text('Low Stock Alert', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                           Text('Product "Packaging Tape" is below threshold.', style: TextStyle(fontSize: 12, color: subTextColor)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: subTextColor),
                  ],
                ),
              ),
            ),
          )
        ],
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.1))),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.dashboard, 'Home', true),
                _buildNavItem(Icons.map, 'Map', false),
                _buildNavItem(Icons.chat, 'Messages', false),
                _buildNavItem(Icons.person, 'Profile', false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(String title, String value, String growth, IconData icon, Color surfaceColor, Color textColor, Color subTextColor, bool isGradient) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isGradient ? null : surfaceColor,
        gradient: isGradient ? const LinearGradient(colors: [Color(0xFF13c8ec), Color(0xFF0b8aacee)], begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: isGradient ? AppColors.primary.withOpacity(0.3) : Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
        border: isGradient ? null : Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isGradient ? Colors.white.withOpacity(0.2) : AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: isGradient ? Colors.white : AppColors.primary, size: 20),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isGradient ? Colors.white.withOpacity(0.2) : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                       Icon(Icons.trending_up, size: 12, color: isGradient ? Colors.white : Colors.green),
                       const SizedBox(width: 2),
                       Text(growth, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isGradient ? Colors.white : Colors.green)),
                    ],
                  ),
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
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 28),
          ),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 10, color: subTextColor), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
     return Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         Icon(
           icon,
           color: isActive ? AppColors.primary : AppColors.textGray.withOpacity(0.6),
           size: 26,
         ),
         const SizedBox(height: 2),
         Text(
           label,
           style: TextStyle(
             fontSize: 10,
             fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
             color: isActive ? AppColors.primary : AppColors.textGray.withOpacity(0.6),
           ),
         )
       ],
     );
  }
}
