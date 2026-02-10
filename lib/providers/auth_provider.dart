import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  UserModel? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // CHECK LOGIN STATUS (Middleware Logic)
  Future<bool> checkLoginStatus() async {
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      try {
        // Ambil data terbaru dari Firestore
        UserModel userData = await _authService.getUserData(currentUser.uid);
        _user = userData;
        notifyListeners();
        return true;
      } catch (e) {
        // Jika gagal ambil data (misal dihapus), logout paksa
        await logout();
        return false;
      }
    }
    return false;
  }

  // LOGIN
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      setLoading(true);
      UserModel loggedInUser = await _authService.signIn(email, password);
      _user = loggedInUser;
      setLoading(false);

      return {"message": "Login Berhasil", "data": loggedInUser, "error": null};
    } catch (e) {
      setLoading(false);
      return {
        "message": "Login Gagal",
        "data": null,
        "error": e.toString().replaceAll("Exception: ", ""),
      };
    }
  }

  // REGISTER (Ini yang tadi hilang)
  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String name,
  ) async {
    try {
      setLoading(true);
      // Panggil Service
      UserModel registeredUser = await _authService.register(
        email: email,
        password: password,
        name: name,
      );

      _user = registeredUser;
      setLoading(false);

      return {
        "message": "Registrasi Berhasil",
        "data": registeredUser,
        "error": null,
      };
    } catch (e) {
      setLoading(false);
      return {
        "message": "Registrasi Gagal",
        "data": null,
        "error": e.toString().replaceAll("Exception: ", ""),
      };
    }
  }

  // LOGOUT
  Future<Map<String, dynamic>> logout() async {
    try {
      await _authService.signOut();
      _user = null;
      notifyListeners();

      return {"message": "Logout Berhasil", "data": null, "error": null};
    } catch (e) {
      return {"message": "Logout Gagal", "data": null, "error": e.toString()};
    }
  }

  // GET CURRENT USER
  Future<UserModel?> getCurrentUser() async {
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      try {
        return _user;
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
