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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    final backgroundColor = isDarkMode
        ? AppColors.backgroundDark
        : AppColors.backgroundLight;
    final surfaceColor = isDarkMode
        ? AppColors.surfaceDark
        : AppColors.surfaceLight;
    final textColor = isDarkMode ? AppColors.textLight : AppColors.textDark;
    final subTextColor = isDarkMode
        ? AppColors.textGrayDark
        : AppColors.textGray;
    final cardColor = isDarkMode ? const Color(0xFF16282b) : Colors.white;
    final cardColor = isDarkMode ? const Color(0xFF16282b) : Colors.white;

    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final productProvider = Provider.of<ProductProvider>(context);

    // Filter products based on search query
    List<ProductModel> displayedProducts = productProvider.products;
    if (_searchQuery.isNotEmpty) {
      displayedProducts = displayedProducts.where((product) {
        return product.name.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Filter by category
    if (_selectedCategory != "Semua" && _selectedCategory != "Pesanan Saya") {
      // Note: Assuming ProductModel has a category field, otherwise this is just UI filtering placeholder
      // For now effectively "Semua" is the only real product category unless we add category logic to ProductModel
    }

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
                    Text(
                      'Selamat datang kembali,',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: subTextColor,
                      ),
                    ),
                    Text(
                      'Halo, ${user?.name ?? 'Pelanggan'}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                // Cart Icon Removed
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    style: TextStyle(color: textColor),
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

          // 2. Tabs Removed as per feedback
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // 3. Grid or List Content
          if (_selectedCategory == "Pesanan Saya")
            _buildOrderList(
              user?.uid ?? '',
              isDarkMode,
              textColor,
              subTextColor,
              surfaceColor,
            )
          else
            _buildProductGrid(
              productProvider,
              displayedProducts,
              cardColor,
              textColor,
              subTextColor,
              isDarkMode,
            ),

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
                _buildNavItem(
                  Icons.home,
                  'Home',
                  _selectedCategory != "Pesanan Saya",
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.customerOrders),
                  child: _buildNavItem(Icons.assignment, 'Pesanan', false),
                ),
                // Removed Lacak Menu
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

  Widget _buildProductGrid(
    ProductProvider provider,
    List<ProductModel> filteredProducts,
    Color cardColor,
    Color textColor,
    Color subTextColor,
    bool isDarkMode,
  ) {
    if (provider.isLoading) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (filteredProducts.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              "Tidak ada produk tersedia.",
              style: TextStyle(color: subTextColor),
            ),
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
        delegate: SliverChildBuilderDelegate((context, index) {
          final product = filteredProducts[index];
          return _buildProductCard(
            product,
            cardColor,
            textColor,
            subTextColor,
            isDarkMode,
          );
        }, childCount: filteredProducts.length),
      ),
    );
  }

  Widget _buildOrderList(
    String uid,
    bool isDarkMode,
    Color textColor,
    Color subTextColor,
    Color surfaceColor,
  ) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: StreamBuilder<List<OrderModel>>(
        stream: Provider.of<OrderProvider>(
          context,
          listen: false,
        ).getOrdersByCustomer(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            debugPrint("Error fetching orders: ${snapshot.error}");
            return SliverToBoxAdapter(
              child: Center(
                child: Text(
                  "Gagal memuat pesanan.",
                  style: TextStyle(color: subTextColor),
                ),
              ),
            );
          }
          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    "Belum ada pesanan.",
                    style: TextStyle(color: subTextColor),
                  ),
                ),
              ),
            );
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final order = orders[index];
              return _buildOrderCard(
                order,
                isDarkMode,
                textColor,
                subTextColor,
                surfaceColor,
              );
            }, childCount: orders.length),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(
    OrderModel order,
    bool isDarkMode,
    Color textColor,
    Color subTextColor,
    Color surfaceColor,
  ) {
    return OrderCard(
      order: order,
      isDarkMode: isDarkMode,
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.customerOrderDetail,
        arguments: order,
      ),
    );
  }

  Widget _buildProductCard(
    ProductModel product,
    Color cardColor,
    Color textColor,
    Color subTextColor,
    bool isDarkMode,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  AppFormatter.formatCurrency(product.price),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: Consumer<OrderProvider>(
                    builder: (context, orderProvider, child) {
                      return ElevatedButton(
                        onPressed: orderProvider.isLoading
                            ? null
                            : () async {
                                final auth = Provider.of<AuthProvider>(
                                  context,
                                  listen: false,
                                );
                                final success = await orderProvider.createOrder(
                                  auth.user?.uid ?? '',
                                  product,
                                  "Alamat Pengiriman Standar",
                                );
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        success
                                            ? "Pesanan berhasil dibuat!"
                                            : "Gagal membuat pesanan",
                                      ),
                                      backgroundColor: success
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode
                              ? Colors.white.withOpacity(0.1)
                              : Colors.grey[100],
                          foregroundColor: textColor,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                        child: orderProvider.isLoading
                            ? const SizedBox(
                                height: 12,
                                width: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Beli',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
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
        Icon(
          icon,
          color: isActive
              ? AppColors.primary
              : AppColors.textGray.withOpacity(0.6),
          size: 24,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive
                ? AppColors.primary
                : AppColors.textGray.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
