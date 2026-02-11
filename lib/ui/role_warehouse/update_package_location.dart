import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/ui_utils.dart';


class UpdatePackageLocationPage extends StatefulWidget {
  final OrderModel? order;
  final String? trackingId;

  const UpdatePackageLocationPage({
    super.key, 
    this.order,
    this.trackingId,
  });

  @override
  State<UpdatePackageLocationPage> createState() => _UpdatePackageLocationPageState();
}

class _UpdatePackageLocationPageState extends State<UpdatePackageLocationPage> {
  late TextEditingController _resiController;
  OrderModel? _order;
  bool _isSearching = false;
  bool _isLoading = false;

  final List<Map<String, String>> _locations = [
    {'value': 'Gudang Jakarta (Cakung)', 'label': 'Gudang Jakarta (Cakung)'},
    {'value': 'Hub Bandung', 'label': 'Hub Bandung'},
    {'value': 'Hub Semarang', 'label': 'Hub Semarang'},
    {'value': 'Hub Surabaya', 'label': 'Hub Surabaya'},
  ];

  final List<Map<String, String>> _statuses = [
    {'value': 'at_warehouse_inbound', 'label': 'Barang Diterima (Inbound)', 'status': 'at_warehouse'},
    {'value': 'at_warehouse_sorting', 'label': 'Dalam Penyortiran (Sorting)', 'status': 'at_warehouse'},
    {'value': 'at_warehouse_outbound', 'label': 'Siap Dikirim (Outbound)', 'status': 'at_warehouse'},
  ];

  String? _selectedLocation;
  String? _selectedStatus;
  String _customDescription = 'Paket sedang diproses di gudang.';

  @override
  void initState() {
    super.initState();
    _resiController = TextEditingController(text: widget.order?.trackingId ?? widget.trackingId ?? '');
    _order = widget.order;
    
    if (_order == null && _resiController.text.isNotEmpty) {
      // Simulate/Trigger search if only ID is provided
      WidgetsBinding.instance.addPostFrameCallback((_) => _searchOrder());
    }
  }

  Future<void> _searchOrder() async {
    if (_resiController.text.isEmpty) return;
    
    setState(() => _isSearching = true);
    
    // For now, we fetch a list and find the one with matching trackingID
    // Improvement: Add getOrderByTrackingId to service
    final _ = Provider.of<OrderProvider>(context, listen: false);
    // This is a bit inefficient but works for now as a workaround
    // Ideally we have a stream or future for a single order by tracking ID
    // Let's assume we can get it or we just use the current order if passed
    
    setState(() => _isSearching = false);
  }

  Future<void> _submitUpdate() async {
    if (_order == null || _selectedLocation == null || _selectedStatus == null) {
      UiUtils.showErrorSnackBar(context, 'Harap lengkapi semua data!');
      return;
    }

    setState(() => _isLoading = true);
    
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final updaterName = authProvider.user?.name ?? 'Warehouse Admin';

    // Resolve actual Firestore status from the unique dropdown value
    final selectedStatusEntry = _statuses.firstWhere(
      (s) => s['value'] == _selectedStatus,
      orElse: () => {'status': 'at_warehouse', 'label': ''},
    );
    final firestoreStatus = selectedStatusEntry['status'] ?? 'at_warehouse';
    final statusLabel = selectedStatusEntry['label'] ?? _customDescription;

    final success = await orderProvider.updateStatus(
      orderId: _order!.orderId,
      status: firestoreStatus,
      location: _selectedLocation!,
      description: _customDescription.isNotEmpty ? _customDescription : statusLabel,
      updaterName: updaterName,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        UiUtils.showSuccessSnackBar(context, 'Lokasi paket berhasil diupdate!');
        Navigator.pop(context);
      } else {
        UiUtils.showErrorSnackBar(context, 'Gagal mengupdate status.');
      }
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
    final borderColor = isDarkMode ? AppColors.inputBorderDark : AppColors.inputBorder;

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
                        width: 40, height: 40,
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                    ),
                  ),
                  const SizedBox(width: 40),
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
                    Text('Nomor Resi / Tracking ID', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: subTextColor)),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(8),
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
                                hintStyle: TextStyle(color: subTextColor.withOpacity(0.5)),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              onSubmitted: (_) => _searchOrder(),
                            ),
                          ),
                          IconButton(
                            onPressed: _searchOrder,
                            icon: Icon(Icons.search, color: AppColors.primary),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 3. Package Info Card
                    if (_order != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor.withOpacity(0.5)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ORDER INFO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: subTextColor, letterSpacing: 0.5)),
                                  const SizedBox(height: 4),
                                  Text(_order!.productName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                                  const SizedBox(height: 4),
                                  Text('Current Status:', style: TextStyle(fontSize: 12, color: subTextColor)),
                                  const SizedBox(height: 2),
                                  Text(_order!.status.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                ],
                              ),
                            ),
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.inventory_2, color: AppColors.primary, size: 28),
                            ),
                          ],
                        ),
                      )
                    else if (_isSearching)
                      const Center(child: CircularProgressIndicator())
                    else
                      Center(child: Text('Harap temukan paket berdasarkan Resi ID', style: TextStyle(color: subTextColor))),

                    if (_order != null) ...[
                      const SizedBox(height: 24),
                      Divider(height: 1, color: borderColor.withOpacity(0.5)),
                      const SizedBox(height: 24),

                      // 4. Action Form
                      Text('Lokasi Update', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: subTextColor)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(8), border: Border.all(color: borderColor)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedLocation,
                            hint: Text('Pilih Lokasi...', style: TextStyle(color: subTextColor)),
                            isExpanded: true,
                            dropdownColor: surfaceColor,
                            items: _locations.map((loc) => DropdownMenuItem(value: loc['value'], child: Text(loc['label']!))).toList(),
                            onChanged: (val) => setState(() => _selectedLocation = val),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text('Status Update', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: subTextColor)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(8), border: Border.all(color: borderColor)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedStatus,
                            hint: Text('Pilih Status...', style: TextStyle(color: subTextColor)),
                            isExpanded: true,
                            dropdownColor: surfaceColor,
                            items: _statuses.map((s) => DropdownMenuItem(value: s['value'], child: Text(s['label']!))).toList(),
                            onChanged: (val) => setState(() => _selectedStatus = val),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      Text('Deskripsi (Opsional)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: subTextColor)),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (val) => _customDescription = val,
                        maxLines: 2,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          hintText: 'Contoh: Paket sedang disortir.',
                          hintStyle: TextStyle(color: subTextColor.withOpacity(0.5)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                        ),
                      ),
                    ],

                    const SizedBox(height: 100),
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
        decoration: BoxDecoration(color: backgroundColor, border: Border(top: BorderSide(color: borderColor.withOpacity(0.5)))),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _submitUpdate,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.backgroundDark,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isLoading 
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
            : const Text('Update Posisi Paket', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
