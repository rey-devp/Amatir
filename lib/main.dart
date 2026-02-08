import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
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
import 'config/app_constants.dart';

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
    return MaterialApp(
      title: 'LogiTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
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
        // Note: OrderDetailCustomerPage might need arguments, handled via onGenerateRoute or arguments
        // For simplicity in named routes, we can register it, but data passing needs care.
        // Let's stick to simple routes first.
        '/customer-order-detail': (context) => const OrderDetailCustomerPage(),
        
        // Warehouse
        '/warehouse-dashboard': (context) => const DashboardWarehousePage(),
        '/warehouse-update-location': (context) => const UpdatePackageLocationPage(),
      },
    );
  }
}
