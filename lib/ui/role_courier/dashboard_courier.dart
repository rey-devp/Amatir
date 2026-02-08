import 'package:flutter/material.dart';
import '../../config/app_constants.dart';

// --- MODELS ---
class _CourierTask {
  final String id, name, description, status, address;
  final bool isPriority;
  final double distance;
  final IconData icon;
  final Color iconColor, iconBgColor;
  _CourierTask({required this.id, required this.name, required this.description, required this.status, required this.address, this.isPriority = false, required this.distance, required this.icon, required this.iconColor, required this.iconBgColor});
}

class DashboardCourier extends StatefulWidget {
  const DashboardCourier({super.key});

  @override
  State<DashboardCourier> createState() => _DashboardCourierState();
}

class _DashboardCourierState extends State<DashboardCourier> {
  bool _isOnline = true;
  final List<_CourierTask> _tasks = [
    _CourierTask(id: '1', name: 'Budi Santoso', description: 'Delivery', status: 'In Transit', isPriority: true, distance: 1.2, address: 'Jl. Melati No. 10', icon: Icons.local_shipping, iconColor: Colors.blue, iconBgColor: Colors.blue.withOpacity(0.1)),
    _CourierTask(id: '2', name: 'PT. Logistik Jaya', description: 'Gudang Utama', status: 'Pending', distance: 5.4, address: 'Kawasan Industri', icon: Icons.warehouse, iconColor: Colors.orange, iconBgColor: Colors.orange.withOpacity(0.1)),
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final backgroundColor = isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surfaceColor = isDarkMode ? AppColors.surfaceDark : Colors.white; // Use white if surfaceLight not defined
    final textColor = isDarkMode ? AppColors.textLight : AppColors.textDark;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: backgroundColor.withOpacity(0.95),
            pinned: true,
            title: const Text('Driver App'),
            actions: [
              Switch(value: _isOnline, onChanged: (val) => setState(() => _isOnline = val), activeColor: AppColors.primary)
            ],
          ),
          
          // Task List
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final task = _tasks[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    border: task.isPriority ? Border.all(color: AppColors.primary) : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text(task.name, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                           if(task.isPriority) const Chip(label: Text('Priority', style: TextStyle(fontSize: 10)), backgroundColor: AppColors.primary),
                         ],
                       ),
                       const SizedBox(height: 8),
                       Text(task.address, style: TextStyle(color: textColor.withOpacity(0.7))),
                       const SizedBox(height: 12),
                       ElevatedButton(
                         onPressed: (){},
                         style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                         child: const Text('Detail Tugas'),
                       )
                    ],
                  ),
                );
              },
              childCount: _tasks.length,
            ),
          )
        ],
      ),
    );
  }
}