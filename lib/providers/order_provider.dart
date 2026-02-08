import 'package:flutter/material.dart';
import '../models/product_model.dart';
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

  Future<bool> updateStatus({
    required String orderId,
    required String status,
    required String description,
    required String location,
    required String updaterName,
  }) async {
    try {
      await _firestoreService.updateOrderStatusWithHistory(
        orderId,
        status,
        location,
        description,
        updaterName,
      );

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error update status: $e"); // Ganti print jadi debugPrint
      return false;
    }
  }
}
