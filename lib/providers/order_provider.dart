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

  // Stream low-priority (available jobs — orders ready at warehouse for pickup)
  Stream<List<OrderModel>> getAvailableJobs() {
    return _firestoreService.getOrdersByStatus('at_warehouse');
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
    String? courierId,
  }) async {
    try {
      await _firestoreService.updateOrderStatusWithHistory(
        orderId,
        status,
        location,
        description,
        updaterName,
        proofUrl: proofUrl,
        courierId: courierId,
      );

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error update status: $e");
      return false;
    }
  }

  /// Courier accepts a job — sets courier_id and updates status to on_delivery.
  Future<bool> acceptJob({
    required String orderId,
    required String courierUid,
    required String courierName,
  }) async {
    try {
      await _firestoreService.updateOrderStatusWithHistory(
        orderId,
        'on_delivery',
        'Pos Logistik',
        'Kurir $courierName telah mengambil paket dan mulai mengantar',
        courierName,
        courierId: courierUid,
      );
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error accept job: $e");
      return false;
    }
  }

  /// Lookup order by tracking ID (for QR scanner).
  Future<OrderModel?> getOrderByTrackingId(String trackingId) {
    return _firestoreService.getOrderByTrackingId(trackingId);
  }

  /// Customer confirms receipt — updates status to completed.
  Future<bool> confirmReceived({
    required String orderId,
    required String customerName,
  }) async {
    try {
      await _firestoreService.updateOrderStatusWithHistory(
        orderId,
        'completed',
        'Alamat Penerima',
        'Paket telah diterima oleh $customerName',
        customerName,
      );
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error confirm receipt: $e");
      return false;
    }
  }
}
