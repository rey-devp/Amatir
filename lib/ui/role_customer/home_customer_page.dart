import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/routes.dart';
import '../../models/product_model.dart';
import '../../models/order_model.dart';
import '../../providers/product_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';
import '../../ui/widgets/order_card.dart';
import '../../utils/formatter.dart';

class HomeCustomerPage extends StatefulWidget {
  const HomeCustomerPage({super.key});

  @override
  State<HomeCustomerPage> createState() => _HomeCustomerPageState();
}

class _HomeCustomerPageState extends State<HomeCustomerPage> {
  String _selectedCategory = "Semua";

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surfaceColor = isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textColor = isDarkMode ? AppColors.textLight : AppColors.textDark;
    final subTextColor = isDarkMode ? AppColors.textGrayDark : AppColors.textGray;
    final cardColor = isDarkMode ? const Color(0xFF16282b) : Colors.white;
    final borderColor = isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05);

    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          // 1. Sticky Header
          SliverAppBar(
            backgroundColor: backgroundColor.withOpacity(0.95),
            floating: true,
            pinned: true,
            elevation: 0,
            toolbarHeight: 80,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selamat datang kembali,', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: subTextColor)),
                    Text('Halo, ${user?.name ?? 'Pelanggan'}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                  ],
                ),
                Stack(
                  children: [
                    IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.shopping_cart_outlined, color: textColor, size: 28),
                    ),
                    Positioned(
                      top: 6, right: 6,
                      child: Container(width: 10, height: 10, decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle, border: Border.all(color: backgroundColor, width: 2))),
                    )
                  ],
                )
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: subTextColor),
                      hintText: 'Cari barang logistik...',
                      hintStyle: TextStyle(color: subTextColor),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 2. Tabs
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _buildTabItem("Semua", _selectedCategory == "Semua", isDarkMode),
                  _buildTabItem("Elektronik", _selectedCategory == "Elektronik", isDarkMode),
                  _buildTabItem("Fashion", _selectedCategory == "Fashion", isDarkMode),
                  _buildTabItem("Health", _selectedCategory == "Health", isDarkMode),
                  const SizedBox(width: 16),
                  Container(width: 1, height: 24, color: borderColor),
                  const SizedBox(width: 16),
                  _buildTabItem("Pesanan Saya", _selectedCategory == "Pesanan Saya", isDarkMode),
                ],
              ),
            ),
          ),

          // 3. Grid or List Content
          if (_selectedCategory == "Pesanan Saya")
            _buildOrderList(user?.uid ?? '', isDarkMode, textColor, subTextColor, surfaceColor)
          else
            _buildProductGrid(productProvider, cardColor, textColor, subTextColor, isDarkMode),

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
                _buildNavItem(Icons.home, 'Home', _selectedCategory != "Pesanan Saya"),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.customerOrders),
                  child: _buildNavItem(Icons.assignment, 'Pesanan', false),
                ),
                _buildNavItem(Icons.local_shipping, 'Lacak', false),
                InkWell(
                  onTap: () {
                     Provider.of<AuthProvider>(context, listen: false).logout();
                     Navigator.pushReplacementNamed(context, AppRoutes.login);
                  },
                  child: _buildNavItem(Icons.logout, 'Logout', false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(String label, bool isSelected, bool isDarkMode) {
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : (isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey[200]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : (isDarkMode ? Colors.white : Colors.black),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid(ProductProvider provider, Color cardColor, Color textColor, Color subTextColor, bool isDarkMode) {
    if (provider.isLoading) {
      return const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())));
    }

    if (provider.products.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text("Tidak ada produk tersedia.", style: TextStyle(color: subTextColor)),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = provider.products[index];
            return _buildProductCard(product, cardColor, textColor, subTextColor, isDarkMode);
          },
          childCount: provider.products.length,
        ),
      ),
    );
  }

  Widget _buildOrderList(String uid, bool isDarkMode, Color textColor, Color subTextColor, Color surfaceColor) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: StreamBuilder<List<OrderModel>>(
        stream: Provider.of<OrderProvider>(context, listen: false).getOrdersByCustomer(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())));
          }
          if (snapshot.hasError) {
            return SliverToBoxAdapter(child: Center(child: Text("Error: ${snapshot.error}", style: TextStyle(color: subTextColor))));
          }
          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return SliverToBoxAdapter(
              child: Center(child: Padding(padding: EdgeInsets.all(32), child: Text("Belum ada pesanan.", style: TextStyle(color: subTextColor)))),
            );
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final order = orders[index];
                return _buildOrderCard(order, isDarkMode, textColor, subTextColor, surfaceColor);
              },
              childCount: orders.length,
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order, bool isDarkMode, Color textColor, Color subTextColor, Color surfaceColor) {
    return OrderCard(
      order: order,
      isDarkMode: isDarkMode,
      onTap: () => Navigator.pushNamed(context, AppRoutes.customerOrderDetail, arguments: order),
    );
  }

  Widget _buildProductCard(ProductModel product, Color cardColor, Color textColor, Color subTextColor, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[300], child: const Icon(Icons.image_not_supported)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textColor), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(AppFormatter.formatCurrency(product.price), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: Consumer<OrderProvider>(
                    builder: (context, orderProvider, child) {
                      return ElevatedButton(
                        onPressed: orderProvider.isLoading 
                          ? null 
                          : () async {
                              final auth = Provider.of<AuthProvider>(context, listen: false);
                               final success = await orderProvider.createOrder(
                                auth.user?.uid ?? '', 
                                product, 
                                "Alamat Pengiriman Standar",
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(success ? "Pesanan berhasil dibuat!" : "Gagal membuat pesanan"), backgroundColor: success ? Colors.green : Colors.red)
                                );
                              }
                           },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey[100],
                          foregroundColor: textColor,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          visualDensity: VisualDensity.compact,
                        ),
                        child: orderProvider.isLoading 
                          ? const SizedBox(height: 12, width: 12, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Beli', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
     return Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         Icon(icon, color: isActive ? AppColors.primary : AppColors.textGray.withOpacity(0.6), size: 24),
         Text(label, style: TextStyle(fontSize: 10, fontWeight: isActive ? FontWeight.bold : FontWeight.w500, color: isActive ? AppColors.primary : AppColors.textGray.withOpacity(0.6))),
       ],
     );
  }
}
