import 'package:flutter/material.dart';
import '../ui/auth/splash_screen.dart';
import '../ui/auth/login_page.dart';
import '../ui/role_customer/home_customer_page.dart';
import '../ui/role_customer/order_detail_customer.dart';
import '../ui/role_customer/my_orders_page.dart';
import '../ui/role_courier/dashboard_courier.dart';
import '../ui/role_courier/delivery_execution_page.dart';
import '../ui/role_courier/scanner_page.dart';
import '../ui/role_warehouse/dashboard_warehouse.dart';
import '../ui/role_admin/admin_dashboard.dart';
import '../ui/role_admin/user_list_page.dart';
import '../ui/role_admin/product_list_page.dart';
import '../ui/role_admin/order_list_page.dart';

/// Centralized route definitions for LogiTrack.
///
/// Pages that require constructor arguments (e.g. UpdatePackageLocationPage)
/// are navigated to via MaterialPageRoute and are NOT registered here.
class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';

  // Admin
  static const String adminDashboard = '/admin-dashboard';
  static const String adminUsers = '/admin-users';
  static const String adminProducts = '/admin-products';
  static const String adminOrders = '/admin-orders';

  // Courier
  static const String courierDashboard = '/courier-dashboard';
  static const String courierScan = '/courier-scan';
  static const String courierDelivery = '/courier-delivery-execution';

  // Customer
  static const String customerHome = '/customer-home';
  static const String customerOrders = '/customer-orders';
  static const String customerOrderDetail = '/customer-order-detail';

  // Warehouse
  static const String warehouseDashboard = '/warehouse-dashboard';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginPage(),

    // Admin
    adminDashboard: (context) => const AdminDashboardPage(),
    adminUsers: (context) => const UserListPage(),
    adminProducts: (context) => const ProductListPage(),
    adminOrders: (context) => const OrderListPage(),

    // Courier
    courierDashboard: (context) => const DashboardCourierPage(),
    courierScan: (context) => const CourierScannerPage(),
    courierDelivery: (context) => const DeliveryExecutionPage(),

    // Customer
    customerHome: (context) => const HomeCustomerPage(),
    customerOrders: (context) => const MyOrdersPage(),
    customerOrderDetail: (context) => const OrderDetailCustomerPage(),

    // Warehouse
    warehouseDashboard: (context) => const DashboardWarehousePage(),
  };
}
