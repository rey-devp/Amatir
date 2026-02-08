import 'dart:async';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/firestore_service.dart';

class ProductProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  StreamSubscription<List<ProductModel>>? _productSubscription;

  ProductProvider() {
    _listenToProducts();
  }

  void _listenToProducts() {
    _isLoading = true;
    notifyListeners();

    try {
      _productSubscription = _firestoreService.getProducts().listen(
        (productsData) {
          _products = productsData;
          _isLoading = false;
          notifyListeners();
        },
        onError: (error) {
          debugPrint(
            "Error fetching products: $error",
          ); // Ganti print jadi debugPrint
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<ProductModel> searchProducts(String query) {
    if (query.isEmpty) return _products;
    return _products.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _productSubscription?.cancel();
    super.dispose();
  }
}
