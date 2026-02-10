import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/app_constants.dart';

class DeliveryExecutionPage extends StatefulWidget {
  const DeliveryExecutionPage({super.key});

  @override
  State<DeliveryExecutionPage> createState() => _DeliveryExecutionPageState();
}

class _DeliveryExecutionPageState extends State<DeliveryExecutionPage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
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
            // 1. Header
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
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                        ),
                        child: Icon(Icons.close, color: textColor),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Konfirmasi Pengiriman',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                   TextButton(
                     onPressed: () => Navigator.of(context).pop(),
                     child: Text(
                       'Batal',
                       style: TextStyle(
                         color: isDarkMode ? const Color(0xFF92c0c9) : Colors.red,
                         fontWeight: FontWeight.bold,
                         fontSize: 16
                       ),
                     ),
                   )
                ],
              ),
            ),
            
            // 2. Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Camera Viewport Section
                    Stack(
                      children: [
                         AspectRatio(
                           aspectRatio: 4/5,
                           child: Container(
                             color: Colors.black,
                             child: Stack(
                               fit: StackFit.expand,
                               children: [
                                 // Camera Preview Placeholder
                                 Image.network(
                                   'https://lh3.googleusercontent.com/aida-public/AB6AXuBblXj8OQhaFytkbFcPK9_ekVbrtWT0pjjnNQVee1Ate-RcmcJhj2TkoNnzrg43ss7r9kIoqyyWo4_9TUJbDl_-SP-N6r4Fr6CNLN-a96eewqkBzkWikE4bKYQnV-qNjk06AjZMSCjkd6cpLH8uqo2wpnu2dLFw3IUYXpieMqsOL-arXpqsBPsagr5yaqjHBow-MX4t8gGy-axfU4lz6GJUHmFp3Az-An2qiMY9CNpdPPX2tFIxJFzaDa0HoR8rXtRXN6Iu4hjA6Ew',
                                   fit: BoxFit.cover,
                                   color: Colors.white.withOpacity(0.8),
                                   colorBlendMode: BlendMode.modulate,
                                 ),
                                 // Viewfinder Guides
                                 Positioned(top: 32, left: 32, child: _buildCornerGuide(true, true)),
                                 Positioned(top: 32, right: 32, child: _buildCornerGuide(true, false)),
                                 Positioned(bottom: 32, left: 32, child: _buildCornerGuide(false, true)),
                                 Positioned(bottom: 32, right: 32, child: _buildCornerGuide(false, false)),
                                 
                                 // Camera Controls Overlay
                                 Positioned(
                                   bottom: 0, left: 0, right: 0,
                                   child: Container(
                                     padding: const EdgeInsets.all(24),
                                     decoration: BoxDecoration(
                                       gradient: LinearGradient(
                                         begin: Alignment.bottomCenter,
                                         end: Alignment.topCenter,
                                         colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                                       )
                                     ),
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                          _buildIconBtn(Icons.photo_library),
                                          const SizedBox(width: 32),
                                          // Shutter Button
                                          GestureDetector(
                                            onTap: () => _pickImage(ImageSource.camera),
                                            child: Container(
                                              width: 80, height: 80,
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(color: Colors.white, width: 4),
                                              ),
                                              child: Container(
                                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 32),
                                          _buildIconBtn(Icons.cameraswitch),
                                       ],
                                     ),
                                   ),
                                 ),

                                 // Flash Indicator
                                 Positioned(
                                   top: 16, left: 0, right: 0,
                                   child: Center(
                                     child: Container(
                                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                       decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(20)),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.bolt, color: AppColors.primary, size: 16),
                                            SizedBox(width: 4),
                                            Text('Flash Auto', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                     ),
                                   ),
                                 )
                               ],
                             ),
                           ),
                         ),
                      ],
                    ),

                    // Captured Content & Details
                    Container(
                      margin: const EdgeInsets.only(top: 0), // Negative margin visually in HTML, here just stacking naturally
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -4))],
                      ),
                      child: Column(
                        children: [
                             // Handle Bar
                             Center(
                               child: Container(
                                 margin: const EdgeInsets.symmetric(vertical: 16),
                                 width: 48, height: 6,
                                 decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(3)),
                               ),
                             ),
                             Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 16),
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     crossAxisAlignment: CrossAxisAlignment.end,
                                     children: [
                                       Text('Bukti Foto', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
                                       const Text('1 Foto diambil', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                     ],
                                   ),
                                   const SizedBox(height: 16),
                                   Row(
                                     children: [
                                       // Captured Image
                                       Container(
                                         width: 96, height: 96,
                                         decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: AppColors.primary, width: 2),
                                            image: _imageFile != null
                                              ? DecorationImage(
                                                  image: FileImage(_imageFile!),
                                                  fit: BoxFit.cover,
                                                )
                                              : const DecorationImage(
                                                  image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuCIERXAXF99M5n8rOUVZFow5TAGilV5ybjwmSKVeeBl3Prwja3EOXuHB9wGIk0KCqGtZbvonwzPQC-f5GvPLZy_lsWaW_OGHoGjM64t7GTXW1q_RoCHUD-bO-WIw_9gOV09txmsp4j6OFJLm3wpWZy3B_EJfeqouFdxW5R9pmjY3U3FrtC04j_xSepO82ZRHSy2kxDyMOH9YFc1FjBAv47ozQtMpZOT1Zmq4VoDZ3eD0LKW3UTojZtwbp7_8BDEQV5CvzWd3mm1mDM'),
                                                  fit: BoxFit.cover,
                                                )
                                         ),
                                         child: Stack(
                                           children: [
                                             if (_imageFile != null)
                                             Positioned(
                                               top: 4, right: 4,
                                               child: Container(
                                                 padding: const EdgeInsets.all(2),
                                                 decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                                 child: const Icon(Icons.check, color: Colors.white, size: 12),
                                               ),
                                             )
                                           ],
                                         ),
                                       ),
                                       const SizedBox(width: 12),
                                       // Add Button
                                       GestureDetector(
                                         onTap: () => _pickImage(ImageSource.gallery),
                                         child: Container(
                                           width: 96, height: 96,
                                           decoration: BoxDecoration(
                                             color: isDarkMode ? AppColors.surfaceDark : Colors.white,
                                             borderRadius: BorderRadius.circular(8),
                                             border: Border.all(color: Colors.grey.withOpacity(0.3), style: BorderStyle.solid), // Dashed manually difficult, using solid
                                           ),
                                           child: Column(
                                             mainAxisAlignment: MainAxisAlignment.center,
                                             children: [
                                                Icon(Icons.add_a_photo, color: subTextColor, size: 28),
                                                const SizedBox(height: 4),
                                                Text('Tambah', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: subTextColor)),
                                             ],
                                           ),
                                         ),
                                       )
                                     ],
                                   ),
                                   const SizedBox(height: 16),
                                   Divider(color: Colors.grey.withOpacity(0.2)),
                                   const SizedBox(height: 16),
                                   
                                   // GPS Location Card
                                   Container(
                                     padding: const EdgeInsets.all(12),
                                     decoration: BoxDecoration(
                                       color: surfaceColor,
                                       borderRadius: BorderRadius.circular(12),
                                       border: Border.all(color: Colors.grey.withOpacity(0.1)),
                                       boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
                                     ),
                                     child: Row(
                                       children: [
                                         Container(
                                           width: 40, height: 40,
                                           decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                           child: const Icon(Icons.location_on, color: AppColors.primary),
                                         ),
                                         const SizedBox(width: 12),
                                         Expanded(
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                                Row(
                                                  children: [
                                                    Text('Lokasi Terkini', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
                                                    const SizedBox(width: 6),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                                      decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.green.withOpacity(0.2))),
                                                      child: const Text('Akurat', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green)),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(height: 2),
                                                Text('-6.917, 107.619', style: TextStyle(fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.w500, color: isDarkMode ? const Color(0xFF92c0c9) : AppColors.textGray)),
                                             ],
                                           ),
                                         ),
                                         // Mini Map
                                         Container(
                                           width: 48, height: 48,
                                           decoration: BoxDecoration(
                                             borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Colors.grey.withOpacity(0.2)),
                                              image: const DecorationImage(
                                                image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuD4BAwE_R_s8aM9GE57Ld5Q8rIuuyUeSP5tc8D12IIdK0yEXphSTJ_bpl_G9o4vZt5SuMUvt8hcNW_HxTHVOsijF7MDOTYbtEO5kOKQ6moqqPZrWrrlYjmbDfi2tPeRCvwwqvzRC_GeXImg5swJawwTNyQ7GtC_J3S0MNI492xONm3Z0hfq0SiPBZLz8s1Xl2nJsehCKQSn1IlyN7h2rD1yC83FkqxTTlCDdf5Cx3ZxYCVGip_07HXvu4aGWgkEjK0M_sYqXA-LKE8'),
                                                fit: BoxFit.cover,
                                              )
                                           ),
                                           child: Center(
                                             child: Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle, border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 4))),
                                           ),
                                         )
                                       ],
                                     ),
                                   ),
                                   
                                   const SizedBox(height: 16),
                                   
                                   // Note Input
                                   Text('Catatan Tambahan (Opsional)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: subTextColor)),
                                   const SizedBox(height: 6),
                                   Stack(
                                     children: [
                                       TextField(
                                         maxLines: 3,
                                         decoration: InputDecoration(
                                           hintText: 'Contoh: Paket ditaruh di pos satpam...',
                                           hintStyle: TextStyle(color: subTextColor.withOpacity(0.5)),
                                           filled: true,
                                           fillColor: surfaceColor,
                                           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.withOpacity(0.2))),
                                           enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.withOpacity(0.2))),
                                           focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
                                            contentPadding: const EdgeInsets.all(16),
                                         ),
                                       ),
                                       Positioned(
                                          bottom: 12, right: 12,
                                          child: Icon(Icons.edit_note, color: subTextColor, size: 20),
                                       )
                                     ],
                                   ),
                                   
                                   const SizedBox(height: 100), // Space for fixed button
                                 ],
                               ),
                             ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomSheet: Container(
        color: backgroundColor.withOpacity(0.95), // Slight transparency for glass effect
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: (){}, 
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.backgroundDark,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              elevation: 4,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Icon(Icons.send, size: 20),
                 SizedBox(width: 8),
                 Text('Kirim Bukti & Selesai', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCornerGuide(bool isTop, bool isLeft) {
    return Container(
      width: 16, height: 16,
      decoration: BoxDecoration(
        border: Border(
           top: isTop ? const BorderSide(color: AppColors.primary, width: 2) : BorderSide.none,
           bottom: !isTop ? const BorderSide(color: AppColors.primary, width: 2) : BorderSide.none,
           left: isLeft ? const BorderSide(color: AppColors.primary, width: 2) : BorderSide.none,
           right: !isLeft ? const BorderSide(color: AppColors.primary, width: 2) : BorderSide.none,
        )
      ),
    );
  }

  Widget _buildIconBtn(IconData icon) {
    return Container(
      width: 48, height: 48,
      decoration: BoxDecoration(
         color: Colors.white.withOpacity(0.1),
         shape: BoxShape.circle,
         border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
