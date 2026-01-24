import 'package:flutter/material.dart';
import '../../config/app_constants.dart';

// Local Data Model for Tracking Timeline
class _TrackingStep {
  final String title;
  final String description;
  final String time;
  final bool isCompleted;
  final bool isCurrent;
  final Widget? extraContent; // For Courier info

  _TrackingStep({
    required this.title,
    required this.description,
    required this.time,
    this.isCompleted = false,
    this.isCurrent = false,
    this.extraContent,
  });
}

class OrderDetailCustomerPage extends StatefulWidget {
  const OrderDetailCustomerPage({super.key});

  @override
  State<OrderDetailCustomerPage> createState() => _OrderDetailCustomerPageState();
}

class _OrderDetailCustomerPageState extends State<OrderDetailCustomerPage> {
  
  late List<_TrackingStep> _steps;

  @override
  void initState() {
    super.initState();
    _steps = [
      _TrackingStep(
        title: 'Out for Delivery',
        description: 'Your package is on the way with our courier.',
        time: '13:45 PM',
        isCurrent: true,
        extraContent: _buildCourierInfo(),
      ),
      _TrackingStep(
        title: 'Departed from Hub',
        description: 'Jakarta Central Hub',
        time: '10:00 AM',
        isCompleted: true,
      ),
      _TrackingStep(
        title: 'Arrived at Warehouse',
        description: 'Jakarta Central Warehouse',
        time: 'Yesterday, 22:00',
        isCompleted: true,
      ),
      _TrackingStep(
        title: 'Order Placed',
        description: 'Online Store',
        time: 'Yesterday, 09:00',
        isCompleted: true,
      ),
    ];
  }

