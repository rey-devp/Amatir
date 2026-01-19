import 'package:flutter/material.dart';
import '../../config/app_constants.dart';

// Local Data Model for Products
class _ProductItem {
  final String id;
  final String name;
  final String price; // Formatted string for display
  final String imageUrl;
  final bool isPromo;

  _ProductItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.isPromo = false,
  });
}

class HomeCustomerPage extends StatefulWidget {
  const HomeCustomerPage({super.key});

  @override
  State<HomeCustomerPage> createState() => _HomeCustomerPageState();
}

class _HomeCustomerPageState extends State<HomeCustomerPage> {
  int _selectedIndex = 0; // "Home" selected

  final List<_ProductItem> _products = [
    _ProductItem(
      id: '1',
      name: 'Forklift Diesel 3 Ton',
      price: 'Rp 155.000.000',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCyLWpw8svjLbLxJBp6PzlUZuxf36QWYL3hv2tAc8mUbCzDBI0lxCWXHGr87597_orMa7o-q4aOAwT2FuH-hwRB8_7Vn6t42EPT0N7kAP7xSPHlrQhw-8WjwqJ-KOrIFPmN5jnbhsDWCVCzhXil8QAGGCRy4kwdwImVBB664CBbbNfqN-UOw3O7DB7QTerfFGGyHFBYLX5ddMkg6HlORyecRHZl3YW97WHPgt3wP55ybFsgDy2WV459m3CwZ38YEKGes9szevZtrCQ',
    ),
    _ProductItem(
      id: '2',
      name: 'Heavy Duty Racking System',
      price: 'Rp 8.200.000',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAp_NbpYwTwhIdEstLuIBtzmPhA9NUHcr-z9KBHxkmuewOWe8WJVj5j0-87jsP0e6XR6wwPn_66JDLX_huuNITxGsnV1QjWaUgdYB1JgHXpxhEVo0UjSZtKH9uiqLL690RURHGGM_5WzgggE9LL5OXD-AR_ELGYvjfL5tWxvLyTcDhP-4rLZYVTehMus7RW1M-sdYwuPw2mY8HkrCoIuWfIZx_wAxjAhXhUMW6EY1WutGGUqI8wTjY_YukVKVAZiKB0j-xETAwVq9g',
      isPromo: true,
    ),
    _ProductItem(
      id: '3',
      name: 'Conveyor Belt System',
      price: 'Rp 25.000.000',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA4-KGqJ-dFzQVoZ1JM8RnXqdbumhJRkoqVgjnaTotIeyUCM5rSL4ToGYNtqlcm5d4783jEpKBvyH6gzovbEfFTr3XtYvMaeyjmCRK-pKNHqL93yA5yfSECYWU7YabaXshz-JBWTB6SCaNcMtz0YqGyyB6ub_BNZPFKMDeAToGX711Ia8yqxIxbQ9xmBO-chTgyxCDGDGDmjaYNgJO2kdCLxPHarsZwFExvyi_fWvZZfsXh1YaQsrPOcJSQsqcl11lcebKodSm42Ac',
    ),
    _ProductItem(
      id: '4',
      name: 'Wireless Warehouse Scanner',
      price: 'Rp 3.500.000',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDxtFKzec-nGXMw0-8_9fDaOaThmpDrE2HveRt85-YLnAEcjt09YlOr0a8-Zhkb8yDqCaxjtC-ngR7SjsRT1ld0WDVUulzk6906LXTR1P6Ii3C0XBaHdR4uoEghokE2ywa-WnJr7urL7uC22dR3XQc_c816Mi3QCvtC6gFn_jWemdK1mWgMXxxTWKvlJ9pFMSLOy1LRCPhWXfL7CB8VdJJe9JRDat93dpHf7EbJs_zNS_mUmIMsXqO3cVtwRqP5lMnxefTcbrzx0-Q',
    ),
     _ProductItem(
      id: '5',
      name: 'Euro Pallet (Kayu Standar)',
      price: 'Rp 150.000',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA4TVFGko9T1uW0NxE6cVhJ-a3lDA2cdtSkXMeKUGoA8JdtBOYN__PVarw8Y11OXvM2WKMZmCEfmad9MRzotAyelvCbTOWZhUKrOI-ikZtBCJwhgoSLLt_FD6Q5stDHbPrsBd8vvvThUhKptQIUixHYnhSp7OdHIGWIWijguzJvSZlWEKkTAmrZUHhwXp9XQIIwADhmzXRBlNU3j2EZX5pjgHb-oQYUyiOxwZcZujaSTsHqcgEWBx19SlbndTq_H1RYOYtw8hbXaZs',
    ),
     _ProductItem(
      id: '6',
      name: 'Pallet Jack Hydraulic',
      price: 'Rp 4.500.000',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC6v6Bd8nYsgT9WPhfYZNFSOyllgCE6mTh0QjGlyUpyEeEgZNc7pgj7ckrFp32LY4-hrB-ueJjtHhlTuE_4u9--mwlSlV1HCj3lMz2ukm2tAWrsOm_f8ZXhJ07-xBGKgeKa08HQv26eJRCTDgtEx6ACiwGhVbT04ly3wIsRG84OEOFgch4Ur0oRNmrBhH4aGCyUGxDVELca7CQcxvpZyfi4cVwHxOL669vRbP-6QYeIlGFFii9gmCutzY2CslSq4gJUehGGiuil2II',
    ),
  ];

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
    final cardColor = isDarkMode ? const Color(0xFF16282b) : Colors.white;

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
                    Text('Halo, Budi Santoso', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
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


          // 2. Section Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text('Katalog Produk', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                   TextButton(onPressed: (){}, child: const Text('Lihat Semua', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
          ),

          // 3. Product Grid
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75, // Adjust based on card content
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = _products[index];
                  return _buildProductCard(product, cardColor, textColor, subTextColor, isDarkMode);
                },
                childCount: _products.length,
              ),
            ),
          ),
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
                _buildNavItem(Icons.home, 'Home', true),
                _buildNavItem(Icons.assignment, 'Pesanan', false),
                _buildNavItem(Icons.local_shipping, 'Lacak', false),
                _buildNavItem(Icons.person, 'Profil', false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(_ProductItem product, Color cardColor, Color textColor, Color subTextColor, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
                if (product.isPromo)
                 Positioned(
                   top: 8, right: 8,
                   child: Container(
                     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                     decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
                     child: const Text('PROMO', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                   ),
                 )
              ],
            ),
          ),
          
          // Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                   product.name,
                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textColor),
                   maxLines: 2,
                   overflow: TextOverflow.ellipsis,
                 ),
                 const SizedBox(height: 8),
                 Text(
                   product.price,
                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                 ),
                 const SizedBox(height: 12),
                 SizedBox(
                   width: double.infinity,
                   child: ElevatedButton(
                     onPressed: (){}, 
                     style: ElevatedButton.styleFrom(
                       backgroundColor: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey[100],
                       foregroundColor: textColor,
                       elevation: 0,
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                       padding: const EdgeInsets.symmetric(vertical: 8),
                     ),
                     child: const Text('Beli', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                   ),
                 )
              ],
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
