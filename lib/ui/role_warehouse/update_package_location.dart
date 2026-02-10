import 'package:flutter/material.dart';
import '../../config/app_constants.dart';

class UpdatePackageLocationPage extends StatefulWidget {
  const UpdatePackageLocationPage({super.key});

  @override
  State<UpdatePackageLocationPage> createState() => _UpdatePackageLocationPageState();
}

class _UpdatePackageLocationPageState extends State<UpdatePackageLocationPage> {
  final TextEditingController _resiController = TextEditingController(text: 'JP-882190');
  
  // Dummy Data for Dropdowns
  final List<Map<String, String>> _locations = [
    {'value': 'gudang-jkt', 'label': 'Gudang Jakarta (Cakung)'},
    {'value': 'hub-bdg', 'label': 'Hub Bandung'},
    {'value': 'hub-smg', 'label': 'Hub Semarang'},
    {'value': 'hub-sby', 'label': 'Hub Surabaya'},
  ];

  final List<Map<String, String>> _statuses = [
    {'value': 'inbound', 'label': 'Barang Diterima (Inbound)'},
    {'value': 'sorting', 'label': 'Dalam Penyortiran (Sorting)'},
    {'value': 'outbound', 'label': 'Siap Dikirim (Outbound)'},
    {'value': 'issue', 'label': 'Issue / Hold'},
  ];

  String? _selectedLocation;
  String? _selectedStatus;

  bool _isLoading = false;

  // Mock Package Data (Simulating result from searching Resi)
  final Map<String, dynamic> _packageData = {
    'resi': 'JP-882190',
    'currentLocation': 'Hub Surabaya',
    'status': 'On Process',
    'statusColor': Colors.amber[800],
    'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAvMshxZtKPsHx5gAsriWQDYlfijb7Q6p0r_LTF7BWQ345ytKX8kJrQpW8ZQvUEMxnfk_k63nNTX2VQA_-8VtoKJ9qkUiaavoQul6SGKXBuyzNJf5MMS-EmZyiwEntklECg0ef74__zFO7fn6omyTNk7qfBAS3Zr2X0wzl0r3I3mq4kM_rkNvlA0socUVGDCbgCebCACOh9uKwYKqAMYJMw2LO9IWNdrd41fnOaqLeWGuwZvqXBckTsV7-l2XAX5o6z82VZXO7g-LE'
  };

  @override
  void initState() {
    super.initState();
    // Default values if needed, or leave null for "Pilih..."
  }

  Future<void> _submitUpdate() async {
    if (_resiController.text.isEmpty || _selectedLocation == null || _selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap lengkapi semua data!'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API Call delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isLoading = false);
      // Success Feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lokasi paket berhasil diupdate!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context); // Optional: Go back to dashboard
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surfaceColor = isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textColor = isDarkMode ? AppColors.textLight : AppColors.textDark;
    final subTextColor = isDarkMode ? AppColors.textGrayDark : AppColors.textGray;
    final borderColor = isDarkMode ? AppColors.inputBorderDark : AppColors.inputBorder; // Using input border color for generic borders

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
             // 1. Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
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
                        child: Icon(Icons.arrow_back, color: textColor),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Update Lokasi',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Balance the back button
                ],
              ),
            ),
            
            Divider(height: 1, color: borderColor.withOpacity(0.5)),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. Input Section
                    Text(
                      'Nomor Resi',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: subTextColor),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(0, 1))
                        ],
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _resiController,
                              style: TextStyle(fontSize: 16, color: textColor),
                              decoration: InputDecoration(
                                hintText: 'Input ID or Scan...',
                                hintStyle: TextStyle(color: subTextColor.withOpacity(0.7)),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              ),
                            ),
                          ),
                          Container(width: 1, height: 48, color: borderColor),
                          InkWell(
                            onTap: (){},
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              height: 48,
                              decoration: BoxDecoration(
                                color: isDarkMode ? AppColors.surfaceDark : Colors.grey[50],
                                borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                              ),
                              child: const Icon(Icons.qr_code_scanner, color: AppColors.textGray, size: 24),
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 3. Package Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor.withOpacity(0.5)),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('RECEIPT ID', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: subTextColor, letterSpacing: 0.5)),
                                Text(_packageData['resi'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                const SizedBox(height: 8),
                                Divider(height: 1, color: borderColor.withOpacity(0.5)),
                                const SizedBox(height: 8),
                                Text('Lokasi Saat Ini:', style: TextStyle(fontSize: 12, color: subTextColor)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, size: 18, color: AppColors.primary),
                                    const SizedBox(width: 4),
                                    Text(_packageData['currentLocation'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text('Status:', style: TextStyle(fontSize: 12, color: subTextColor)),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.warning.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(_packageData['status'], style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _packageData['statusColor'])),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(_packageData['imageUrl']),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(color: borderColor.withOpacity(0.5)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    Divider(height: 1, color: borderColor.withOpacity(0.5)),
                    const SizedBox(height: 24),

                    // 4. Action Form
                     Text(
                      'Lokasi Baru',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: subTextColor),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedLocation,
                          hint: Text('Pilih Lokasi...', style: TextStyle(color: subTextColor)),
                          isExpanded: true,
                          icon: const Icon(Icons.expand_more, color: AppColors.textGray),
                          style: TextStyle(fontSize: 16, color: textColor),
                          dropdownColor: surfaceColor,
                          items: _locations.map((loc) => DropdownMenuItem(
                            value: loc['value'],
                            child: Text(loc['label']!),
                          )).toList(),
                          onChanged: (val) => setState(() => _selectedLocation = val),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                     Text(
                      'Status Update',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: subTextColor),
                    ),
                    const SizedBox(height: 8),
                     Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedStatus,
                          hint: Text('Pilih Status...', style: TextStyle(color: subTextColor)),
                          isExpanded: true,
                          icon: const Icon(Icons.expand_more, color: AppColors.textGray),
                          style: TextStyle(fontSize: 16, color: textColor),
                          dropdownColor: surfaceColor,
                          items: _statuses.map((status) => DropdownMenuItem(
                            value: status['value'],
                            child: Text(status['label']!),
                          )).toList(),
                          onChanged: (val) => setState(() => _selectedStatus = val),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 100), // Space for bottom button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(top: BorderSide(color: borderColor.withOpacity(0.5))),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, -2))
          ],
        ),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitUpdate,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.backgroundDark, // Text color
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              shadowColor: AppColors.primary.withOpacity(0.5),
              disabledBackgroundColor: Colors.grey,
            ),
            child: _isLoading 
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
              : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text('Update Posisi Paket', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                   SizedBox(width: 8),
                   Icon(Icons.check_circle, size: 22),
                ],
              ),
          ),
      ),
    );
  }
}
