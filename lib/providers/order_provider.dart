import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../services/firestore_service.dart';

class OrderProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Function untuk Customer Beli Barang
  Future<bool> createOrder(String uid, ProductModel product, String address) async {
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
      return true; // Berhasil
    } catch (e) {
      print("Error create order: $e");
      _isLoading = false;
      notifyListeners();
      return false; // Gagal
    }
  }

  // Function untuk Update Status (Gudang/Kurir)
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
        updaterName   
      );
      
      notifyListeners();
      return true;
    } catch (e) {
      print("Error update status: $e");
      return false;
    }
  }
}