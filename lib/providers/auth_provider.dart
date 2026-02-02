import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserModel? _user;
  UserModel? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    try {
      setLoading(true);
      _errorMessage = null;

      // KARENA AuthService SUDAH RETURN UserModel, KITA LANGSUNG PAKAI SAJA
      UserModel loggedInUser = await _authService.signIn(email, password);
      
      _user = loggedInUser; // Simpan ke state provider
      
      setLoading(false);
      return true; // Login Sukses
    } catch (e) {
      setLoading(false);
      _errorMessage = e.toString();
      notifyListeners();
      return false; // Login Gagal
    }
  }

  Future<bool> register(String email, String password, String name) async {
    try {
      setLoading(true);
      _errorMessage = null;

      UserModel registeredUser = await _authService.register(
        email: email, 
        password: password, 
        name: name
      );

      _user = registeredUser;
      
      setLoading(false);
      return true;
    } catch (e) {
      setLoading(false);
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}
