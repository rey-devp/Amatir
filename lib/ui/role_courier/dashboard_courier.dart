import 'package:flutter/material.dart';
import '../../config/app_constants.dart';

// Local Data Model for Courier Tasks
// Local Data Model matching API Contract Response for getAssignedTasks
class _CourierTask {
  final String id;
  final String recipientName; // Contract: recipientName
  final String address;
  final double distance;
  final bool isPriority;
  final String status;
  // Extra fields for UI (assuming Backend will provide or we derive)
  final String description; 
  final String? time;
  final String? paymentStatus;
  final IconData icon; // Derived from description/status in fromMap
  final Color iconColor;
  final Color iconBgColor;

  _CourierTask({
    required this.id,
    required this.recipientName,
    required this.address,
    required this.distance,
    required this.isPriority,
    required this.status,
    required this.description,
    this.time,
    this.paymentStatus,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });

  factory _CourierTask.fromMap(Map<String, dynamic> map) {
    // Deriving UI properties
    IconData icon = Icons.local_shipping;
    Color iconColor = Colors.blue;
    Color iconBgColor = Colors.blue.withOpacity(0.1);

    if (map['isPriority'] == true) {
      iconColor = Colors.red;
      iconBgColor = Colors.red.withOpacity(0.1);
    } 
    
    // Simple logic to vary icons/colors based on description/mock data
    // In real app, this might come from 'type' field
    
    return _CourierTask(
      id: map['id'] ?? '',
      recipientName: map['recipientName'] ?? 'Unknown',
      address: map['address'] ?? '',
      distance: (map['distance'] as num?)?.toDouble() ?? 0.0,
      isPriority: map['isPriority'] ?? false,
      status: map['status'] ?? 'Pending',
      description: map['description'] ?? 'Package Delivery', 
      time: map['time'], // Optional in contract
      paymentStatus: map['paymentStatus'], // Optional in contract
      icon: icon,
      iconColor: iconColor,
      iconBgColor: iconBgColor,
    );
  }
}

class DashboardCourierPage extends StatefulWidget {
  const DashboardCourierPage({super.key});

  @override
  State<DashboardCourierPage> createState() => _DashboardCourierPageState();
}

class _DashboardCourierPageState extends State<DashboardCourierPage> {
  bool _isOnline = true;
  int _selectedIndex = 0;

  // Dummy Data
  // MOCK RAW RESPONSE from CourierProvider.getAssignedTasks()
  final List<Map<String, dynamic>> _mockApiResponse = [
    {
      'id': '1',
      'recipientName': 'Budi Santoso',
      'description': 'Delivery',
      'status': 'In Transit',
      'isPriority': true,
      'distance': 1.2,
      'address': 'Jl. Melati No. 10, RT 05/RW 02, Cilandak, Jakarta Selatan',
    },
    {
      'id': '2',
      'recipientName': 'PT. Logistik Jaya',
      'description': 'Gudang Utama A',
      'status': 'Pending',
      'isPriority': false,
      'distance': 5.4,
      'address': 'Kawasan Industri Pulogadung, Jakarta Timur',
      'time': '10:30 AM',
    },
    {
      'id': '3',
      'recipientName': 'Siti Aminah',
      'description': 'Paket Regular',
      'status': 'Pending',
      'isPriority': false,
      'distance': 8.0,
      'address': 'Apartemen City Park, Tower B, Cengkareng',
      'paymentStatus': 'Pre-paid',
    },
  ];

  late List<_CourierTask> _tasks;

