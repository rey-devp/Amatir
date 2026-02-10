import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Import Config
import 'config/theme.dart';
import 'config/routes.dart'; // Keep for reference, but we use inline for now from frontend
import 'config/app_constants.dart'; // Check if this exists, or if it refers to lib/utils/constants.dart
import 'firebase_options.dart'; 

// Import Providers
import 'providers/auth_provider.dart';
import 'providers/order_provider.dart';
import 'providers/product_provider.dart';

// Import UI Pages (Frontend)
import 'ui/auth/splash_screen.dart';
import 'ui/auth/login_page.dart';
import 'ui/role_warehouse/dashboard_warehouse.dart';
import 'ui/role_warehouse/update_package_location.dart';
import 'ui/role_courier/dashboard_courier.dart';
import 'ui/role_courier/delivery_execution_page.dart';
import 'ui/role_customer/home_customer_page.dart';
import 'ui/role_customer/order_detail_customer.dart';
import 'ui/role_admin/admin_dashboard.dart';
import 'ui/role_admin/user_list_page.dart';
import 'utils/constants.dart'; // Ensure constants are imported

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
    print("✅ Environment variables loaded.");

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("✅ Firebase initialized successfully!");
  } catch (e) {
    print("❌ Failed to initialize Firebase: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider: Menyuntikkan semua Logic ke Aplikasi
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        title: 'Amatir', // Use string or AppConstants.appName if available
        debugShowCheckedModeBanner: false,
        
        // Gunakan Tema
        theme: AppTheme.lightTheme,
        
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/login': (context) => const LoginPage(),
          
          // Admin
          '/admin-dashboard': (context) => const AdminDashboardPage(),
          '/admin-users': (context) => const UserListPage(),
          
          // Courier
          '/courier-dashboard': (context) => const DashboardCourierPage(),
          '/courier-delivery-execution': (context) => const DeliveryExecutionPage(),
          
          // Customer
          '/customer-home': (context) => const HomeCustomerPage(),
          '/customer-order-detail': (context) => const OrderDetailCustomerPage(),
          
          // Warehouse
          '/warehouse-dashboard': (context) => const DashboardWarehousePage(),
          '/warehouse-update-location': (context) => const UpdatePackageLocationPage(),
        },
      ),
    );
  }
}