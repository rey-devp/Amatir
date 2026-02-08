import 'dart:async';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/firestore_service.dart';

class ProductProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  
  // Data Produk
  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  // Status Loading
  bool _isLoading = true; 
  bool get isLoading => _isLoading;

  // Stream Subscription
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
          print("Error fetching products: $error");
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filter Produk
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