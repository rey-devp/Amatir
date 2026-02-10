import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

class AdminProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  Stream<List<UserModel>> getUsers() {
    return _firestoreService.getAllUsers();
  }

  Stream<List<OrderModel>> getAllOrders() {
    return _firestoreService.getAllOrders();
  }

  Stream<List<ProductModel>> getProducts() {
    return _firestoreService.getProducts();
  }

  // Calculated Stats for Dashboard (Simple implementation)
  // In a real app, these might be aggregated in a separate collection or Cloud Function
  
  Stream<Map<String, dynamic>> getDashboardStats() {
    // Combine multiple streams into one Map for dashboard
    // This is a simplified version for small datasets
    return Stream.periodic(const Duration(seconds: 1)).asyncMap((_) async {
      // Note: This is inefficient for large data, better to use discrete builders in UI
      // but for demonstration we'll just show the structure.
      return {};
    });
  }
}
