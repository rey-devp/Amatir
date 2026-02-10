import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/routes.dart';
import '../../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Animation setup
    _controller = AnimationController(
        duration: const Duration(seconds: 2), vsync: this)..repeat(reverse: true);
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
     _fadeAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );


    // Navigation Logic with Session Check
    Future.delayed(const Duration(seconds: 3), () async {
      if (!mounted) return;
      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isLoggedIn = await authProvider.checkLoginStatus();

      if (!mounted) return;

      if (isLoggedIn) {
        final role = authProvider.user?.role;
        if (role == 'admin') {
          Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
        } else if (role == 'courier') {
          Navigator.pushReplacementNamed(context, AppRoutes.courierDashboard);
        } else if (role == 'warehouse') {
          Navigator.pushReplacementNamed(context, AppRoutes.warehouseDashboard);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.customerHome);
        }
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textColor = isDarkMode ? AppColors.textLight : AppColors.textDark;
    final subTextColor = isDarkMode ? AppColors.textGrayDark : AppColors.textGray;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
            // Background Pattern (Optional placeholder if no image available, or simple gradient)
             Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: isDarkMode 
                        ? [AppColors.backgroundDark, const Color(0xFF1a2c30)] 
                        : [AppColors.backgroundLight, const Color(0xFFeef2f2)],
                  ),
              ),
             ),
             
             // Main Content
             SafeArea(
               child: Column(
                children: [
                  const Spacer(),
                  
                  // Logo Section
                  Center(
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon Container
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primary.withOpacity(0.2),
                                  AppColors.primary.withOpacity(0.05),
                                ],
                              ),
                            ),
                            child: Stack(
                              children: [
                                const Center(
                                  child: Icon(
                                    Icons.local_shipping,
                                    color: AppColors.primary,
                                    size: 60, // ~ text-6xl
                                  ),
                                ),
                                // Decorative Dot Top-Right
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                 // Decorative Dot Bottom-Left
                                Positioned(
                                  bottom: 12,
                                  left: 12,
                                  child: Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.6),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // App Name
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 36, // ~ text-4xl
                                fontWeight: FontWeight.w800,
                                color: textColor,
                                fontFamily: 'Inter', // If available, else default
                                letterSpacing: -1.0, 
                              ),
                              children: const [
                                TextSpan(text: 'Logi'),
                                TextSpan(
                                  text: 'Track',
                                  style: TextStyle(color: AppColors.primary),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'SMART LOGISTICS SOLUTION',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: subTextColor,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Loading Indicator
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        const SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: AppColors.primary,
                            backgroundColor: Colors.transparent, // Or primary/20
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Initializing...',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: subTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Footer Version
                  Text(
                    'Ver 1.0.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: subTextColor.withOpacity(0.6),
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
               ),
             ),
        ],
      ),
    );
  }
}
