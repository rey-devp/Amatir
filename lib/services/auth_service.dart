import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  // LOGIN (Mengembalikan UserModel lengkap dengan Role)
  Future<UserModel> signIn(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
      email: email, 
      password: password
    );

    DocumentSnapshot doc = await _db.collection('users').doc(result.user!.uid).get();

    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    } else {
      throw Exception('Data user tidak ditemukan di database');
    }
  }

  // REGISTER
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    String role = 'customer',
  }) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
      email: email, 
      password: password
    );

    UserModel newUser = UserModel(
      uid: result.user!.uid,
      email: email,
      name: name,
      password: password, 
      role: role,
      createdAt: DateTime.now().toString(),
    );

    await _db.collection('users').doc(newUser.uid).set(newUser.toMap());
    return newUser;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}