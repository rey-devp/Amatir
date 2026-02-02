import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Cek User sedang login atau tidak
  User? get currentUser => _auth.currentUser;

  // LOGIN
  Future<UserModel> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      
      // Ambil data detail (role) dari Firestore
      DocumentSnapshot doc = await _db
          .collection(Constants.usersCollection)
          .doc(result.user!.uid)
          .get();

      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        throw Exception("Data user tidak ditemukan di database!");
      }
    } catch (e) {
      rethrow;
    }
  }

  // REGISTER
  Future<UserModel> register({
    required String email, 
    required String password, 
    required String name,
    String role = Constants.roleCustomer, // Default Customer
  }) async {
    try {
      // 1. Buat Akun di Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );

      // 2. Simpan Data ke Firestore
      UserModel newUser = UserModel(
        uid: result.user!.uid,
        email: email,
        name: name,
        role: role,
      );

      await _db
          .collection(Constants.usersCollection)
          .doc(newUser.uid)
          .set(newUser.toMap());

      return newUser;
    } catch (e) {
      rethrow;
    }
  }

  // LOGOUT
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
