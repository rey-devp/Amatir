import 'package:flutter/material.dart';
import '../../config/app_constants.dart';

// Local Data Model for Dashboard Items (Package List)
class _DashboardItem {
  final String id;
  final String origin;
  final String status;
  final IconData details1Icon;
  final String details1Text;
  final IconData details2Icon;
  final String details2Text;
  final IconData icon;
  final bool isProcessed;

  _DashboardItem({
    required this.id,
    required this.origin,
    required this.status,
    required this.details1Icon,
    required this.details1Text,
    required this.details2Icon,
    required this.details2Text,
    required this.icon,
    this.isProcessed = false,
  });
}

// Local Data Model for Stats Cards
class _StatItem {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;
  final IconData trendIcon;

  _StatItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.trend,
    required this.trendIcon,
  });
}

// Local Data Model for Tabs
class _TabItem {
  final String label;
  final String count;
  final bool isActive;

  _TabItem({
    required this.label,
    required this.count,
    this.isActive = false,
  });
}

class DashboardWarehousePage extends StatefulWidget {
  const DashboardWarehousePage({super.key});

  @override
  State<DashboardWarehousePage> createState() => _DashboardWarehousePageState();
}

class _DashboardWarehousePageState extends State<DashboardWarehousePage> {
  // Dummy Data List: Stats
  final List<_StatItem> _statItems = [
    _StatItem(
      title: 'Incoming',
      value: '142',
      icon: Icons.input,
      color: AppColors.primary,
      trend: '+12%',
      trendIcon: Icons.trending_up,
    ),
    _StatItem(
      title: 'Outgoing',
      value: '89',
      icon: Icons.output,
      color: AppColors.purple,
      trend: 'On Track',
      trendIcon: Icons.trending_flat,
    ),
  ];

  // Dummy Data List: Tabs
  final List<_TabItem> _tabItems = [
    _TabItem(label: 'Incoming', count: '12', isActive: true),
    _TabItem(label: 'Outgoing', count: '', isActive: false),
    _TabItem(label: 'History', count: '', isActive: false),
  ];

