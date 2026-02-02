import 'package:flutter/material.dart';
import '../ui/auth/splash_screen.dart';
import '../ui/auth/login_page.dart';
import '../ui/auth/register_page.dart';
import '../ui/role_customer/home_customer_page.dart';
import '../ui/role_courier/dashboard_courier.dart';
import '../ui/role_warehouse/dashboard_warehouse.dart';
import '../ui/role_admin/admin_dashboard.dart';
import '../ui/role_admin/user_list_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  
  // Rute Peran
  static const String homeCustomer = '/home-customer';
  static const String dashboardCourier = '/dashboard-courier';
  static const String dashboardWarehouse = '/dashboard-warehouse';
  static const String dashboardAdmin = '/dashboard-admin';
  static const String userList = '/user-list';

  // Map Rute ke Widget
  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),
    
    homeCustomer: (context) => const HomeCustomerPage(),
    dashboardCourier: (context) => const DashboardCourier(),
    dashboardWarehouse: (context) => const DashboardWarehouse(),
    dashboardAdmin: (context) => const AdminDashboard(),
    userList: (context) => const UserListPage(),
  };
}