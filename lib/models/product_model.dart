class ProductModel {
  final String id;
  final String name;
  final String warehouseOrigin;
  final int stock;
  final double price; // Changed to double for better precision with prices
  final String imageUrl;

  ProductModel({
    required this.id,
    required this.name,
    required this.warehouseOrigin,
    required this.stock,
    required this.price,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'warehouse_origin': warehouseOrigin,
      'stock': stock,
      'price': price,
      'image_url': imageUrl,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      warehouseOrigin: map['warehouse_origin'] ?? '',
      stock: (map['stock'] ?? 0) as int,
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['image_url'] ?? '',
    );
  }
}