  // Dummy Data List: Packages
  final List<_DashboardItem> _dashboardItems = [
    _DashboardItem(
      id: '#LOG-9921',
      origin: 'Shanghai',
      status: 'Pending',
      details1Icon: Icons.inventory_2_outlined,
      details1Text: '12 Boxes',
      details2Icon: Icons.schedule,
      details2Text: 'Arriving in 2h',
      icon: Icons.local_shipping_outlined,
    ),
    _DashboardItem(
      id: '#TRK-8821',
      origin: 'New York',
      status: 'Pending',
      details1Icon: Icons.layers_outlined,
      details1Text: '2 Pallets',
      details2Icon: Icons.schedule,
      details2Text: 'Arriving in 4h',
      icon: Icons.flight_land,
    ),
    _DashboardItem(
      id: '#LOG-3321',
      origin: 'Berlin',
      status: 'Pending',
      details1Icon: Icons.category_outlined,
      details1Text: '5 Crates',
      details2Icon: Icons.schedule,
      details2Text: 'Delayed',
      icon: Icons.local_shipping_outlined,
    ),
    _DashboardItem(
      id: '#LOG-1029',
      origin: 'Tokyo',
      status: 'Processed',
      details1Icon: Icons.check_circle_outline,
      details1Text: '',
      details2Icon: Icons.access_time,
      details2Text: '',
      icon: Icons.check_circle_outline,
      isProcessed: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Determine Theme Mode based on System
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    // Define Local Colors based on Theme or AppColors
    final backgroundColor = isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surfaceColor = isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textColor = isDarkMode ? AppColors.textLight : AppColors.textDark;
    final subTextColor = isDarkMode ? AppColors.textGrayDark : AppColors.textGray;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          // 1. Header (Sticky)
          SliverAppBar(
            backgroundColor: backgroundColor.withOpacity(0.95), // Glassmorphism-like
            pinned: true,
            elevation: 0,
            toolbarHeight: 80,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Profile Pic
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        image: const DecorationImage(
                          image: NetworkImage(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuCkvrh8fD0M4uyC0zr26yuDagU0xdZlHxhutihWa9akj60HeCCXw7dsoo0HgauwuaTBMxXctIRjy6U4QigRfmgaOlyb-jCmLNP4XA5ty9NX-E4Hl9nkpmJh5h-E0XRy6_CBR-QNfIbyTh01KnbEsPUbqxzvdpntkXSiAQpvkUHWxmkWFQ8z1FUJT417Ava8K4h55GmcEV87huSBpbuji_jdxQ6SUnGps6FjWf7YzZ_bmDjogAme89ijNfcbiu80pa1o-yc_2WFEcx4'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good Morning,',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500, color: subTextColor),
                        ),
                        Text(
                          'Warehouse 4',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
                        ),
                      ],
                    ),
                  ],
                ),
                // Notification Button
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), spreadRadius: 1),
                    ],
                  ),
                  child: Icon(Icons.notifications_outlined, color: subTextColor),
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
                    'OCT 24, 2023',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 2. Stats Grid (Dynamic from List)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverToBoxAdapter(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.4,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _statItems.length,
                itemBuilder: (context, index) {
                  final stat = _statItems[index];
                  return _buildStatCard(
                    title: stat.title,
                    value: stat.value,
                    icon: stat.icon,
                    color: stat.color,
                    trend: stat.trend,
                    trendIcon: stat.trendIcon,
                    surfaceColor: surfaceColor,
                    textColor: textColor,
                    subTextColor: subTextColor,
                  );
                },
              ),
            ),
          ),

          // 3. Tabs (Sticky & Dynamic from List)
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabHeaderDelegate(
              minHeight: 60,
              maxHeight: 60,
              child: Container(
                color: backgroundColor, // Background to cover content when scrolling under
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    for (int i = 0; i < _tabItems.length; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      Expanded(
                        child: _buildTabButton(
                          _tabItems[i].label,
                          _tabItems[i].count,
                          _tabItems[i].isActive,
                          surfaceColor,
                          // If active, use textColor, else subTextColor
                          _tabItems[i].isActive ? textColor : subTextColor,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),

          // 4. List Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pending Arrivals',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_list, size: 18, color: AppColors.primary),
                    label: const Text('Filter',
                        style:
                            TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  ),
                ],
              ),
            ),
          ),

          // 5. Package List (Dynamic from List)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100), // Bottom padding for FAB
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = _dashboardItems[index];
                  return Column(
                    children: [
                      _buildPackageCard(
                        id: item.id,
                        origin: item.origin,
                        status: item.status,
                        details1Icon: item.details1Icon,
                        details1Text: item.details1Text,
                        details2Icon: item.details2Icon,
                        details2Text: item.details2Text,
                        surfaceColor:
                            item.isProcessed ? surfaceColor.withOpacity(0.5) : surfaceColor,
                        textColor: item.isProcessed ? subTextColor : textColor,
                        subTextColor: subTextColor,
                        icon: item.icon,
                        isProcessed: item.isProcessed,
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                },
                childCount: _dashboardItems.length,
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: SizedBox(
        width: 64,
        height: 64,
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: AppColors.primary,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child:
              const Icon(Icons.qr_code_scanner, size: 32, color: AppColors.backgroundDark),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

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
                _buildNavItem(Icons.dashboard, 'Dash', true),
                _buildNavItem(Icons.inventory, 'Inventory', false),
                const SizedBox(width: 40), // Spacer for FAB breathing room
                _buildNavItem(Icons.calendar_month, 'Schedule', false),
                _buildNavItem(Icons.settings, 'Settings', false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String trend,
    required IconData trendIcon,
    required Color surfaceColor,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Opacity(
              opacity: 0.1,
              child: Icon(icon, size: 48, color: color),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text(title,
                      style: TextStyle(
                          color: subTextColor, fontWeight: FontWeight.w500, fontSize: 13)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value,
                      style: TextStyle(
                          color: textColor, fontWeight: FontWeight.bold, fontSize: 28)),
                  Row(
                    children: [
                      Icon(trendIcon, size: 14, color: AppColors.success),
                      const SizedBox(width: 4),
                      Text(trend,
                          style: const TextStyle(
                              color: AppColors.success, fontWeight: FontWeight.w600, fontSize: 11)),
                    ],
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, String count, bool isActive, Color surfaceColor, Color targetTextColor) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: isActive ? surfaceColor : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        boxShadow: isActive
            ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2)]
            : [],
        border: isActive ? null : Border.all(color: Colors.transparent),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label,
                  style: TextStyle(
                    color: targetTextColor,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    fontSize: 13,
                  )),
              if (count.isNotEmpty) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color:
                        isActive ? AppColors.primary.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(count,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isActive ? AppColors.primary : AppColors.textGray,
                      )),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPackageCard({
    required String id,
    required String origin,
    required String status,
    required IconData details1Icon,
    required String details1Text,
    required IconData details2Icon,
    required String details2Text,
    required Color surfaceColor,
    required Color textColor,
    required Color subTextColor,
    required IconData icon,
    bool isProcessed = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: isProcessed
            ? Border.all(
                color: Colors.grey.withOpacity(0.2),
                style: BorderStyle.solid) // Dashed border needs custom painter
            : Border.all(color: Colors.grey.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: subTextColor),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        id,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          decoration:
                              isProcessed ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      Text.rich(TextSpan(
                          text: 'Origin: ',
                          style: TextStyle(fontSize: 12, color: subTextColor),
                          children: [
                            TextSpan(
                                text: origin,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color:
                                        isProcessed ? subTextColor : textColor)),
                          ])),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isProcessed
                      ? Colors.grey.withOpacity(0.1)
                      : AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: isProcessed
                          ? Colors.grey.withOpacity(0.2)
                          : AppColors.warning.withOpacity(0.2)),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isProcessed
                        ? subTextColor
                        : Colors.amber[800], // Darker amber for visibility
                  ),
                ),
              ),
            ],
          ),
          if (!isProcessed) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(details1Icon, size: 16, color: subTextColor),
                        const SizedBox(width: 4),
                        Text(details1Text,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: textColor)),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        Icon(details2Icon, size: 16, color: subTextColor),
                        const SizedBox(width: 4),
                        Text(details2Text,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: textColor)),
                      ],
                    ),
                  ],
                ),
                Icon(Icons.more_horiz, color: subTextColor),
              ],
            ),
          ]
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

class _SliverTabHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverTabHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverTabHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
