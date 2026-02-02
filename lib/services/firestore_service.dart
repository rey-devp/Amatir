import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart'; 

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  // collection references
  CollectionReference get _ordersRef => _db.collection('orders');
  CollectionReference get _productsRef => _db.collection('products');
  CollectionReference get _usersRef => _db.collection('users');

  // USERS 
  Future<UserModel> getUser(String uid) async {
    DocumentSnapshot doc = await _usersRef.doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    } else {
      throw Exception('User tidak ditemukan');
    }
  }

  //PRODUCTS 
  Stream<List<ProductModel>> getProducts() {
    return _productsRef.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => ProductModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }

  //  ORDERS
  // CUSTOMER MEMBUAT ORDER
  Future<void> createOrder({
    required String uid,
    required ProductModel product,
    required String destination,
  }) async {
    String orderId = _uuid.v4();
    String trackingId = "TRX-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";

    TrackingHistory firstHistory = TrackingHistory(
      status: 'created',
      description: 'Pesanan berhasil dibuat',
      location: 'Online System',
      timestamp: DateTime.now().toString(),
      updatedBy: uid,
    );

    OrderModel newOrder = OrderModel(
      orderId: orderId,
      trackingId: trackingId,
      status: 'created',
      customerId: uid,
      productName: product.name,
      destination: destination,
      trackingHistory: [firstHistory],
    );

    await _ordersRef.doc(orderId).set(newOrder.toMap());
  }

  // UPDATE STATUS DENGAN TRANSACTION (GABUNGAN HISTORY)
  Future<void> updateOrderStatusWithHistory(
      String orderId, String newStatus, String location, String description, String updatedBy) async {
    final docRef = _ordersRef.doc(orderId);

    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) throw Exception("Order not found!");

      List<dynamic> currentHistory = snapshot.data()?['trackingHistory'] ?? [];
      
      // Tambah history baru
      currentHistory.add({
        'status': newStatus,
        'description': description,
        'location': location,
        'timestamp': DateTime.now().toIso8601String(),
        'updatedBy': updatedBy,
      });

      transaction.update(docRef, {
        'status': newStatus,
        'trackingHistory': currentHistory,
        'currentLocation': location, 
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  // GET ORDERS BY CUSTOMER
  Stream<List<OrderModel>> getOrdersByCustomer(String uid) {
    return _ordersRef
        .where('customerId', isEqualTo: uid) // Pastikan field di firebase 'customerId'
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  // GET ORDERS BY STATUS (Untuk Kurir/Gudang)
  Stream<List<OrderModel>> getOrdersByStatus(String status) {
    return _ordersRef
        .where('status', isEqualTo: status)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  //  GET ALL ORDERS (Untuk Admin)
  Stream<List<OrderModel>> getAllOrders() {
    return _ordersRef.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }
}