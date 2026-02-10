import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';
import '../services/firestore_service.dart';

class OrderProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> createOrder(
    String uid,
    ProductModel product,
    String address,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firestoreService.createOrder(
        uid: uid,
        product: product,
        destination: address,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error create order: $e"); // Ganti print jadi debugPrint
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Stream<List<OrderModel>> getOrdersByCustomer(String uid) {
    return _firestoreService.getOrdersByCustomer(uid);
  }

  // Stream low-priority (available jobs)
  Stream<List<OrderModel>> getAvailableJobs() {
    return _firestoreService.getOrdersByStatus('pending');
  }

  Stream<List<OrderModel>> getOrdersByStatus(String status) {
    return _firestoreService.getOrdersByStatus(status);
  }

  // Stream assigned tasks
  Stream<List<OrderModel>> getOrdersByCourier(String uid) {
    return _firestoreService.getOrdersByCourier(uid);
  }

  Future<bool> updateStatus({
    required String orderId,
    required String status,
    required String description,
    required String location,
    required String updaterName,
    String? proofUrl,
  }) async {
    try {
      await _firestoreService.updateOrderStatusWithHistory(
        orderId,
        status,
        location,
        description,
        updaterName,
        proofUrl: proofUrl,
      );

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error update status: $e"); // Ganti print jadi debugPrint
      return false;
    }
  }
}
