class OrderModel {
  final String orderId;
  final String trackingId;
  final String status;
  final String customerId;
  final String productName;
  final String destination;
  final DateTime createdAt;
  final String? courierId;
  final List<TrackingHistory> trackingHistory;

  OrderModel({
    required this.orderId,
    required this.trackingId,
    required this.status,
    required this.customerId,
    required this.productName,
    required this.destination,
    required this.createdAt,
    this.courierId,
    required this.trackingHistory,
  });

  Map<String, dynamic> toMap() {
    return {
      'order_id': orderId,
      'tracking_id': trackingId,
      'status': status,
      'customer_id': customerId,
      'product_name': productName,
      'destination': destination,
      'created_at': createdAt.toIso8601String(),
      'courier_id': courierId,
      'tracking_history': trackingHistory.map((x) => x.toMap()).toList(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['order_id'] ?? '',
      trackingId: map['tracking_id'] ?? '',
      status: map['status'] ?? '',
      customerId: map['customer_id'] ?? '',
      productName: map['product_name'] ?? '',
      destination: map['destination'] ?? '',
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : DateTime.now(),
      courierId: map['courier_id'],
      trackingHistory: List<TrackingHistory>.from(
        (map['tracking_history'] as List<dynamic>? ?? []).map<TrackingHistory>(
          (x) => TrackingHistory.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}

class TrackingHistory {
  final String status;
  final String description;
  final String location;
  final DateTime timestamp;
  final String updatedBy;
  final String? proofUrl;

  TrackingHistory({
    required this.status,
    required this.description,
    required this.location,
    required this.timestamp,
    required this.updatedBy,
    this.proofUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'description': description,
      'location': location,
      'timestamp': timestamp.toIso8601String(),
      'updated_by': updatedBy,
      'proof_url': proofUrl,
    };
  }

  factory TrackingHistory.fromMap(Map<String, dynamic> map) {
    return TrackingHistory(
      status: map['status'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      timestamp: map['timestamp'] != null 
          ? DateTime.parse(map['timestamp']) 
          : DateTime.now(),
      updatedBy: map['updated_by'] ?? '',
      proofUrl: map['proof_url'],
    );
  }
}
