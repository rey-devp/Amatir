class AppConstants {
  // Frontend & Shared Constants
  static const String appName = 'Amatir';

  // Firestore Collections
  static const String collectionUsers = 'users'; // Shared
  static const String collectionProducts = 'products';
  static const String collectionOrders = 'orders';

  // Storage Folders
  static const String pathProductImage = 'product_images';
  static const String pathProofDelivery = 'proof_delivery';

  // Roles
  static const String roleCustomer = 'customer';
  static const String roleCourier = 'courier';
  static const String roleWarehouse = 'gudang';
  static const String roleAdmin = 'admin';

  // Order Status
  static const String statusCreated = 'created';
  static const String statusWarehouse = 'at_warehouse';
  static const String statusOnDelivery = 'on_delivery';
  static const String statusDelivered = 'delivered';
}

class Constants {
  // Backend Compatibility Wrapper
  // Maps to AppConstants where possible

  static const String usersCollection = AppConstants.collectionUsers;
  static const String productsCollection = AppConstants.collectionProducts;
  static const String ordersCollection = AppConstants.collectionOrders;

  static const String roleCustomer = AppConstants.roleCustomer;
  static const String roleCourier = AppConstants.roleCourier;
  static const String roleWarehouse = AppConstants.roleWarehouse;
  static const String roleAdmin = AppConstants.roleAdmin;

  static const String statusCreated = AppConstants.statusCreated;
  static const String statusWarehouse = AppConstants.statusWarehouse;
  static const String statusOnDelivery = AppConstants.statusOnDelivery;
  static const String statusDelivered = AppConstants.statusDelivered;
}
