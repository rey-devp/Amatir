import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/routes.dart';
import '../../providers/admin_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../models/order_model.dart';
import '../../models/product_model.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    final backgroundColor = isDarkMode
        ? AppColors.backgroundDark
        : AppColors.backgroundLight;
    final surfaceColor = isDarkMode ? const Color(0xFF1a2c32) : Colors.white;
    final textColor = isDarkMode ? AppColors.textLight : AppColors.textDark;
    final subTextColor = isDarkMode
        ? AppColors.textGrayDark
        : AppColors.textGray;

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
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LogiTrack',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  'Admin Panel',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: subTextColor,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  // Logout logic
                  Provider.of<AdminProvider>(
                    context,
                    listen: false,
                  ).logout(); // Assuming AdminProvider or AuthProvider has logout
                  // Actually AuthProvider handles logout usually, let's check.
                  // Redirect to login
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                color: textColor,
                tooltip: 'Logout',
              ),
              const SizedBox(width: 8),
            ],
          ),

          // 2. Greeting
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, Admin',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    'Overview of LogiTrack Ecosystem',
                    style: TextStyle(fontSize: 14, color: subTextColor),
                  ),
                ],
              ),
            ),
          ),

          // 3. Stats Section
          SliverToBoxAdapter(
            child: SizedBox(
              height: 140,
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: StreamBuilder<List<UserModel>>(
                      stream: adminProvider.getUsers(),
                      builder: (context, snapshot) {
                        return _buildStatsCard(
                          'Users',
                          '${snapshot.data?.length ?? '...'}',
                          Icons.group,
                          surfaceColor,
                          textColor,
                          subTextColor,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StreamBuilder<List<OrderModel>>(
                      stream: adminProvider.getAllOrders(),
                      builder: (context, snapshot) {
                        return _buildStatsCard(
                          'Orders',
                          '${snapshot.data?.length ?? '...'}',
                          Icons.local_shipping,
                          surfaceColor,
                          textColor,
                          subTextColor,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StreamBuilder<List<ProductModel>>(
                      stream: adminProvider.getProducts(),
                      builder: (context, snapshot) {
                        return _buildStatsCard(
                          'Products',
                          '${snapshot.data?.length ?? '...'}',
                          Icons.inventory,
                          surfaceColor,
                          textColor,
                          subTextColor,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),

          // 4. Quick Actions
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                _buildActionCard(
                  'Manage Users',
                  Icons.manage_accounts,
                  surfaceColor,
                  textColor,
                  () => Navigator.pushNamed(context, AppRoutes.adminUsers),
                ),
                _buildActionCard(
                  'Manage Products',
                  Icons.inventory_2,
                  surfaceColor,
                  textColor,
                  () => Navigator.pushNamed(context, AppRoutes.adminProducts),
                ),
                _buildActionCard(
                  'Manage Orders',
                  Icons.shopping_bag,
                  surfaceColor,
                  textColor,
                  () => Navigator.pushNamed(context, AppRoutes.adminOrders),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(
    String title,
    String value,
    IconData icon,
    Color surfaceColor,
    Color textColor,
    Color subTextColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(title, style: TextStyle(fontSize: 12, color: subTextColor)),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color surfaceColor,
    Color textColor,
    VoidCallback onTap,
  ) {
    return Material(
      color: surfaceColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primary, size: 30),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
