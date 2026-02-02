
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../utils/constants.dart'; // Pastikan path ini benar

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  // collection references (biar rapi)
  CollectionReference get _ordersRef => _db.collection('orders');
  CollectionReference get _productsRef => _db.collection('products');

  // ================= PRODUCTS =================
  
  // Ambil data produk (Stream)
  Stream<List<ProductModel>> getProducts() {
    return _productsRef.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => ProductModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }

  // ================= ORDERS =================

  // 1. CUSTOMER MEMBUAT ORDER
  Future<void> createOrder({
    required String uid,
    required ProductModel product,
    required String destination,
  }) async {
    String orderId = _uuid.v4();
    // Buat tracking ID (Resi) simpel, misal: TRX-12345678
    String trackingId = "TRX-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";

    // Item History Pertama
    TrackingHistory firstHistory = TrackingHistory(
      status: 'created',
      description: 'Pesanan berhasil dibuat',
      location: 'Online System',
      timestamp: DateTime.now().toString(),
      updatedBy: uid, // Customer ID
    );

    // Buat Object OrderModel
    OrderModel newOrder = OrderModel(
      orderId: orderId,
      trackingId: trackingId,
      status: 'created',
      customerId: uid,
      productName: product.name,
      destination: destination,
      trackingHistory: [firstHistory], // List berisi 1 item
    );

    // Simpan ke Firestore
    await _ordersRef.doc(orderId).set(newOrder.toMap());
  }

  // 2. GUDANG / KURIR UPDATE STATUS (Tracking)
  Future<void> updateTracking({
    required String orderId,
    required String newStatus,
    required String description,
    required String location,
    required String updatedBy, // Nama/ID orang yg update
  }) async {
    
    // Buat object TrackingHistory baru
    TrackingHistory newHistory = TrackingHistory(
      status: newStatus,
      description: description,
      location: location,
      timestamp: DateTime.now().toString(),
      updatedBy: updatedBy,
    );

    // Update status utama DAN tambahkan history baru ke array
    await _ordersRef.doc(orderId).update({
      'status': newStatus,
      // ArrayUnion: Menambah item ke list tanpa menghapus yg lama
      'tracking_history': FieldValue.arrayUnion([newHistory.toMap()]),
    });
  }

  // 3. GET ORDERS BY CUSTOMER (Untuk Halaman "Pesanan Saya")
  Stream<List<OrderModel>> getOrdersByCustomer(String uid) {
    return _ordersRef
        .where('customer_id', isEqualTo: uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  // 4. GET ALL ORDERS (Untuk Admin & Gudang)
  Stream<List<OrderModel>> getAllOrders() {
    return _ordersRef.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }
}