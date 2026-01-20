import 'package:flutter/material.dart';
import 'ui/role_warehouse/dashboard_warehouse.dart';
import 'ui/role_warehouse/update_package_location.dart';
import 'ui/role_courier/dashboard_courier.dart';
import 'ui/role_courier/delivery_execution_page.dart';
import 'ui/role_customer/home_customer_page.dart';
import 'ui/role_customer/order_detail_customer.dart';
import 'ui/role_admin/admin_dashboard.dart';
import 'ui/role_admin/user_list_page.dart';
import 'config/app_constants.dart';

void main() {
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
      home: const UserListPage(),
    );
  }
}
