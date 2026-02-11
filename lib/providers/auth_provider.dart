import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        UserModel userData = await _authService.getUserData(currentUser.uid);
        _user = userData;
        notifyListeners();
        return true;
      } catch (e) {
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
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      return {
        "message": "Login Gagal",
        "data": null,
        "error": _getFirebaseErrorMessage(e.code),
      };
    } catch (e) {
      setLoading(false);
      // Fallback: Check if error string contains Firebase error codes
      String errorMessage = e.toString();
      String finalError = errorMessage.replaceAll("Exception: ", "");
      
      if (errorMessage.contains("invalid-credential")) {
        finalError = _getFirebaseErrorMessage("invalid-credential");
      } else if (errorMessage.contains("user-not-found")) {
        finalError = _getFirebaseErrorMessage("user-not-found");
      } else if (errorMessage.contains("wrong-password")) {
        finalError = _getFirebaseErrorMessage("wrong-password");
      } else if (errorMessage.contains("network-request-failed")) {
        finalError = _getFirebaseErrorMessage("network-request-failed");
      }

      return {
        "message": "Login Gagal",
        "data": null,
        "error": finalError,
      };
    }
  }

  // REGISTER
  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String name,
  ) async {
    try {
      setLoading(true);
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
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      return {
        "message": "Registrasi Gagal",
        "data": null,
        "error": _getFirebaseErrorMessage(e.code),
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

  /// Translates Firebase Auth error codes to Indonesian messages.
  String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'user-disabled':
        return 'Akun ini telah dinonaktifkan.';
      case 'user-not-found':
        return 'Email tidak terdaftar. Silakan daftar terlebih dahulu.';
      case 'wrong-password':
        return 'Password salah. Silakan coba lagi.';
      case 'invalid-credential':
        return 'Email atau password salah.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan login. Coba lagi nanti.';
      case 'email-already-in-use':
        return 'Email sudah digunakan akun lain.';
      case 'weak-password':
        return 'Password terlalu lemah. Minimal 6 karakter.';
      case 'network-request-failed':
        return 'Tidak ada koneksi internet.';
      case 'operation-not-allowed':
        return 'Metode login ini tidak diizinkan.';
      default:
        return 'Terjadi kesalahan ($code). Silakan coba lagi.';
    }
  }
}