  Widget _buildCourierInfo() {
    // This widget needs access to context/theme, but we can return a builder or just structure it to be built in build()
    // For simplicity, we'll return a container and style it in the build method or use generic styles.
    // Instead of returning a Widget here that might need context, let's just use a flag or separate method in build.
    return Container(); 
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
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                        ),
                        child: Icon(Icons.arrow_back, color: textColor),
                      ),
                    ),
                  ),
                  Text('Order Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                    ),
                    child: Icon(Icons.support_agent, color: subTextColor),
                  ),
                ],
              ),
            ),
            
            // 2. Main Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Hero Status Card with Map
                    Container(
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          // Map Preview
                          SizedBox(
                            height: 128,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDdUNOyL083Orvk-TTsLhiwh470rjG33uwoA--CeU7THXaLJkOt1Zbm9JuwafDTgu6SZGL9gFq0JpElYlT3xMOq_T_niaPcjpxs8tJ-2psdbyGtaGAYafJyrAs0-mQspUr23qoYEFLeeuYbe9Xa_W9yiq8CjuRvW1fxEtal6h7aVG0cSI6g18gAxpIjc1ey7O6amYqZnYOMntSZTwDeZBYool0GiZFL0XjVaerviLUtZhteirvmWh56594MwAwf5O797Ct0F9JSsj4',
                                  fit: BoxFit.cover,
                                  color: Colors.white.withOpacity(0.8),
                                  colorBlendMode: BlendMode.modulate,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [surfaceColor, Colors.transparent],
                                    )
                                  ),
                                ),
                                Positioned(
                                  bottom: 16, left: 16,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8)],
                                    ),
                                    child: const Icon(Icons.local_shipping, color: Colors.black, size: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Card Content
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('TRACKING ID', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: subTextColor, letterSpacing: 0.5)),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text('LOGI-8839201', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                                            const SizedBox(width: 8),
                                            Icon(Icons.content_copy, size: 16, color: subTextColor),
                                          ],
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text('EST. ARRIVAL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: subTextColor, letterSpacing: 0.5)),
                                        const SizedBox(height: 4),
                                        const Text('Today, 16:00', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('On the way', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textColor)),
                                    Text('3 of 4 steps', style: TextStyle(fontSize: 12, color: subTextColor)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  height: 8,
                                  decoration: BoxDecoration(color: isDarkMode ? const Color(0xFF325e67) : Colors.grey.shade200, borderRadius: BorderRadius.circular(4)),
                                  child: FractionallySizedBox(
                                    widthFactor: 0.75,
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),

                    // Timeline Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Tracking History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _steps.length,
                      itemBuilder: (context, index) {
                        return _buildTimelineStep(_steps[index], index == _steps.length - 1, textColor, subTextColor, surfaceColor, isDarkMode);
                      },
                    ),

                    const SizedBox(height: 16),
                    
                    // Proof of Delivery Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                         border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.image, color: AppColors.primary, size: 20),
                                    const SizedBox(width: 8),
                                    Text('Proof of Delivery', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text('Status', style: TextStyle(fontSize: 12, color: subTextColor)),
                                Text('Pending Delivery', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
                                const SizedBox(height: 4),
                                Text('Photo will appear here upon arrival', style: TextStyle(fontSize: 12, color: isDarkMode ? const Color(0xFF587a81) : AppColors.textGray)),
                              ],
                            ),
                          ),
                          Container(
                            width: 80, height: 80,
                            decoration: BoxDecoration(
                               color: isDarkMode ? const Color(0xFF111f22) : Colors.grey.shade100,
                               borderRadius: BorderRadius.circular(8),
                               border: Border.all(color: isDarkMode ? const Color(0xFF325e67) : Colors.grey.shade300, style: BorderStyle.none), // dashed border hard in standard flutter without packages 
                            ),
                            child: const Icon(Icons.photo_camera, color: Colors.grey, size: 32),
                          )
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 80), // Bottom padding
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor.withOpacity(0.95),
          border: Border(top: BorderSide(color: borderColor)),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.backgroundDark,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text('Konfirmasi Terima Barang', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                 SizedBox(width: 8),
                 Icon(Icons.check_circle, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineStep(_TrackingStep step, bool isLast, Color textColor, Color subTextColor, Color surfaceColor, bool isDarkMode) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
           // Timeline Line & Dot
           SizedBox(
             width: 40,
             child: Column(
               children: [
                 Container(
                   width: 16, height: 16,
                   decoration: BoxDecoration(
                     color: step.isCurrent ? AppColors.primary : (step.isCompleted ? (isDarkMode ? const Color(0xFF325e67) : Colors.grey.shade300) : Colors.grey.shade200),
                     shape: BoxShape.circle,
                     // ring effect for current
                     border: step.isCurrent ? Border.all(color: isDarkMode ? AppColors.backgroundDark : Colors.white, width: 2) : null,
                     boxShadow: step.isCurrent ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 4)] : [],
                   ),
                   child: step.isCurrent ? Center(child: Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle))) : null,
                 ),
                 if (!isLast)
                   Expanded(
                     child: Container(
                       width: 2,
                       color: step.isCurrent ? AppColors.primary : (isDarkMode ? const Color(0xFF325e67) : Colors.grey.shade200),
                     ),
                   )
               ],
             ),
           ),
           // Content
           Expanded(
             child: Padding(
               padding: const EdgeInsets.only(bottom: 24, left: 4),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                    Text(step.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: step.isCurrent ? AppColors.primary : textColor.withOpacity(step.isCompleted || step.isCurrent ? 1 : 0.4))),
                    Text(step.description, style: TextStyle(fontSize: 14, color: isDarkMode ? (step.isCurrent ? const Color(0xFF92c0c9) : subTextColor) : Colors.grey[600] )),
                    
                    // Extra Content (Courier Info)
                    if (step.extraContent != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.05)),
                        ),
                        child: Row(
                          children: [
                             Container(
                               width: 40, height: 40,
                               decoration: BoxDecoration(
                                 color: Colors.grey.shade200,
                                 shape: BoxShape.circle,
                                 image: const DecorationImage(
                                   image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuAujIbPjH8524m9DcL-mNRCL0spYICOoNpx7AYp2TU8QUicMrHO8sclRH-s6oBAMqGPq9EMcmAVI-6MpH31X9n95y01HjGtaxjrz7Y086vlXSOTskAY2IkujfLu06PlOJpjtXqmleOgZlWWZkgTDz9SmzF0gtVgzHcjdb3CJ6gFonkNN5F1kRRfbOTi3kStTSXakgPTU5ogH01BLPTjNyr4mJl-PEp93qg7r4c1qSCKHaupU7sSIgJPqWECRjCz1_ia5LmGF4JiAOA'),
                                   fit: BoxFit.cover,
                                 ),
                               ),
                             ),
                             const SizedBox(width: 12),
                             Expanded(
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text('Budi Santoso', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                                   Row(
                                     children: [
                                        const Icon(Icons.star, size: 14, color: AppColors.textGray),
                                        const SizedBox(width: 2),
                                        Text('4.9 • Courier', style: TextStyle(fontSize: 12, color: subTextColor)),
                                     ],
                                   )
                                 ],
                               ),
                             ),
                             CircleAvatar(
                               backgroundColor: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.shade100,
                               radius: 18,
                               child: const Icon(Icons.call, color: AppColors.primary, size: 18),
                             )
                          ],
                        ),
                      )
                    ],

                    const SizedBox(height: 4),
                    Text(step.time, style: const TextStyle(fontSize: 12, color: AppColors.textGray, fontWeight: FontWeight.w500)),
                 ],
               ),
             ),
           )
        ],
      ),
    );
  }
}