  @override
  void initState() {
    super.initState();
    // Simulate parsing data from Provider
    _tasks = _mockApiResponse.map((json) => _CourierTask.fromMap(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

     // Colors
    final backgroundColor = isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surfaceColor = isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textColor = isDarkMode ? AppColors.textLight : AppColors.textDark;
    final subTextColor = isDarkMode ? AppColors.textGrayDark : AppColors.textGray;
    final borderColor = isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05);

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
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.withOpacity(0.3), width: 2),
                    image: const DecorationImage(
                      image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuDhWV2TmOi56jV4Uyi1rUn9sfnqVuJoDnpeyO0Qhgx_BENGSZjD0lv-IpAnEyXFJH9Gw_80ygPZgsKHwqC3o2_gy75LVGQFkKY01-bjmKMBnOGiq6D5nlIKGQZQShye9VRIixzT21RiOftmFv2nazScQ-40NjGxrKrR9ytUvaDv-yrsiduwwJUTp3SKKyXHbGh1s9rL--JWTJGV4uRTEe2n27O-AHZ_1ANRQVVpVl_mqHWnuD5szquNyOVR7J3YleJfXyqIs41XYVg'),
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
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  width: 40, 
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.surfaceDark : Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    children: [
                      Center(child: Icon(Icons.notifications_outlined, color: subTextColor)),
                      Positioned(
                        top: 10, right: 10,
                        child: Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle, border: Border.all(color: surfaceColor, width: 1.5))),
                      )
                    ],
                  ),
                ),
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
                            boxShadow: _isOnline ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2)] : [],
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
                            boxShadow: !_isOnline ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2)] : [],
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

          // 3. Summary Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1a2c32), // Fixed dark surface for card
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
                ),
                child: Stack(
                  children: [
                    Positioned(right: -24, top: -24, child: Container(width: 128, height: 128, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle))),
                    Positioned(right: 40, bottom: 0, child: Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), shape: BoxShape.circle))),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Halo, Budi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textGrayDark)),
                                const SizedBox(height: 4),
                                const Text('Tugas Hari Ini: 5 Paket', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                              ],
                            ),
                            Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.2), shape: BoxShape.circle),
                              child: const Icon(Icons.local_shipping, color: AppColors.primary),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             const Text('PROGRESS HARIAN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textGrayDark)),
                             const Text('40%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 10,
                          width: double.infinity,
                          decoration: BoxDecoration(color: const Color(0xFF325e67), borderRadius: BorderRadius.circular(5)),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: 0.4,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary, 
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.5), blurRadius: 6)],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text('2 dari 5 pengiriman selesai', style: TextStyle(fontSize: 12, color: AppColors.textGrayDark)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),

          // 4. Task List Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Daftar Pengiriman', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                  TextButton(onPressed: (){}, child: const Text('Lihat Semua', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
          ),

          // 5. Task List
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final task = _tasks[index];
                if (task.isPriority) {
                  return _buildActiveTaskCard(task, surfaceColor, textColor, subTextColor, isDarkMode);
                } else {
                  return _buildPendingTaskCard(task, surfaceColor, textColor, subTextColor, isDarkMode);
                }
              },
              childCount: _tasks.length,
            ),
          ),

          // Bottom Padding
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
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
                _buildNavItem(Icons.dashboard, 'Dashboard', true),
                _buildNavItem(Icons.map, 'Map', false),
                _buildNavItem(Icons.history, 'Riwayat', false),
                _buildNavItem(Icons.settings, 'Akun', false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTaskCard(_CourierTask task, Color surfaceColor, Color textColor, Color subTextColor, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1),
      ),
      child: Stack(
        children: [
          Positioned(left: 0, top: 0, bottom: 0, child: Container(width: 4, decoration: const BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.horizontal(left: Radius.circular(16))))),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Container(
                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                       decoration: BoxDecoration(color: Colors.blue.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                       child: const Row(
                         children: [
                            Icon(Icons.circle, size: 8, color: Colors.blue),
                            SizedBox(width: 6),
                            Text('In Transit', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue)),
                         ],
                       ),
                     ),
                     const Text('Priority', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(task.recipientName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.near_me, size: 16, color: subTextColor),
                    const SizedBox(width: 4),
                    Text('${task.distance} km', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: subTextColor)),
                    const SizedBox(width: 8),
                    Container(width: 4, height: 4, decoration: BoxDecoration(color: subTextColor, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(task.description, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: subTextColor)),
                  ],
                ),
                 const SizedBox(height: 12),
                 Container(
                   padding: const EdgeInsets.all(12),
                   decoration: BoxDecoration(
                     color: isDarkMode ? const Color(0xFF111f22) : Colors.grey[50], // Slightly lighter/darker bg
                     borderRadius: BorderRadius.circular(12),
                   ),
                   child: Row(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                        const Icon(Icons.location_on, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(task.address, style: TextStyle(fontSize: 13, color: textColor, height: 1.4))),
                     ],
                   ),
                 ),
                 const SizedBox(height: 16),
                 Row(
                   children: [
                     Container(
                       width: 44, height: 44,
                       decoration: BoxDecoration(color: isDarkMode ? const Color(0xFF234248) : Colors.grey[200], borderRadius: BorderRadius.circular(12)),
                       child: Icon(Icons.call, color: textColor),
                     ),
                     const SizedBox(width: 12),
                     Expanded(
                       child: ElevatedButton(
                         onPressed: (){
                           Navigator.pushNamed(context, '/courier-delivery-execution');
                         },
                         style: ElevatedButton.styleFrom(
                           backgroundColor: AppColors.primary,
                           foregroundColor: Colors.black, // Dark text on primary button
                           elevation: 4,
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
                 )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingTaskCard(_CourierTask task, Color surfaceColor, Color textColor, Color subTextColor, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: task.iconBgColor, borderRadius: BorderRadius.circular(8)),
                    child: Icon(task.icon, color: task.iconColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.recipientName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
                      Text(task.description, style: TextStyle(fontSize: 12, color: subTextColor)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: Text('Pending', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: subTextColor)),
              )
            ],
          ),
          const SizedBox(height: 12),
          DottedDivider(color: Colors.grey.withOpacity(0.2)), // Helper custom widget or simple divider
          const SizedBox(height: 12),
          Row(
            children: [
               Row(
                 children: [
                    Icon(Icons.near_me, size: 16, color: subTextColor),
                    const SizedBox(width: 4),
                    Text('${task.distance} km', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textColor)),
                 ],
               ),
               Container(height: 12, width: 1, color: Colors.grey.withOpacity(0.3), margin: const EdgeInsets.symmetric(horizontal: 12)),
               if (task.time != null)
                 Row(
                   children: [
                      Icon(Icons.schedule, size: 16, color: subTextColor),
                      const SizedBox(width: 4),
                      Text(task.time!, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: subTextColor)),
                   ],
                 ),
               if (task.paymentStatus != null)
                 Row(
                   children: [
                      Icon(Icons.payments, size: 16, color: subTextColor),
                      const SizedBox(width: 4),
                      Text(task.paymentStatus!, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: subTextColor)),
                   ],
                 ),
            ],
          ),
          const SizedBox(height: 12),
           Row(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Icon(Icons.location_on, size: 18, color: subTextColor),
               const SizedBox(width: 4),
               Expanded(child: Text(task.address, style: TextStyle(fontSize: 12, color: subTextColor), maxLines: 1, overflow: TextOverflow.ellipsis)),
             ],
           ),
           const SizedBox(height: 16),
           SizedBox(
             width: double.infinity,
             child: ElevatedButton(
               onPressed: (){}, 
               style: ElevatedButton.styleFrom(
                 backgroundColor: isDarkMode ? const Color(0xFF234248) : Colors.black87,
                 foregroundColor: Colors.white,
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                 padding: const EdgeInsets.symmetric(vertical: 10),
               ),
               child: const Text('Ambil Tugas', style: TextStyle(fontWeight: FontWeight.bold)),
             ),
           )
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

class DottedDivider extends StatelessWidget {
  final Color color;
  const DottedDivider({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 6.0;
        final dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
