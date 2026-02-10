class AppConstants {
  // Application Info
  static const String appName = 'LogiTrack';
  static const String loginHeaderImageUrl = 'https://lh3.googleusercontent.com/aida-public/AB6AXuAyeCgWV4b6G4_0eXN05ZyBAdDEUweS7HKez_BcYrXtd4tyJ4tNP9fGhd2fsdHzTLrn7hYk3EX8G7vVad5WAKHCqV1_8x5DAEZgCrnNPl8_i4j4KrlkQglEOS3q8wgpcxwxxHtti_qpXgEEgOqEgORonLm4Vr5_hlw_Z4rdfocegCW8nTttJdCNfBphht6eF5hG1U7JMmJzAXYn2lFQo9ql8jEoif-z_rDx20OIr0-xQ8BA-hPUZ0-1xg-4gDiOk45u388L3H30aUE';

  // Firestore Collections
  static const String collectionUsers = 'users';
  static const String collectionProducts = 'products';
  static const String collectionOrders = 'orders';

  // Storage Folders
  static const String pathProductImage = 'product_images';
  static const String pathProofDelivery = 'proof_delivery';

  // Roles
  static const String roleCustomer = 'customer';
  static const String roleCourier = 'courier';
  static const String roleWarehouse = 'warehouse';
  static const String roleAdmin = 'admin';

  // Order Status
  static const String statusPending = 'pending';
  static const String statusAtWarehouse = 'at_warehouse';
  static const String statusOnDelivery = 'on_delivery';
  static const String statusDelivered = 'delivered';
  static const String statusCompleted = 'completed';
}

/// Legacy alias for compatibility during refactoring
class Constants {
  static const String usersCollection = AppConstants.collectionUsers;
  static const String productsCollection = AppConstants.collectionProducts;
  static const String ordersCollection = AppConstants.collectionOrders;

  static const String roleCustomer = AppConstants.roleCustomer;
  static const String roleCourier = AppConstants.roleCourier;
  static const String roleWarehouse = AppConstants.roleWarehouse;
  static const String roleAdmin = AppConstants.roleAdmin;

  static const String statusCreated = AppConstants.statusPending;
  static const String statusWarehouse = AppConstants.statusAtWarehouse;
  static const String statusOnDelivery = AppConstants.statusOnDelivery;
  static const String statusDelivered = AppConstants.statusDelivered;
}
